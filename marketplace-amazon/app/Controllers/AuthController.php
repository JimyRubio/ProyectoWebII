<?php
require_once __DIR__ . '/../Models/ClienteModel.php';

class AuthController {
    private ClienteModel $model;

    public function __construct() {
        $this->model = new ClienteModel();
    }

    /**
     * Retorna la información de la sesión activa y el token CSRF
     */
    public function sessionInfo(): void {
        $user = AuthHelper::user();
        Response::success([
            'authenticated' => AuthHelper::check(),
            'user' => $user,
            'csrf_token' => Security::generateCsrfToken()
        ], 'Información de sesión');
    }

    /**
     * Procesa el inicio de sesión vía AJAX
     * AHORA CON: validación de email, protección contra fuerza bruta, CSRF, logging IP
     */
    public function login(): void {
        // Verificar token CSRF en todas las solicitudes POST
        $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
        if (!Security::verifyCsrfToken($token)) {
            Security::logAccess(null, 'login_csrf_fail', 'Token CSRF inválido');
            Response::error('Token de seguridad no válido. Recarga la página.', 403);
        }

        $rawEmail = trim($_POST['email'] ?? $_POST['email_or_user'] ?? '');
        $password = $_POST['password'] ?? '';

        if (empty($rawEmail) || empty($password)) {
            Response::error('Debe ingresar correo y contraseña', 400);
        }

        // Validar y sanitizar email
        $email = Security::validateEmail($rawEmail);
        if ($email === null) {
            Security::logAccess(null, 'login_invalid_email', 'Email inválido: ' . $rawEmail);
            Response::error('Formato de correo electrónico no válido', 400);
        }

        // === PROTECCIÓN CONTRA FUERZA BRUTA ===
        $bruteForce = Security::checkBruteForce($this->model->db, $email);
        if ($bruteForce['blocked']) {
            if ($bruteForce['remaining_time'] > 0) {
                $minutes = ceil($bruteForce['remaining_time'] / 60);
                Security::logAccess(null, 'login_blocked', "Bloqueado {$minutes}min por intentos fallidos ({$bruteForce['attempts']})");
                Response::error("Demasiados intentos fallidos. Intenta de nuevo en {$minutes} minuto(s).", 429);
            }
        }

        $user = $this->model->findByEmail($email);
        
        // Check if user is blocked/banned by admin
        if ($user && !empty($user['bloqueado']) && $user['bloqueado'] == 1) {
            $razon = !empty($user['razon_bloqueo']) ? $user['razon_bloqueo'] : 'Violación de términos del servicio';
            Security::logAccess($user['id'] ?? null, 'login_blocked_admin', "Cuenta bloqueada por admin");
            Response::error('Tu cuenta ha sido bloqueada. Motivo: ' . $razon . '. Contacta al administrador para más información.', 403);
        }
        
        if (!$user || !Security::verifyPassword($password, $user['password_hash'])) {
            // Incrementar contador de intentos fallidos
            if ($user) {
                Security::incrementFailedAttempts($this->model->db, $email);
                $attempts = ($user['intentos_fallidos'] ?? 0) + 1;
                error_log("Login fallido: email={$email}, intentos={$attempts}, IP=" . Security::getClientIP());
                Security::logAccess($user['id'], 'login_fail', "Password incorrecto (intento {$attempts})");
            } else {
                Security::logAccess(null, 'login_fail', "Usuario no encontrado: {$email}");
            }
            Response::error('Credenciales incorrectas o usuario inactivo', 401);
        }

        // Login exitoso: resetear intentos fallidos, registrar IP
        Security::resetFailedAttempts($this->model->db, $email);
        AuthHelper::login($user, ['id' => $user['cliente_id']], ['id' => $user['vendedor_id']]);

        // Auditoría de login exitoso
        Security::logAccess($user['id'], 'login_success', 'Login exitoso');

        Response::success([
            'user' => AuthHelper::user(),
            'csrf_token' => Security::generateCsrfToken()
        ], 'Inicio de sesión exitoso');
    }

    /**
     * Registra un nuevo cliente vía AJAX
     * AHORA CON: validación de fortaleza de contraseña, CSRF, validación de email
     */
    public function register(): void {
        // Verificar token CSRF
        $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
        if (!Security::verifyCsrfToken($token)) {
            Response::error('Token de seguridad no válido. Recarga la página.', 403);
        }

        $nombreCompleto = Security::sanitizeString($_POST['full_name'] ?? $_POST['nombre'] ?? '');
        $rawEmail = trim($_POST['email'] ?? '');
        $password = $_POST['password'] ?? '';
        $confirm = $_POST['confirm_password'] ?? $password;

        if (empty($nombreCompleto) || empty($rawEmail) || empty($password)) {
            Response::error('Todos los campos son obligatorios', 400);
        }

        if ($password !== $confirm) {
            Response::error('Las contraseñas no coinciden', 400);
        }

        // Validar email
        $email = Security::validateEmail($rawEmail);
        if ($email === null) {
            Response::error('Formato de correo electrónico no válido', 400);
        }

        // Validar fortaleza de la contraseña
        $passValidation = Security::validatePasswordStrength($password);
        if (!$passValidation['valid']) {
            Response::error($passValidation['message'], 400);
        }

        if ($this->model->findByEmail($email)) {
            Response::error('El correo electrónico ya está registrado', 400);
        }

        $parts = explode(' ', $nombreCompleto, 2);
        $nombre = $parts[0];
        $apellido = $parts[1] ?? '';

        try {
            $userId = $this->model->registerUser([
                'nombre' => $nombre,
                'apellido' => $apellido,
                'email' => $email,
                'password' => $password,
                'rol_id' => 3
            ]);

            $user = $this->model->findByEmail($email);
            AuthHelper::login($user, ['id' => $user['cliente_id']], null);

            Security::logAccess($user['id'], 'register_success', 'Registro exitoso');

            Response::success([
                'user' => AuthHelper::user(),
                'csrf_token' => Security::generateCsrfToken()
            ], 'Cuenta creada exitosamente', 201);
        } catch (Exception $e) {
            error_log("Error al registrar usuario: " . $e->getMessage());
            Response::error('Error al registrar usuario. Intente nuevamente.', 500);
        }
    }

/**
     * Cierra la sesión (requiere CSRF para prevenir cierre forzado)
     */
    public function logout(): void {
        // Verificar CSRF
        $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
        if (!Security::verifyCsrfToken($token)) {
            Security::logAccess(null, 'logout_csrf_fail', 'Token CSRF inválido en logout');
            Response::error('Token de seguridad no válido', 403);
        }
        $user = AuthHelper::user();
        AuthHelper::logout();
        if ($user) {
            Security::logAccess($user['id'], 'logout', 'Sesión cerrada');
        }
        Response::success(null, 'Sesión cerrada correctamente');
    }

    /**
     * Procesa solicitud de restablecimiento de contraseña (Forgot Password)
     * AHORA CON: CSRF, NO expone el token en la respuesta, validación de email mejorada
     */
    public function forgotPassword(): void {
        // Verificar CSRF
        $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
        if (!Security::verifyCsrfToken($token)) {
            Response::error('Token de seguridad no válido', 403);
        }

        $rawEmail = trim($_POST['email'] ?? '');
        $email = Security::validateEmail($rawEmail);
        if ($email === null) {
            Response::error('Correo electrónico inválido', 400);
        }

        $user = $this->model->findByEmail($email);
        if (!$user) {
            // No revelar si el correo existe o no por seguridad
            Response::success(null, 'Si el correo está registrado, recibirás instrucciones para restablecer tu contraseña.');
            return;
        }

try {
            // Generar token único
            $resetToken = bin2hex(random_bytes(32));
            $expiry = date('Y-m-d H:i:s', strtotime('+1 hour'));
            $usuarioId = (int)$user['id'];
            $userName = trim(($user['nombre'] ?? '') . ' ' . ($user['apellido'] ?? ''));

            // Marcar tokens anteriores como usados
            $this->model->invalidarTokensReset($usuarioId);

            // Insertar nuevo token en la tabla tokens_autenticacion
            $this->model->crearTokenReset($usuarioId, $resetToken, $expiry);

            // Cargar MailHelper y enviar correo
            require_once ROOT_PATH . 'app/Helpers/MailHelper.php';
            $resetURL = BASE_URL . 'views/auth/reset_password.php?token=' . $resetToken;
            
            $mailResult = MailHelper::sendPasswordResetEmail($email, $userName, $resetToken, $resetURL);

            Security::logAccess($usuarioId, 'forgot_password', $mailResult['success'] ? 'Correo enviado' : 'Fallo envío correo');

            if ($mailResult['success']) {
                Response::success([
                    'email_sent' => true
                ], 'Instrucciones enviadas. Revisa tu correo electrónico.');
            } else {
                // NO devolver el token al cliente por seguridad
                error_log('Error enviando correo de recuperación a ' . $email . ': ' . $mailResult['message']);
                Response::success([
                    'email_sent' => false
                ], 'No se pudo enviar el correo. Contacta al administrador o intenta más tarde.');
            }
        } catch (Exception $e) {
            error_log("Error en forgotPassword: " . $e->getMessage());
            Response::error('Error al procesar la solicitud. Intente nuevamente.', 500);
        }
    }

    /**
     * Procesa el restablecimiento de contraseña con token
     * AHORA CON: CSRF, validación de fortaleza de contraseña
     */
    public function resetPassword(): void {
        // Verificar CSRF
        $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
        if (!Security::verifyCsrfToken($token)) {
            Response::error('Token de seguridad no válido. Recarga la página.', 403);
        }

        $resetToken = Security::sanitizeString($_POST['token'] ?? '');
        $password = $_POST['password'] ?? '';
        $confirm = $_POST['confirm_password'] ?? '';

        if (empty($resetToken) || empty($password)) {
            Response::error('Token y nueva contraseña son requeridos', 400);
        }

        if ($password !== $confirm) {
            Response::error('Las contraseñas no coinciden', 400);
        }

        // Validar fortaleza de la contraseña
        $passValidation = Security::validatePasswordStrength($password);
        if (!$passValidation['valid']) {
            Response::error($passValidation['message'], 400);
        }

try {
            // Buscar usuario por token válido y no expirado
            $tokenRow = $this->model->findUsuarioByToken($resetToken);

            if (!$tokenRow) {
                Security::logAccess(null, 'reset_password_invalid_token', 'Token inválido o expirado');
                Response::error('Token inválido o expirado. Solicita un nuevo restablecimiento.', 400);
            }

            $usuarioId = (int)$tokenRow['id'];

            // Actualizar contraseña
            $this->model->updatePassword($usuarioId, Security::hashPassword($password));

            // Marcar token como usado
            $this->model->marcarTokenUsado($resetToken);

            Security::logAccess($usuarioId, 'reset_password_success', 'Contraseña restablecida exitosamente');

            Response::success(null, 'Contraseña restablecida exitosamente. Ya puedes iniciar sesión con tu nueva contraseña.');
        } catch (Exception $e) {
            error_log("Error en resetPassword: " . $e->getMessage());
            Response::error('Error al restablecer la contraseña. Intente nuevamente.', 500);
        }
    }
}

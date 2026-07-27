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
     */
    public function login(): void {
        $email = Security::sanitizeString($_POST['email'] ?? $_POST['email_or_user'] ?? '');
        $password = $_POST['password'] ?? '';

        if (empty($email) || empty($password)) {
            Response::error('Debe ingresar correo y contraseña', 400);
        }

        $user = $this->model->findByEmail($email);
        
        // Check if user is blocked/banned
        if ($user && !empty($user['bloqueado']) && $user['bloqueado'] == 1) {
            $razon = !empty($user['razon_bloqueo']) ? $user['razon_bloqueo'] : 'Violación de términos del servicio';
            Response::error('Tu cuenta ha sido bloqueada. Motivo: ' . $razon . '. Contacta al administrador para más información.', 403);
        }
        
        if (!$user || !Security::verifyPassword($password, $user['password_hash'])) {
            Response::error('Credenciales incorrectas o usuario inactivo', 401);
        }

        AuthHelper::login($user, ['id' => $user['cliente_id']], ['id' => $user['vendedor_id']]);

        Response::success([
            'user' => AuthHelper::user(),
            'csrf_token' => Security::generateCsrfToken()
        ], 'Inicio de sesión exitoso');
    }

    /**
     * Registra un nuevo cliente vía AJAX
     */
    public function register(): void {
        $nombreCompleto = Security::sanitizeString($_POST['full_name'] ?? $_POST['nombre'] ?? '');
        $email = Security::sanitizeString($_POST['email'] ?? '');
        $password = $_POST['password'] ?? '';
        $confirm = $_POST['confirm_password'] ?? $password;

        if (empty($nombreCompleto) || empty($email) || empty($password)) {
            Response::error('Todos los campos son obligatorios', 400);
        }

        if ($password !== $confirm) {
            Response::error('Las contraseñas no coinciden', 400);
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

            Response::success([
                'user' => AuthHelper::user(),
                'csrf_token' => Security::generateCsrfToken()
            ], 'Cuenta creada exitosamente', 201);
        } catch (Exception $e) {
            Response::error('Error al registrar usuario: ' . $e->getMessage(), 500);
        }
    }

/**
     * Cierra la sesión
     */
    public function logout(): void {
        AuthHelper::logout();
        Response::success(null, 'Sesión cerrada correctamente');
    }

/**
     * Procesa solicitud de restablecimiento de contraseña (Forgot Password)
     * Usa la tabla tokens_autenticacion para almacenar el token
     * Envía el correo de recuperación usando PHPMailer via Gmail SMTP
     */
    public function forgotPassword(): void {
        $email = Security::sanitizeString($_POST['email'] ?? '');
        if (empty($email) || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
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
            $token = bin2hex(random_bytes(32));
            $expiry = date('Y-m-d H:i:s', strtotime('+1 hour'));
            $usuarioId = (int)$user['id'];
            $userName = trim(($user['nombre'] ?? '') . ' ' . ($user['apellido'] ?? ''));

            // Marcar tokens anteriores como usados
            $stmtMark = $this->model->db->prepare("UPDATE tokens_autenticacion SET usado = 1 WHERE usuario_id = :uid AND tipo = 'reset_password' AND usado = 0");
            $stmtMark->execute([':uid' => $usuarioId]);

            // Insertar nuevo token en la tabla tokens_autenticacion
            $stmtInsert = $this->model->db->prepare("INSERT INTO tokens_autenticacion (usuario_id, token, tipo, expira_en, usado) VALUES (:uid, :token, 'reset_password', :expira, 0)");
            $stmtInsert->execute([
                ':uid' => $usuarioId,
                ':token' => $token,
                ':expira' => $expiry
            ]);

            // Cargar MailHelper y enviar correo
            require_once ROOT_PATH . 'app/Helpers/MailHelper.php';
            $resetURL = BASE_URL . 'views/auth/reset_password.php?token=' . $token;
            
            $mailResult = MailHelper::sendPasswordResetEmail($email, $userName, $token, $resetURL);

            if ($mailResult['success']) {
                Response::success([
                    'email_sent' => true,
                    'message' => 'Correo enviado exitosamente a ' . $email
                ], 'Instrucciones enviadas. Revisa tu correo electrónico.');
            } else {
                // Si falla el envio, devolvemos el token de todas formas para depuración
                error_log('Error enviando correo de recuperación: ' . $mailResult['message']);
                Response::success([
                    'token' => $token,
                    'reset_url' => $resetURL,
                    'email_sent' => false,
                    'email_error' => $mailResult['message']
                ], 'No se pudo enviar el correo. Usa el token de recuperación manualmente.');
            }
        } catch (Exception $e) {
            Response::error('Error al procesar la solicitud: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Procesa el restablecimiento de contraseña con token
     * Busca el token en la tabla tokens_autenticacion
     */
    public function resetPassword(): void {
        $token = Security::sanitizeString($_POST['token'] ?? '');
        $password = $_POST['password'] ?? '';
        $confirm = $_POST['confirm_password'] ?? '';

        if (empty($token) || empty($password)) {
            Response::error('Token y nueva contraseña son requeridos', 400);
        }

        if ($password !== $confirm) {
            Response::error('Las contraseñas no coinciden', 400);
        }

        if (strlen($password) < 6) {
            Response::error('La contraseña debe tener al menos 6 caracteres', 400);
        }

        try {
            // Buscar usuario por token válido y no expirado usando la tabla tokens_autenticacion
            $stmt = $this->model->db->prepare("SELECT ta.usuario_id as id FROM tokens_autenticacion ta 
                                                WHERE ta.token = :token AND ta.tipo = 'reset_password' 
                                                AND ta.expira_en > NOW() AND ta.usado = 0");
            $stmt->execute([':token' => $token]);
            $tokenRow = $stmt->fetch();

            if (!$tokenRow) {
                Response::error('Token inválido o expirado. Solicita un nuevo restablecimiento.', 400);
            }

            $usuarioId = (int)$tokenRow['id'];

            // Actualizar contraseña
            $stmtUpd = $this->model->db->prepare("UPDATE usuarios SET password_hash = :password_hash WHERE id = :id");
            $stmtUpd->execute([
                ':password_hash' => Security::hashPassword($password),
                ':id' => $usuarioId
            ]);

            // Marcar token como usado
            $stmtTokenUsed = $this->model->db->prepare("UPDATE tokens_autenticacion SET usado = 1 WHERE token = :token");
            $stmtTokenUsed->execute([':token' => $token]);

            Response::success(null, 'Contraseña restablecida exitosamente. Ya puedes iniciar sesión con tu nueva contraseña.');
        } catch (Exception $e) {
            Response::error('Error al restablecer la contraseña: ' . $e->getMessage(), 500);
        }
    }
}

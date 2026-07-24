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
        }

        try {
            // Generar token único
            $token = bin2hex(random_bytes(32));
            $expiry = date('Y-m-d H:i:s', strtotime('+1 hour'));

            // Guardar token en BD
            $stmt = $this->model->db->prepare("UPDATE usuarios SET reset_token = :token, reset_token_expiry = :expiry WHERE email = :email");
            $stmt->execute([
                ':token' => $token,
                ':expiry' => $expiry,
                ':email' => $email
            ]);

            // En un entorno real, aquí se enviaría un correo electrónico con el enlace:
            // $resetLink = BASE_URL . "views/auth/reset_password.php?token=" . $token;
            // Por ahora simulamos el envío devolviendo el token en la respuesta
            // (En producción se debería enviar por email)

            Response::success([
                'token' => $token,
                'reset_url' => BASE_URL . 'views/auth/forgot_password.php?token=' . $token
            ], 'Instrucciones enviadas. Revisa tu correo electrónico.');
        } catch (Exception $e) {
            Response::error('Error al procesar la solicitud: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Procesa el restablecimiento de contraseña con token
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
            // Buscar usuario por token válido y no expirado
            $stmt = $this->model->db->prepare("SELECT id FROM usuarios WHERE reset_token = :token AND reset_token_expiry > NOW() AND activo = 1");
            $stmt->execute([':token' => $token]);
            $user = $stmt->fetch();

            if (!$user) {
                Response::error('Token inválido o expirado. Solicita un nuevo restablecimiento.', 400);
            }

            // Actualizar contraseña y limpiar token
            $stmtUpd = $this->model->db->prepare("UPDATE usuarios SET password_hash = :password_hash, reset_token = NULL, reset_token_expiry = NULL WHERE id = :id");
            $stmtUpd->execute([
                ':password_hash' => Security::hashPassword($password),
                ':id' => $user['id']
            ]);

            Response::success(null, 'Contraseña restablecida exitosamente. Ya puedes iniciar sesión con tu nueva contraseña.');
        } catch (Exception $e) {
            Response::error('Error al restablecer la contraseña: ' . $e->getMessage(), 500);
        }
    }
}

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
}

<?php
/**
 * API para que Administradores creen usuarios con roles específicos
 * Endpoint: POST /api/admin_register.php
 * Requiere: Sesión de Administrador
 * Crea: Vendedores, Administradores (o Clientes si se desea)
 *
 * Arquitectura de 3 capas: La lógica de negocio y acceso a datos
 * se delegan a ClienteModel (capa de datos). Este archivo solo actúa
 * como capa de presentación (routing + validación + respuesta JSON).
 */

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Models/ClienteModel.php';

AuthHelper::requireAuth();

// Verificar que sea administrador
$user = AuthHelper::user();
$roleName = strtolower($user['rol_nombre'] ?? '');
if ($roleName !== 'administrador' && $roleName !== 'admin') {
    Response::error('Solo los administradores pueden crear usuarios con roles', 403);
}

// Verificar CSRF
$token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
if (!Security::verifyCsrfToken($token)) {
    Response::error('Token CSRF no válido', 403);
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    Response::error('Método no permitido', 405);
}

$nombre = Security::sanitizeString($_POST['nombre'] ?? '');
$apellido = Security::sanitizeString($_POST['apellido'] ?? '');
$rawEmail = trim($_POST['email'] ?? '');
$password = $_POST['password'] ?? '';
$rolId = (int)($_POST['rol_id'] ?? 3);
$telefono = Security::sanitizeString($_POST['telefono'] ?? '');
$genero = Security::sanitizeString($_POST['genero'] ?? '');
$fechaNacimiento = Security::sanitizeString($_POST['fecha_nacimiento'] ?? '');
$direccion = Security::sanitizeString($_POST['direccion'] ?? '');
$nombreEmpresa = Security::sanitizeString($_POST['nombre_empresa'] ?? '');

// Validaciones
if (empty($nombre) || empty($rawEmail) || empty($password)) {
    Response::error('Nombre, email y contraseña son obligatorios', 400);
}

$email = Security::validateEmail($rawEmail);
if ($email === null) {
    Response::error('Email inválido', 400);
}

// Validar fortaleza de la contraseña
$passValidation = Security::validatePasswordStrength($password);
if (!$passValidation['valid']) {
    Response::error($passValidation['message'], 400);
}

// Validar que el rol sea válido (1=Admin, 2=Vendedor, 3=Cliente)
$rolesPermitidos = [1, 2, 3];
if (!in_array($rolId, $rolesPermitidos)) {
    Response::error('Rol no válido. Use: 1=Admin, 2=Vendedor, 3=Cliente', 400);
}

// Validar género si se proporciona
if (!empty($genero) && !in_array($genero, ['M', 'F', 'O'])) {
    Response::error('Género no válido. Use M, F u O', 400);
}

$model = new ClienteModel();

// Verificar email único
if ($model->findByEmail($email)) {
    Response::error('El email ya está registrado', 400);
}

try {
    $usuarioId = $model->registerUserByRole([
        'nombre' => $nombre,
        'apellido' => $apellido,
        'email' => $email,
        'password' => $password,
        'rol_id' => $rolId,
        'telefono' => $telefono ?: null,
        'genero' => $genero ?: null,
        'fecha_nacimiento' => $fechaNacimiento ?: null,
        'direccion' => $direccion ?: null,
        'nombre_empresa' => $rolId === 2 ? ($nombreEmpresa ?: ($nombre . ' Store')) : null
    ]);

    $rolNombre = $rolId == 1 ? 'Administrador' : ($rolId == 2 ? 'Vendedor' : 'Cliente');

    Response::success([
        'usuario_id' => $usuarioId,
        'nombre' => $nombre,
        'email' => $email,
        'rol_id' => $rolId
    ], 'Usuario creado exitosamente con rol ' . $rolNombre, 201);

} catch (Exception $e) {
    error_log("Error en admin_register.php: " . $e->getMessage());
    Response::error('Error al crear usuario. Intente nuevamente.', 500);
}

<?php
/**
 * API para que Administradores creen usuarios con roles específicos
 * Endpoint: POST /api/admin_register.php
 * Requiere: Sesión de Administrador
 * Crea: Vendedores, Administradores (o Clientes si se desea)
 */

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Helpers/Security.php';
require_once __DIR__ . '/../app/Helpers/Response.php';
require_once __DIR__ . '/../app/Helpers/AuthHelper.php';
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
    $model->beginTransaction();

    // 1. Insertar usuario
    $sqlUser = "INSERT INTO usuarios (email, password_hash, nombre, apellido, telefono, genero, fecha_nacimiento, direccion, rol_id, activo, created_at)
                VALUES (:email, :password_hash, :nombre, :apellido, :telefono, :genero, :fecha_nacimiento, :direccion, :rol_id, 1, NOW())";
    
    $stmtUser = $model->db->prepare($sqlUser);
    $stmtUser->execute([
        ':email' => $email,
        ':password_hash' => Security::hashPassword($password),
        ':nombre' => $nombre,
        ':apellido' => $apellido,
        ':telefono' => $telefono ?: null,
        ':genero' => $genero ?: null,
        ':fecha_nacimiento' => $fechaNacimiento ?: null,
        ':direccion' => $direccion ?: null,
        ':rol_id' => $rolId
    ]);

    $usuarioId = (int)$model->db->lastInsertId();

    // 2. Crear registros según el rol
    if ($rolId == 3) {
        // Cliente
        $sqlCliente = "INSERT INTO clientes (usuario_id, tipo_cliente, fecha_registro) VALUES (:uid, 'regular', NOW())";
        $model->db->prepare($sqlCliente)->execute([':uid' => $usuarioId]);
        $clienteId = (int)$model->db->lastInsertId();
        
        // Carrito
        $model->db->prepare("INSERT INTO carritos (cliente_id) VALUES (:cid)")->execute([':cid' => $clienteId]);
    } elseif ($rolId == 2) {
        // Vendedor
        $nombreEmpresa = Security::sanitizeString($_POST['nombre_empresa'] ?? ($nombre . ' Store'));
        $sqlVendedor = "INSERT INTO vendedores (usuario_id, nombre_empresa, fecha_registro) VALUES (:uid, :empresa, NOW())";
        $model->db->prepare($sqlVendedor)->execute([':uid' => $usuarioId, ':empresa' => $nombreEmpresa]);
        $vendedorId = (int)$model->db->lastInsertId();
        
        // Tienda
        $slug = strtolower(trim(preg_replace('/[^A-Za-z0-9-]+/', '-', $nombreEmpresa))) . '-' . $vendedorId;
        $sqlTienda = "INSERT INTO tiendas (vendedor_id, nombre_tienda, slug, activa, fecha_creacion) VALUES (:vid, :nombre, :slug, 1, NOW())";
        $model->db->prepare($sqlTienda)->execute([':vid' => $vendedorId, ':nombre' => $nombreEmpresa, ':slug' => $slug]);
    }
    // Admin (rol 1) no necesita tablas adicionales

    $model->commit();

    Response::success([
        'usuario_id' => $usuarioId,
        'nombre' => $nombre,
        'email' => $email,
        'rol_id' => $rolId
    ], 'Usuario creado exitosamente con rol ' . ($rolId == 1 ? 'Administrador' : ($rolId == 2 ? 'Vendedor' : 'Cliente')), 201);

} catch (Exception $e) {
    $model->rollBack();
    Response::error('Error al crear usuario: ' . $e->getMessage(), 500);
}


<?php
/**
 * API de Subida de Imágenes para Productos
 * Endpoint: POST /api/upload.php
 * Recibe: archivo (multipart/form-data)
 * Retorna: JSON con URL de la imagen subida
 */

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Helpers/Security.php';
require_once __DIR__ . '/../app/Helpers/Response.php';
require_once __DIR__ . '/../app/Helpers/AuthHelper.php';

// Solo usuarios autenticados pueden subir imágenes
AuthHelper::requireAuth();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    Response::error('Método no permitido', 405);
}

// Verificar CSRF
$token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
if (!Security::verifyCsrfToken($token)) {
    Response::error('Token CSRF no válido', 403);
}

// Verificar que se envió un archivo
if (!isset($_FILES['imagen']) || $_FILES['imagen']['error'] !== UPLOAD_ERR_OK) {
    $errorCode = $_FILES['imagen']['error'] ?? -1;
    $errorMessages = [
        UPLOAD_ERR_INI_SIZE => 'El archivo excede el tamaño máximo permitido por el servidor',
        UPLOAD_ERR_FORM_SIZE => 'El archivo excede el tamaño máximo del formulario',
        UPLOAD_ERR_PARTIAL => 'El archivo se subió parcialmente',
        UPLOAD_ERR_NO_FILE => 'No se seleccionó ningún archivo',
        UPLOAD_ERR_NO_TMP_DIR => 'Falta la carpeta temporal de subidas',
        UPLOAD_ERR_CANT_WRITE => 'Error al escribir el archivo en el disco',
    ];
    $message = $errorMessages[$errorCode] ?? 'Error al subir el archivo';
    Response::error($message, 400);
}

$archivo = $_FILES['imagen'];

// Validar tipo de archivo (solo imágenes)
$tiposPermitidos = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
$extensionesPermitidas = ['jpg', 'jpeg', 'png', 'gif', 'webp'];

$finfo = finfo_open(FILEINFO_MIME_TYPE);
$mimeType = finfo_file($finfo, $archivo['tmp_name']);
finfo_close($finfo);

if (!in_array($mimeType, $tiposPermitidos)) {
    Response::error('Tipo de archivo no permitido. Solo JPG, PNG, GIF y WebP', 400);
}

$extension = strtolower(pathinfo($archivo['name'], PATHINFO_EXTENSION));
if (!in_array($extension, $extensionesPermitidas)) {
    Response::error('Extensión de archivo no permitida', 400);
}

// Validar tamaño (máximo 5MB)
$maxSize = 5 * 1024 * 1024;
if ($archivo['size'] > $maxSize) {
    Response::error('El archivo excede el tamaño máximo de 5MB', 400);
}

// Crear directorio de uploads si no existe
$uploadDir = ROOT_PATH . 'public/uploads/productos/';
if (!is_dir($uploadDir)) {
    mkdir($uploadDir, 0755, true);
}

// Generar nombre único
$nombreUnico = uniqid('prod_') . '_' . time() . '.' . $extension;
$rutaDestino = $uploadDir . $nombreUnico;

// Mover el archivo
if (move_uploaded_file($archivo['tmp_name'], $rutaDestino)) {
    $url = BASE_URL . 'public/uploads/productos/' . $nombreUnico;
    Response::success([
        'url' => $url,
        'nombre' => $nombreUnico
    ], 'Imagen subida exitosamente');
} else {
    Response::error('Error al guardar la imagen', 500);
}


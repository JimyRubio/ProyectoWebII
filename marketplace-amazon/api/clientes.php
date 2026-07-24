<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Controllers/ClienteController.php';

$controller = new ClienteController();
$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? $_POST['action'] ?? 'profile';

// Validación CSRF para métodos POST
if ($method === 'POST') {
    $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
    if (!Security::verifyCsrfToken($token)) {
        Response::error('Token CSRF no válido o expirado', 403);
    }
}

switch ($method) {
    case 'GET':
        if ($action === 'direcciones') {
            $controller->direcciones();
        } else {
            $controller->profile();
        }
        break;

    case 'POST':
        if ($action === 'update_profile') {
            $controller->updateProfile();
        } elseif ($action === 'add_direccion') {
            $controller->storeDireccion();
        } else {
            Response::error('Acción no válida', 400);
        }
        break;

    default:
        Response::error('Método HTTP no soportado', 405);
        break;
}

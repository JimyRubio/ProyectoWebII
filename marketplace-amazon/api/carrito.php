<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Controllers/CarritoController.php';

$controller = new CarritoController();
$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? $_POST['action'] ?? null;

// Validación CSRF para métodos POST
if ($method === 'POST') {
    $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
    if (!Security::verifyCsrfToken($token)) {
        Response::error('Token CSRF no válido o expirado', 403);
    }
}

switch ($method) {
    case 'GET':
        $controller->index();
        break;

    case 'POST':
        if ($action === 'add') {
            $controller->add();
        } elseif ($action === 'update_qty') {
            $controller->updateQty();
        } elseif ($action === 'remove') {
            $controller->remove();
        } elseif ($action === 'clear') {
            $controller->clear();
        } else {
            Response::error('Acción de carrito no válida', 400);
        }
        break;

    default:
        Response::error('Método HTTP no soportado', 405);
        break;
}

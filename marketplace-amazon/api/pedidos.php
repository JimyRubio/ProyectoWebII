<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Controllers/PedidoController.php';

$controller = new PedidoController();
$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? null;
$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;

// Validación CSRF para métodos POST
if ($method === 'POST') {
    $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
    if (!Security::verifyCsrfToken($token)) {
        Response::error('Token CSRF no válido o expirado', 403);
    }
}

switch ($method) {
    case 'GET':
        if ($action === 'rastreo' && $id > 0) {
            $controller->rastreo($id);
        } elseif ($id > 0) {
            $controller->show($id);
        } else {
            $controller->index();
        }
        break;

    case 'POST':
        $controller->create();
        break;

    default:
        Response::error('Método HTTP no soportado', 405);
        break;
}

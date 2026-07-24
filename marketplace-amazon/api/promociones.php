<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Controllers/PromocionController.php';

$controller = new PromocionController();
$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? $_POST['action'] ?? 'index';

// Validación CSRF para métodos POST
if ($method === 'POST') {
    $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
    if (!Security::verifyCsrfToken($token)) {
        Response::error('Token CSRF no válido o expirado', 403);
    }
}

switch ($method) {
    case 'GET':
        if ($action === 'validar') {
            $controller->validarCupon();
        } else {
            $controller->index();
        }
        break;

    case 'POST':
        $controller->validarCupon();
        break;

    default:
        Response::error('Método HTTP no soportado', 405);
        break;
}

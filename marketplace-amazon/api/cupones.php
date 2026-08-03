<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Controllers/CuponController.php';

$controller = new CuponController();
$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? $_POST['action'] ?? 'index';
$id = isset($_GET['id']) ? (int)$_GET['id'] : (isset($_POST['id']) ? (int)$_POST['id'] : null);

// Validación CSRF solo para acciones que modifican datos (NO para validar cupón)
$csrfActions = ['store', 'update', 'delete', 'toggle'];
if ($method === 'POST' && in_array($action, $csrfActions)) {
    $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
    if (!Security::verifyCsrfToken($token)) {
        Response::error('Token CSRF no válido o expirado', 403);
    }
}

switch ($method) {
    case 'GET':
        if ($action === 'all') {
            $controller->all();
        } elseif ($action === 'activos') {
            $controller->activos();
        } elseif ($action === 'validar') {
            $controller->validarCupon();
        } else {
            Response::error('Acción GET no reconocida', 400);
        }
        break;

    case 'POST':
        if ($action === 'store') {
            $controller->store();
        } elseif ($action === 'update') {
            $controller->update();
        } elseif ($action === 'delete' && $id > 0) {
            $controller->delete($id);
        } elseif ($action === 'toggle') {
            $controller->toggle();
        } elseif ($action === 'validar') {
            $controller->validarCupon();
        } else {
            Response::error('Acción POST no reconocida', 400);
        }
        break;

    default:
        Response::error('Método HTTP no soportado', 405);
        break;
}


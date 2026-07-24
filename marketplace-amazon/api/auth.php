<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Controllers/AuthController.php';

$controller = new AuthController();
$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? $_POST['action'] ?? null;

switch ($method) {
    case 'GET':
        $controller->sessionInfo();
        break;

    case 'POST':
        if ($action === 'login') {
            $controller->login();
        } elseif ($action === 'register') {
            $controller->register();
        } elseif ($action === 'logout') {
            $controller->logout();
        } else {
            Response::error('Acción no reconocida', 400);
        }
        break;

    default:
        Response::error('Método HTTP no soportado', 405);
        break;
}

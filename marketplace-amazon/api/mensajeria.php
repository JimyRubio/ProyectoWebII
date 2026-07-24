<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Controllers/MensajeriaController.php';

$controller = new MensajeriaController();
$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? $_POST['action'] ?? 'conversaciones';

switch ($method) {
    case 'GET':
        if ($action === 'mensajes') {
            $controller->mensajes();
        } else {
            $controller->conversaciones();
        }
        break;

    case 'POST':
        $controller->enviar();
        break;

    default:
        Response::error('Método HTTP no soportado', 405);
        break;
}

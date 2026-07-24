<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Controllers/PedidoController.php';

$controller = new PedidoController();
$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? null;
$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;

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

<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Controllers/CarritoController.php';

$controller = new CarritoController();
$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? $_POST['action'] ?? null;

switch ($method) {
    case 'GET':
        $controller->index();
        break;

    case 'POST':
        if ($action === 'add') {
            $controller->add();
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

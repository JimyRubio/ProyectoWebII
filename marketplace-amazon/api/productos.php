<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Controllers/ProductoController.php';

$controller = new ProductoController();
$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? $_POST['action'] ?? null;
$id = isset($_GET['id']) ? (int)$_GET['id'] : (isset($_POST['id']) ? (int)$_POST['id'] : null);

switch ($method) {
    case 'GET':
        if ($action === 'destacados') {
            $controller->destacados();
        } elseif ($id !== null && $id > 0) {
            $controller->show($id);
        } else {
            $controller->index();
        }
        break;

    case 'POST':
        if ($action === 'store') {
            $controller->store();
        } elseif ($action === 'update_stock') {
            $controller->updateStock();
        } elseif ($action === 'delete' && $id > 0) {
            $controller->delete($id);
        } else {
            Response::error('Acción POST no válida', 400);
        }
        break;

    default:
        Response::error('Método HTTP no soportado', 405);
        break;
}

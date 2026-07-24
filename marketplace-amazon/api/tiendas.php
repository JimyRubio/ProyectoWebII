<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Controllers/TiendaController.php';

$controller = new TiendaController();
$method = $_SERVER['REQUEST_METHOD'];
$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;
$action = $_GET['action'] ?? null;

switch ($method) {
    case 'GET':
        if ($id > 0 && $action === 'productos') {
            $controller->productos($id);
        } elseif ($id > 0) {
            $controller->show($id);
        } else {
            $controller->index();
        }
        break;

    default:
        Response::error('Método HTTP no soportado', 405);
        break;
}

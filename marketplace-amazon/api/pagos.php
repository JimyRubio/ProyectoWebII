<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Controllers/PagoController.php';

$controller = new PagoController();
$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? $_POST['action'] ?? 'metodos';

switch ($method) {
    case 'GET':
        if ($action === 'guardados') {
            $controller->opcionesGuardadas();
        } else {
            $controller->metodos();
        }
        break;

    case 'POST':
        $controller->procesar();
        break;

    default:
        Response::error('Método HTTP no soportado', 405);
        break;
}

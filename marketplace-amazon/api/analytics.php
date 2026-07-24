<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Controllers/AnalyticsController.php';

$controller = new AnalyticsController();
$action = $_GET['action'] ?? $_POST['action'] ?? 'dashboard';

if ($action === 'comisiones') {
    $controller->calcularComisiones();
} else {
    $controller->dashboardData();
}

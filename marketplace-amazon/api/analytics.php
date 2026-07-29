<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Controllers/AnalyticsController.php';

try {
    $controller = new AnalyticsController();
    $action = $_GET['action'] ?? $_POST['action'] ?? 'dashboard';

    if ($action === 'comisiones') {
        $controller->calcularComisiones();
    } else {
        $controller->dashboardData();
    }
} catch (PDOException $e) {
    error_log("Error en analytics.php: " . $e->getMessage());
    Response::error('Error en la consulta de datos: ' . $e->getMessage(), 500);
} catch (Exception $e) {
    error_log("Error en analytics.php: " . $e->getMessage());
    Response::error('Error interno del servidor: ' . $e->getMessage(), 500);
}

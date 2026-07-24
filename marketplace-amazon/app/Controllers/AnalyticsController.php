<?php
require_once __DIR__ . '/../Models/AnalyticsModel.php';

class AnalyticsController {
    private AnalyticsModel $model;

    public function __construct() {
        $this->model = new AnalyticsModel();
    }

    /**
     * Retorna todos los datos en vivo para el Dashboard de Analytics en JSON
     */
    public function dashboardData(): void {
        $period = Security::sanitizeString($_GET['period'] ?? '7days');

        $kpi = $this->model->getKPIMetrics($period);
        $salesTrend = $this->model->getSalesTrendChartData();
        $categoryDist = $this->model->getCategoryDistribution();
        $topProducts = $this->model->getTopProducts();
        $activity = $this->model->getRecentActivity();

        Response::success([
            'kpis' => $kpi,
            'sales_chart' => $salesTrend,
            'category_chart' => $categoryDist,
            'top_products' => $topProducts,
            'activity' => $activity
        ], 'Datos del Dashboard de Analytics obtenidos');
    }

    /**
     * Calcula comisiones de un vendedor invocando el Stored Procedure
     */
    public function calcularComisiones(): void {
        AuthHelper::requireAuth();

        $vendedorId = (int)($_GET['vendedor_id'] ?? $_POST['vendedor_id'] ?? 1);
        $fechaInicio = Security::sanitizeString($_GET['fecha_inicio'] ?? date('Y-m-01'));
        $fechaFin = Security::sanitizeString($_GET['fecha_fin'] ?? date('Y-m-d'));

        try {
            $comisiones = $this->model->calcularComisionesVendedorSP($vendedorId, $fechaInicio, $fechaFin);
            Response::success($comisiones, 'Comisiones calculadas por Stored Procedure');
        } catch (Exception $e) {
            Response::error('Error al calcular comisiones vía SP: ' . $e->getMessage(), 500);
        }
    }
}

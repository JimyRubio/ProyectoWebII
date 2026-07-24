<?php
require_once __DIR__ . '/Model.php';

class AnalyticsModel extends Model {

    /**
     * Obtiene métricas resumidas para las tarjetas KPI del Dashboard
     */
    public function getKPIMetrics(string $period = '7days'): array {
        // Cálculo de fechas según período
        $startDate = date('Y-m-d', strtotime('-7 days'));
        if ($period === 'today') {
            $startDate = date('Y-m-d');
        } elseif ($period === '30days') {
            $startDate = date('Y-m-d', strtotime('-30 days'));
        } elseif ($period === 'this_month') {
            $startDate = date('Y-m-01');
        }

        // 1. Ventas Totales y Pedidos
        $sqlVentas = "SELECT 
                        COALESCE(SUM(total), 0) as total_sales, 
                        COUNT(id) as total_orders 
                      FROM pedidos 
                      WHERE fecha_pedido >= :start_date AND estado != 'cancelado'";
        $stmtVentas = $this->db->prepare($sqlVentas);
        $stmtVentas->execute([':start_date' => $startDate . ' 00:00:00']);
        $salesData = $stmtVentas->fetch();

        // 2. Vendedores Activos
        $sqlVendors = "SELECT COUNT(DISTINCT id) as active_vendors FROM vendedores WHERE verificado = 1";
        $stmtVendors = $this->db->query($sqlVendors);
        $vendorData = $stmtVendors->fetch();

        // 3. Tasa de Conversión Promedio
        $sqlConv = "SELECT COALESCE(AVG(conversion_rate), 3.5) as conversion_rate FROM metricas_diarias WHERE fecha >= :start_date";
        $stmtConv = $this->db->prepare($sqlConv);
        $stmtConv->execute([':start_date' => $startDate]);
        $convData = $stmtConv->fetch();

        return [
            'total_sales' => (float)($salesData['total_sales'] ?? 0),
            'total_orders' => (int)($salesData['total_orders'] ?? 0),
            'active_vendors' => (int)($vendorData['active_vendors'] ?? 0),
            'conversion_rate' => round((float)($convData['conversion_rate'] ?? 3.64), 2)
        ];
    }

    /**
     * Obtiene datos para la gráfica de tendencia de ventas (últimos días)
     */
    public function getSalesTrendChartData(): array {
        $sql = "SELECT DATE_FORMAT(fecha, '%d/%m') as dia, 
                       total_ventas, 
                       ROUND(total_ventas * 0.10, 2) as comisiones
                FROM metricas_diarias 
                ORDER BY fecha ASC 
                LIMIT 7";
        
        $stmt = $this->db->query($sql);
        $rows = $stmt->fetchAll();

        // Fallback si no hay registros suficientes en metricas_diarias
        if (empty($rows)) {
            return [
                'labels' => ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'],
                'sales' => [12400, 18500, 14200, 22100, 28900, 34500, 31200],
                'commissions' => [1240, 1850, 1420, 2210, 2890, 3450, 3120]
            ];
        }

        $labels = [];
        $sales = [];
        $commissions = [];

        foreach ($rows as $r) {
            $labels[] = $r['dia'];
            $sales[] = (float)$r['total_ventas'];
            $commissions[] = (float)$r['comisiones'];
        }

        return [
            'labels' => $labels,
            'sales' => $sales,
            'commissions' => $commissions
        ];
    }

    /**
     * Obtiene la distribución de ventas por categoría
     */
    public function getCategoryDistribution(): array {
        $sql = "SELECT c.nombre as categoria, COUNT(pi.id) as total_items, COALESCE(SUM(pi.subtotal), 0) as total_ventas
                FROM categorias c
                LEFT JOIN productos p ON p.categoria_id = c.id
                LEFT JOIN pedido_items pi ON pi.producto_id = p.id
                GROUP BY c.id
                ORDER BY total_ventas DESC
                LIMIT 5";
        
        $stmt = $this->db->query($sql);
        $rows = $stmt->fetchAll();

        if (empty($rows)) {
            return [
                'labels' => ['Electrónica', 'Ropa y Moda', 'Hogar y Cocina', 'Deportes', 'Juegos'],
                'data' => [42, 22, 16, 12, 8]
            ];
        }

        $labels = [];
        $data = [];
        foreach ($rows as $r) {
            $labels[] = $r['categoria'];
            $data[] = (float)$r['total_ventas'];
        }

        return [
            'labels' => $labels,
            'data' => $data
        ];
    }

    /**
     * Obtiene el Top 5 de productos más vendidos
     */
    public function getTopProducts(): array {
        $sql = "SELECT p.id, p.nombre, p.sku, t.nombre_tienda, 
                       p.total_vendidos as unidades, 
                       ROUND(p.total_vendidos * p.precio, 2) as total_generado
                FROM productos p
                INNER JOIN tiendas t ON p.tienda_id = t.id
                ORDER BY p.total_vendidos DESC, p.precio DESC
                LIMIT 5";
        
        $stmt = $this->db->query($sql);
        return $stmt->fetchAll();
    }

    /**
     * Obtiene el feed de actividad reciente
     */
    public function getRecentActivity(): array {
        $sql = "SELECT 'sale' as tipo, CONCAT('Nueva compra de $', p.total, ' en pedido #', p.numero_pedido) as descripcion, p.fecha_pedido as fecha
                FROM pedidos p
                ORDER BY p.id DESC
                LIMIT 5";
        
        $stmt = $this->db->query($sql);
        $activities = $stmt->fetchAll();

        if (empty($activities)) {
            return [
                ['tipo' => 'sale', 'text' => 'Nueva compra de <strong>$1,299.00</strong> en <em>TechStore Oficial</em>', 'time' => 'Hace 2 minutos'],
                ['tipo' => 'user', 'text' => 'Nuevo vendedor registrado: <strong>Fashion Outlet Store</strong>', 'time' => 'Hace 14 minutos'],
                ['tipo' => 'payout', 'text' => 'Pago procesado a tienda <strong>GamerZone Hub</strong> por $12,450.00', 'time' => 'Hace 32 minutos'],
                ['tipo' => 'sale', 'text' => 'Nueva compra de <strong>$199.00</strong> en <em>AudioPhile Direct</em>', 'time' => 'Hace 45 minutos']
            ];
        }

        return array_map(function($act) {
            return [
                'tipo' => $act['tipo'],
                'text' => $act['descripcion'],
                'time' => $act['fecha']
            ];
        }, $activities);
    }

    /**
     * Llama al Stored Procedure CALL calcular_comisiones_vendedor(?, ?, ?)
     */
    public function calcularComisionesVendedorSP(int $vendedorId, string $fechaInicio, string $fechaFin): array {
        $stmt = $this->db->prepare("CALL calcular_comisiones_vendedor(:vendedor_id, :fecha_inicio, :fecha_fin)");
        $stmt->execute([
            ':vendedor_id' => $vendedorId,
            ':fecha_inicio' => $fechaInicio,
            ':fecha_fin' => $fechaFin
        ]);
        return $stmt->fetch() ?: [];
    }
}

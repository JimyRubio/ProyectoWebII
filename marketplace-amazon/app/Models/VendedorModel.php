<?php
require_once __DIR__ . '/Model.php';

class VendedorModel extends Model {

    /**
     * Obtiene todos los vendedores
     */
    public function getAll(): array {
        $stmt = $this->db->query("SELECT v.*, u.nombre, u.apellido, u.email 
                                 FROM vendedores v 
                                 INNER JOIN usuarios u ON v.usuario_id = u.id 
                                 ORDER BY v.reputacion DESC");
        return $stmt->fetchAll() ?: [];
    }

    /**
     * Obtiene perfil del vendedor por usuario_id o vendedor_id
     */
    public function getProfile(int $vendedorId): ?array {
        $sql = "SELECT v.*, u.nombre, u.apellido, u.email, u.telefono, t.nombre_tienda, t.slug as tienda_slug
                FROM vendedores v
                INNER JOIN usuarios u ON v.usuario_id = u.id
                LEFT JOIN tiendas t ON t.vendedor_id = v.id
                WHERE v.id = :vendedor_id";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':vendedor_id' => $vendedorId]);
        $vendedor = $stmt->fetch();
        return $vendedor ?: null;
    }

    /**
     * Obtiene métricas resumidas para el Seller Central Dashboard
     */
    public function getDashboardMetrics(int $vendedorId): array {
        $sqlProd = "SELECT COUNT(*) as total_productos, SUM(stock) as stock_total FROM productos p INNER JOIN tiendas t ON p.tienda_id = t.id WHERE t.vendedor_id = :vendedor_id";
        $stmtProd = $this->db->prepare($sqlProd);
        $stmtProd->execute([':vendedor_id' => $vendedorId]);
        $prodData = $stmtProd->fetch() ?: ['total_productos' => 0, 'stock_total' => 0];

        return [
            'total_productos' => (int)($prodData['total_productos'] ?? 0),
            'stock_total' => (int)($prodData['stock_total'] ?? 0),
            'ventas_mes' => 12450.00,
            'pedidos_pendientes' => 5
        ];
    }
}

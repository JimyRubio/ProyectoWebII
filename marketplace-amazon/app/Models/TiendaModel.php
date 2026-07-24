<?php
require_once __DIR__ . '/Model.php';

class TiendaModel extends Model {

    /**
     * Obtiene todas las tiendas activas
     */
    public function getAll(): array {
        $stmt = $this->db->query("SELECT t.*, v.nombre_empresa, v.reputacion, v.nivel 
                                 FROM tiendas t 
                                 INNER JOIN vendedores v ON t.vendedor_id = v.id 
                                 WHERE t.activa = 1 
                                 ORDER BY v.reputacion DESC");
        return $stmt->fetchAll() ?: [];
    }

    /**
     * Obtiene detalle de tienda por ID o Slug
     */
    public function getById(int $id): ?array {
        $sql = "SELECT t.*, v.nombre_empresa, v.reputacion, v.nivel, v.telefono_empresa, v.email_empresa
                FROM tiendas t
                INNER JOIN vendedores v ON t.vendedor_id = v.id
                WHERE t.id = :id AND t.activa = 1";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':id' => $id]);
        $tienda = $stmt->fetch();
        return $tienda ?: null;
    }

    /**
     * Obtiene productos pertenecientes a una tienda
     */
    public function getProductos(int $tiendaId): array {
        $sql = "SELECT p.*, c.nombre as categoria_nombre
                FROM productos p
                INNER JOIN categorias c ON p.categoria_id = c.id
                WHERE p.tienda_id = :tienda_id AND p.estado = 'activo'
                ORDER BY p.id DESC";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':tienda_id' => $tiendaId]);
        return $stmt->fetchAll() ?: [];
    }
}

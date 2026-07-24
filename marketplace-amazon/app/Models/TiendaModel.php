<?php
require_once __DIR__ . '/Model.php';

class TiendaModel extends Model {
    public function getAll(): array {
        $stmt = $this->db->query("SELECT t.*, v.nombre_empresa FROM tiendas t INNER JOIN vendedores v ON t.vendedor_id = v.id WHERE t.activa = 1");
        return $stmt->fetchAll();
    }
}

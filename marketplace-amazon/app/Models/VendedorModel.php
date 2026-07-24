<?php
require_once __DIR__ . '/Model.php';

class VendedorModel extends Model {
    public function getAll(): array {
        $stmt = $this->db->query("SELECT v.*, u.nombre, u.apellido, u.email FROM vendedores v INNER JOIN usuarios u ON v.usuario_id = u.id");
        return $stmt->fetchAll();
    }
}

<?php
require_once __DIR__ . '/Model.php';

class PagoModel extends Model {
    public function getMetodos(): array {
        $stmt = $this->db->query("SELECT * FROM metodos_pago WHERE activo = 1");
        return $stmt->fetchAll();
    }
}

<?php
require_once __DIR__ . '/Model.php';

class PromocionModel extends Model {
    public function getActivas(): array {
        $stmt = $this->db->query("SELECT * FROM promociones WHERE activo = 1 AND fecha_fin >= NOW()");
        return $stmt->fetchAll();
    }
}

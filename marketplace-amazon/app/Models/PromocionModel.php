<?php
require_once __DIR__ . '/Model.php';

class PromocionModel extends Model {

    /**
     * Obtiene todas las promociones vigentes
     */
    public function getActivas(): array {
        $stmt = $this->db->query("SELECT * FROM promociones WHERE activo = 1 AND fecha_fin >= NOW() ORDER BY fecha_inicio DESC");
        return $stmt->fetchAll() ?: [];
    }

    /**
     * Valida y consulta un cupón de descuento por su código
     */
    public function validarCupon(string $codigo): ?array {
        $sql = "SELECT * FROM cupones WHERE codigo = :codigo AND activo = 1 AND fecha_fin >= NOW()";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':codigo' => strtoupper(trim($codigo))]);
        $cupon = $stmt->fetch();
        return $cupon ?: null;
    }
}

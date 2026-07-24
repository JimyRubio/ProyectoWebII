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
     * Obtiene todas las promociones (para admin/vendedor)
     */
    public function getAll(): array {
        $stmt = $this->db->query("SELECT * FROM promociones ORDER BY fecha_inicio DESC");
        return $stmt->fetchAll() ?: [];
    }

    /**
     * Crea una nueva promoción
     */
    public function create(array $data): int {
        $sql = "INSERT INTO promociones (codigo, nombre, descripcion, tipo, valor, minimo_compra, maximo_descuento, usa_veces, usa_por_cliente, fecha_inicio, fecha_fin, activo, created_at)
                VALUES (:codigo, :nombre, :descripcion, :tipo, :valor, :minimo_compra, :maximo_descuento, :usa_veces, :usa_por_cliente, :fecha_inicio, :fecha_fin, 1, NOW())";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([
            ':codigo' => $data['codigo'] ?? null,
            ':nombre' => $data['nombre'],
            ':descripcion' => $data['descripcion'] ?? '',
            ':tipo' => $data['tipo'],
            ':valor' => $data['valor'],
            ':minimo_compra' => $data['minimo_compra'] ?? 0,
            ':maximo_descuento' => $data['maximo_descuento'] ?? null,
            ':usa_veces' => $data['usa_veces'] ?? 1,
            ':usa_por_cliente' => $data['usa_por_cliente'] ?? 1,
            ':fecha_inicio' => $data['fecha_inicio'],
            ':fecha_fin' => $data['fecha_fin']
        ]);
        return (int)$this->db->lastInsertId();
    }

    /**
     * Actualiza una promoción existente
     */
    public function update(int $id, array $data): bool {
        $sql = "UPDATE promociones SET 
                    codigo = :codigo,
                    nombre = :nombre,
                    descripcion = :descripcion,
                    tipo = :tipo,
                    valor = :valor,
                    minimo_compra = :minimo_compra,
                    fecha_inicio = :fecha_inicio,
                    fecha_fin = :fecha_fin,
                    updated_at = NOW()
                WHERE id = :id";
        $stmt = $this->db->prepare($sql);
        return $stmt->execute([
            ':id' => $id,
            ':codigo' => $data['codigo'] ?? null,
            ':nombre' => $data['nombre'],
            ':descripcion' => $data['descripcion'] ?? '',
            ':tipo' => $data['tipo'],
            ':valor' => $data['valor'],
            ':minimo_compra' => $data['minimo_compra'] ?? 0,
            ':fecha_inicio' => $data['fecha_inicio'],
            ':fecha_fin' => $data['fecha_fin']
        ]);
    }

    /**
     * Elimina una promoción
     */
    public function delete(int $id): bool {
        $stmt = $this->db->prepare("DELETE FROM promociones WHERE id = :id");
        return $stmt->execute([':id' => $id]);
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

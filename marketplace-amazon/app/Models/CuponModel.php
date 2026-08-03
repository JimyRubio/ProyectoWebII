<?php
require_once __DIR__ . '/Model.php';

class CuponModel extends Model {

    /**
     * Obtiene todos los cupones (para admin)
     */
    public function getAll(): array {
        $stmt = $this->db->query("SELECT * FROM cupones ORDER BY id DESC");
        return $stmt->fetchAll() ?: [];
    }

    /**
     * Obtiene una lista de cupones activos y vigentes (para mostrar en tienda)
     */
    public function getActivos(): array {
        $stmt = $this->db->query(
            "SELECT * FROM cupones 
             WHERE activo = 1 
               AND fecha_inicio <= NOW() 
               AND fecha_fin >= NOW() 
             ORDER BY fecha_fin ASC"
        );
        return $stmt->fetchAll() ?: [];
    }

    /**
     * Obtiene un cupón por su ID
     */
    public function getById(int $id): ?array {
        $stmt = $this->db->prepare("SELECT * FROM cupones WHERE id = :id");
        $stmt->execute([':id' => $id]);
        $cupon = $stmt->fetch();
        return $cupon ?: null;
    }

    /**
     * Valida y consulta un cupón por su código
     * Considera: activo, fecha_inicio <= NOW(), fecha_fin >= NOW()
     */
    public function validarCupon(string $codigo): ?array {
        $sql = "SELECT * FROM cupones 
                WHERE codigo = :codigo 
                  AND activo = 1 
                  AND fecha_inicio <= NOW() 
                  AND fecha_fin >= NOW()";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':codigo' => strtoupper(trim($codigo))]);
        $cupon = $stmt->fetch();
        return $cupon ?: null;
    }

    /**
     * Crea un nuevo cupón
     */
    public function create(array $data): int {
        $sql = "INSERT INTO cupones 
                    (codigo, descripcion, tipo_descuento, valor, minimo_compra, maximo_descuento,
                     productos_aplicables, categorias_aplicables, fecha_inicio, fecha_fin,
                     usa_veces, usa_por_cliente, activo, created_at)
                VALUES 
                    (:codigo, :descripcion, :tipo_descuento, :valor, :minimo_compra, :maximo_descuento,
                     :productos_aplicables, :categorias_aplicables, :fecha_inicio, :fecha_fin,
                     :usa_veces, :usa_por_cliente, :activo, NOW())";

        $stmt = $this->db->prepare($sql);
        $stmt->execute([
            ':codigo'               => strtoupper(trim($data['codigo'])),
            ':descripcion'          => $data['descripcion'] ?? '',
            ':tipo_descuento'       => $data['tipo_descuento'],
            ':valor'                => $data['valor'],
            ':minimo_compra'        => $data['minimo_compra'] ?? 0,
            ':maximo_descuento'     => $data['maximo_descuento'] ?? null,
            ':productos_aplicables' => $data['productos_aplicables'] ?? null,
            ':categorias_aplicables'=> $data['categorias_aplicables'] ?? null,
            ':fecha_inicio'         => $data['fecha_inicio'],
            ':fecha_fin'            => $data['fecha_fin'],
            ':usa_veces'            => $data['usa_veces'] ?? 1,
            ':usa_por_cliente'      => $data['usa_por_cliente'] ?? 1,
            ':activo'               => (int)($data['activo'] ?? 1)
        ]);

        return (int)$this->db->lastInsertId();
    }

    /**
     * Actualiza un cupón existente
     */
    public function update(int $id, array $data): bool {
        $sql = "UPDATE cupones SET 
                    codigo = :codigo,
                    descripcion = :descripcion,
                    tipo_descuento = :tipo_descuento,
                    valor = :valor,
                    minimo_compra = :minimo_compra,
                    maximo_descuento = :maximo_descuento,
                    productos_aplicables = :productos_aplicables,
                    categorias_aplicables = :categorias_aplicables,
                    fecha_inicio = :fecha_inicio,
                    fecha_fin = :fecha_fin,
                    usa_veces = :usa_veces,
                    usa_por_cliente = :usa_por_cliente,
                    activo = :activo,
                    updated_at = NOW()
                WHERE id = :id";

        $stmt = $this->db->prepare($sql);
        return $stmt->execute([
            ':id'                    => $id,
            ':codigo'                => strtoupper(trim($data['codigo'] ?? '')),
            ':descripcion'           => $data['descripcion'] ?? '',
            ':tipo_descuento'        => $data['tipo_descuento'],
            ':valor'                 => $data['valor'],
            ':minimo_compra'         => $data['minimo_compra'] ?? 0,
            ':maximo_descuento'      => $data['maximo_descuento'] ?? null,
            ':productos_aplicables'  => $data['productos_aplicables'] ?? null,
            ':categorias_aplicables' => $data['categorias_aplicables'] ?? null,
            ':fecha_inicio'          => $data['fecha_inicio'],
            ':fecha_fin'             => $data['fecha_fin'],
            ':usa_veces'             => $data['usa_veces'] ?? 1,
            ':usa_por_cliente'       => $data['usa_por_cliente'] ?? 1,
            ':activo'                => (int)($data['activo'] ?? 1)
        ]);
    }

    /**
     * Elimina un cupón
     */
    public function delete(int $id): bool {
        $stmt = $this->db->prepare("DELETE FROM cupones WHERE id = :id");
        return $stmt->execute([':id' => $id]);
    }

    /**
     * Activa o desactiva un cupón
     */
    public function toggleActivo(int $id): bool {
        $stmt = $this->db->prepare("UPDATE cupones SET activo = 1 - activo, updated_at = NOW() WHERE id = :id");
        return $stmt->execute([':id' => $id]);
    }
}


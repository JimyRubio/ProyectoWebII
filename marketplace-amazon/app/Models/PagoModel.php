<?php
require_once __DIR__ . '/Model.php';

class PagoModel extends Model {
    
    /**
     * Obtiene los métodos de pago activos
     */
    public function getMetodos(): array {
        $stmt = $this->db->query("SELECT * FROM metodos_pago WHERE activo = 1 ORDER BY id ASC");
        return $stmt->fetchAll() ?: [];
    }

    /**
     * Obtiene opciones de pago guardadas por un cliente
     */
    public function getOpcionesGuardadas(int $clienteId): array {
        $sql = "SELECT * FROM opciones_pago_guardadas WHERE cliente_id = :cliente_id ORDER BY predeterminado DESC, id DESC";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':cliente_id' => $clienteId]);
        return $stmt->fetchAll() ?: [];
    }

    /**
     * Procesa y registra un pago para un pedido
     */
    public function registrarPago(array $data): int {
        $this->beginTransaction();
        try {
            $sql = "INSERT INTO pagos (pedido_id, metodo_pago_id, monto, estado, codigo_transaccion, fecha_pago, created_at)
                    VALUES (:pedido_id, :metodo_pago_id, :monto, :estado, :codigo_transaccion, NOW(), NOW())";
            $stmt = $this->db->prepare($sql);
            $codigoTransaccion = 'TRX-' . strtoupper(bin2hex(random_bytes(6)));
            
            $stmt->execute([
                ':pedido_id' => $data['pedido_id'],
                ':metodo_pago_id' => $data['metodo_pago_id'],
                ':monto' => $data['monto'],
                ':estado' => $data['estado'] ?? 'completado',
                ':codigo_transaccion' => $codigoTransaccion
            ]);

            $pagoId = (int)$this->db->lastInsertId();

            // Actualizar estado del pedido
            $sqlOrder = "UPDATE pedidos SET estado_pago = 'pagado', estado = 'confirmado' WHERE id = :pedido_id";
            $stmtOrder = $this->db->prepare($sqlOrder);
            $stmtOrder->execute([':pedido_id' => $data['pedido_id']]);

            $this->commit();
            return $pagoId;
        } catch (Exception $e) {
            $this->rollBack();
            throw $e;
        }
    }
}

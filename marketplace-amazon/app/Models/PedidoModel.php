<?php
require_once __DIR__ . '/Model.php';

class PedidoModel extends Model {

    /**
     * Crea un pedido a partir de un carrito de compras
     */
    public function createOrder(int $clienteId, array $items, float $subtotal, float $costoEnvio = 0.00, ?int $direccionId = null): int {
        $this->beginTransaction();
        try {
            $numeroPedido = 'ORD-' . strtoupper(uniqid());
            $total = $subtotal + $costoEnvio;

            $sqlOrder = "INSERT INTO pedidos (cliente_id, numero_pedido, estado, estado_pago, subtotal, costo_envio, total, direccion_envio_id, fecha_pedido)
                         VALUES (:cliente_id, :numero_pedido, 'pendiente', 'pendiente', :subtotal, :costo_envio, :total, :direccion_id, NOW())";
            
            $stmtOrder = $this->db->prepare($sqlOrder);
            $stmtOrder->execute([
                ':cliente_id' => $clienteId,
                ':numero_pedido' => $numeroPedido,
                ':subtotal' => $subtotal,
                ':costo_envio' => $costoEnvio,
                ':total' => $total,
                ':direccion_id' => $direccionId
            ]);

            $pedidoId = (int)$this->db->lastInsertId();

            // Insertar items del pedido
            $sqlItem = "INSERT INTO pedido_items (pedido_id, producto_id, cantidad, precio_unitario, subtotal)
                        VALUES (:pedido_id, :producto_id, :cantidad, :precio_unitario, :subtotal)";
            $stmtItem = $this->db->prepare($sqlItem);

            foreach ($items as $item) {
                $stmtItem->execute([
                    ':pedido_id' => $pedidoId,
                    ':producto_id' => $item['producto_id'],
                    ':cantidad' => $item['cantidad'],
                    ':precio_unitario' => $item['precio_unitario'],
                    ':subtotal' => $item['subtotal']
                ]);
            }

            $this->commit();
            return $pedidoId;
        } catch (Exception $e) {
            $this->rollBack();
            throw $e;
        }
    }

    /**
     * Procesa y confirma el pedido invocando el Stored Procedure CALL procesar_pedido(?)
     */
    public function procesarPedidoSP(int $pedidoId): bool {
        $stmt = $this->db->prepare("CALL procesar_pedido(:pedido_id)");
        return $stmt->execute([':pedido_id' => $pedidoId]);
    }

    /**
     * Obtiene el detalle completo del pedido
     */
    public function getById(int $id): ?array {
        $sql = "SELECT p.*, CONCAT(u.nombre, ' ', u.apellido) as cliente_nombre, u.email as cliente_email
                FROM pedidos p
                INNER JOIN clientes c ON p.cliente_id = c.id
                INNER JOIN usuarios u ON c.usuario_id = u.id
                WHERE p.id = :id";
        
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':id' => $id]);
        $pedido = $stmt->fetch();

        if (!$pedido) return null;

        $sqlItems = "SELECT pi.*, pr.nombre as producto_nombre, pr.sku
                     FROM pedido_items pi
                     INNER JOIN productos pr ON pi.producto_id = pr.id
                     WHERE pi.pedido_id = :pedido_id";
        $stmtItems = $this->db->prepare($sqlItems);
        $stmtItems->execute([':pedido_id' => $id]);
        $pedido['items'] = $stmtItems->fetchAll();

        return $pedido;
    }
}

<?php
require_once __DIR__ . '/Model.php';

class PedidoModel extends Model {

    /**
     * Crea un pedido a partir de un carrito de compras
     */
    public function createOrder(int $clienteId, array $items, float $subtotal, float $costoEnvio = 0.00, ?int $direccionId = null, float $descuentos = 0.00): int {
        $this->beginTransaction();
        try {
            $numeroPedido = 'ORD-' . strtoupper(uniqid());
            $total = ($subtotal + $costoEnvio) - $descuentos;
            if ($total < 0) $total = 0;

            $sqlOrder = "INSERT INTO pedidos (cliente_id, numero_pedido, estado, estado_pago, subtotal, descuentos, costo_envio, total, direccion_envio_id, fecha_pedido)
                         VALUES (:cliente_id, :numero_pedido, 'pendiente', 'pendiente', :subtotal, :descuentos, :costo_envio, :total, :direccion_id, NOW())";
            
            $stmtOrder = $this->db->prepare($sqlOrder);
            $stmtOrder->execute([
                ':cliente_id' => $clienteId,
                ':numero_pedido' => $numeroPedido,
                ':subtotal' => $subtotal,
                ':descuentos' => $descuentos,
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

            // Insertar historial inicial
            $sqlHist = "INSERT INTO historial_estados_pedido (pedido_id, estado_nuevo, comentario)
                        VALUES (:pedido_id, 'pendiente', 'Pedido registrado exitosamente')";
            $this->db->prepare($sqlHist)->execute([':pedido_id' => $pedidoId]);

            $this->commit();
            return $pedidoId;
        } catch (Exception $e) {
            $this->rollBack();
            throw $e;
        }
    }

/**
     * Procesa y confirma el pedido (actualiza estado, stock y totales)
     * Reemplaza el Stored Procedure 'procesar_pedido' que no existe en la BD
     */
    public function procesarPedidoSP(int $pedidoId): bool {
        $this->beginTransaction();
        try {
            // 1. Actualizar estado del pedido a confirmado
            $stmtOrder = $this->db->prepare("UPDATE pedidos SET estado = 'confirmado', fecha_confirmacion = NOW() WHERE id = :id AND estado = 'pendiente'");
            $stmtOrder->execute([':id' => $pedidoId]);

            // 2. Obtener los items del pedido
            $stmtItems = $this->db->prepare("SELECT producto_id, cantidad FROM pedido_items WHERE pedido_id = :pedido_id");
            $stmtItems->execute([':pedido_id' => $pedidoId]);
            $items = $stmtItems->fetchAll();

            // 3. Actualizar stock y total_vendidos de cada producto
            foreach ($items as $item) {
                $productoId = (int)$item['producto_id'];
                $cantidad = (int)$item['cantidad'];

                // Descontar stock
                $stmtStock = $this->db->prepare("UPDATE productos SET stock = stock - :cantidad, total_vendidos = total_vendidos + :cantidad2 WHERE id = :producto_id AND stock >= :cantidad3");
                $stmtStock->execute([
                    ':cantidad' => $cantidad,
                    ':cantidad2' => $cantidad,
                    ':cantidad3' => $cantidad,
                    ':producto_id' => $productoId
                ]);

                // Si stock llegó a 0, marcar como agotado
                $stmtCheck = $this->db->prepare("UPDATE productos SET estado = 'agotado' WHERE id = :id AND stock <= 0 AND estado = 'activo'");
                $stmtCheck->execute([':id' => $productoId]);
            }

            // 4. Insertar en historial de estados
            $stmtHist = $this->db->prepare("INSERT INTO historial_estados_pedido (pedido_id, estado_anterior, estado_nuevo, comentario) VALUES (:pedido_id, 'pendiente', 'confirmado', 'Pedido procesado y confirmado exitosamente')");
            $stmtHist->execute([':pedido_id' => $pedidoId]);

            // 5. Registrar en auditoría
            $stmtAudit = $this->db->prepare("INSERT INTO auditoria (usuario_id, accion, tabla_afectada, registro_id, datos_nuevos) VALUES (NULL, 'PROCESAR_PEDIDO', 'pedidos', :pedido_id, :datos)");
            $stmtAudit->execute([
                ':pedido_id' => $pedidoId,
                ':datos' => json_encode(['estado' => 'confirmado'])
            ]);

            $this->commit();
            return true;
        } catch (Exception $e) {
            $this->rollBack();
            error_log("Error procesarPedidoSP: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Obtiene los pedidos de un cliente
     */
    public function getByCliente(int $clienteId): array {
        $sql = "SELECT p.*, COUNT(pi.id) as total_items
                FROM pedidos p
                LEFT JOIN pedido_items pi ON pi.pedido_id = p.id
                WHERE p.cliente_id = :cliente_id
                GROUP BY p.id
                ORDER BY p.fecha_pedido DESC";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':cliente_id' => $clienteId]);
        return $stmt->fetchAll() ?: [];
    }

    /**
     * Obtiene el detalle completo del pedido
     */
    public function getById(int $id): ?array {
        $sql = "SELECT p.*, CONCAT(u.nombre, ' ', u.apellido) as cliente_nombre, u.email as cliente_email,
                       d.calle, d.numero, d.ciudad, d.estado as estado_dir, d.codigo_postal
                FROM pedidos p
                INNER JOIN clientes c ON p.cliente_id = c.id
                INNER JOIN usuarios u ON c.usuario_id = u.id
                LEFT JOIN direcciones d ON p.direccion_envio_id = d.id
                WHERE p.id = :id";
        
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':id' => $id]);
        $pedido = $stmt->fetch();

        if (!$pedido) return null;

        $sqlItems = "SELECT pi.*, pr.nombre as producto_nombre, pr.sku,
                            (SELECT url FROM imagenes_productos WHERE producto_id = pr.id ORDER BY principal DESC, orden ASC LIMIT 1) as imagen_url
                     FROM pedido_items pi
                     INNER JOIN productos pr ON pi.producto_id = pr.id
                     WHERE pi.pedido_id = :pedido_id";
        $stmtItems = $this->db->prepare($sqlItems);
        $stmtItems->execute([':pedido_id' => $id]);
        $pedido['items'] = $stmtItems->fetchAll() ?: [];

        return $pedido;
    }

    /**
     * Obtiene el seguimiento/rastreo de un envio
     */
    public function getRastreo(int $pedidoId): array {
        $sql = "SELECT h.*, e.tracking_number, t.nombre as transportista_nombre
                FROM historial_estados_pedido h
                LEFT JOIN pedidos p ON p.id = h.pedido_id
                LEFT JOIN envios e ON e.pedido_id = p.id
                LEFT JOIN transportistas t ON t.id = e.transportista_id
                WHERE h.pedido_id = :pedido_id
                ORDER BY h.created_at ASC";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':pedido_id' => $pedidoId]);
        return $stmt->fetchAll() ?: [];
    }
}

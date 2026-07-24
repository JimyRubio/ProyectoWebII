<?php
require_once __DIR__ . '/Model.php';

class CarritoModel extends Model {

    /**
     * Obtiene o crea el carrito activo de un cliente
     */
    public function getCartByClienteId(int $clienteId): array {
        $stmt = $this->db->prepare("SELECT * FROM carritos WHERE cliente_id = :cliente_id");
        $stmt->execute([':cliente_id' => $clienteId]);
        $cart = $stmt->fetch();

        if (!$cart) {
            $stmtInsert = $this->db->prepare("INSERT INTO carritos (cliente_id) VALUES (:cliente_id)");
            $stmtInsert->execute([':cliente_id' => $clienteId]);
            $cartId = (int)$this->db->lastInsertId();
            $cart = [
                'id' => $cartId,
                'cliente_id' => $clienteId,
                'total_items' => 0,
                'subtotal' => 0.00,
                'descuentos' => 0.00,
                'total' => 0.00
            ];
        }

        // Cargar los items del carrito con información del producto
        $sqlItems = "SELECT ci.*, p.nombre as producto_nombre, p.precio, p.sku,
                            (SELECT url FROM imagenes_productos WHERE producto_id = p.id ORDER BY principal DESC LIMIT 1) as imagen_url
                     FROM carrito_items ci
                     INNER JOIN productos p ON ci.producto_id = p.id
                     WHERE ci.carrito_id = :carrito_id";
        
        $stmtItems = $this->db->prepare($sqlItems);
        $stmtItems->execute([':carrito_id' => $cart['id']]);
        $items = $stmtItems->fetchAll();
        $cart['items'] = $items;

        // Recalcular totales desde los items en lugar de confiar en triggers
        $totalItems = 0;
        $subtotal = 0.00;
        foreach ($items as $item) {
            $totalItems += (int)$item['cantidad'];
            $subtotal += (float)$item['subtotal'];
        }
        $cart['total_items'] = $totalItems;
        $cart['subtotal'] = round($subtotal, 2);
        $cart['total'] = round($subtotal - (float)($cart['descuentos'] ?? 0), 2);

        return $cart;
    }

    /**
     * Agrega un producto al carrito y recalcula totales
     */
    public function addItem(int $cartId, int $productoId, int $cantidad = 1, float $precioUnitario = 0.00): bool {
        $this->db->beginTransaction();
        try {
            // Verificar si el item ya existe en el carrito
            $stmtCheck = $this->db->prepare("SELECT id, cantidad FROM carrito_items WHERE carrito_id = ? AND producto_id = ?");
            $stmtCheck->execute([$cartId, $productoId]);
            $existing = $stmtCheck->fetch();

            if ($existing) {
                $nuevaCantidad = $existing['cantidad'] + $cantidad;
                $subtotal = $nuevaCantidad * $precioUnitario;
                $stmtUpdate = $this->db->prepare("UPDATE carrito_items SET cantidad = ?, subtotal = ?, updated_at = NOW() WHERE id = ?");
                $stmtUpdate->execute([$nuevaCantidad, $subtotal, $existing['id']]);
            } else {
                $subtotal = $cantidad * $precioUnitario;
                $stmtInsert = $this->db->prepare("INSERT INTO carrito_items (carrito_id, producto_id, cantidad, precio_unitario, subtotal) VALUES (?, ?, ?, ?, ?)");
                $stmtInsert->execute([$cartId, $productoId, $cantidad, $precioUnitario, $subtotal]);
            }

            // Recalcular totales del carrito explícitamente
            $this->recalcularTotales($cartId);
            $this->db->commit();
            return true;
        } catch (Exception $e) {
            $this->db->rollBack();
            error_log("Error addItem: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Recalcula los totales del carrito desde los items
     */
    private function recalcularTotales(int $cartId): void {
        $sql = "SELECT COUNT(id) as total_items, COALESCE(SUM(subtotal), 0) as subtotal FROM carrito_items WHERE carrito_id = ?";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$cartId]);
        $totales = $stmt->fetch();

        $items = (int)($totales['total_items'] ?? 0);
        $subtotal = round((float)($totales['subtotal'] ?? 0), 2);

        // Usar positional params para evitar error HY093 de named params duplicados
        $stmtUpd = $this->db->prepare("UPDATE carritos SET total_items = ?, subtotal = ?, total = ? - COALESCE(descuentos, 0) WHERE id = ?");
        $stmtUpd->execute([$items, $subtotal, $subtotal, $cartId]);
    }

    /**
     * Obtiene el precio unitario de un ítem del carrito
     */
    public function getItemPrecioUnitario(int $itemId): ?float {
        $stmt = $this->db->prepare("SELECT precio_unitario FROM carrito_items WHERE id = ?");
        $stmt->execute([$itemId]);
        $item = $stmt->fetch();
        return $item ? (float)$item['precio_unitario'] : null;
    }

    /**
     * Actualiza la cantidad de un ítem en el carrito y recalcula totales
     */
    public function updateItemQty(int $itemId, int $cantidad, float $precioUnitario = 0.00): bool {
        $this->db->beginTransaction();
        try {
            $subtotal = $cantidad * $precioUnitario;
            $stmt = $this->db->prepare("UPDATE carrito_items SET cantidad = ?, subtotal = ?, updated_at = NOW() WHERE id = ?");
            $stmt->execute([$cantidad, $subtotal, $itemId]);

            // Obtener carrito_id para recalcular
            $stmtCart = $this->db->prepare("SELECT carrito_id FROM carrito_items WHERE id = ?");
            $stmtCart->execute([$itemId]);
            $row = $stmtCart->fetch();
            if ($row) {
                $this->recalcularTotales((int)$row['carrito_id']);
            }
            $this->db->commit();
            return true;
        } catch (Exception $e) {
            $this->db->rollBack();
            error_log("Error updateItemQty: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Remueve un ítem del carrito y recalcula totales
     */
    public function removeItem(int $itemId): bool {
        $this->db->beginTransaction();
        try {
            $stmtCart = $this->db->prepare("SELECT carrito_id FROM carrito_items WHERE id = ?");
            $stmtCart->execute([$itemId]);
            $row = $stmtCart->fetch();
            $cartId = $row ? (int)$row['carrito_id'] : 0;

            $stmt = $this->db->prepare("DELETE FROM carrito_items WHERE id = ?");
            $stmt->execute([$itemId]);

            if ($cartId > 0) {
                $this->recalcularTotales($cartId);
            }
            $this->db->commit();
            return true;
        } catch (Exception $e) {
            $this->db->rollBack();
            error_log("Error removeItem: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Vacía el carrito por completo y recalcula totales
     */
    public function clearCart(int $cartId): bool {
        $this->db->beginTransaction();
        try {
            $stmt = $this->db->prepare("DELETE FROM carrito_items WHERE carrito_id = ?");
            $stmt->execute([$cartId]);
            $this->recalcularTotales($cartId);
            $this->db->commit();
            return true;
        } catch (Exception $e) {
            $this->db->rollBack();
            error_log("Error clearCart: " . $e->getMessage());
            return false;
        }
    }
}

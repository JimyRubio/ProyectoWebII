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
        $cart['items'] = $stmtItems->fetchAll();

        return $cart;
    }

    /**
     * Agrega un producto al carrito
     */
    public function addItem(int $cartId, int $productoId, int $cantidad = 1, float $precioUnitario = 0.00): bool {
        // Verificar si el item ya existe en el carrito
        $stmtCheck = $this->db->prepare("SELECT id, cantidad FROM carrito_items WHERE carrito_id = :carrito_id AND producto_id = :producto_id");
        $stmtCheck->execute([':carrito_id' => $cartId, ':producto_id' => $productoId]);
        $existing = $stmtCheck->fetch();

        if ($existing) {
            $nuevaCantidad = $existing['cantidad'] + $cantidad;
            $subtotal = $nuevaCantidad * $precioUnitario;
            $stmtUpdate = $this->db->prepare("UPDATE carrito_items SET cantidad = :cantidad, subtotal = :subtotal, updated_at = NOW() WHERE id = :id");
            return $stmtUpdate->execute([':cantidad' => $nuevaCantidad, ':subtotal' => $subtotal, ':id' => $existing['id']]);
        }

        $subtotal = $cantidad * $precioUnitario;
        // Al insertar, el Trigger MySQL tr_carrito_update actualiza los totales de la tabla carritos
        $stmtInsert = $this->db->prepare("INSERT INTO carrito_items (carrito_id, producto_id, cantidad, precio_unitario, subtotal) VALUES (:carrito_id, :producto_id, :cantidad, :precio_unitario, :subtotal)");
        return $stmtInsert->execute([
            ':carrito_id' => $cartId,
            ':producto_id' => $productoId,
            ':cantidad' => $cantidad,
            ':precio_unitario' => $precioUnitario,
            ':subtotal' => $subtotal
        ]);
    }

    /**
     * Remueve un ítem del carrito
     */
    public function removeItem(int $itemId): bool {
        $stmt = $this->db->prepare("DELETE FROM carrito_items WHERE id = :id");
        return $stmt->execute([':id' => $itemId]);
    }

    /**
     * Vacía el carrito por completo
     */
    public function clearCart(int $cartId): bool {
        $stmt = $this->db->prepare("DELETE FROM carrito_items WHERE carrito_id = :carrito_id");
        return $stmt->execute([':carrito_id' => $cartId]);
    }
}

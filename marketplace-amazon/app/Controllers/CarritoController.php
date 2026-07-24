<?php
require_once __DIR__ . '/../Models/CarritoModel.php';
require_once __DIR__ . '/../Models/ProductoModel.php';

class CarritoController {
    private CarritoModel $model;
    private ProductoModel $productoModel;

    public function __construct() {
        $this->model = new CarritoModel();
        $this->productoModel = new ProductoModel();
    }

    private function getClienteId(): int {
        $user = AuthHelper::user();
        return $user['cliente_id'] ?? 1; // Fallback cliente_id para invitados de prueba
    }

    public function index(): void {
        $clienteId = $this->getClienteId();
        $cart = $this->model->getCartByClienteId($clienteId);
        Response::success($cart, 'Contenido del carrito');
    }

    public function add(): void {
        $productoId = (int)($_POST['producto_id'] ?? 0);
        $cantidad = max(1, (int)($_POST['cantidad'] ?? 1));

        if ($productoId <= 0) {
            Response::error('ID de producto no válido', 400);
        }

        $producto = $this->productoModel->getById($productoId);
        if (!$producto) {
            Response::error('Producto no encontrado', 404);
        }

        $clienteId = $this->getClienteId();
        $cart = $this->model->getCartByClienteId($clienteId);

        $precio = (float)($producto['precio_oferta'] ?? $producto['precio']);
        $success = $this->model->addItem($cart['id'], $productoId, $cantidad, $precio);

        if ($success) {
            $updatedCart = $this->model->getCartByClienteId($clienteId);
            Response::success($updatedCart, 'Producto agregado al carrito');
        } else {
            Response::error('No se pudo agregar el producto al carrito', 500);
        }
    }

    public function updateQty(): void {
        $itemId = (int)($_POST['item_id'] ?? 0);
        $cantidad = max(1, (int)($_POST['cantidad'] ?? 1));

        if ($itemId <= 0) {
            Response::error('ID de ítem no válido', 400);
        }

        // Obtener precio unitario del item actual
        $stmt = $this->model->db->prepare("SELECT precio_unitario FROM carrito_items WHERE id = :id");
        $stmt->execute([':id' => $itemId]);
        $item = $stmt->fetch();

        if (!$item) {
            Response::error('Ítem no encontrado en el carrito', 404);
        }

        if ($this->model->updateItemQty($itemId, $cantidad, (float)$item['precio_unitario'])) {
            $clienteId = $this->getClienteId();
            $updatedCart = $this->model->getCartByClienteId($clienteId);
            Response::success($updatedCart, 'Cantidad actualizada');
        } else {
            Response::error('Error al actualizar cantidad', 500);
        }
    }

    public function remove(): void {
        $itemId = (int)($_POST['item_id'] ?? $_GET['item_id'] ?? 0);
        if ($itemId <= 0) {
            Response::error('ID de ítem no válido', 400);
        }

        if ($this->model->removeItem($itemId)) {
            $clienteId = $this->getClienteId();
            $updatedCart = $this->model->getCartByClienteId($clienteId);
            Response::success($updatedCart, 'Ítem eliminado del carrito');
        } else {
            Response::error('Error al eliminar ítem', 500);
        }
    }

    public function clear(): void {
        $clienteId = $this->getClienteId();
        $cart = $this->model->getCartByClienteId($clienteId);
        if ($this->model->clearCart($cart['id'])) {
            Response::success(null, 'Carrito vaciado');
        } else {
            Response::error('Error al vaciar carrito', 500);
        }
    }
}

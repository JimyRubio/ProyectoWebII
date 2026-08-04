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

    private function getClienteId(): ?int {
        $user = AuthHelper::user();
        return $user['cliente_id'] ?? null;
    }

    public function index(): void {
        $clienteId = $this->getClienteId();
        if ($clienteId === null) {
            Response::success([
                'id' => 0,
                'cliente_id' => 0,
                'total_items' => 0,
                'subtotal' => 0.00,
                'descuentos' => 0.00,
                'total' => 0.00,
                'items' => []
            ], 'Debe iniciar sesión para ver el carrito');
            return;
        }
        $cart = $this->model->getCartByClienteId($clienteId);
        Response::success($cart, 'Contenido del carrito');
    }

public function add(): void {
        // Verificar CSRF
        $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
        if (!Security::verifyCsrfToken($token)) {
            Response::error('Token de seguridad no válido. Recarga la página.', 403);
        }

        // Requerir autenticación para agregar al carrito (evita FK error con cliente_id null)
        $clienteId = $this->getClienteId();
        if ($clienteId === null) {
            Response::error('Debe iniciar sesión para agregar productos al carrito', 401);
        }

        $productoId = (int)($_POST['producto_id'] ?? 0);
        $cantidad = max(1, (int)($_POST['cantidad'] ?? 1));

        if ($productoId <= 0) {
            Response::error('ID de producto no válido', 400);
        }

        $producto = $this->productoModel->getById($productoId);
        if (!$producto) {
            Response::error('Producto no encontrado', 404);
        }

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
        // Verificar CSRF
        $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
        if (!Security::verifyCsrfToken($token)) {
            Response::error('Token de seguridad no válido. Recarga la página.', 403);
        }

        $itemId = (int)($_POST['item_id'] ?? 0);
        $cantidad = max(1, (int)($_POST['cantidad'] ?? 1));

        if ($itemId <= 0) {
            Response::error('ID de ítem no válido', 400);
        }

        // Obtener precio unitario del item actual usando el método del modelo
        $precioUnitario = $this->model->getItemPrecioUnitario($itemId);
        if ($precioUnitario === null) {
            Response::error('Ítem no encontrado en el carrito', 404);
        }

        if ($this->model->updateItemQty($itemId, $cantidad, $precioUnitario)) {
            $clienteId = $this->getClienteId();
            $updatedCart = $this->model->getCartByClienteId($clienteId);
            Response::success($updatedCart, 'Cantidad actualizada');
        } else {
            Response::error('Error al actualizar cantidad', 500);
        }
    }

    public function remove(): void {
        // Verificar CSRF
        $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
        if (!Security::verifyCsrfToken($token)) {
            Response::error('Token de seguridad no válido. Recarga la página.', 403);
        }

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
        // Verificar CSRF
        $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
        if (!Security::verifyCsrfToken($token)) {
            Response::error('Token de seguridad no válido. Recarga la página.', 403);
        }

        $clienteId = $this->getClienteId();
        $cart = $this->model->getCartByClienteId($clienteId);
        if ($this->model->clearCart($cart['id'])) {
            Response::success(null, 'Carrito vaciado');
        } else {
            Response::error('Error al vaciar carrito', 500);
        }
    }

    /**
     * Aplica un cupón de descuento al carrito
     */
    public function applyCoupon(): void {
        $clienteId = $this->getClienteId();
        if ($clienteId === null) {
            Response::error('Debe iniciar sesión para aplicar un cupón', 401);
        }

        $codigo = strtoupper(trim($_POST['codigo'] ?? ''));
        if (empty($codigo)) {
            Response::error('Ingrese un código de cupón válido', 400);
        }

        // Validar el cupón usando el PromocionModel
        require_once ROOT_PATH . 'app/Models/PromocionModel.php';
        $promocionModel = new PromocionModel();
        $cupon = $promocionModel->validarCupon($codigo);

        if (!$cupon) {
            Response::error('El cupón no es válido o ha expirado', 404);
        }

        // Aplicar el descuento al carrito
        $result = $this->model->applyCoupon($clienteId, $cupon);
        if ($result === false) {
            // Verificar si fue por mínimo de compra
            $cart = $this->model->getCartByClienteId($clienteId);
            if (!empty($cupon['minimo_compra']) && $cart['subtotal'] < (float)$cupon['minimo_compra']) {
                Response::error('El monto mínimo de compra para este cupón es de L. ' . number_format((float)$cupon['minimo_compra'], 2), 400);
            }
            Response::error('No se pudo aplicar el cupón. Verifica que el carrito no esté vacío.', 400);
        }

        $updatedCart = $this->model->getCartByClienteId($clienteId);
        Response::success([
            'cart' => $updatedCart,
            'cupon' => $cupon
        ], '¡Cupón aplicado exitosamente!');
    }

    /**
     * Remueve el cupón de descuento del carrito
     */
    public function removeCoupon(): void {
        $clienteId = $this->getClienteId();
        if ($clienteId === null) {
            Response::error('Debe iniciar sesión', 401);
        }

        if ($this->model->removeCoupon($clienteId)) {
            $updatedCart = $this->model->getCartByClienteId($clienteId);
            Response::success($updatedCart, 'Cupón removido del carrito');
        } else {
            Response::error('Error al remover el cupón', 500);
        }
    }
}

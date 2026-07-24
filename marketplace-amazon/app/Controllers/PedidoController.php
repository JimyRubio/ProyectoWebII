<?php
require_once __DIR__ . '/../Models/PedidoModel.php';
require_once __DIR__ . '/../Models/CarritoModel.php';

class PedidoController {
    private PedidoModel $model;
    private CarritoModel $carritoModel;

    public function __construct() {
        $this->model = new PedidoModel();
        $this->carritoModel = new CarritoModel();
    }

    public function create(): void {
        AuthHelper::requireAuth();
        $user = AuthHelper::user();
        $clienteId = $user['cliente_id'];

        $cart = $this->carritoModel->getCartByClienteId($clienteId);
        if (empty($cart['items'])) {
            Response::error('El carrito está vacío', 400);
        }

        try {
            $pedidoId = $this->model->createOrder($clienteId, $cart['items'], $cart['subtotal']);
            $this->model->procesarPedidoSP($pedidoId);
            $this->carritoModel->clearCart($cart['id']);

            Response::success(['pedido_id' => $pedidoId], 'Pedido realizado y procesado correctamente mediante Stored Procedure', 201);
        } catch (Exception $e) {
            Response::error('Error al procesar el pedido: ' . $e->getMessage(), 500);
        }
    }

    public function show(int $id): void {
        AuthHelper::requireAuth();
        $pedido = $this->model->getById($id);
        if (!$pedido) {
            Response::error('Pedido no encontrado', 404);
        }
        Response::success($pedido, 'Detalle del pedido');
    }
}

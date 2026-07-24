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

    /**
     * Lista los pedidos del cliente en sesión
     */
    public function index(): void {
        AuthHelper::requireAuth();
        $user = AuthHelper::user();
        $clienteId = $user['cliente_id'] ?? 1;

        $pedidos = $this->model->getByCliente($clienteId);
        Response::success($pedidos, 'Pedidos del cliente');
    }

    /**
     * Crea un nuevo pedido a partir del carrito
     */
    public function create(): void {
        AuthHelper::requireAuth();
        $user = AuthHelper::user();
        $clienteId = $user['cliente_id'] ?? 1;

        $cart = $this->carritoModel->getCartByClienteId($clienteId);
        if (empty($cart['items'])) {
            Response::error('El carrito está vacío', 400);
        }

        $direccionId = (int)($_POST['direccion_id'] ?? 0) ?: null;

        try {
            $pedidoId = $this->model->createOrder($clienteId, $cart['items'], $cart['subtotal'], 0.00, $direccionId);
            $this->model->procesarPedidoSP($pedidoId);
            $this->carritoModel->clearCart($cart['id']);

            Response::success(['pedido_id' => $pedidoId], 'Pedido realizado y procesado correctamente mediante Stored Procedure', 201);
        } catch (Exception $e) {
            Response::error('Error al procesar el pedido: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Muestra el detalle de un pedido
     */
    public function show(int $id): void {
        AuthHelper::requireAuth();
        $pedido = $this->model->getById($id);
        if (!$pedido) {
            Response::error('Pedido no encontrado', 404);
        }
        Response::success($pedido, 'Detalle del pedido');
    }

    /**
     * Muestra el rastreo de envío de un pedido
     */
    public function rastreo(int $id): void {
        AuthHelper::requireAuth();
        $rastreo = $this->model->getRastreo($id);
        Response::success($rastreo, 'Historial de rastreo del envío');
    }
}

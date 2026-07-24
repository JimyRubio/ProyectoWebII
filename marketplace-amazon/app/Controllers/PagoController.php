<?php
require_once __DIR__ . '/../Models/PagoModel.php';

class PagoController {
    private PagoModel $model;

    public function __construct() {
        $this->model = new PagoModel();
    }

    /**
     * Retorna métodos de pago disponibles
     */
    public function metodos(): void {
        Response::success($this->model->getMetodos(), 'Métodos de pago activos');
    }

    /**
     * Retorna tarjetas/opciones guardadas del cliente
     */
    public function opcionesGuardadas(): void {
        AuthHelper::requireAuth();
        $user = AuthHelper::user();
        $clienteId = $user['cliente_id'] ?? 1;
        Response::success($this->model->getOpcionesGuardadas($clienteId), 'Opciones de pago guardadas');
    }

    /**
     * Procesa un pago para un pedido (crea el pedido primero desde el carrito)
     */
    public function procesar(): void {
        AuthHelper::requireAuth();
        $user = AuthHelper::user();
        $clienteId = $user['cliente_id'] ?? 0;

        if ($clienteId <= 0) {
            Response::error('Debe iniciar sesión como cliente', 401);
        }

        $metodoPagoId = (int)($_POST['metodo_pago_id'] ?? 1);
        $direccionId = (int)($_POST['direccion_id'] ?? 0) ?: null;

        // Datos de la tarjeta (validación del lado servidor)
        $cardNumber = preg_replace('/\s+/', '', $_POST['card_number'] ?? '');
        $cardName = Security::sanitizeString($_POST['card_name'] ?? '');
        $cardExp = $_POST['card_expiry'] ?? '';
        $cardCvv = $_POST['card_cvv'] ?? '';

        // Validaciones de tarjeta
        if (empty($cardNumber) || strlen($cardNumber) < 13) {
            Response::error('Número de tarjeta inválido', 400);
        }
        if (empty($cardName)) {
            Response::error('Nombre del titular es requerido', 400);
        }
        if (empty($cardExp) || !preg_match('/^\d{2}\/\d{2}$/', $cardExp)) {
            Response::error('Fecha de expiración inválida (MM/YY)', 400);
        }
        if (empty($cardCvv) || !preg_match('/^\d{3,4}$/', $cardCvv)) {
            Response::error('CVV inválido', 400);
        }

        // Obtener carrito
        require_once ROOT_PATH . 'app/Models/CarritoModel.php';
        $carritoModel = new CarritoModel();
        $cart = $carritoModel->getCartByClienteId($clienteId);

        if (empty($cart['items'])) {
            Response::error('El carrito está vacío', 400);
        }

        try {
            // 1. Crear pedido
            require_once ROOT_PATH . 'app/Models/PedidoModel.php';
            $pedidoModel = new PedidoModel();
            $pedidoId = $pedidoModel->createOrder($clienteId, $cart['items'], $cart['subtotal'], 0.00, $direccionId);

            // 2. Registrar pago
            $pagoId = $this->model->registrarPago([
                'pedido_id' => $pedidoId,
                'metodo_pago_id' => $metodoPagoId,
                'monto' => $cart['total'],
                'estado' => 'completado'
            ]);

            // 3. Procesar pedido (actualizar stock)
            $pedidoModel->procesarPedidoSP($pedidoId);

            // 4. Vaciar carrito
            $carritoModel->clearCart($cart['id']);

            // 5. Registrar los últimos 4 dígitos en auditoría (nunca el número completo)
            $ultimos4 = substr($cardNumber, -4);
            error_log("Pago procesado: Pedido #{$pedidoId}, Tarjeta terminada en {$ultimos4}, Monto: {$cart['total']}");

            Response::success([
                'pedido_id' => $pedidoId,
                'pago_id' => $pagoId
            ], '¡Pago procesado exitosamente! Pedido #' . $pedidoId . ' confirmado.', 201);
        } catch (Exception $e) {
            Response::error('Error al procesar el pago: ' . $e->getMessage(), 500);
        }
    }
}

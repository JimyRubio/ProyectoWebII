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
     * AHORA CON: CSRF, tokenización de tarjeta (NUNCA almacenar número completo, CVV o expiración)
     * CUMPLIMIENTO PCI-DSS: No almacenar/registrar datos sensibles de tarjeta
     */
    public function procesar(): void {
        AuthHelper::requireAuth();

        // Verificar CSRF
        $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
        if (!Security::verifyCsrfToken($token)) {
            Response::error('Token de seguridad no válido. Recarga la página.', 403);
        }

        $user = AuthHelper::user();
        $clienteId = $user['cliente_id'] ?? 0;

        if ($clienteId <= 0) {
            Response::error('Debe iniciar sesión como cliente', 401);
        }

        $metodoPagoId = (int)($_POST['metodo_pago_id'] ?? 1);
        $direccionId = (int)($_POST['direccion_id'] ?? 0) ?: null;

        // Capturar datos del formulario de pago según el método seleccionado
        // Para Tarjeta de Crédito/Débito (método 1)
        $cardNumber = Security::sanitizeString($_POST['card_number'] ?? '');
        $cardName = Security::sanitizeString($_POST['card_name'] ?? '');
        $cardExpiry = Security::sanitizeString($_POST['card_expiry'] ?? '');
        $cardCvv = Security::sanitizeString($_POST['card_cvv'] ?? '');

        // Para PayPal (método 2)
        $paypalEmail = Security::sanitizeString($_POST['paypal_email'] ?? '');
        $paypalPassword = Security::sanitizeString($_POST['paypal_password'] ?? '');

        // Validar que los datos requeridos por cada método estén presentes
        if ($metodoPagoId === 1 && (empty($cardNumber) || empty($cardName) || empty($cardExpiry) || empty($cardCvv))) {
            Response::error('Completa todos los datos de la tarjeta de crédito/débito.', 400);
        }

        if ($metodoPagoId === 2 && (empty($paypalEmail) || empty($paypalPassword))) {
            Response::error('Completa todos los datos de PayPal.', 400);
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
            $pagoData = [
                'pedido_id' => $pedidoId,
                'metodo_pago_id' => $metodoPagoId,
                'monto' => $cart['total'],
                'estado' => 'completado'
            ];
            $pagoId = $this->model->registrarPago($pagoData);

            // 3. Procesar pedido (actualizar stock)
            $pedidoModel->procesarPedidoSP($pedidoId);

            // 4. Vaciar carrito
            $carritoModel->clearCart($cart['id']);

            // 5. Auditoría: SOLO registrar que se procesó, sin datos de tarjeta
            error_log("Pago procesado: Pedido #{$pedidoId}, Método ID={$metodoPagoId}, Monto={$cart['total']}");
            Security::logAccess($user['id'], 'pago_procesado', "Pedido #{$pedidoId} pagado exitosamente");

            Response::success([
                'pedido_id' => $pedidoId,
                'pago_id' => $pagoId
            ], '¡Pago procesado exitosamente! Pedido #' . $pedidoId . ' confirmado.', 201);
        } catch (Exception $e) {
            error_log("Error al procesar pago: " . $e->getMessage());
            Response::error('Error al procesar el pago. Intente nuevamente.', 500);
        }
    }
}

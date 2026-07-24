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
     * Procesa un pago para un pedido
     */
    public function procesar(): void {
        AuthHelper::requireAuth();

        $pedidoId = (int)($_POST['pedido_id'] ?? 0);
        $metodoPagoId = (int)($_POST['metodo_pago_id'] ?? 1);
        $monto = (float)($_POST['monto'] ?? 0);

        if ($pedidoId <= 0 || $monto <= 0) {
            Response::error('ID de pedido y monto válidos son requeridos', 400);
        }

        try {
            $pagoId = $this->model->registrarPago([
                'pedido_id' => $pedidoId,
                'metodo_pago_id' => $metodoPagoId,
                'monto' => $monto,
                'estado' => 'completado'
            ]);
            Response::success(['pago_id' => $pagoId], 'Pago procesado exitosamente');
        } catch (Exception $e) {
            Response::error('Error al procesar el pago: ' . $e->getMessage(), 500);
        }
    }
}

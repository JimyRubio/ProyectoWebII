<?php
require_once __DIR__ . '/../Models/MensajeriaModel.php';

class MensajeriaController {
    private MensajeriaModel $model;

    public function __construct() {
        $this->model = new MensajeriaModel();
    }

    /**
     * Lista las conversaciones del usuario
     */
    public function conversaciones(): void {
        AuthHelper::requireAuth();
        $user = AuthHelper::user();
        $clienteId = $user['cliente_id'] ?? 1;
        $conversaciones = $this->model->getConversaciones($clienteId);
        Response::success($conversaciones, 'Conversaciones del usuario');
    }

    /**
     * Obtiene mensajes de una conversación
     */
    public function mensajes(): void {
        AuthHelper::requireAuth();
        $conversacionId = (int)($_GET['conversacion_id'] ?? 0);
        if ($conversacionId <= 0) {
            Response::error('ID de conversación inválido', 400);
        }
        $mensajes = $this->model->getMensajes($conversacionId);
        Response::success($mensajes, 'Mensajes de la conversación');
    }

    /**
     * Envía un mensaje en el chat
     */
    public function enviar(): void {
        AuthHelper::requireAuth();
        $user = AuthHelper::user();

        $conversacionId = (int)($_POST['conversacion_id'] ?? 0);
        $mensaje = Security::sanitizeString($_POST['mensaje'] ?? '');

        if ($conversacionId <= 0 || empty($mensaje)) {
            Response::error('Conversación y mensaje son obligatorios', 400);
        }

        $remitenteTipo = AuthHelper::hasRole('Vendedor') ? 'vendedor' : 'cliente';

        try {
            $id = $this->model->enviarMensaje($conversacionId, $user['id'], $remitenteTipo, $mensaje);
            Response::success(['id' => $id], 'Mensaje enviado correctamente');
        } catch (Exception $e) {
            Response::error('Error al enviar el mensaje: ' . $e->getMessage(), 500);
        }
    }
}

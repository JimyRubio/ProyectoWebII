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
        $tipo = AuthHelper::hasRole('Vendedor') ? 'vendedor' : 'cliente';
        $conversaciones = $this->model->getConversaciones($user['id'], $tipo);
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

    /**
     * Crea una nueva conversación desde el detalle del producto
     */
    public function crear(): void {
        AuthHelper::requireAuth();
        $user = AuthHelper::user();
        $clienteId = $user['cliente_id'] ?? null;

        if (!$clienteId) {
            Response::error('Solo los clientes pueden iniciar conversaciones', 400);
        }

        $vendedorId = (int)($_POST['vendedor_id'] ?? 0);
        $asunto = Security::sanitizeString($_POST['asunto'] ?? 'Consulta');
        $mensaje = Security::sanitizeString($_POST['mensaje'] ?? '');

        if ($vendedorId <= 0) {
            Response::error('ID de vendedor no válido', 400);
        }

        if (empty($mensaje)) {
            Response::error('El mensaje inicial es obligatorio', 400);
        }

        try {
            $conversacionId = $this->model->crearConversacion($clienteId, $vendedorId, $asunto, $mensaje);
            Response::success(['id' => $conversacionId], 'Conversación creada exitosamente', 201);
        } catch (Exception $e) {
            Response::error('Error al crear conversación: ' . $e->getMessage(), 500);
        }
    }
}

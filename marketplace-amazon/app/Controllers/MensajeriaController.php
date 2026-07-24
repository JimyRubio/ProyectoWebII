<?php
require_once __DIR__ . '/../Models/MensajeriaModel.php';

class MensajeriaController {
    private MensajeriaModel $model;
    public function __construct() { $this->model = new MensajeriaModel(); }
    public function index(): void {
        AuthHelper::requireAuth();
        $user = AuthHelper::user();
        Response::success($this->model->getConversaciones($user['cliente_id'] ?? 1));
    }
}

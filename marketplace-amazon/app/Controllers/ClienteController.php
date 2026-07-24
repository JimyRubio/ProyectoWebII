<?php
require_once __DIR__ . '/../Models/ClienteModel.php';

class ClienteController {
    private ClienteModel $model;

    public function __construct() {
        $this->model = new ClienteModel();
    }

    public function profile(): void {
        AuthHelper::requireAuth();
        $user = AuthHelper::user();
        $profile = $this->model->getProfile($user['id']);
        Response::success($profile, 'Perfil del cliente');
    }
}

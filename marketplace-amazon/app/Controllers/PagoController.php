<?php
require_once __DIR__ . '/../Models/PagoModel.php';

class PagoController {
    private PagoModel $model;
    public function __construct() { $this->model = new PagoModel(); }
    public function metodos(): void { Response::success($this->model->getMetodos()); }
}

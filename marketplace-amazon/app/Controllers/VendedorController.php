<?php
require_once __DIR__ . '/../Models/VendedorModel.php';

class VendedorController {
    private VendedorModel $model;
    public function __construct() { $this->model = new VendedorModel(); }
    public function index(): void { Response::success($this->model->getAll()); }
}

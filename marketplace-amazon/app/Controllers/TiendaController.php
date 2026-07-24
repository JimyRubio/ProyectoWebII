<?php
require_once __DIR__ . '/../Models/TiendaModel.php';

class TiendaController {
    private TiendaModel $model;
    public function __construct() { $this->model = new TiendaModel(); }
    public function index(): void { Response::success($this->model->getAll()); }
}

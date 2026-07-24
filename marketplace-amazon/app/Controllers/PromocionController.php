<?php
require_once __DIR__ . '/../Models/PromocionModel.php';

class PromocionController {
    private PromocionModel $model;
    public function __construct() { $this->model = new PromocionModel(); }
    public function index(): void { Response::success($this->model->getActivas()); }
}

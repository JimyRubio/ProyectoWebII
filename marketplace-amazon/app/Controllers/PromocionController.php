<?php
require_once __DIR__ . '/../Models/PromocionModel.php';

class PromocionController {
    private PromocionModel $model;

    public function __construct() {
        $this->model = new PromocionModel();
    }

    /**
     * Retorna lista de promociones vigentes
     */
    public function index(): void {
        Response::success($this->model->getActivas(), 'Promociones y ofertas activas');
    }

    /**
     * Valida un código de cupón introducido por el usuario
     */
    public function validarCupon(): void {
        $codigo = Security::sanitizeString($_POST['codigo'] ?? $_GET['codigo'] ?? '');
        if (empty($codigo)) {
            Response::error('Código de cupón requerido', 400);
        }

        $cupon = $this->model->validarCupon($codigo);
        if (!$cupon) {
            Response::error('El cupón no es válido o ha expirado', 404);
        }

        Response::success($cupon, 'Cupón válido aplicado');
    }
}

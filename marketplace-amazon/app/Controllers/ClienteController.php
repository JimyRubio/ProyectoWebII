<?php
require_once __DIR__ . '/../Models/ClienteModel.php';

class ClienteController {
    private ClienteModel $model;

    public function __construct() {
        $this->model = new ClienteModel();
    }

    /**
     * Devuelve el perfil del cliente logueado
     */
    public function profile(): void {
        AuthHelper::requireAuth();
        $user = AuthHelper::user();
        $profile = $this->model->getProfile($user['id']);
        if (!$profile) {
            Response::error('Perfil no encontrado', 404);
        }
        Response::success($profile, 'Perfil del cliente obtenido');
    }

    /**
     * Actualiza la información personal
     */
    public function updateProfile(): void {
        AuthHelper::requireAuth();
        $user = AuthHelper::user();

        $data = [
            'nombre' => Security::sanitizeString($_POST['nombre'] ?? ''),
            'apellido' => Security::sanitizeString($_POST['apellido'] ?? ''),
            'telefono' => Security::sanitizeString($_POST['telefono'] ?? ''),
            'direccion' => Security::sanitizeString($_POST['direccion'] ?? '')
        ];

        if (empty($data['nombre'])) {
            Response::error('El nombre es requerido', 400);
        }

        if ($this->model->updateProfile($user['id'], $data)) {
            Response::success(null, 'Perfil actualizado correctamente');
        } else {
            Response::error('Error al actualizar el perfil', 500);
        }
    }

    /**
     * Obtiene direcciones guardadas
     */
    public function direcciones(): void {
        AuthHelper::requireAuth();
        $user = AuthHelper::user();
        $profile = $this->model->getProfile($user['id']);
        $clienteId = $profile['cliente_id'] ?? 1;

        $direcciones = $this->model->getDirecciones($clienteId);
        Response::success($direcciones, 'Direcciones obtenidas');
    }

    /**
     * Registra una nueva dirección
     */
    public function storeDireccion(): void {
        AuthHelper::requireAuth();
        $user = AuthHelper::user();
        $profile = $this->model->getProfile($user['id']);
        $clienteId = $profile['cliente_id'] ?? 1;

        $calle = Security::sanitizeString($_POST['calle'] ?? '');
        $ciudad = Security::sanitizeString($_POST['ciudad'] ?? '');
        $estado = Security::sanitizeString($_POST['estado'] ?? '');
        $cp = Security::sanitizeString($_POST['codigo_postal'] ?? '');

        if (empty($calle) || empty($ciudad) || empty($estado) || empty($cp)) {
            Response::error('Calle, ciudad, estado y código postal son obligatorios', 400);
        }

        $direccionData = [
            'calle' => $calle,
            'numero' => Security::sanitizeString($_POST['numero'] ?? ''),
            'colonia' => Security::sanitizeString($_POST['colonia'] ?? ''),
            'ciudad' => $ciudad,
            'estado' => $estado,
            'pais' => Security::sanitizeString($_POST['pais'] ?? 'México'),
            'codigo_postal' => $cp,
            'referencia' => Security::sanitizeString($_POST['referencia'] ?? ''),
            'predeterminada' => !empty($_POST['predeterminada'])
        ];

        try {
            $id = $this->model->addDireccion($clienteId, $direccionData);
            Response::success(['id' => $id], 'Dirección agregada exitosamente', 201);
        } catch (Exception $e) {
            Response::error('Error al guardar la dirección: ' . $e->getMessage(), 500);
        }
    }
}

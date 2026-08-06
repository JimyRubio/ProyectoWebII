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
     * Sube y actualiza la foto de perfil (avatar) del usuario
     */
    public function updateAvatar(): void {
        AuthHelper::requireAuth();
        $user = AuthHelper::user();

        // Verificar que se envió un archivo
        if (!isset($_FILES['avatar']) || $_FILES['avatar']['error'] !== UPLOAD_ERR_OK) {
            $errorCode = $_FILES['avatar']['error'] ?? -1;
            $errorMessages = [
                UPLOAD_ERR_INI_SIZE => 'El archivo excede el tamaño máximo permitido por el servidor',
                UPLOAD_ERR_FORM_SIZE => 'El archivo excede el tamaño máximo del formulario',
                UPLOAD_ERR_PARTIAL => 'El archivo se subió parcialmente',
                UPLOAD_ERR_NO_FILE => 'No se seleccionó ningún archivo',
                UPLOAD_ERR_NO_TMP_DIR => 'Falta la carpeta temporal de subidas',
                UPLOAD_ERR_CANT_WRITE => 'Error al escribir el archivo en el disco',
            ];
            $message = $errorMessages[$errorCode] ?? 'Error al subir el archivo';
            Response::error($message, 400);
        }

        $archivo = $_FILES['avatar'];

        // Validar tipo de archivo (solo imágenes)
        $tiposPermitidos = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
        $extensionesPermitidas = ['jpg', 'jpeg', 'png', 'gif', 'webp'];

        $finfo = finfo_open(FILEINFO_MIME_TYPE);
        $mimeType = finfo_file($finfo, $archivo['tmp_name']);

        if (!in_array($mimeType, $tiposPermitidos)) {
            Response::error('Tipo de archivo no permitido. Solo JPG, PNG, GIF y WebP', 400);
        }

        $extension = strtolower(pathinfo($archivo['name'], PATHINFO_EXTENSION));
        if (!in_array($extension, $extensionesPermitidas)) {
            Response::error('Extensión de archivo no permitida', 400);
        }

        // Validar tamaño (máximo 5MB)
        $maxSize = 5 * 1024 * 1024;
        if ($archivo['size'] > $maxSize) {
            Response::error('El archivo excede el tamaño máximo de 5MB', 400);
        }

        // Crear directorio de avatares si no existe
        $uploadDir = ROOT_PATH . 'public/uploads/avatares/';
        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0755, true);
        }

        // Generar nombre único
        $nombreUnico = 'avatar_' . $user['id'] . '_' . time() . '.' . $extension;
        $rutaDestino = $uploadDir . $nombreUnico;

        // Mover el archivo
        if (move_uploaded_file($archivo['tmp_name'], $rutaDestino)) {
            $url = '/public/uploads/avatares/' . $nombreUnico;

            if ($this->model->updateAvatar($user['id'], $url)) {
                Response::success(['url' => $url], 'Foto de perfil actualizada correctamente');
            } else {
                // Revertir archivo si falla la BD
                @unlink($rutaDestino);
                Response::error('Error al guardar la foto de perfil', 500);
            }
        } else {
            Response::error('Error al guardar la imagen', 500);
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
     * [Admin] Obtiene lista de todos los usuarios del sistema
     */
    public function listaUsuarios(): void {
        AuthHelper::requireAuth();
        $user = AuthHelper::user();
        $roleName = strtolower($user['rol_nombre'] ?? '');
        $roleId = (int)($user['rol_id'] ?? 0);

        if ($roleId !== 1 && $roleName !== 'administrador' && $roleName !== 'admin') {
            Response::error('Acceso denegado. Solo administradores', 403);
        }

        try {
            $usuarios = $this->model->listaUsuarios();
            Response::success($usuarios, 'Lista de usuarios');
        } catch (Exception $e) {
            error_log("Error en listaUsuarios: " . $e->getMessage());
            Response::error('Error al obtener la lista de usuarios', 500);
        }
    }

    /**
     * [Admin] Activa/Desactiva un usuario
     */
    public function toggleUsuario(): void {
        AuthHelper::requireAuth();
        $user = AuthHelper::user();
        $roleName = strtolower($user['rol_nombre'] ?? '');

        if ($roleName !== 'administrador' && $roleName !== 'admin') {
            Response::error('Acceso denegado. Solo administradores', 403);
        }

        $usuarioId = (int)($_POST['usuario_id'] ?? 0);
        if ($usuarioId <= 0) {
            Response::error('ID de usuario no válido', 400);
        }

        try {
            $usuario = $this->model->getUsuarioById($usuarioId);
            if (!$usuario) {
                Response::error('Usuario no encontrado', 404);
            }

            // No permitir desactivar a otro admin
            if ((int)$usuario['rol_id'] === 1 && $usuarioId !== $user['id']) {
                Response::error('No puedes desactivar a otro administrador', 403);
            }

            $resultado = $this->model->toggleUsuario($usuarioId);
            Response::success(['activo' => $resultado['activo']], $resultado['activo'] ? 'Usuario activado' : 'Usuario desactivado');
        } catch (Exception $e) {
            error_log("Error en toggleUsuario: " . $e->getMessage());
            Response::error('Error al cambiar el estado del usuario', 500);
        }
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

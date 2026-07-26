<?php
$page_title = "Editar Producto - MarketZone";
$module_css = "productos.css";
$module_js = "productos.js";
require_once __DIR__ . '/../layouts/header.php';

$producto_id = isset($_GET['id']) ? (int)$_GET['id'] : 0;
if ($producto_id <= 0) {
    header('Location: ' . BASE_URL . 'views/productos/gestion.php');
    exit;
}
?>

<div class="gestion-header">
    <h1><i class="fa-solid fa-pen-to-square"></i> Editar Producto</h1>
    <a href="<?php echo BASE_URL; ?>views/productos/gestion.php" class="btn-primary" style="text-decoration:none;padding:10px 20px;background:var(--secondary-gradient);width:auto;">
        <i class="fa-solid fa-arrow-left"></i> Volver a Gestión
    </a>
</div>

<div class="producto-form" id="edit-producto-container" style="max-width:900px;">
    <div id="edit-loading" style="text-align:center;padding:60px;color:var(--text-secondary);">
        <i class="fa-solid fa-spinner fa-spin" style="font-size:2rem;display:block;margin-bottom:15px;"></i>
        <p>Cargando datos del producto...</p>
    </div>

    <form id="form-edit-producto" style="display:none;">
        <input type="hidden" name="id" id="edit-producto-id" value="<?php echo $producto_id; ?>">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="imagen_url" id="edit-imagen_url_hidden" value="">

        <!-- Sección: Información básica -->
        <div class="form-section">
            <h3><i class="fa-solid fa-info-circle"></i> Información Básica</h3>
            <div class="form-group">
                <label>Nombre del Producto *</label>
                <input type="text" name="nombre" id="edit-nombre" class="form-control" required>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Categoría *</label>
                    <select name="categoria_id" id="edit-categoria_id" class="form-control" required>
                        <option value="">Seleccionar categoría...</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>SKU</label>
                    <input type="text" id="edit-sku" class="form-control" readonly style="background:var(--bg-secondary);opacity:0.8;cursor:not-allowed;">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Precio *</label>
                    <input type="number" step="0.01" name="precio" id="edit-precio" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Precio Oferta</label>
                    <input type="number" step="0.01" name="precio_oferta" id="edit-precio_oferta" class="form-control">
                </div>
                <div class="form-group">
                    <label>Stock</label>
                    <input type="number" name="stock" id="edit-stock" class="form-control">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Destacado</label>
                    <select name="destacado" id="edit-destacado" class="form-control">
                        <option value="0">No</option>
                        <option value="1">Sí</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Estado</label>
                    <select name="estado" id="edit-estado" class="form-control">
                        <option value="activo">Activo</option>
                        <option value="inactivo">Inactivo</option>
                        <option value="agotado">Agotado</option>
                        <option value="descontinuado">Descontinuado</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>En Oferta</label>
                    <select name="oferta" id="edit-oferta" class="form-control">
                        <option value="0">No</option>
                        <option value="1">Sí</option>
                    </select>
                </div>
            </div>
        </div>

        <!-- Sección: Descripción -->
        <div class="form-section">
            <h3><i class="fa-solid fa-align-left"></i> Descripción</h3>
            <div class="form-group">
                <label>Descripción Corta</label>
                <textarea name="descripcion_corta" id="edit-descripcion_corta" class="form-control" rows="2"></textarea>
            </div>
            <div class="form-group">
                <label>Descripción Larga</label>
                <textarea name="descripcion_larga" id="edit-descripcion_larga" class="form-control" rows="5"></textarea>
            </div>
        </div>

        <!-- Sección: Imagen -->
        <div class="form-section">
            <h3><i class="fa-solid fa-image"></i> Imagen del Producto</h3>
            <div class="form-group">
                <div id="edit-image-current" style="margin-bottom:15px;">
                    <label>Imagen actual:</label>
                    <div style="margin-top:8px;">
                        <img id="edit-current-img" src="" alt="Imagen actual" style="max-width:150px;max-height:150px;border-radius:8px;border:1px solid var(--card-border);padding:5px;background:var(--bg-secondary);">
                    </div>
                </div>
                <label>Cambiar imagen:</label>
                <div style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;margin-top:8px;">
                    <input type="file" id="edit-image-file" accept="image/jpeg,image/png,image/gif,image/webp" style="flex:1;padding:10px;background:rgba(255,255,255,0.05);border:1px solid var(--card-border);border-radius:8px;color:var(--text-primary);">
                    <button type="button" class="btn-primary" id="btn-edit-upload-image" style="padding:10px 20px;width:auto;">
                        <i class="fa-solid fa-cloud-arrow-up"></i> Subir
                    </button>
                </div>
                <div id="edit-image-upload-preview" style="display:none;margin-top:10px;padding:10px;background:rgba(16,185,129,0.1);border-radius:8px;border:1px solid rgba(16,185,129,0.3);">
                    <img id="edit-preview-img" src="" alt="Preview" style="max-width:150px;max-height:150px;border-radius:8px;display:block;margin-bottom:8px;">
                    <span id="edit-uploaded-url" style="color:var(--price-color);font-size:0.85rem;word-break:break-all;"></span>
                </div>
            </div>
        </div>

        <!-- Botones -->
        <div style="display:flex;gap:12px;margin-top:20px;flex-wrap:wrap;">
            <button type="submit" class="btn-primary" id="btn-save-edit" style="padding:14px 35px;font-size:1rem;">
                <i class="fa-solid fa-save"></i> Guardar Cambios
            </button>
            <a href="<?php echo BASE_URL; ?>views/productos/gestion.php" class="btn-secondary" style="text-decoration:none;padding:14px 25px;display:inline-flex;align-items:center;gap:8px;border:1px solid var(--card-border);border-radius:8px;color:var(--text-secondary);">
                <i class="fa-solid fa-times"></i> Cancelar
            </a>
        </div>
    </form>
</div>

<style>
#form-edit-producto .form-section {
    margin-bottom: 25px;
}
#form-edit-producto .form-section h3 {
    font-size:1.1rem;
    margin-bottom:15px;
    color:var(--text-primary);
    border-bottom:1px solid var(--card-border);
    padding-bottom:10px;
}
</style>

<script>
$(document).ready(function() {
    var productoId = <?php echo $producto_id; ?>;
    if (!productoId) {
        App.notify('ID de producto no válido', 'error');
        return;
    }

    // Cargar categorías
    App.ajax({
        url: App.baseUrl + 'api/productos.php?action=categorias',
        method: 'GET',
        success: function(response) {
            if (response.success && response.data) {
                const $select = $('#edit-categoria_id');
                response.data.forEach(function(c) {
                    $select.append('<option value="' + c.id + '">' + c.nombre + '</option>');
                });
            }
        }
    });

    // Cargar datos del producto
    App.ajax({
        url: App.baseUrl + 'api/productos.php',
        method: 'GET',
        data: { id: productoId },
        success: function(response) {
            if (response.success && response.data) {
                fillEditForm(response.data);
                $('#edit-loading').hide();
                $('#form-edit-producto').show();
            } else {
                $('#edit-loading').html(
                    '<div style="color:#EF4444;">' +
                    '<i class="fa-solid fa-triangle-exclamation" style="font-size:2rem;display:block;margin-bottom:10px;"></i>' +
                    '<p>Producto no encontrado</p>' +
                    '<a href="' + App.baseUrl + 'views/productos/gestion.php" class="btn-primary" style="display:inline-block;margin-top:15px;">Volver a Gestión</a>' +
                    '</div>'
                );
            }
        },
        error: function() {
            $('#edit-loading').html(
                '<div style="color:#EF4444;">' +
                '<i class="fa-solid fa-triangle-exclamation" style="font-size:2rem;display:block;margin-bottom:10px;"></i>' +
                '<p>Error al cargar el producto</p>' +
                '<a href="' + App.baseUrl + 'views/productos/gestion.php" class="btn-primary" style="display:inline-block;margin-top:15px;">Volver a Gestión</a>' +
                '</div>'
            );
        }
    });

    function fillEditForm(p) {
        $('#edit-producto-id').val(p.id);
        $('#edit-nombre').val(p.nombre);
        $('#edit-categoria_id').val(p.categoria_id);
        $('#edit-sku').val(p.sku);
        $('#edit-precio').val(p.precio);
        $('#edit-precio_oferta').val(p.precio_oferta || '');
        $('#edit-stock').val(p.stock);
        $('#edit-estado').val(p.estado);
        $('#edit-destacado').val(p.destacado);
        $('#edit-oferta').val(p.oferta);
        $('#edit-descripcion_corta').val(p.descripcion_corta || '');
        $('#edit-descripcion_larga').val(p.descripcion_larga || '');

        // Imagen actual (solo preview, NO enviar al submit a menos que se suba una nueva)
        var imgUrl = p.imagen_principal || App.baseUrl + 'public/uploads/productos/placeholder.svg';
        $('#edit-current-img').attr('src', imgUrl);
        $('#edit-imagen_url_hidden').val(''); // Vacío para no enviar imagen a menos que se cambie
    }

    // Subir imagen
    $('#btn-edit-upload-image').on('click', function() {
        var fileInput = document.getElementById('edit-image-file');
        var file = fileInput.files[0];

        if (!file) {
            App.notify('Selecciona una imagen primero', 'warning');
            return;
        }

        var tiposPermitidos = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
        if (!tiposPermitidos.includes(file.type)) {
            App.notify('Formato no permitido. Usa JPG, PNG, GIF o WebP', 'error');
            return;
        }

        if (file.size > 5 * 1024 * 1024) {
            App.notify('La imagen excede el tamaño máximo de 5MB', 'error');
            return;
        }

        var formData = new FormData();
        formData.append('imagen', file);
        formData.append('csrf_token', App.getCsrfToken());

        var $btn = $('#btn-edit-upload-image');
        $btn.prop('disabled', true).html('<i class="fa-solid fa-spinner fa-spin"></i> Subiendo...');

        $.ajax({
            url: App.baseUrl + 'api/upload.php',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    var url = response.data.url;
                    $('#edit-preview-img').attr('src', url);
                    $('#edit-uploaded-url').text(url);
                    $('#edit-imagen_url_hidden').val(url);
                    $('#edit-image-upload-preview').show();
                    $('#edit-current-img').attr('src', url);
                    App.notify('Imagen subida exitosamente', 'success');
                } else {
                    App.notify(response.message || 'Error al subir imagen', 'error');
                }
            },
            error: function() {
                App.notify('Error de conexión al subir imagen', 'error');
            },
            complete: function() {
                $btn.prop('disabled', false).html('<i class="fa-solid fa-cloud-arrow-up"></i> Subir');
            }
        });
    });

    // Enviar formulario de edición
    $('#form-edit-producto').on('submit', function(e) {
        e.preventDefault();

        var data = $(this).serializeArray();
        var productoId = $('#edit-producto-id').val();
        var nombre = $('#edit-nombre').val().trim();
        var precio = parseFloat($('#edit-precio').val());

        if (!nombre) {
            App.notify('El nombre del producto es requerido', 'warning');
            return;
        }
        if (!precio || precio <= 0) {
            App.notify('Precio no válido', 'warning');
            return;
        }

        var $btn = $('#btn-save-edit');
        $btn.prop('disabled', true).html('<i class="fa-solid fa-spinner fa-spin"></i> Guardando...');

        App.ajax({
            url: App.baseUrl + 'api/productos.php',
            method: 'POST',
            data: $.param(data),
            success: function(response) {
                if (response.success) {
                    App.notify('Producto actualizado exitosamente', 'success');
                    setTimeout(function() {
                        window.location.href = App.baseUrl + 'views/productos/gestion.php';
                    }, 1500);
                } else {
                    App.notify(response.message || 'Error al actualizar', 'error');
                    $btn.prop('disabled', false).html('<i class="fa-solid fa-save"></i> Guardar Cambios');
                }
            },
            error: function() {
                $btn.prop('disabled', false).html('<i class="fa-solid fa-save"></i> Guardar Cambios');
            }
        });
    });
});
</script>

<?php require_once __DIR__ . '/../layouts/footer.php'; ?>


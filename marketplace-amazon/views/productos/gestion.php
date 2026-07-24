<?php
$page_title = "Gestión de Productos - MarketZone";
$module_css = "productos.css";
$module_js = "productos.js";
require_once __DIR__ . '/../layouts/header.php';
?>

<div class="gestion-header">
    <h1><i class="fa-solid fa-boxes"></i> Gestión de Productos</h1>
    <button class="btn-primary" id="btn-nuevo-producto" onclick="$('#form-producto').slideToggle();">
        <i class="fa-solid fa-plus"></i> Nuevo Producto
    </button>
</div>

<!-- Formulario de nuevo producto -->
<div id="form-producto" class="producto-form" style="display:none;margin-bottom:30px;">
    <h3><i class="fa-solid fa-pen"></i> Registrar Producto</h3>
    <form id="form-create-producto">
        <div class="form-section">
            <div class="form-group">
                <label>Nombre del Producto *</label>
                <input type="text" name="nombre" class="form-control" required>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Precio *</label>
                    <input type="number" step="0.01" name="precio" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Precio Oferta</label>
                    <input type="number" step="0.01" name="precio_oferta" class="form-control">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Stock</label>
                    <input type="number" name="stock" class="form-control" value="10">
                </div>
                <div class="form-group">
                    <label>SKU</label>
                    <input type="text" name="sku" class="form-control" placeholder="SKU-XXXX">
                </div>
            </div>
            <div class="form-group">
                <label>Descripción Corta</label>
                <textarea name="descripcion_corta" class="form-control" rows="2"></textarea>
            </div>
            <div class="form-group">
                <label>Descripción Larga</label>
                <textarea name="descripcion_larga" class="form-control" rows="4"></textarea>
            </div>
<div class="form-group">
                <label>Imagen del Producto</label>
                <div style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;">
                    <input type="file" id="prod-image-file" accept="image/jpeg,image/png,image/gif,image/webp" style="flex:1;padding:10px;background:rgba(255,255,255,0.05);border:1px solid var(--card-border);border-radius:8px;color:var(--text-primary);">
                    <button type="button" class="btn-primary" id="btn-upload-image" style="padding:10px 20px;width:auto;" onclick="uploadProductImage()">
                        <i class="fa-solid fa-cloud-arrow-up"></i> Subir
                    </button>
                </div>
                <div id="image-upload-preview" style="display:none;margin-top:10px;padding:10px;background:rgba(16,185,129,0.1);border-radius:8px;border:1px solid rgba(16,185,129,0.3);">
                    <img id="preview-img" src="" alt="Preview" style="max-width:150px;max-height:150px;border-radius:8px;display:block;margin-bottom:8px;">
                    <span id="uploaded-url" style="color:var(--price-color);font-size:0.85rem;word-break:break-all;"></span>
                    <input type="hidden" name="imagen_url" id="imagen_url_hidden" value="">
                </div>
            </div>
        </div>
        <button type="submit" class="btn-primary">
            <i class="fa-solid fa-save"></i> Guardar Producto
        </button>
    </form>
</div>

<!-- Tabla de productos -->
<div class="gestion-table-wrapper">
    <table class="gestion-table">
        <thead>
            <tr>
                <th>Imagen</th>
                <th>Nombre</th>
                <th>SKU</th>
                <th>Precio</th>
                <th>Stock</th>
                <th>Estado</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody id="gestion-productos-table-body">
            <!-- Carga dinámica vía AJAX -->
        </tbody>
    </table>
</div>
<div id="gestion-pagination" class="pagination-wrapper" style="margin-top:20px;display:flex;justify-content:center;gap:8px;">
    <!-- Paginación AJAX -->
</div>

<style>
#form-create-producto .form-section {
    margin-bottom: 25px;
}
#form-create-producto .form-section h3 {
    font-size:1.1rem;
    margin-bottom:15px;
    color:var(--text-primary);
    border-bottom:1px solid var(--card-border);
    padding-bottom:10px;
}
</style>

<script>
$(document).ready(function() {
    loadGestionProductos(1);

    $('#form-create-producto').on('submit', function(e) {
        e.preventDefault();
        const data = $(this).serializeArray();
        data.push({name: 'action', value: 'store'});
        
        App.ajax({
            url: App.baseUrl + 'api/productos.php',
            method: 'POST',
            data: $.param(data),
            success: function(response) {
                if(response.success) {
                    App.notify('Producto creado exitosamente', 'success');
                    $('#form-create-producto')[0].reset();
                    $('#form-producto').slideUp();
                    loadGestionProductos(1);
                }
            }
        });
    });
});

let gestionPage = 1;
function loadGestionProductos(page) {
    gestionPage = page;
    App.ajax({
        url: App.baseUrl + 'api/productos.php',
        method: 'GET',
        data: { page: page, limit: 10 },
        success: function(response) {
            if(response.success && response.data) {
                renderGestionProductos(response.data.productos);
                App.renderPagination('#gestion-pagination', response.data.pagination, function(np) {
                    loadGestionProductos(np);
                });
            }
        }
    });
}

function renderGestionProductos(productos) {
    const $tbody = $('#gestion-productos-table-body');
    if(!$tbody.length) return;
    if(!productos || productos.length === 0) {
        $tbody.html('<tr><td colspan="7" style="text-align:center;color:var(--text-secondary);padding:30px;">No hay productos registrados</td></tr>');
        return;
    }
    
    let html = '';
    const estadoBadge = {'activo':'success','inactivo':'secondary','agotado':'warning','descontinuado':'danger'};
    
    productos.forEach(p => {
        html += `
            <tr>
                <td><img src="${p.imagen_principal || 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=50&q=80'}" class="producto-thumb-sm"></td>
                <td><strong>${p.nombre}</strong><br><span style="font-size:0.8rem;color:var(--text-secondary)">${p.categoria_nombre}</span></td>
                <td>${p.sku}</td>
                <td>${App.formatCurrency(p.precio)}</td>
                <td>${p.stock}</td>
                <td><span class="badge-${estadoBadge[p.estado] || 'info'}">${p.estado}</span></td>
                <td>
                    <button class="action-btn edit"><i class="fa-solid fa-pen"></i></button>
                    <button class="action-btn delete" onclick="eliminarProducto(${p.id})"><i class="fa-solid fa-trash"></i></button>
                </td>
            </tr>
        `;
    });
    $tbody.html(html);
}

// Función para subir imagen con preview
function uploadProductImage() {
    const fileInput = document.getElementById('prod-image-file');
    const file = fileInput.files[0];
    
    if (!file) {
        App.notify('Selecciona una imagen primero', 'warning');
        return;
    }

    // Validar tipo
    const tiposPermitidos = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
    if (!tiposPermitidos.includes(file.type)) {
        App.notify('Formato no permitido. Usa JPG, PNG, GIF o WebP', 'error');
        return;
    }

    // Validar tamaño (5MB)
    if (file.size > 5 * 1024 * 1024) {
        App.notify('La imagen excede el tamaño máximo de 5MB', 'error');
        return;
    }

    const formData = new FormData();
    formData.append('imagen', file);
    formData.append('csrf_token', App.getCsrfToken());

    const $btn = $('#btn-upload-image');
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
                const url = response.data.url;
                $('#preview-img').attr('src', url);
                $('#uploaded-url').text(url);
                $('#imagen_url_hidden').val(url);
                $('#image-upload-preview').show();
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
}

function clearImagePreview() {
    $('#image-upload-preview').hide();
    $('#preview-img').attr('src', '');
    $('#uploaded-url').text('');
    $('#imagen_url_hidden').val('');
    $('#prod-image-file').val('');
}

function eliminarProducto(id) {
    if(!confirm('¿Eliminar este producto?')) return;
    App.ajax({
        url: App.baseUrl + 'api/productos.php',
        method: 'POST',
        data: { action: 'delete', id: id },
        success: function(response) {
            if(response.success) {
                App.notify('Producto eliminado', 'info');
                loadGestionProductos(gestionPage);
            }
        }
    });
}
</script>

<?php require_once __DIR__ . '/../layouts/footer.php'; ?>


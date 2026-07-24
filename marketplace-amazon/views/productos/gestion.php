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
                <label>URL de Imagen Principal</label>
                <input type="url" name="imagen_url" class="form-control" placeholder="https://ejemplo.com/imagen.jpg">
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


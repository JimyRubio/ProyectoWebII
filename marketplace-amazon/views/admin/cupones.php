<?php
$page_title = "Gestión de Cupones - Admin";
$module_css = "productos.css";
$module_js = "cupones.js";
require_once __DIR__ . '/../layouts/header.php';
?>

<div class="gestion-header">
    <h1><i class="fa-solid fa-ticket"></i> Gestión de Cupones</h1>
    <button class="btn-primary" id="btn-nuevo-cupon" onclick="$('#form-cupon').slideToggle();$('#btn-nuevo-cupon').toggleClass('active');">
        <i class="fa-solid fa-plus"></i> Nuevo Cupón
    </button>
</div>

<!-- Formulario crear/editar cupón -->
<div id="form-cupon" class="producto-form" style="display:none;margin-bottom:30px;">
    <h3 id="form-cupon-title"><i class="fa-solid fa-ticket"></i> Crear Nuevo Cupón</h3>
    <form id="form-create-cupon">
        <input type="hidden" name="id" id="cupon-id" value="0">
        <div class="form-section">
            <div class="form-row">
                <div class="form-group">
                    <label>Código del Cupón *</label>
                    <input type="text" name="codigo" id="cupon-codigo-input" class="form-control" placeholder="Ej: BIENVENIDO10" maxlength="50" required style="text-transform:uppercase;">
                </div>
                <div class="form-group">
                    <label>Descripción</label>
                    <input type="text" name="descripcion" class="form-control" placeholder="Ej: 10% de descuento para nuevos clientes">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Tipo de Descuento *</label>
                    <select name="tipo_descuento" id="cupon-tipo-input" class="form-control" required>
                        <option value="porcentaje">% Porcentaje</option>
                        <option value="monto_fijo">💰 Monto Fijo</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Valor *</label>
                    <input type="number" step="0.01" min="0.01" name="valor" class="form-control" placeholder="Ej: 10 (para 10%)" required>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Fecha Inicio *</label>
                    <input type="datetime-local" name="fecha_inicio" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Fecha Fin *</label>
                    <input type="datetime-local" name="fecha_fin" class="form-control" required>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Mínimo de Compra</label>
                    <input type="number" step="0.01" min="0" name="minimo_compra" class="form-control" value="0" placeholder="0 = sin mínimo">
                </div>
                <div class="form-group">
                    <label>Máximo Descuento</label>
                    <input type="number" step="0.01" min="0" name="maximo_descuento" class="form-control" placeholder="Opcional">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Usos Totales (usa_veces)</label>
                    <input type="number" min="0" name="usa_veces" class="form-control" value="1" placeholder="0 = ilimitado">
                </div>
                <div class="form-group">
                    <label>Usos por Cliente</label>
                    <input type="number" min="1" name="usa_por_cliente" class="form-control" value="1">
                </div>
            </div>
            <div class="form-group">
                <label style="display:flex;align-items:center;gap:8px;cursor:pointer;">
                    <input type="checkbox" name="activo" id="cupon-activo-input" value="1" checked style="width:auto;">
                    Cupón activo
                </label>
            </div>
        </div>
        <div style="display:flex;gap:10px;">
            <button type="submit" class="btn-primary" id="btn-guardar-cupon">
                <i class="fa-solid fa-save"></i> Guardar Cupón
            </button>
            <button type="button" class="btn-secondary" id="btn-cancelar-cupon" onclick="$('#form-cupon').slideUp();$('#btn-nuevo-cupon').removeClass('active');resetFormCupon();">
                <i class="fa-solid fa-xmark"></i> Cancelar
            </button>
        </div>
    </form>
</div>

<!-- Tabla de cupones -->
<div class="gestion-table-wrapper">
    <table class="gestion-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Código</th>
                <th>Descripción</th>
                <th>Tipo</th>
                <th>Valor</th>
                <th>Vigencia</th>
                <th>Estado</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody id="lista-cupones-body">
            <!-- Carga dinámica vía AJAX -->
        </tbody>
    </table>
</div>

<style>
#form-create-cupon .form-section {
    margin-bottom: 25px;
}
#form-create-cupon .form-section h3 {
    font-size:1.1rem;
    margin-bottom:15px;
    color:var(--text-primary);
    border-bottom:1px solid var(--card-border);
    padding-bottom:10px;
}
select.form-control {
    appearance: auto;
    -webkit-appearance: auto;
}
.badge-success {
    background: rgba(16,185,129,0.15);
    color: #10B981;
    padding: 3px 10px;
    border-radius: 12px;
    font-size: 0.75rem;
    font-weight: 600;
}
.badge-secondary {
    background: rgba(148,163,184,0.15);
    color: #94A3B8;
    padding: 3px 10px;
    border-radius: 12px;
    font-size: 0.75rem;
    font-weight: 600;
}
.badge-danger {
    background: rgba(239,68,68,0.15);
    color: #EF4444;
    padding: 3px 10px;
    border-radius: 12px;
    font-size: 0.75rem;
    font-weight: 600;
}
.action-btn {
    background: transparent;
    border: 1px solid var(--card-border);
    color: var(--text-secondary);
    width: 32px;
    height: 32px;
    border-radius: 8px;
    cursor: pointer;
    margin-right: 4px;
    transition: all 0.2s;
}
.action-btn:hover {
    background: rgba(59,130,246,0.1);
    color: #3B82F6;
    border-color: #3B82F6;
}
.action-btn.delete:hover {
    background: rgba(239,68,68,0.1);
    color: #EF4444;
    border-color: #EF4444;
}
.action-btn.success {
    color: #10B981;
}
.action-btn.warning {
    color: #F59E0B;
}
</style>

<?php require_once __DIR__ . '/../layouts/footer.php'; ?>


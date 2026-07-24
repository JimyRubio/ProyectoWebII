<?php
$page_title = "Gestión de Usuarios - Admin";
$module_css = "productos.css";
$module_js = "clientes.js";
require_once __DIR__ . '/../layouts/header.php';
?>

<div class="gestion-header">
    <h1><i class="fa-solid fa-users-gear"></i> Gestión de Usuarios</h1>
    <button class="btn-primary" id="btn-nuevo-usuario" onclick="$('#form-usuario').slideToggle();">
        <i class="fa-solid fa-user-plus"></i> Nuevo Usuario
    </button>
</div>

<!-- Formulario para crear usuario con rol específico -->
<div id="form-usuario" class="producto-form" style="display:none;margin-bottom:30px;">
    <h3><i class="fa-solid fa-user-shield"></i> Crear Nuevo Usuario</h3>
    <form id="form-create-usuario">
        <div class="form-section">
            <div class="form-row">
                <div class="form-group">
                    <label>Nombre *</label>
                    <input type="text" name="nombre" class="form-control" placeholder="Nombre" required>
                </div>
                <div class="form-group">
                    <label>Apellido *</label>
                    <input type="text" name="apellido" class="form-control" placeholder="Apellido" required>
                </div>
            </div>
            <div class="form-group">
                <label>Correo Electrónico *</label>
                <input type="email" name="email" class="form-control" placeholder="usuario@ejemplo.com" required>
            </div>
            <div class="form-group">
                <label>Contraseña * (mín. 6 caracteres)</label>
                <input type="password" name="password" class="form-control" placeholder="••••••••" required>
            </div>
            <div class="form-group">
                <label>Rol del Usuario *</label>
                <select name="rol_id" class="form-control" required>
                    <option value="3">👤 Cliente</option>
                    <option value="2">🏪 Vendedor</option>
                    <option value="1">🔐 Administrador</option>
                </select>
            </div>
            <div class="form-group" id="empresa-field" style="display:none;">
                <label>Nombre de la Empresa (para Vendedor)</label>
                <input type="text" name="nombre_empresa" class="form-control" placeholder="Ej: TechStore HN">
            </div>
        </div>
        <button type="submit" class="btn-primary">
            <i class="fa-solid fa-save"></i> Crear Usuario
        </button>
    </form>
</div>

<!-- Lista de usuarios existentes -->
<div class="gestion-table-wrapper">
    <table class="gestion-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nombre</th>
                <th>Email</th>
                <th>Rol</th>
                <th>Estado</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody id="lista-usuarios-body">
            <!-- Carga dinámica vía AJAX -->
        </tbody>
    </table>
</div>

<style>
#form-create-usuario .form-section {
    margin-bottom: 25px;
}
#form-create-usuario .form-section h3 {
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
</style>

<script>
$(document).ready(function() {
    loadUsuarios();

    // Mostrar/ocultar campo empresa según rol seleccionado
    $('select[name="rol_id"]').on('change', function() {
        if ($(this).val() === '2') {
            $('#empresa-field').slideDown();
        } else {
            $('#empresa-field').slideUp();
        }
    });

    $('#form-create-usuario').on('submit', function(e) {
        e.preventDefault();
        const data = $(this).serializeArray();

        App.ajax({
            url: App.baseUrl + 'api/admin_register.php',
            method: 'POST',
            data: $.param(data),
            success: function(response) {
                if (response.success) {
                    App.notify('Usuario creado: ' + response.data.nombre + ' (' + (response.data.rol_id === 1 ? 'Admin' : response.data.rol_id === 2 ? 'Vendedor' : 'Cliente') + ')', 'success');
                    $('#form-create-usuario')[0].reset();
                    $('#form-usuario').slideUp();
                    loadUsuarios();
                }
            }
        });
    });
});

function loadUsuarios() {
    App.ajax({
        url: App.baseUrl + 'api/clientes.php?action=lista_usuarios',
        method: 'GET',
        success: function(response) {
            if (response.success && response.data) {
                renderUsuarios(response.data);
            }
        }
    });
}

function renderUsuarios(usuarios) {
    const $tbody = $('#lista-usuarios-body');
    if (!$tbody.length) return;

    if (!usuarios || usuarios.length === 0) {
        $tbody.html('<tr><td colspan="6" style="text-align:center;color:var(--text-secondary);padding:30px;">No hay usuarios registrados</td></tr>');
        return;
    }

    const rolLabels = {1:'<span class="badge-success">Admin</span>', 2:'<span class="badge-info">Vendedor</span>', 3:'<span class="badge-secondary">Cliente</span>'};

    let html = '';
    usuarios.forEach(u => {
        const activoLabel = u.activo ? '<span class="badge-success">Activo</span>' : '<span class="badge-danger">Inactivo</span>';
        html += `
            <tr>
                <td>${u.id}</td>
                <td>${u.nombre} ${u.apellido || ''}</td>
                <td>${u.email}</td>
                <td>${rolLabels[u.rol_id] || '—'}</td>
                <td>${activoLabel}</td>
                <td>
                    <button class="action-btn ${u.activo ? 'warning' : 'success'}" onclick="toggleUsuario(${u.id}, ${u.activo})">
                        <i class="fa-solid ${u.activo ? 'fa-ban' : 'fa-check'}"></i>
                    </button>
                </td>
            </tr>
        `;
    });
    $tbody.html(html);
}

function toggleUsuario(id, activo) {
    const accion = activo ? 'desactivar' : 'activar';
    if (!confirm('¿' + accion.charAt(0).toUpperCase() + accion.slice(1) + ' este usuario?')) return;

    App.ajax({
        url: App.baseUrl + 'api/clientes.php',
        method: 'POST',
        data: { action: 'toggle_usuario', usuario_id: id },
        success: function(response) {
            if (response.success) {
                App.notify('Usuario ' + (activo ? 'desactivado' : 'activado'), 'info');
                loadUsuarios();
            }
        }
    });
}
</script>

<?php require_once __DIR__ . '/../layouts/footer.php'; ?>

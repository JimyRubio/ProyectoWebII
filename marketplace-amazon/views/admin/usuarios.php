<?php
$page_title = "Gesti&oacute;n de Usuarios - Admin";
$module_css = "productos.css";
$module_js = "";
require_once __DIR__ . '/../layouts/header.php';
?>

<div class="gestion-header">
    <h1><i class="fa-solid fa-users-gear"></i> Gesti&oacute;n de Usuarios</h1>
    <button class="btn-primary" id="btn-nuevo-usuario" onclick="$('#form-usuario').slideToggle();">
        <i class="fa-solid fa-user-plus"></i> Nuevo Usuario
    </button>
</div>

<!-- Formulario para crear usuario con rol espec&iacute;fico -->
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
                <label>Correo Electr&oacute;nico *</label>
                <input type="email" name="email" class="form-control" placeholder="usuario@ejemplo.com" required>
            </div>
            <div class="form-group">
                <label>Contrase&ntilde;a * (m&iacute;n. 6 caracteres)</label>
                <input type="password" name="password" class="form-control" placeholder="&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;" required>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Tel&eacute;fono</label>
                    <input type="text" name="telefono" class="form-control" placeholder="+504 9999-9999">
                </div>
                <div class="form-group">
                    <label>G&eacute;nero</label>
                    <select name="genero" class="form-control">
                        <option value="">Seleccionar...</option>
                        <option value="M">Masculino</option>
                        <option value="F">Femenino</option>
                        <option value="O">Otro</option>
                    </select>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Fecha de Nacimiento</label>
                    <input type="date" name="fecha_nacimiento" class="form-control">
                </div>
                <div class="form-group">
                    <label>Rol del Usuario *</label>
                    <select name="rol_id" class="form-control" required>
                        <option value="3">&#128100; Cliente</option>
                        <option value="2">&#127963; Vendedor</option>
                        <option value="1">&#128274; Administrador</option>
                    </select>
                </div>
            </div>
            <div class="form-group" id="empresa-field" style="display:none;">
                <label>Nombre de la Empresa (para Vendedor)</label>
                <input type="text" name="nombre_empresa" class="form-control" placeholder="Ej: TechStore HN">
            </div>
            <div class="form-group">
                <label>Direcci&oacute;n</label>
                <textarea name="direccion" class="form-control" rows="2" placeholder="Calle, colonia, ciudad..."></textarea>
            </div>
        </div>
        <button type="submit" class="btn-primary">
            <i class="fa-solid fa-save"></i> Crear Usuario
        </button>
    </form>
</div>

<!-- Filtros de b&uacute;squeda -->
<div style="display:flex;gap:15px;margin-bottom:20px;flex-wrap:wrap;align-items:center;">
    <div class="search-bar" style="flex:1;min-width:250px;">
        <input type="text" id="filter-usuario-search" placeholder="Buscar por nombre o email..." style="width:100%;padding:10px 16px;background:rgba(255,255,255,0.05);border:1px solid var(--card-border);border-radius:8px;color:var(--text-primary);font-size:0.9rem;outline:none;">
        <button onclick="filtrarUsuarios()" style="position:absolute;right:5px;top:50%;transform:translateY(-50%);background:var(--accent-gradient);border:none;width:36px;height:36px;border-radius:50%;color:#fff;cursor:pointer;"><i class="fa-solid fa-magnifying-glass"></i></button>
    </div>
    <select id="filter-rol" onchange="filtrarUsuarios()" style="padding:10px 16px;background:rgba(255,255,255,0.05);border:1px solid var(--card-border);border-radius:8px;color:var(--text-primary);font-size:0.9rem;outline:none;">
        <option value="">Todos los roles</option>
        <option value="1">Admin</option>
        <option value="2">Vendedor</option>
        <option value="3">Cliente</option>
    </select>
    <select id="filter-estado" onchange="filtrarUsuarios()" style="padding:10px 16px;background:rgba(255,255,255,0.05);border:1px solid var(--card-border);border-radius:8px;color:var(--text-primary);font-size:0.9rem;outline:none;">
        <option value="">Todos los estados</option>
        <option value="1">Activos</option>
        <option value="0">Inactivos</option>
    </select>
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
            <!-- Carga din&aacute;mica v&iacute;a AJAX -->
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
.search-bar {
    position: relative;
    display: flex;
}
</style>

<script>
$(document).ready(function() {
    loadUsuarios();

    // Enter en b&uacute;squeda
    $('#filter-usuario-search').on('keypress', function(e) {
        if (e.which === 13) filtrarUsuarios();
    });

    // Mostrar/ocultar campo empresa seg&uacute;n rol seleccionado
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
        data.push({name: 'csrf_token', value: App.getCsrfToken()});

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

    let html = '';
    usuarios.forEach(function(u) {
        const rolBadge = u.rol_id == 1 ? 'badge-danger' : (u.rol_id == 2 ? 'badge-warning' : 'badge-info');
        const rolNombre = u.rol_id == 1 ? 'Admin' : (u.rol_id == 2 ? 'Vendedor' : 'Cliente');
        const estadoHtml = u.activo 
            ? '<span class="badge-success" style="padding:2px 8px;border-radius:12px;font-size:0.75rem;">Activo</span>' 
            : '<span class="badge-secondary" style="padding:2px 8px;border-radius:12px;font-size:0.75rem;">Inactivo</span>';

        html += '<tr>';
        html += '<td>' + u.id + '</td>';
        html += '<td><strong>' + (u.nombre || '') + ' ' + (u.apellido || '') + '</strong></td>';
        html += '<td>' + (u.email || '') + '</td>';
        html += '<td><span class="' + rolBadge + '" style="padding:2px 8px;border-radius:12px;font-size:0.75rem;">' + rolNombre + '</span></td>';
        html += '<td>' + estadoHtml + '</td>';
        html += '<td>';
        html += '<button class="action-btn ' + (u.activo ? 'warning' : 'success') + '" onclick="toggleUsuario(' + u.id + ')" title="' + (u.activo ? 'Desactivar' : 'Activar') + '">';
        html += '<i class="fa-solid fa-' + (u.activo ? 'ban' : 'check') + '"></i>';
        html += '</button>';
        html += '</td>';
        html += '</tr>';
    });

    $tbody.html(html);
}

function filtrarUsuarios() {
    const search = $('#filter-usuario-search').val().toLowerCase().trim();
    const rol = $('#filter-rol').val();
    const estado = $('#filter-estado').val();

    App.ajax({
        url: App.baseUrl + 'api/clientes.php?action=lista_usuarios',
        method: 'GET',
        success: function(response) {
            if (response.success && response.data) {
                let datos = response.data;
                // Filtro por b&uacute;squeda
                if (search) {
                    datos = datos.filter(function(u) {
                        return (u.nombre || '').toLowerCase().includes(search) ||
                               (u.apellido || '').toLowerCase().includes(search) ||
                               (u.email || '').toLowerCase().includes(search);
                    });
                }
                // Filtro por rol
                if (rol) {
                    datos = datos.filter(function(u) { return u.rol_id == rol; });
                }
                // Filtro por estado
                if (estado !== '') {
                    datos = datos.filter(function(u) { return u.activo == estado; });
                }
                renderUsuarios(datos);
            }
        }
    });
}

function toggleUsuario(usuarioId) {
    App.confirm('¿Estás seguro de que deseas cambiar el estado de este usuario?', {
        type: 'warning',
        title: 'Cambiar Estado',
        confirmText: 'Sí, cambiar estado',
        cancelText: 'Cancelar'
    }).then(function (confirmed) {
if (!confirmed) return;
        App.ajax({
            url: App.baseUrl + 'api/clientes.php',
            method: 'POST',
            data: {
                action: 'toggle_usuario',
                usuario_id: usuarioId,
                csrf_token: App.getCsrfToken()
            },
            success: function(response) {
                if (response.success) {
                    App.notify(response.message, 'success');
                    loadUsuarios();
                }
            }
        });
    });
}
</script>

<?php require_once __DIR__ . '/../layouts/footer.php'; ?>


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
        <button type="submit" class="btn-primary">
            <i class="fa-solid fa-save"></i> Crear Usuario
        </button>
    </form>
</div>

<!-- Filtros de búsqueda -->
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
.search-bar {
    position: relative;
    display: flex;
}
</style>

<script>
$(document).ready(function() {
    loadUsuarios();

    // Enter en búsqueda
    $('#filter-usuario-search').on('keypress', function(e) {
        if (e.which === 13) filtrarUsuarios();
    });

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
                // Filtro por búsqueda
                if (search) {
                    datos = datos.filter(u => 
                        (u.nombre || '').toLowerCase().includes(search) ||
                        (u.apellido || '').toLowerCase().includes(search) ||
                        (u.email || '').toLowerCase().includes(search)
                    );
                }
                // Filtro por rol
                if (rol) {
                    datos = datos.filter(u => u.rol_id == rol);
                }
                // F

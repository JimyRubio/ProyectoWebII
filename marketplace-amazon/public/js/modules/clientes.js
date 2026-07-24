/* ==========================================================================
   MARKETPLACE AMAZON - MÓDULO JS DE CLIENTES (clientes.js)
   ========================================================================== */

$(document).ready(function () {
    if ($('#perfil-container').length) {
        loadPerfil();
    }

    if ($('#historial-pedidos-container').length) {
        loadHistorialPedidos();
    }

    // Formulario de actualización de perfil
    $('#form-update-profile').on('submit', function (e) {
        e.preventDefault();
        updateProfile();
    });

    // Formulario de nueva dirección
    $('#form-add-direccion').on('submit', function (e) {
        e.preventDefault();
        addDireccion();
    });
});

function loadPerfil() {
    App.ajax({
        url: App.baseUrl + 'api/clientes.php',
        method: 'GET',
        success: function (response) {
            if (response.success && response.data) {
                renderPerfil(response.data);
            }
        }
    });
}

function renderPerfil(profile) {
    const $container = $('#perfil-container');
    if (!$container.length) return;

    const html = `
        <div class="perfil-header">
            <div class="perfil-avatar">
                <i class="fa-solid fa-user-circle" style="font-size:4rem;color:var(--secondary-accent)"></i>
            </div>
            <div class="perfil-info">
                <h2>${profile.nombre} ${profile.apellido}</h2>
                <p class="perfil-email"><i class="fa-regular fa-envelope"></i> ${profile.email}</p>
                <p class="perfil-tipo"><span class="badge-${profile.tipo_cliente}">${profile.tipo_cliente.toUpperCase()}</span></p>
            </div>
            <div class="perfil-stats">
                <div class="stat-item">
                    <span class="stat-value">${App.formatCurrency(profile.total_compras)}</span>
                    <span class="stat-label">Total Compras</span>
                </div>
                <div class="stat-item">
                    <span class="stat-value">${profile.total_pedidos}</span>
                    <span class="stat-label">Pedidos</span>
                </div>
                <div class="stat-item">
                    <span class="stat-value">${profile.puntos_lealtad}</span>
                    <span class="stat-label">Puntos</span>
                </div>
            </div>
        </div>

        <div class="perfil-form-section">
            <h3><i class="fa-solid fa-pen"></i> Editar Información Personal</h3>
            <form id="form-update-profile">
                <div class="form-row">
                    <div class="form-group">
                        <label>Nombre</label>
                        <input type="text" name="nombre" class="form-control" value="${profile.nombre}" required>
                    </div>
                    <div class="form-group">
                        <label>Apellido</label>
                        <input type="text" name="apellido" class="form-control" value="${profile.apellido || ''}">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Teléfono</label>
                        <input type="text" name="telefono" class="form-control" value="${profile.telefono || ''}">
                    </div>
                    <div class="form-group">
                        <label>Dirección</label>
                        <input type="text" name="direccion" class="form-control" value="${profile.direccion || ''}">
                    </div>
                </div>
                <button type="submit" class="btn-primary">
                    <i class="fa-solid fa-save"></i> Guardar Cambios
                </button>
            </form>
        </div>

        <div class="perfil-direcciones-section">
            <h3><i class="fa-solid fa-location-dot"></i> Mis Direcciones</h3>
            <div id="direcciones-list"></div>
            <button class="btn-primary" id="btn-add-direccion" style="margin-top:15px;">
                <i class="fa-solid fa-plus"></i> Agregar Dirección
            </button>
            <div id="form-add-direccion-wrapper" style="display:none;margin-top:15px;">
                <form id="form-add-direccion">
                    <div class="form-row">
                        <div class="form-group">
                            <label>Calle *</label>
                            <input type="text" name="calle" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Número</label>
                            <input type="text" name="numero" class="form-control">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Colonia</label>
                            <input type="text" name="colonia" class="form-control">
                        </div>
                        <div class="form-group">
                            <label>Ciudad *</label>
                            <input type="text" name="ciudad" class="form-control" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Estado *</label>
                            <input type="text" name="estado" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Código Postal *</label>
                            <input type="text" name="codigo_postal" class="form-control" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Referencia</label>
                        <textarea name="referencia" class="form-control" rows="2"></textarea>
                    </div>
                    <button type="submit" class="btn-primary">
                        <i class="fa-solid fa-check"></i> Guardar Dirección
                    </button>
                </form>
            </div>
        </div>
    `;

    $container.html(html);
    loadDirecciones();

    $('#btn-add-direccion').on('click', function () {
        $('#form-add-direccion-wrapper').slideToggle();
    });
}

function loadDirecciones() {
    App.ajax({
        url: App.baseUrl + 'api/clientes.php?action=direcciones',
        method: 'GET',
        success: function (response) {
            if (response.success && response.data) {
                renderDirecciones(response.data);
            }
        }
    });
}

function renderDirecciones(direcciones) {
    const $list = $('#direcciones-list');
    if (!$list.length) return;

    if (!direcciones || direcciones.length === 0) {
        $list.html('<p style="color:var(--text-secondary)">No tienes direcciones guardadas.</p>');
        return;
    }

    let html = '<div class="direcciones-grid">';
    direcciones.forEach(dir => {
        html += `
            <div class="direccion-card ${dir.predeterminada ? 'default' : ''}">
                ${dir.predeterminada ? '<span class="badge-default">Predeterminada</span>' : ''}
                <p><strong>${dir.calle} ${dir.numero}</strong></p>
                <p>${dir.colonia ? dir.colonia + ', ' : ''}${dir.ciudad}, ${dir.estado}</p>
                <p>CP: ${dir.codigo_postal}</p>
                <p style="color:var(--text-secondary);font-size:0.85rem;">${dir.referencia || ''}</p>
            </div>
        `;
    });
    html += '</div>';
    $list.html(html);
}

function updateProfile() {
    const $form = $('#form-update-profile');
    const data = $form.serializeArray();
    data.push({ name: 'action', value: 'update_profile' });

    App.ajax({
        url: App.baseUrl + 'api/clientes.php',
        method: 'POST',
        data: $.param(data),
        success: function (response) {
            if (response.success) {
                App.notify('Perfil actualizado correctamente', 'success');
            }
        }
    });
}

function addDireccion() {
    const $form = $('#form-add-direccion');
    const data = $form.serializeArray();
    data.push({ name: 'action', value: 'add_direccion' });

    App.ajax({
        url: App.baseUrl + 'api/clientes.php',
        method: 'POST',
        data: $.param(data),
        success: function (response) {
            if (response.success) {
                App.notify('Dirección agregada', 'success');
                $('#form-add-direccion-wrapper').hide();
                $form[0].reset();
                loadDirecciones();
            }
        }
    });
}

function loadHistorialPedidos() {
    App.ajax({
        url: App.baseUrl + 'api/pedidos.php',
        method: 'GET',
        success: function (response) {
            if (response.success && response.data) {
                renderHistorialPedidos(response.data);
            }
        }
    });
}

function renderHistorialPedidos(pedidos) {
    const $container = $('#historial-pedidos-container');
    if (!$container.length) return;

    if (!pedidos || pedidos.length === 0) {
        $container.html('<p style="color:var(--text-secondary)">No tienes pedidos aún.</p>');
        return;
    }

    let html = '<div class="pedidos-table-wrapper"><table class="pedidos-table"><thead><tr><th>Pedido</th><th>Fecha</th><th>Items</th><th>Total</th><th>Estado</th><th>Acción</th></tr></thead><tbody>';
    pedidos.forEach(p => {
        const estadoClass = p.estado === 'entregado' ? 'success' : (p.estado === 'cancelado' ? 'danger' : 'warning');
        html += `
            <tr>
                <td><strong>#${p.numero_pedido}</strong></td>
                <td>${p.fecha_pedido}</td>
                <td>${p.total_items}</td>
                <td>${App.formatCurrency(p.total)}</td>
                <td><span class="badge-${estadoClass}">${p.estado}</span></td>
                <td>
                    <a href="${App.baseUrl}views/pedidos/rastreo.php?id=${p.id}" class="btn-primary" style="padding:4px 12px;font-size:0.8rem;display:inline-block;">
                        <i class="fa-solid fa-truck"></i> Rastrear
                    </a>
                </td>
            </tr>
        `;
    });
    html += '</tbody></table></div>';
    $container.html(html);
}


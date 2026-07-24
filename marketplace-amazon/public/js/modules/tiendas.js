/* ==========================================================================
   MARKETPLACE AMAZON - MÓDULO JS DE TIENDAS (tiendas.js)
   ========================================================================== */

$(document).ready(function () {
    if ($('#tiendas-grid').length) {
        loadTiendas();
    }

    if ($('#tienda-detalle-container').length) {
        const tiendaId = $('#tienda-detalle-container').data('id');
        if (tiendaId) loadTiendaDetalle(tiendaId);
    }

    if ($('#gestion-tiendas-container').length) {
        loadGestionTiendas();
    }
});

function loadTiendas() {
    App.ajax({
        url: App.baseUrl + 'api/tiendas.php',
        method: 'GET',
        success: function (response) {
            if (response.success && response.data) {
                renderTiendas(response.data);
            }
        }
    });
}

function renderTiendas(tiendas) {
    const $grid = $('#tiendas-grid');
    if (!$grid.length) return;

    if (!tiendas || tiendas.length === 0) {
        $grid.html('<div class="no-products-msg"><p>No hay tiendas disponibles.</p></div>');
        return;
    }

    let html = '';
    tiendas.forEach(tienda => {
        const nivelBadge = {
            'basic': 'badge-secondary',
            'silver': 'badge-info',
            'gold': 'badge-warning',
            'platinum': 'badge-success'
        };

        html += `
            <div class="tienda-card" data-id="${tienda.id}">
                <div class="tienda-logo">
                    <i class="fa-solid fa-store" style="font-size:2.5rem;color:var(--secondary-accent)"></i>
                </div>
                <h3>${tienda.nombre_tienda}</h3>
                <p class="tienda-empresa">${tienda.nombre_empresa}</p>
                <div class="tienda-meta">
                    <span class="${nivelBadge[tienda.nivel] || 'badge-secondary'}">${tienda.nivel}</span>
                    <span class="tienda-rating">
                        <i class="fa-solid fa-star" style="color:var(--secondary-accent)"></i> ${tienda.reputacion || '0.00'}
                    </span>
                </div>
                <a href="${App.baseUrl}views/tiendas/detalle.php?id=${tienda.id}" class="btn-primary" style="margin-top:15px;text-decoration:none;display:inline-block;">
                    <i class="fa-solid fa-eye"></i> Ver Tienda
                </a>
            </div>
        `;
    });

    $grid.html(html);
}

function loadTiendaDetalle(id) {
    App.ajax({
        url: App.baseUrl + 'api/tiendas.php',
        method: 'GET',
        data: { id: id },
        success: function (response) {
            if (response.success && response.data) {
                renderTiendaDetalle(response.data);
                loadProductosTienda(id);
            }
        }
    });
}

function renderTiendaDetalle(tienda) {
    const $container = $('#tienda-detalle-container');
    if (!$container.length) return;

    const html = `
        <div class="tienda-detalle-header">
            <div class="tienda-logo-large">
                <i class="fa-solid fa-store" style="font-size:4rem;color:var(--secondary-accent)"></i>
            </div>
            <div class="tienda-detalle-info">
                <h1>${tienda.nombre_tienda}</h1>
                <p><strong>${tienda.nombre_empresa}</strong></p>
                <p style="color:var(--text-secondary);margin-top:10px;">${tienda.descripcion || ''}</p>
                <div class="tienda-contacto" style="margin-top:15px;">
                    <p><i class="fa-solid fa-phone"></i> ${tienda.telefono_empresa || 'N/A'}</p>
                    <p><i class="fa-regular fa-envelope"></i> ${tienda.email_empresa || 'N/A'}</p>
                </div>
            </div>
            <div class="tienda-detalle-stats">
                <div class="stat">
                    <span class="stat-value">${tienda.reputacion || '0.00'}</span>
                    <span class="stat-label">Reputación</span>
                </div>
                <div class="stat">
                    <span class="stat-value">${tienda.nivel}</span>
                    <span class="stat-label">Nivel</span>
                </div>
            </div>
        </div>
    `;

    $container.html(html);
}

function loadProductosTienda(tiendaId) {
    App.ajax({
        url: App.baseUrl + 'api/tiendas.php?action=productos',
        method: 'GET',
        data: { id: tiendaId },
        success: function (response) {
            if (response.success && response.data) {
                renderProductosTienda(response.data);
            }
        }
    });
}

function renderProductosTienda(productos) {
    const $grid = $('#productos-tienda-grid');
    if (!$grid.length) return;

    if (!productos || productos.length === 0) {
        $grid.html('<p style="color:var(--text-secondary)">Esta tienda no tiene productos aún.</p>');
        return;
    }

    let html = '';
    productos.forEach(p => {
        html += `
            <div class="product-card">
                <h3>${p.nombre}</h3>
                <p class="price">${App.formatCurrency(p.precio)}</p>
                <p style="color:var(--text-secondary);font-size:0.85rem;">${p.categoria_nombre}</p>
            </div>
        `;
    });

    $grid.html(html);
}

function loadGestionTiendas() {
    App.ajax({
        url: App.baseUrl + 'api/tiendas.php',
        method: 'GET',
        success: function (response) {
            if (response.success && response.data) {
                renderGestionTiendas(response.data);
            }
        }
    });
}

function renderGestionTiendas(tiendas) {
    const $container = $('#gestion-tiendas-container');
    if (!$container.length) return;

    let html = '<div class="table-wrapper"><table class="analytics-table"><thead><tr><th>Tienda</th><th>Vendedor</th><th>Nivel</th><th>Reputación</th><th>Estado</th><th>Acción</th></tr></thead><tbody>';
    tiendas.forEach(t => {
        html += `
            <tr>
                <td><strong>${t.nombre_tienda}</strong></td>
                <td>${t.nombre_empresa}</td>
                <td><span class="badge-info">${t.nivel}</span></td>
                <td>${t.reputacion || '0.00'}</td>
                <td><span class="badge-success">${t.activa ? 'Activa' : 'Inactiva'}</span></td>
                <td><a href="${App.baseUrl}views/tiendas/detalle.php?id=${t.id}" class="btn-primary" style="padding:4px 12px;font-size:0.8rem;">Ver</a></td>
            </tr>
        `;
    });
    html += '</tbody></table></div>';
    $container.html(html);
}


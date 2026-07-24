/* ==========================================================================
   MARKETPLACE AMAZON - MÓDULO JS DE VENDEDORES (vendedores.js)
   ========================================================================== */

$(document).ready(function () {
    if ($('#vendedores-grid').length) {
        loadVendedores();
    }

    if ($('#seller-dashboard-container').length) {
        loadSellerDashboard();
    }
});

function loadVendedores() {
    App.ajax({
        url: App.baseUrl + 'api/vendedores.php',
        method: 'GET',
        success: function (response) {
            if (response.success && response.data) {
                renderVendedores(response.data);
            }
        }
    });
}

function renderVendedores(vendedores) {
    const $grid = $('#vendedores-grid');
    if (!$grid.length) return;

    if (!vendedores || vendedores.length === 0) {
        $grid.html('<div class="no-products-msg"><p>No hay vendedores registrados.</p></div>');
        return;
    }

    let html = '';
    vendedores.forEach(v => {
        const nivelBadge = {
            'basic': 'badge-secondary',
            'silver': 'badge-info',
            'gold': 'badge-warning',
            'platinum': 'badge-success'
        };

        html += `
            <div class="vendedor-card">
                <div class="vendedor-avatar">
                    <i class="fa-solid fa-user-tie" style="font-size:2.5rem;color:var(--primary-accent)"></i>
                </div>
                <h3>${v.nombre_empresa}</h3>
                <p class="vendedor-contact">${v.nombre} ${v.apellido}</p>
                <p class="vendedor-email">${v.email}</p>
                <div class="vendedor-meta">
                    <span class="${nivelBadge[v.nivel] || 'badge-secondary'}">${v.nivel}</span>
                    <span class="vendedor-rep">
                        <i class="fa-solid fa-star" style="color:var(--secondary-accent)"></i> ${v.reputacion || '0.00'}
                    </span>
                </div>
                <p class="vendedor-verificado" style="margin-top:10px;">
                    ${v.verificado 
                        ? '<span style="color:var(--price-color)"><i class="fa-solid fa-badge-check"></i> Verificado</span>' 
                        : '<span style="color:var(--text-secondary)">No verificado</span>'}
                </p>
            </div>
        `;
    });

    $grid.html(html);
}

function loadSellerDashboard() {
    App.ajax({
        url: App.baseUrl + 'api/vendedores.php?action=dashboard',
        method: 'GET',
        success: function (response) {
            if (response.success && response.data) {
                renderSellerDashboard(response.data);
            }
        }
    });
}

function renderSellerDashboard(metrics) {
    const $container = $('#seller-dashboard-container');
    if (!$container.length) return;

    const html = `
        <div class="kpi-grid">
            <div class="kpi-card blue">
                <div class="kpi-top-row">
                    <span class="kpi-title">Productos</span>
                    <div class="kpi-icon-box"><i class="fa-solid fa-box"></i></div>
                </div>
                <div class="kpi-value-container">
                    <span class="kpi-value">${metrics.total_productos}</span>
                </div>
            </div>

            <div class="kpi-card amber">
                <div class="kpi-top-row">
                    <span class="kpi-title">Stock Total</span>
                    <div class="kpi-icon-box"><i class="fa-solid fa-warehouse"></i></div>
                </div>
                <div class="kpi-value-container">
                    <span class="kpi-value">${metrics.stock_total}</span>
                </div>
            </div>

            <div class="kpi-card green">
                <div class="kpi-top-row">
                    <span class="kpi-title">Ventas del Mes</span>
                    <div class="kpi-icon-box"><i class="fa-solid fa-chart-line"></i></div>
                </div>
                <div class="kpi-value-container">
                    <span class="kpi-value">${App.formatCurrency(metrics.ventas_mes)}</span>
                </div>
            </div>

            <div class="kpi-card purple">
                <div class="kpi-top-row">
                    <span class="kpi-title">Pedidos Pendientes</span>
                    <div class="kpi-icon-box"><i class="fa-solid fa-clock"></i></div>
                </div>
                <div class="kpi-value-container">
                    <span class="kpi-value">${metrics.pedidos_pendientes}</span>
                </div>
            </div>
        </div>

        <div class="seller-actions" style="margin-top:30px;">
            <a href="${App.baseUrl}views/productos/gestion.php" class="btn-primary" style="text-decoration:none;display:inline-block;">
                <i class="fa-solid fa-plus"></i> Gestionar Productos
            </a>
            <a href="${App.baseUrl}views/pedidos/historial.php" class="btn-primary" style="text-decoration:none;display:inline-block;background:var(--blue-gradient);">
                <i class="fa-solid fa-receipt"></i> Ver Pedidos
            </a>
        </div>
    `;

    $container.html(html);
}


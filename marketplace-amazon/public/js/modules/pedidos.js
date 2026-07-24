/* ==========================================================================
   MARKETPLACE AMAZON - MÓDULO JS DE PEDIDOS (pedidos.js)
   ========================================================================== */

$(document).ready(function () {
    if ($('#pedido-detalle-container').length) {
        const pedidoId = $('#pedido-detalle-container').data('id');
        if (pedidoId) loadPedidoDetalle(pedidoId);
    }

    if ($('#rastreo-container').length) {
        const pedidoId = $('#rastreo-container').data('id');
        if (pedidoId) loadRastreo(pedidoId);
    }
});

function loadPedidoDetalle(id) {
    App.ajax({
        url: App.baseUrl + 'api/pedidos.php',
        method: 'GET',
        data: { id: id },
        success: function (response) {
            if (response.success && response.data) {
                renderPedidoDetalle(response.data);
            }
        }
    });
}

function renderPedidoDetalle(pedido) {
    const $container = $('#pedido-detalle-container');
    if (!$container.length) return;

    const estadoColors = {
        'pendiente': 'warning',
        'confirmado': 'info',
        'preparando': 'info',
        'enviado': 'primary',
        'entregado': 'success',
        'cancelado': 'danger',
        'devuelto': 'secondary'
    };

    let itemsHtml = '';
    if (pedido.items) {
        pedido.items.forEach(item => {
            itemsHtml += `
                <tr>
                    <td>
                        <img src="${item.imagen_url || 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=80&q=80'}" width="50" height="50" style="border-radius:8px;object-fit:cover;">
                    </td>
                    <td>${item.producto_nombre}</td>
                    <td>SKU: ${item.sku}</td>
                    <td>${item.cantidad}</td>
                    <td>${App.formatCurrency(item.precio_unitario)}</td>
                    <td>${App.formatCurrency(item.subtotal)}</td>
                </tr>
            `;
        });
    }

    const html = `
        <div class="pedido-header">
            <h2><i class="fa-solid fa-receipt"></i> Pedido #${pedido.numero_pedido}</h2>
            <span class="badge-${estadoColors[pedido.estado] || 'info'}">${pedido.estado.toUpperCase()}</span>
        </div>

        <div class="pedido-info-grid">
            <div class="pedido-info-card">
                <h4><i class="fa-regular fa-calendar"></i> Fecha</h4>
                <p>${pedido.fecha_pedido}</p>
            </div>
            <div class="pedido-info-card">
                <h4><i class="fa-solid fa-user"></i> Cliente</h4>
                <p>${pedido.cliente_nombre}</p>
                <p style="font-size:0.85rem;color:var(--text-secondary)">${pedido.cliente_email}</p>
            </div>
            <div class="pedido-info-card">
                <h4><i class="fa-solid fa-location-dot"></i> Dirección de Envío</h4>
                <p>${pedido.calle || 'No especificada'} ${pedido.numero || ''}</p>
                <p style="font-size:0.85rem;color:var(--text-secondary)">${pedido.ciudad || ''}, ${pedido.estado_dir || ''} CP: ${pedido.codigo_postal || ''}</p>
            </div>
            <div class="pedido-info-card">
                <h4><i class="fa-solid fa-credit-card"></i> Total Pagado</h4>
                <p style="font-size:1.5rem;font-weight:700;color:var(--price-color)">${App.formatCurrency(pedido.total)}</p>
            </div>
        </div>

        <h3 style="margin-top:30px;">Productos</h3>
        <div class="table-wrapper">
            <table class="analytics-table">
                <thead>
                    <tr>
                        <th></th>
                        <th>Producto</th>
                        <th>SKU</th>
                        <th>Cant.</th>
                        <th>Precio Unit.</th>
                        <th>Subtotal</th>
                    </tr>
                </thead>
                <tbody>${itemsHtml}</tbody>
            </table>
        </div>
    `;

    $container.html(html);
}

function loadRastreo(id) {
    App.ajax({
        url: App.baseUrl + 'api/pedidos.php',
        method: 'GET',
        data: { id: id, action: 'rastreo' },
        success: function (response) {
            if (response.success) {
                renderRastreo(response.data);
            }
        }
    });
}

function renderRastreo(historial) {
    const $container = $('#rastreo-container');
    if (!$container.length) return;

    if (!historial || historial.length === 0) {
        $container.html('<p style="color:var(--text-secondary)">No hay información de rastreo disponible.</p>');
        return;
    }

    let html = '<div class="timeline">';
    historial.forEach((h, idx) => {
        const isLast = idx === historial.length - 1;
        html += `
            <div class="timeline-item ${isLast ? 'active' : ''}">
                <div class="timeline-marker"></div>
                <div class="timeline-content">
                    <h4>${h.estado_nuevo.toUpperCase()}</h4>
                    <p>${h.comentario || ''}</p>
                    <span class="timeline-date">${h.created_at}</span>
                </div>
            </div>
        `;
    });
    html += '</div>';

    // Info de envío
    const lastItem = historial[historial.length - 1];
    if (lastItem.tracking_number) {
        html += `
            <div class="envio-info" style="margin-top:20px;padding:20px;background:var(--card-bg);border-radius:12px;">
                <h4><i class="fa-solid fa-truck"></i> Información de Envío</h4>
                <p><strong>Transportista:</strong> ${lastItem.transportista_nombre || 'N/A'}</p>
                <p><strong>Tracking:</strong> ${lastItem.tracking_number}</p>
            </div>
        `;
    }

    $container.html(html);
}


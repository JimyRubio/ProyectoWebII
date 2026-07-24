/* ==========================================================================
   MARKETPLACE AMAZON - MÓDULO JS DE PAGOS (pagos.js)
   ========================================================================== */

$(document).ready(function () {
    if ($('#checkout-container').length) {
        loadMetodosPago();
        loadCarritoCheckout();
        loadDireccionesCheckout();
    }
});

function loadMetodosPago() {
    App.ajax({
        url: App.baseUrl + 'api/pagos.php',
        method: 'GET',
        success: function (response) {
            if (response.success && response.data) {
                renderMetodosPago(response.data);
            }
        }
    });
}

function renderMetodosPago(metodos) {
    const $container = $('#metodos-pago-container');
    if (!$container.length) return;

    let html = '';
    metodos.forEach(m => {
        html += `
            <label class="metodo-pago-card">
                <input type="radio" name="metodo_pago_id" value="${m.id}" ${m.id === 1 ? 'checked' : ''}>
                <div class="metodo-pago-info">
                    <span class="metodo-nombre">${m.nombre}</span>
                    <span class="metodo-desc">${m.descripcion || ''}</span>
                </div>
            </label>
        `;
    });

    $container.html(html);
}

function loadCarritoCheckout() {
    App.ajax({
        url: App.baseUrl + 'api/carrito.php',
        method: 'GET',
        success: function (response) {
            if (response.success && response.data) {
                renderResumenCompra(response.data);
            }
        }
    });
}

function renderResumenCompra(cart) {
    const $container = $('#resumen-compra');
    if (!$container.length) return;

    if (!cart.items || cart.items.length === 0) {
        $container.html('<p style="color:var(--text-secondary)">Tu carrito está vacío. <a href="' + App.baseUrl + '">Ir a la tienda</a></p>');
        return;
    }

    let itemsHtml = '';
    cart.items.forEach(item => {
        itemsHtml += `
            <div class="resumen-item">
                <span>${item.producto_nombre} x${item.cantidad}</span>
                <span>${App.formatCurrency(item.subtotal)}</span>
            </div>
        `;
    });

    const html = `
        <h3>Resumen de Compra</h3>
        <div class="resumen-items">${itemsHtml}</div>
        <div class="resumen-totals">
            <div class="total-row">
                <span>Subtotal</span>
                <span>${App.formatCurrency(cart.subtotal)}</span>
            </div>
            <div class="total-row">
                <span>Envío</span>
                <span>Por calcular</span>
            </div>
            <div class="total-row grand-total">
                <span>Total</span>
                <span>${App.formatCurrency(cart.total)}</span>
            </div>
        </div>
    `;

    $container.html(html);
}

function loadDireccionesCheckout() {
    App.ajax({
        url: App.baseUrl + 'api/clientes.php?action=direcciones',
        method: 'GET',
        success: function (response) {
            if (response.success && response.data) {
                renderDireccionesCheckout(response.data);
            }
        }
    });
}

function renderDireccionesCheckout(direcciones) {
    const $container = $('#direcciones-envio');
    if (!$container.length) return;

    if (!direcciones || direcciones.length === 0) {
        $container.html('<p style="color:var(--text-secondary)">No hay direcciones guardadas.</p>');
        return;
    }

    let html = '';
    direcciones.forEach(d => {
        html += `
            <label class="direccion-envio-card ${d.predeterminada ? 'selected' : ''}">
                <input type="radio" name="direccion_id" value="${d.id}" ${d.predeterminada ? 'checked' : ''}>
                <div class="direccion-envio-info">
                    <strong>${d.calle} ${d.numero}</strong>
                    <span>${d.ciudad}, ${d.estado} - CP: ${d.codigo_postal}</span>
                </div>
            </label>
        `;
    });

    $container.html(html);
}

function procesarPago() {
    const metodoPagoId = $('input[name="metodo_pago_id"]:checked').val();
    const direccionId = $('input[name="direccion_id"]:checked').val();
    const totalText = $('#resumen-compra .grand-total span:last').text();
    const monto = parseFloat(totalText.replace(/[$,]/g, ''));

    if (!metodoPagoId) {
        App.notify('Selecciona un método de pago', 'error');
        return;
    }

    App.ajax({
        url: App.baseUrl + 'api/pagos.php',
        method: 'POST',
        data: {
            action: 'procesar',
            pedido_id: 0, // Se creará en backend
            metodo_pago_id: metodoPagoId,
            monto: monto,
            direccion_id: direccionId
        },
        success: function (response) {
            if (response.success) {
                App.notify('Pago procesado exitosamente', 'success');
                setTimeout(function () {
                    window.location.href = App.baseUrl + 'views/pedidos/historial.php';
                }, 1500);
            }
        }
    });
}


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

    // Set up change listener on radio buttons to show "Siguiente" button
    setupMetodoPagoToggle();

    // Hide all payment forms and pay button initially
    $('.payment-form-section').hide();
    $('#btn-pagar-container').hide();
    $('#btn-volver-container').hide();
    $('#btn-siguiente').hide();

    // If there's a default selection, show the "Siguiente" button
    const checkedRadio = $container.find('input[name="metodo_pago_id"]:checked');
    if (checkedRadio.length) {
        $('#btn-siguiente').show();
    }
}

/**
 * Sets up change listener on payment method radio buttons to show "Siguiente" button.
 */
function setupMetodoPagoToggle() {
    $(document).on('change', 'input[name="metodo_pago_id"]', function () {
        // Show the "Siguiente" button when a method is selected
        $('#btn-siguiente').show();
    });
}

/**
 * Called when user clicks "Siguiente".
 * Hides the ENTIRE method selection section and shows the corresponding form + pay button + back button.
 */
function irAlFormulario() {
    const metodoId = parseInt($('input[name="metodo_pago_id"]:checked').val());

    if (!metodoId) {
        App.notify('Selecciona un método de pago primero', 'error');
        return;
    }

    // Hide the ENTIRE method selection section (radio buttons + Siguiente button)
    $('#metodo-pago-section').hide();

    // Hide all payment forms initially
    $('.payment-form-section').hide();
    $('#btn-pagar-container').hide();
    $('#btn-volver-container').hide();

    if (metodoId === 1) {
        // Tarjeta de Crédito/Débito - show card form
        $('#card-form-section').show();
    } else if (metodoId === 2) {
        // PayPal
        $('#paypal-form-section').show();
    }
    // For method 3 (Transferencia) and 4 (Efectivo), no form is shown

    // Always show the pay button and back button after clicking Siguiente
    $('#btn-pagar-container').show();
    $('#btn-volver-container').show();
}

/**
 * Called when user clicks "Volver a métodos de pago".
 * Goes back to method selection, hides forms and pay button.
 */
function volverAMetodos() {
    // Hide all payment forms, pay button, and back button
    $('.payment-form-section').hide();
    $('#btn-pagar-container').hide();
    $('#btn-volver-container').hide();

    // Show the ENTIRE method selection section again
    $('#metodo-pago-section').show();
    $('#btn-siguiente').show();
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

    // Mostrar descuento si existe
    let descuentoHtml = '';
    const descuentos = parseFloat(cart.descuentos) || 0;
    if (descuentos > 0) {
        descuentoHtml = `
            <div class="total-row" style="color:#10B981;">
                <span>Descuento cupón</span>
                <span>-${App.formatCurrency(descuentos)}</span>
            </div>
        `;
    }

    const html = `
        <h3>Resumen de Compra</h3>
        <div class="resumen-items">${itemsHtml}</div>
        <div class="resumen-totals">
            <div class="total-row">
                <span>Subtotal</span>
                <span>${App.formatCurrency(cart.subtotal)}</span>
            </div>
            ${descuentoHtml}
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

/**
 * Aplica un cupón de descuento al carrito
 */
function aplicarCupon() {
    const codigo = $('#cupon-codigo').val().trim().toUpperCase();
    const $mensaje = $('#cupon-mensaje');

    if (!codigo) {
        App.notify('Ingresa un código de cupón', 'error');
        return;
    }

    // Deshabilitar botón mientras se procesa
    const $btn = $('#btn-aplicar-cupon');
    $btn.prop('disabled', true).html('<i class="fa-solid fa-spinner fa-spin"></i>');

    $mensaje.removeClass('success error').html('');

    App.ajax({
        url: App.baseUrl + 'api/carrito.php',
        method: 'POST',
        data: { action: 'apply_coupon', codigo: codigo },
        success: function (response) {
            if (response.success) {
                const data = response.data;
                const cupon = data.cupon;

                // Mostrar cupón aplicado
                $('#cupon-form').hide();
                $('#cupon-codigo-display').text(cupon.codigo || codigo);

                let valorDisplay = '';
                if (cupon.tipo_descuento === 'porcentaje') {
                    valorDisplay = cupon.valor + '% de descuento';
                } else {
                    valorDisplay = App.formatCurrency(cupon.valor) + ' de descuento';
                }
                $('#cupon-descuento-display').text(valorDisplay);
                $('#cupon-aplicado').show();
                $mensaje.removeClass('error').addClass('success').html('¡Cupón aplicado exitosamente!').show();

                // Actualizar resumen de compra con el carrito actualizado
                renderResumenCompra(data.cart);

                App.notify('¡Cupón aplicado!', 'success');
            } else {
                $mensaje.removeClass('success').addClass('error').html(App.escapeHtml(response.message || 'El cupón no pudo ser aplicado')).show();
            }
        },
        error: function (xhr) {
            let msg = 'Error al aplicar el cupón';
            try {
                if (xhr.responseJSON && xhr.responseJSON.message) {
                    msg = xhr.responseJSON.message;
                }
            } catch (e) {}
            $mensaje.removeClass('success').addClass('error').html(App.escapeHtml(msg)).show();
        },
        complete: function () {
            $btn.prop('disabled', false).html('<i class="fa-solid fa-check"></i> Aplicar');
        }
    });
}

/**
 * Remueve el cupón de descuento del carrito
 */
function removerCupon() {
    const $mensaje = $('#cupon-mensaje');

    App.ajax({
        url: App.baseUrl + 'api/carrito.php',
        method: 'POST',
        data: { action: 'remove_coupon' },
        success: function (response) {
            if (response.success) {
                // Ocultar cupón aplicado y mostrar formulario
                $('#cupon-aplicado').hide();
                $('#cupon-form').show();
                $('#cupon-codigo').val('');
                $mensaje.removeClass('success error').html('');

                // Actualizar resumen de compra
                renderResumenCompra(response.data);

                App.notify('Cupón removido', 'info');
            }
        },
        error: function () {
            App.notify('Error al remover el cupón', 'error');
        }
    });
}

// Habilitar Enter para aplicar cupón
$(document).ready(function () {
    $(document).on('keypress', '#cupon-codigo', function (e) {
        if (e.which === 13) {
            e.preventDefault();
            aplicarCupon();
        }
    });
});

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
    
    // Validar que se seleccionó un método de pago
    if (!metodoPagoId) {
        App.notify('Selecciona un método de pago', 'error');
        return;
    }

    // Deshabilitar botón para evitar doble clic
    const $btn = $('#btn-procesar-pago');
    $btn.prop('disabled', true).html('<i class="fa-solid fa-spinner fa-spin"></i> Procesando...');

    // Build request data
    const data = {
        action: 'procesar',
        metodo_pago_id: metodoPagoId,
        direccion_id: direccionId
    };

    // Add card details if Tarjeta de Crédito/Débito is selected
    const metodoIdInt = parseInt(metodoPagoId);
    if (metodoIdInt === 1) {
        const cardNumber = $('#card_number').val().replace(/\s/g, '');
        const cardName = $('#card_name').val().trim();
        const cardExpiry = $('#card_expiry').val().trim();
        const cardCvv = $('#card_cvv').val().trim();

        if (!cardNumber || !cardName || !cardExpiry || !cardCvv) {
            App.notify('Completa todos los datos de la tarjeta', 'error');
            $btn.prop('disabled', false).html('<i class="fa-solid fa-check-circle"></i> Confirmar y Pagar');
            return;
        }

        data.card_number = cardNumber;
        data.card_name = cardName;
        data.card_expiry = cardExpiry;
        data.card_cvv = cardCvv;
    }

    // Add PayPal details if PayPal is selected
    if (metodoIdInt === 2) {
        const paypalEmail = $('#paypal_email').val().trim();
        const paypalPassword = $('#paypal_password').val();

        if (!paypalEmail || !paypalPassword) {
            App.notify('Completa todos los datos de PayPal', 'error');
            $btn.prop('disabled', false).html('<i class="fa-solid fa-check-circle"></i> Confirmar y Pagar');
            return;
        }

        data.paypal_email = paypalEmail;
        data.paypal_password = paypalPassword;
    }

    App.ajax({
        url: App.baseUrl + 'api/pagos.php',
        method: 'POST',
        data: data,
        success: function (response) {
            if (response.success) {
                App.notify('¡Pago procesado exitosamente!', 'success');
                setTimeout(function () {
                    window.location.href = App.baseUrl + 'views/pedidos/historial.php';
                }, 2000);
            } else {
                $btn.prop('disabled', false).html('<i class="fa-solid fa-check-circle"></i> Confirmar y Pagar');
            }
        },
        error: function() {
            $btn.prop('disabled', false).html('<i class="fa-solid fa-check-circle"></i> Confirmar y Pagar');
        }
    });
}

// Auto-formatear número de tarjeta (agregar espacios cada 4 dígitos)
$(document).ready(function() {
    $('#card_number').on('input', function() {
        let val = $(this).val().replace(/\D/g, '');
        let formatted = val.replace(/(.{4})/g, '$1 ').trim();
        $(this).val(formatted);
    });

    // Auto-formatear fecha expiración
    $('#card_expiry').on('input', function() {
        let val = $(this).val().replace(/\D/g, '');
        if (val.length >= 2) {
            val = val.substring(0, 2) + '/' + val.substring(2, 4);
        }
        $(this).val(val);
    });

    // Solo números para CVV
    $('#card_cvv').on('input', function() {
        $(this).val($(this).val().replace(/\D/g, ''));
    });
});


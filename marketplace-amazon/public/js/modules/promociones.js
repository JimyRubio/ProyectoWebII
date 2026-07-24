/* ==========================================================================
   MARKETPLACE AMAZON - MÓDULO JS DE PROMOCIONES (promociones.js)
   ========================================================================== */

$(document).ready(function () {
    if ($('#promociones-grid').length) {
        loadPromociones();
    }

    // Modal validar cupón
    $('#btn-validar-cupon').on('click', function () {
        $('#cupon-modal').fadeIn(200);
    });

    $('.modal-close').on('click', function () {
        $('#cupon-modal').fadeOut(200);
    });

    $(window).on('click', function (e) {
        if ($(e.target).hasClass('modal-overlay')) {
            $('.modal-overlay').fadeOut(200);
        }
    });

    $('#btn-verificar-cupon').on('click', function () {
        validarCupon();
    });

    $('#cupon-codigo-input').on('keypress', function (e) {
        if (e.which === 13) {
            validarCupon();
        }
    });
});

function loadPromociones() {
    App.ajax({
        url: App.baseUrl + 'api/promociones.php',
        method: 'GET',
        success: function (response) {
            if (response.success && response.data) {
                renderPromociones(response.data);
            }
        }
    });
}

function renderPromociones(promociones) {
    const $grid = $('#promociones-grid');
    if (!$grid.length) return;

    if (!promociones || promociones.length === 0) {
        $grid.html('<div class="no-products-msg"><p>No hay promociones activas en este momento.</p></div>');
        return;
    }

    let html = '';
    promociones.forEach(promo => {
        const tipoLabel = {
            'porcentaje': '% Descuento',
            'monto_fijo': 'Descuento Fijo',
            'envio_gratis': 'Envío Gratis',
            'combo': 'Combo'
        };

        const valorDisplay = promo.tipo === 'porcentaje' ? `${promo.valor}%` : App.formatCurrency(promo.valor);

        html += `
            <div class="promo-card">
                <span class="promo-tag">${tipoLabel[promo.tipo] || 'Oferta'}</span>
                <h3>${promo.nombre}</h3>
                <p class="promo-desc">${promo.descripcion || ''}</p>
                <div class="promo-value">${valorDisplay}</div>
                <div class="promo-meta">
                    <span><i class="fa-regular fa-calendar"></i> ${promo.fecha_inicio}</span>
                    <span><i class="fa-regular fa-calendar-check"></i> ${promo.fecha_fin}</span>
                </div>
                ${promo.codigo ? `<div class="promo-code"><strong>Código:</strong> <span class="code-text">${promo.codigo}</span></div>` : ''}
            </div>
        `;
    });

    $grid.html(html);
}

function validarCupon() {
    const codigo = $('#cupon-codigo-input').val().trim();
    const $result = $('#cupon-result');

    if (!codigo) {
        App.notify('Ingresa un código de cupón', 'error');
        return;
    }

    $result.hide();

    App.ajax({
        url: App.baseUrl + 'api/promociones.php?action=validar',
        method: 'POST',
        data: { codigo: codigo },
        success: function (response) {
            if (response.success && response.data) {
                const cupon = response.data;
                const valorDisplay = cupon.tipo_descuento === 'porcentaje' ? `${cupon.valor}%` : App.formatCurrency(cupon.valor);
                $result.removeClass('error').addClass('success').html(`
                    <i class="fa-solid fa-check-circle"></i> 
                    Cupón válido! ${cupon.descripcion || ''} - <strong>${valorDisplay} de descuento</strong>
                `).show();
            }
        },
        error: function (xhr) {
            const msg = (xhr.responseJSON && xhr.responseJSON.message) || 'El cupón no es válido o ha expirado';
            $result.removeClass('success').addClass('error').html(`
                <i class="fa-solid fa-times-circle"></i> ${msg}
            `).show();
        }
    });
}


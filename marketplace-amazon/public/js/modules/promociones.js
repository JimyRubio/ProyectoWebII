/* ==========================================================================
   MARKETPLACE AMAZON - MÓDULO JS DE PROMOCIONES (promociones.js)
   ========================================================================== */

$(document).ready(function () {
    if ($('#promociones-grid').length) {
        loadPromociones();
    }

    // Botón "Nueva Promoción" - mostrar/ocultar formulario
    $('#btn-nueva-promo').on('click', function () {
        $('#form-nueva-promo').slideToggle(300);
        $(this).toggleClass('active');
    });

    // Submit formulario nueva promoción
    $('#form-create-promo').on('submit', function (e) {
        e.preventDefault();
        const data = $(this).serializeArray();
        data.push({ name: 'action', value: 'store' });

        App.ajax({
            url: App.baseUrl + 'api/promociones.php',
            method: 'POST',
            data: $.param(data),
            success: function (response) {
                if (response.success) {
                    App.notify('Promoción creada exitosamente', 'success');
                    $('#form-create-promo')[0].reset();
                    $('#form-nueva-promo').slideUp();
                    $('#btn-nueva-promo').removeClass('active');
                    loadPromociones();
                }
            }
        });
    });

    // Modal validar cupón
    $('#btn-validar-cupon').on('click', function () {
        $('#cupon-modal').fadeIn(200);
        $('#cupon-result').hide().removeClass('success error');
        $('#cupon-codigo-input').val('').focus();
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
        },
        error: function () {
            $('#promociones-grid').html('<div class="no-products-msg"><p style="color:var(--text-secondary);">Error al cargar promociones. Intente nuevamente.</p></div>');
        }
    });
}

function renderPromociones(promociones) {
    const $grid = $('#promociones-grid');
    if (!$grid.length) return;

    if (!promociones || promociones.length === 0) {
        $grid.html('<div class="no-products-msg" style="grid-column:1/-1;text-align:center;padding:40px;color:var(--text-secondary);"><i class="fa-solid fa-tag" style="font-size:2rem;display:block;margin-bottom:10px;"></i><p>No hay promociones activas en este momento.</p></div>');
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
        const fechaInicio = promo.fecha_inicio ? promo.fecha_inicio.substring(0, 10) : '';
        const fechaFin = promo.fecha_fin ? promo.fecha_fin.substring(0, 10) : '';

        html += `
            <div class="promo-card">
                <span class="promo-tag">${tipoLabel[promo.tipo] || 'Oferta'}</span>
                <h3>${App.escapeHtml(promo.nombre)}</h3>
                ${promo.descripcion ? '<p class="promo-desc">' + App.escapeHtml(promo.descripcion) + '</p>' : ''}
                <div class="promo-value">${valorDisplay}</div>
                <div class="promo-meta">
                    <span><i class="fa-regular fa-calendar"></i> ${fechaInicio}</span>
                    <span><i class="fa-regular fa-calendar-check"></i> ${fechaFin}</span>
                    <span>${promo.minimo_compra > 0 ? 'Mín: ' + App.formatCurrency(promo.minimo_compra) : 'Sin mínimo'}</span>
                </div>
                ${promo.codigo ? `<div class="promo-code" style="margin-top:8px;"><strong>Código:</strong> <span class="code-text" style="background:rgba(255,255,255,0.05);padding:2px 8px;border-radius:4px;font-family:monospace;">${App.escapeHtml(promo.codigo)}</span></div>` : ''}
                <div style="margin-top:10px;border-top:1px solid var(--card-border);padding-top:10px;display:flex;gap:8px;">
                    <button class="action-btn edit" onclick="alert('Editar promo ID: ${promo.id}')" title="Editar"><i class="fa-solid fa-pen"></i></button>
                    <button class="action-btn delete" onclick="eliminarPromocion(${promo.id})" title="Eliminar"><i class="fa-solid fa-trash"></i></button>
                </div>
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

    $result.hide().removeClass('success error');

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
                    ${cupon.minimo_compra > 0 ? '<br><small>Mínimo de compra: ' + App.formatCurrency(cupon.minimo_compra) + '</small>' : ''}
                `).show();
            } else {
                const msg = response.message || 'El cupón no es válido o ha expirado';
                $result.removeClass('success').addClass('error').html(`
                    <i class="fa-solid fa-times-circle"></i> ${App.escapeHtml(msg)}
                `).show();
            }
        },
        error: function (xhr) {
            const msg = (xhr.responseJSON && xhr.responseJSON.message) || 'El cupón no es válido o ha expirado';
            $result.removeClass('success').addClass('error').html(`
                <i class="fa-solid fa-times-circle"></i> ${App.escapeHtml(msg)}
            `).show();
        }
    });
}

function eliminarPromocion(id) {
    if (!confirm('¿Estás seguro de eliminar esta promoción?')) return;
    App.ajax({
        url: App.baseUrl + 'api/promociones.php',
        method: 'POST',
        data: { action: 'delete', id: id },
        success: function (response) {
            if (response.success) {
                App.notify('Promoción eliminada correctamente', 'info');
                loadPromociones();
            }
        }
    });
}

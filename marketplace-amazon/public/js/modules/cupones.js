/* ==========================================================================
   MARKETPLACE AMAZON - MÓDULO JS DE CUPONES ADMIN (cupones.js)
   ========================================================================== */

$(document).ready(function () {
    if ($('#lista-cupones-body').length) {
        loadCupones();
    }

    // Submit formulario crear/editar cupón
    $('#form-create-cupon').on('submit', function (e) {
        e.preventDefault();
        guardarCupon();
    });
});

/**
 * Carga todos los cupones (admin)
 */
function loadCupones() {
    App.ajax({
        url: App.baseUrl + 'api/cupones.php?action=all',
        method: 'GET',
        success: function (response) {
            if (response.success && response.data) {
                renderCupones(response.data);
            }
        },
        error: function () {
            $('#lista-cupones-body').html('<tr><td colspan="8" style="text-align:center;color:var(--text-secondary);padding:30px;">Error al cargar cupones. Verifica que tengas sesión iniciada como administrador.</td></tr>');
        }
    });
}

/**
 * Renderiza la tabla de cupones
 */
function renderCupones(cupones) {
    const $tbody = $('#lista-cupones-body');
    if (!$tbody.length) return;

    if (!cupones || cupones.length === 0) {
        $tbody.html('<tr><td colspan="8" style="text-align:center;color:var(--text-secondary);padding:30px;">No hay cupones registrados. Crea el primero con el botón "Nuevo Cupón".</td></tr>');
        return;
    }

    let html = '';
    cupones.forEach(function (c) {
        const tipoLabel = c.tipo_descuento === 'porcentaje' ? '% Porcentaje' : 'Monto Fijo';
        const valorDisplay = c.tipo_descuento === 'porcentaje' ? c.valor + '%' : App.formatCurrency(c.valor);
        const fechaInicio = c.fecha_inicio ? c.fecha_inicio.substring(0, 16).replace('T', ' ') : '';
        const fechaFin = c.fecha_fin ? c.fecha_fin.substring(0, 16).replace('T', ' ') : '';

        // Estado activo
        let estadoHtml;
        if (c.activo == 1) {
            estadoHtml = '<span class="badge-success">Activo</span>';
        } else {
            estadoHtml = '<span class="badge-secondary">Inactivo</span>';
        }

        html += '<tr>';
        html += '<td>' + c.id + '</td>';
        html += '<td><strong style="font-family:monospace;letter-spacing:1px;">' + App.escapeHtml(c.codigo) + '</strong></td>';
        html += '<td>' + App.escapeHtml(c.descripcion || '') + '</td>';
        html += '<td>' + tipoLabel + '</td>';
        html += '<td style="color:var(--price-color);font-weight:600;">' + valorDisplay + '</td>';
        html += '<td style="font-size:0.8rem;">' + fechaInicio + ' → ' + fechaFin + '</td>';
        html += '<td>' + estadoHtml + '</td>';
        html += '<td>';
        // Botón editar
        html += '<button class="action-btn" onclick="editarCupon(' + c.id + ')" title="Editar"><i class="fa-solid fa-pen"></i></button>';
        // Botón activar/desactivar
        html += '<button class="action-btn ' + (c.activo == 1 ? 'warning' : 'success') + '" onclick="toggleCupon(' + c.id + ')" title="' + (c.activo == 1 ? 'Desactivar' : 'Activar') + '"><i class="fa-solid fa-' + (c.activo == 1 ? 'ban' : 'check') + '"></i></button>';
        // Botón eliminar
        html += '<button class="action-btn delete" onclick="eliminarCupon(' + c.id + ')" title="Eliminar"><i class="fa-solid fa-trash"></i></button>';
        html += '</td>';
        html += '</tr>';
    });

    $tbody.html(html);
}

/**
 * Guarda un cupón (crear o actualizar)
 */
function guardarCupon() {
    const $form = $('#form-create-cupon');
    const cuponId = parseInt($('#cupon-id').val()) || 0;
    const data = $form.serializeArray();
    data.push({ name: 'action', value: cuponId > 0 ? 'update' : 'store' });
    data.push({ name: 'csrf_token', value: App.getCsrfToken() });
    // Asegurar que 'activo' llegue como 1 o 0
    if (!$('#cupon-activo-input').is(':checked')) {
        data.push({ name: 'activo', value: 0 });
    }

    const $btn = $('#btn-guardar-cupon');
    $btn.prop('disabled', true).html('<i class="fa-solid fa-spinner fa-spin"></i> Guardando...');

    App.ajax({
        url: App.baseUrl + 'api/cupones.php',
        method: 'POST',
        data: $.param(data),
        success: function (response) {
            if (response.success) {
                App.notify(cuponId > 0 ? 'Cupón actualizado exitosamente' : 'Cupón creado exitosamente', 'success');
                resetFormCupon();
                $('#form-cupon').slideUp();
                $('#btn-nuevo-cupon').removeClass('active');
                loadCupones();
            }
        },
        complete: function () {
            $btn.prop('disabled', false).html('<i class="fa-solid fa-save"></i> Guardar Cupón');
        }
    });
}

/**
 * Carga los datos de un cupón en el formulario para editar
 */
function editarCupon(id) {
    App.ajax({
        url: App.baseUrl + 'api/cupones.php?action=all',
        method: 'GET',
        success: function (response) {
            if (!response.success || !response.data) return;
            const cupon = response.data.find(c => c.id == id);
            if (!cupon) return;

            // Rellenar formulario
            $('#cupon-id').val(cupon.id);
            $('#cupon-codigo-input').val(cupon.codigo);
            $('#form-create-cupon [name="descripcion"]').val(cupon.descripcion || '');
            $('#cupon-tipo-input').val(cupon.tipo_descuento);
            $('#form-create-cupon [name="valor"]').val(cupon.valor);
            $('#form-create-cupon [name="minimo_compra"]').val(cupon.minimo_compra);
            $('#form-create-cupon [name="maximo_descuento"]').val(cupon.maximo_descuento || '');
            $('#form-create-cupon [name="usa_veces"]').val(cupon.usa_veces);
            $('#form-create-cupon [name="usa_por_cliente"]').val(cupon.usa_por_cliente);
            $('#cupon-activo-input').prop('checked', cupon.activo == 1);

            // Convertir fechas a formato datetime-local
            if (cupon.fecha_inicio) {
                $('#form-create-cupon [name="fecha_inicio"]').val(cupon.fecha_inicio.substring(0, 16));
            }
            if (cupon.fecha_fin) {
                $('#form-create-cupon [name="fecha_fin"]').val(cupon.fecha_fin.substring(0, 16));
            }

            $('#form-cupon-title').html('<i class="fa-solid fa-pen"></i> Editar Cupón ' + cupon.codigo);
            $('#form-cupon').slideDown();
            $('#btn-nuevo-cupon').addClass('active');
            $('#form-cupon')[0].scrollIntoView({ behavior: 'smooth' });
        }
    });
}

/**
 * Activa o desactiva un cupón
 */
function toggleCupon(id) {
    App.ajax({
        url: App.baseUrl + 'api/cupones.php',
        method: 'POST',
        data: { action: 'toggle', id: id, csrf_token: App.getCsrfToken() },
        success: function (response) {
            if (response.success) {
                App.notify(response.message, 'success');
                loadCupones();
            }
        }
    });
}

/**
 * Elimina un cupón con confirmación
 */
function eliminarCupon(id) {
    App.confirm('El cupón se eliminará permanentemente. Esta acción no se puede deshacer.', {
        type: 'danger',
        title: 'Eliminar Cupón',
        confirmText: 'Sí, eliminar',
        cancelText: 'Cancelar'
    }).then(function (confirmed) {
        if (!confirmed) return;
        App.ajax({
            url: App.baseUrl + 'api/cupones.php',
            method: 'POST',
            data: { action: 'delete', id: id, csrf_token: App.getCsrfToken() },
            success: function (response) {
                if (response.success) {
                    App.notify('Cupón eliminado correctamente', 'info');
                    loadCupones();
                }
            }
        });
    });
}

/**
 * Resetea el formulario de cupón
 */
function resetFormCupon() {
    $('#form-create-cupon')[0].reset();
    $('#cupon-id').val(0);
    $('#cupon-activo-input').prop('checked', true);
    $('#form-cupon-title').html('<i class="fa-solid fa-ticket"></i> Crear Nuevo Cupón');
}


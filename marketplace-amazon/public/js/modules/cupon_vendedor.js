/* ==========================================================================
   MARKETPLACE AMAZON - MÓDULO JS DE CUPONES VENDEDOR (cupon_vendedor.js)
   Muestra los cupones activos del administrador para que el vendedor
   pueda verlos y aplicarlos en el Punto de Venta.
   ========================================================================== */

$(document).ready(function () {
    if ($('#lista-cupones-vendedor-body').length) {
        loadCuponesVendedor();
    }
});

/**
 * Carga todos los cupones activos (los del admin)
 */
function loadCuponesVendedor() {
    App.ajax({
        url: App.baseUrl + 'api/cupones.php?action=activos',
        method: 'GET',
        success: function (response) {
            if (response.success && response.data) {
                renderCuponesVendedor(response.data);
            } else {
                $('#lista-cupones-vendedor-body').html('<tr><td colspan="8" style="text-align:center;color:var(--text-secondary);padding:30px;">No hay cupones activos disponibles.</td></tr>');
            }
        },
        error: function () {
            $('#lista-cupones-vendedor-body').html('<tr><td colspan="8" style="text-align:center;color:var(--text-secondary);padding:30px;">Error al cargar cupones. Verifica que tengas sesión iniciada.</td></tr>');
        }
    });
}

/**
 * Renderiza la tabla de cupones activos
 */
function renderCuponesVendedor(cupones) {
    const $tbody = $('#lista-cupones-vendedor-body');
    if (!$tbody.length) return;

    if (!cupones || cupones.length === 0) {
        $tbody.html('<tr><td colspan="8" style="text-align:center;color:var(--text-secondary);padding:30px;">No hay cupones activos registrados por el administrador.</td></tr>');
        return;
    }

    let html = '';
    cupones.forEach(function (c) {
        const tipoLabel = c.tipo_descuento === 'porcentaje' ? '% Porcentaje' : 'Monto Fijo';
        const valorDisplay = c.tipo_descuento === 'porcentaje' ? c.valor + '%' : App.formatCurrency(c.valor);
        const minimoDisplay = c.minimo_compra > 0 ? App.formatCurrency(c.minimo_compra) : 'Sin mínimo';
        const fechaInicio = c.fecha_inicio ? c.fecha_inicio.substring(0, 16).replace('T', ' ') : '';
        const fechaFin = c.fecha_fin ? c.fecha_fin.substring(0, 16).replace('T', ' ') : '';

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
        html += '<td>' + minimoDisplay + '</td>';
        html += '<td style="font-size:0.8rem;">' + fechaInicio + ' → ' + fechaFin + '</td>';
        html += '<td>' + estadoHtml + '</td>';
        html += '</tr>';
    });

    $tbody.html(html);
}

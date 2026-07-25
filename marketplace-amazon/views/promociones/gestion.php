<?php
$page_title = "Gestión de Promociones y Cupones - MarketZone";
$module_js = "promociones.js";
require_once __DIR__ . '/../layouts/header.php';
?>

<div class="welcome-section">
    <h1>Gestión de Promociones y Cupones</h1>
    <p>Administra las ofertas globales, descuentos y cupones del marketplace.</p>
</div>

<div class="promo-toolbar" style="display:flex;gap:12px;margin-bottom:30px;flex-wrap:wrap;">
    <button class="btn-primary" id="btn-nueva-promo">
        <i class="fa-solid fa-plus"></i> Nueva Promoción
    </button>
    <button class="btn-primary" id="btn-validar-cupon" style="background:var(--blue-gradient);">
        <i class="fa-solid fa-ticket"></i> Validar Cupón
    </button>
</div>

<!-- Formulario nueva promoción -->
<div id="form-nueva-promo" class="producto-form" style="display:none;margin-bottom:30px;">
    <h3><i class="fa-solid fa-tag"></i> Crear Nueva Promoción</h3>
    <form id="form-create-promo">
        <div class="form-section">
            <div class="form-row">
                <div class="form-group">
                    <label>Nombre *</label>
                    <input type="text" name="nombre" class="form-control" placeholder="Ej: Oferta de Verano" required>
                </div>
                <div class="form-group">
                    <label>Código (opcional)</label>
                    <input type="text" name="codigo" class="form-control" placeholder="Ej: VERANO25">
                </div>
            </div>
            <div class="form-group">
                <label>Descripción</label>
                <textarea name="descripcion" class="form-control" rows="2" placeholder="Describe la promoción..."></textarea>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Tipo *</label>
                    <select name="tipo" class="form-control" required>
                        <option value="porcentaje">% Porcentaje de Descuento</option>
                        <option value="monto_fijo">💰 Monto Fijo</option>
                        <option value="envio_gratis">🚚 Envío Gratis</option>
                        <option value="combo">📦 Combo</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Valor *</label>
                    <input type="number" step="0.01" name="valor" class="form-control" placeholder="Ej: 25 (para 25%)" required>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Fecha Inicio *</label>
                    <input type="datetime-local" name="fecha_inicio" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Fecha Fin *</label>
                    <input type="datetime-local" name="fecha_fin" class="form-control" required>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Mínimo de Compra</label>
                    <input type="number" step="0.01" name="minimo_compra" class="form-control" value="0">
                </div>
                <div class="form-group">
                    <label>Usos por Cliente</label>
                    <input type="number" name="usa_por_cliente" class="form-control" value="1">
                </div>
            </div>
        </div>
        <button type="submit" class="btn-primary">
            <i class="fa-solid fa-save"></i> Guardar Promoción
        </button>
    </form>
</div>

<!-- Sección de Cupones -->
<h2 class="section-title" style="margin-top:40px;">Cupones de Descuento</h2>
<p style="color:var(--text-secondary);margin-bottom:20px;">Los cupones se gestionan desde la base de datos (tabla <code>cupones</code>). Los clientes pueden ingresar su código en el punto de venta o carrito.</p>

<!-- Grid de Promociones Activas -->
<h2 class="section-title">Promociones Vigentes</h2>
<div id="promociones-grid" class="promo-grid" style="display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:20px;margin-bottom:30px;">
    <!-- Carga dinámica vía AJAX -->
</div>

<!-- Modal Validar Cupón -->
<div id="cupon-modal" class="modal-overlay" style="display:none;">
    <div class="modal-content">
        <span class="modal-close">&times;</span>
        <h3><i class="fa-solid fa-ticket"></i> Validar Cupón de Descuento</h3>
        <div class="form-group">
            <label>Código del Cupón</label>
            <input type="text" id="cupon-codigo-input" class="form-control" placeholder="Ej: BIENVENIDO10">
        </div>
        <div id="cupon-result"></div>
        <button class="btn-primary" id="btn-verificar-cupon">
            <i class="fa-solid fa-check"></i> Verificar Cupón
        </button>
    </div>
</div>

<style>
.promo-card {
    background: var(--card-bg);
    backdrop-filter: blur(10px);
    border: 1px solid var(--card-border);
    border-radius: 14px;
    padding: 24px;
    transition: all 0.3s ease;
}
.promo-card:hover {
    transform: translateY(-4px);
    border-color: rgba(255, 153, 0, 0.3);
}
.promo-card .promo-tag {
    display: inline-block;
    background: var(--accent-gradient);
    color: #fff;
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 0.75rem;
    font-weight: 700;
    text-transform: uppercase;
    margin-bottom: 12px;
}
.promo-card h3 {
    font-size: 1.15rem;
    margin-bottom: 8px;
}
.promo-card .promo-desc {
    color: var(--text-secondary);
    font-size: 0.9rem;
    margin-bottom: 15px;
}
.promo-card .promo-meta {
    display: flex;
    justify-content: space-between;
    font-size: 0.85rem;
    color: var(--text-secondary);
    border-top: 1px solid var(--card-border);
    padding-top: 12px;
}
.promo-card .promo-value {
    font-size: 1.5rem;
    font-weight: 700;
    color: var(--price-color);
    margin-bottom: 10px;
}
.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0,0,0,0.7);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 2000;
}
.modal-content {
    background: var(--card-bg);
    backdrop-filter: blur(12px);
    border: 1px solid var(--card-border);
    border-radius: 16px;
    padding: 30px;
    width: 90%;
    max-width: 480px;
    animation: fadeIn 0.3s ease;
}
.modal-close {
    float: right;
    font-size: 1.8rem;
    cursor: pointer;
    color: var(--text-secondary);
}
.modal-content h3 {
    margin-bottom: 20px;
    color: var(--text-primary);
}
#cupon-result {
    margin: 15px 0;
    padding: 12px;
    border-radius: 8px;
    display: none;
}
#cupon-result.success {
    display: block;
    background: rgba(16, 185, 129, 0.1);
    border: 1px solid rgba(16, 185, 129, 0.3);
    color: #34D399;
}
#cupon-result.error {
    display: block;
    background: rgba(239, 68, 68, 0.1);
    border: 1px solid rgba(239, 68, 68, 0.3);
    color: #F87171;
}
</style>

<script>
$(document).ready(function() {
    cargarPromociones();

    // Toggle form
    $('#btn-nueva-promo').on('click', function() {
        $('#form-nueva-promo').slideToggle();
    });

    // Submit promoción
    $('#form-create-promo').on('submit', function(e) {
        e.preventDefault();
        const data = $(this).serializeArray();
        data.push({name: 'action', value: 'store'});
        
        App.ajax({
            url: App.baseUrl + 'api/promociones.php',
            method: 'POST',
            data: $.param(data),
            success: function(response) {
                if(response.success) {
                    App.notify('Promoción creada exitosamente', 'success');
                    $('#form-create-promo')[0].reset();
                    $('#form-nueva-promo').slideUp();
                    cargarPromociones();
                }
            }
        });
    });

    // Modal cupón
    $('#btn-validar-cupon').on('click', function() {
        $('#cupon-modal').fadeIn();
        $('#cupon-result').hide().removeClass('success error');
    });

    $('.modal-close').on('click', function() {
        $('#cupon-modal').fadeOut();
    });

    $(document).on('click', function(e) {
        if ($(e.target).is('.modal-overlay')) {
            $('#cupon-modal').fadeOut();
        }
    });

    $('#btn-verificar-cupon').on('click', function() {
        const codigo = $('#cupon-codigo-input').val().trim();
        if (!codigo) {
            App.notify('Ingresa un código de cupón', 'warning');
            return;
        }

        App.ajax({
            url: App.baseUrl + 'api/promociones.php',
            method: 'POST',
            data: { action: 'validar', codigo: codigo },
            success: function(response) {
                const $result = $('#cupon-result');
                if (response.success && response.data) {
                    const cupon = response.data;
                    let descInfo = cupon.tipo_descuento === 'porcentaje' ? cupon.valor + '%' : App.formatCurrency(cupon.valor);
                    $result.html(`<i class="fa-solid fa-check-circle"></i> Cupón válido: ${descInfo} de descuento${cupon.minimo_compra > 0 ? ' (mín. ' + App.formatCurrency(cupon.minimo_compra) + ')' : ''}`)
                        .removeClass('error').addClass('success').show();
                } else {
                    $result.html(`<i class="fa-solid fa-times-circle"></i> ${response.message || 'El cupón no es válido o ha expirado'}`)
                        .removeClass('success').addClass('error').show();
                }
            }
        });
    });

    $('#cupon-codigo-input').on('keypress', function(e) {
        if (e.which === 13) $('#btn-verificar-cupon').click();
    });
});

function cargarPromociones() {
    App.ajax({
        url: App.baseUrl + 'api/promociones.php',
        method: 'GET',
        success: function(response) {
            if (response.success && response.data) {
                renderPromociones(response.data);
            }
        }
    });
}

function renderPromociones(promociones) {
    const $grid = $('#promociones-grid');
    if (!promociones || promociones.length === 0) {
        $grid.html('<div style="text-align:center;padding:40px;color:var(--text-secondary);grid-column:1/-1;"><i class="fa-solid fa-tag" style="font-size:2rem;display:block;margin-bottom:10px;"></i><p>No hay promociones activas</p></div>');
        return;
    }

    let html = '';
    promociones.forEach(p => {
        const tipoLabel = {
            'porcentaje': '% Descuento',
            'monto_fijo': 'Monto Fijo',
            'envio_gratis': 'Envío Gratis',
            'combo': 'Combo'
        }[p.tipo] || p.tipo;

        const valorDisplay = p.tipo === 'porcentaje' ? p.valor + '%' : App.formatCurrency(p.valor);

        html += `
            <div class="promo-card">
                <div class="promo-tag">${tipoLabel}</div>
                <h3>${p.nombre}</h3>
                ${p.descripcion ? '<p class="promo-desc">' + p.descripcion + '</p>' : ''}
                <div class="promo-value">${valorDisplay}</div>
                ${p.codigo ? '<div style="margin-bottom:10px;"><span style="background:rgba(255,255,255,0.05);padding:4px 10px;border-radius:4px;font-size:0.85rem;font-family:monospace;">Código: ' + p.codigo + '</span></div>' : ''}
                <div class="promo-meta">
                    <span><i class="fa-regular fa-calendar"></i> ${p.fecha_inicio ? p.fecha_inicio.substring(0,10) : ''}</span>
                    <span><i class="fa-regular fa-calendar-check"></i> ${p.fecha_fin ? p.fecha_fin.substring(0,10) : ''}</span>
                    <span>${p.minimo_compra > 0 ? 'Mín: ' + App.formatCurrency(p.minimo_compra) : 'Sin mínimo'}</span>
                </div>
            </div>
        `;
    });
    $grid.html(html);
}
</script>

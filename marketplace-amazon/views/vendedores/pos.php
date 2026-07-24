<?php
$page_title = "Punto de Venta - MarketZone";
$module_css = "productos.css";
$module_js = "vendedores.js";
require_once __DIR__ . '/../layouts/header.php';
?>

<div class="gestion-header">
    <h1><i class="fa-solid fa-cash-register"></i> Punto de Venta</h1>
    <button class="btn-primary" onclick="window.print()" style="background:var(--blue-gradient);">
        <i class="fa-solid fa-print"></i> Imprimir Factura
    </button>
</div>

<div style="display:grid;grid-template-columns:1fr 400px;gap:25px;">
    <!-- Columna izquierda: Búsqueda y productos -->
    <div>
        <div style="display:flex;gap:10px;margin-bottom:20px;">
            <input type="text" id="pos-search" placeholder="Buscar producto por nombre o SKU..." style="flex:1;padding:12px 16px;background:rgba(255,255,255,0.05);border:1px solid var(--card-border);border-radius:8px;color:var(--text-primary);font-size:0.95rem;outline:none;">
            <select id="pos-categoria" style="padding:12px 16px;background:rgba(255,255,255,0.05);border:1px solid var(--card-border);border-radius:8px;color:var(--text-primary);font-size:0.9rem;outline:none;">
                <option value="">Todas las categorías</option>
            </select>
        </div>
        <div id="pos-productos-grid" style="display:grid;grid-template-columns:repeat(auto-fill,minmax(180px,1fr));gap:12px;">
            <!-- Productos cargados vía AJAX -->
        </div>

    <!-- Columna derecha: Carrito / Ticket -->
    <div style="background:var(--card-bg);border:1px solid var(--card-border);border-radius:14px;padding:20px;position:sticky;top:100px;align-self:start;">
        <h3 style="margin-bottom:15px;"><i class="fa-solid fa-receipt"></i> Ticket de Venta</h3>
        <div id="pos-cart-items" style="max-height:400px;overflow-y:auto;margin-bottom:15px;"></div>
        <div style="border-top:2px dashed var(--card-border);padding-top:15px;">
            <div class="total-row"><span>Subtotal</span><span id="pos-subtotal">L. 0.00</span></div>
            <div class="total-row"><span>Descuento</span><span id="pos-descuento">L. 0.00</span></div>
            <div class="total-row grand-total"><span>Total</span><span id="pos-total">L. 0.00</span></div>
        <button class="btn-primary" id="btn-pos-pagar" style="margin-top:15px;width:100%;padding:14px;">
            <i class="fa-solid fa-check-circle"></i> Cobrar (L. 0.00)
        </button>
        <button class="btn-secondary" id="btn-pos-limpiar" style="margin-top:8px;width:100%;">
            <i class="fa-solid fa-trash"></i> Limpiar Ticket
        </button>
    </div>

<!-- Datos para factura -->
<div id="pos-factura-data" style="display:none;">
    <div class="producto-form" style="margin-top:30px;">
        <h3><i class="fa-solid fa-file-invoice"></i> Datos para Factura</h3>
        <form id="form-factura">
            <div class="form-row">
                <div class="form-group">
                    <label>Nombre / Razón Social</label>
                    <input type="text" name="razon_social" class="form-control" placeholder="Nombre del cliente" required>
                </div>
                <div class="form-group">
                    <label>RUC / Identidad</label>
                    <input type="text" name="ruc" class="form-control" placeholder="0801-2000-12345">
                </div>
            <div class="form-group">
                <label>Dirección</label>
                <textarea name="direccion" class="form-control" rows="2" placeholder="Dirección del cliente"></textarea>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Método de Pago</label>
                    <select name="metodo_pago" class="form-control">
                        <option value="EFECTIVO">Efectivo</option>
                        <option value="TARJETA">Tarjeta</option>
                        <option value="TRANSFERENCIA">Transferencia</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Monto Recibido</label>
                    <input type="number" step="0.01" name="monto_recibido" class="form-control" placeholder="0.00">
                </div>
            <button type="submit" class="btn-primary">
                <i class="fa-solid fa-file-invoice"></i> Generar Factura e Imprimir
            </button>
        </form>
    </div>

<style>
#pos-cart-items .pos-cart-item {
    display:flex;
    align-items:center;
    gap:10px;
    padding:10px 0;
    border-bottom:1px solid rgba(255,255,255,0.05);
}
#pos-cart-items .pos-cart-item .pos-item-info {
    flex:1;
}
#pos-cart-items .pos-cart-item .pos-item-info h4 {
    font-size:0.9rem;
    margin:0;
}
#pos-cart-items .pos-cart-item .pos-item-info small {
    color:var(--text-secondary);
    font-size:0.75rem;
}
#pos-cart-items .pos-cart-item .pos-item-qty {
    display:flex;
    align-items:center;
    gap:6px;
}
#pos-cart-items .pos-cart-item .pos-item-qty button {
    width:24px;height:24px;
    border-radius:4px;
    border:1px solid var(--card-border);
    background:rgba(255,255,255,0.05);
    color:#fff;
    cursor:pointer;
}
#pos-cart-items .pos-cart-item .pos-item-qty span {
    font-size:0.9rem;
    min-width:20px;text-align:center;
}
#pos-cart-items .pos-cart-item .pos-item-price {
    font-weight:700;
    color:var(--price-color);
    min-width:70px;
    text-align:right;
}
#pos-cart-items .pos-cart-item .pos-item-remove {
    color:#EF4444;
    cursor:pointer;
    font-size:1.1rem;
}
.pos-producto-card {
    background:var(--card-bg);
    border:1px solid var(--card-border);
    border-radius:10px;
    padding:12px;
    cursor:pointer;
    transition:all 0.2s;
    text-align:center;
}
.pos-producto-card:hover {
    border-color:var(--primary-accent);
    transform:translateY(-2px);
    box-shadow:0 4px 15px rgba(0,0,0,0.3);
}
.pos-producto-card img {
    width:100%;
    height:100px;
    object-fit:contain;
    margin-bottom:8px;
}
.pos-producto-card h4 {
    font-size:0.85rem;
    margin-bottom:4px;
}
.pos-producto-card .pos-precio {
    font-weight:700;
    color:var(--price-color);
    font-size:0.95rem;
}
@media print {
    .main-header,.main-footer,.btn-primary,.btn-secondary,#pos-search,#pos-categoria,#btn-pos-pagar,#btn-pos-limpiar,#pos-factura-data,#btn-nuevo-producto{display:none!important;}
    body{background:#fff!important;color:#000!important;}
    .container{max-width:100%!important;margin:0!important;padding:20px!important;}
    #pos-cart-items{max-height:none!important;overflow:visible!important;}
    [style*="grid-template-columns:1fr 400px"]{grid-template-columns:1fr!important;}
    .pos-producto-card{display:none!important;}
}
</style>

<script>
let posItems = [];
let posProductos = [];

$(document).ready(function() {
    cargarCategorias();
    cargarProductosPOS();

    $('#pos-search').on('keyup', function() {
        filtrarProductosPOS();
    });

    $('#pos-categoria').on('change', function() {
        filtrarProductosPOS();
    });

    $('#btn-pos-limpiar').on('click', function() {
        if (confirm('¿Limpiar ticket actual?')) {
            posItems = [];
            renderPOSSidebar();
        }
    });

    $('#form-factura').on('submit', function(e) {
        e.preventDefault();
        generarFactura();
    });

    $('#btn-pos-pagar').on('click', function() {
        if (posItems.length === 0) {
            App.notify('Agrega productos al ticket primero', 'warning');
            return;
        }
        $('#pos-factura-data').slideDown();
        $('html, body').animate({ scrollTop: $(document).height() }, 500);
    });
});

function cargarCategorias() {
    $.getJSON(App.baseUrl + 'api/productos.php?action=destacados&limit=1', function(r) {
        // Obtener categorías desde los productos destacados o endpoint
        $.getJSON(App.baseUrl + 'api/productos.php?limit=100', function(resp) {
            if (resp.success && resp.data && resp.data.productos) {
                const cats = new Set();
                resp.data.productos.forEach(p => {
                    if (p.categoria_nombre) cats.add(p.categoria_nombre);
                });
                const $sel = $('#pos-categoria');
                cats.forEach(c => {
                    $sel.append(`<option value="${c}">${c}</option>`);
                });
            }
        });
    });
}

function cargarProductosPOS() {
    App.ajax({
        url: App.baseUrl + 'api/productos.php',
        method: 'GET',
        data: { limit: 50 },
        success: function(response) {
            if (response.success && response.data && response.data.productos) {
                posProductos = response.data.productos;
                renderProductosPOS(posProductos);
            }
        }
    });
}

function filtrarProductosPOS() {
    const search = $('#pos-search').val().toLowerCase().trim();
    const cat = $('#pos-categoria').val();

    let filtrados = posProductos.filter(p => {
        const matchSearch = !search || 
            p.nombre.toLowerCase().includes(search) || 
            (p.sku && p.sku.toLowerCase().includes(search));
        const matchCat = !cat || p.categoria_nombre === cat;
        return matchSearch && matchCat;
    });
    renderProductosPOS(filtrados);
}

function renderProductosPOS(productos) {
    const $grid = $('#pos-productos-grid');
    if (!productos || productos.length === 0) {
        $grid.html('<div class="no-products-msg"><p>No se encontraron productos</p></div>');
        return;
    }

    let html = '';
    productos.forEach(p => {
        const img = p.imagen_principal || 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=150&q=80';
        html += `
            <div class="pos-producto-card" onclick="agregarAPOS(${p.id}, '${p.nombre.replace(/'/g, "\\'")}', ${p.precio}, '${img}')">
                <img src="${img}" alt="${p.nombre}" loading="lazy">
                <h4>${p.nombre.length > 30 ? p.nombre.substring(0,30)+'...' : p.nombre}</h4>
                <div class="pos-precio">${App.formatCurrency(p.precio)}</div>
                <small style="color:var(--text-secondary);font-size:0.75rem;">Stock: ${p.stock}</small>
            </div>
        `;
    });
    $grid.html(html);
}

function agregarAPOS(id, nombre, precio, img) {
    const existente = posItems.find(i => i.producto_id === id);
    if (existente) {
        existente.cantidad++;
        existente.subtotal = existente.cantidad * existente.precio_unitario;
    } else {
        posItems.push({
            producto_id: id,
            nombre: nombre,
            precio_unitario: precio,
            cantidad: 1,
            subtotal: precio,
            imagen: img
        });
    }
    renderPOSSidebar();
    App.notify(`${nombre} agregado`, 'success');
}

function renderPOSSidebar() {
    const $container = $('#pos-cart-items');
    const $btn = $('#btn-pos-pagar');
    let subtotal = 0;

    if (posItems.length === 0) {
        $container.html('<div style="text-align:center;padding:30px;color:var(--text-secondary);"><i class="fa-solid fa-cart-plus" style="font-size:2rem;display:block;margin-bottom:10px;"></i>Ticket vacío<br>Haz clic en un producto</div>');
        $('#pos-subtotal').text('L. 0.00');
        $('#pos-descuento').text('L. 0.00');
        $('#pos-total').text('L. 0.00');
        $btn.html('<i class="fa-solid fa-check-circle"></i> Cobrar (L. 0.00)');
        $('#pos-factura-data').slideUp();
        return;
    }

    let html = '';
    posItems.forEach((item, idx) => {
        subtotal += item.subtotal;
        html += `
            <div class="pos-cart-item">
                <img src="${item.imagen}" style="width:40px;height:40px;object-fit:contain;border-radius:4px;">
                <div class="pos-item-info">
                    <h4>${item.nombre}</h4>
                    <small>${App.formatCurrency(item.precio_unitario)} c/u</small>
                </div>
                <div class="pos-item-qty">
                    <button onclick="cambiarCantidadPOS(${idx}, -1)">−</button>
                    <span>${item.cantidad}</span>
                    <button onclick="cambiarCantidadPOS(${idx}, 1)">+</button>
                </div>
                <div class="pos-item-price">${App.formatCurrency(item.subtotal)}</div>
                <div class="pos-item-remove" onclick="eliminarItemPOS(${idx})"><i class="fa-solid fa-xmark"></i></div>
        `;
    });

    $container.html(html);
    const total = subtotal;
    $('#pos-subtotal').text(App.formatCurrency(subtotal));
    $('#pos-descuento').text('L. 0.00');
    $('#pos-total').text(App.formatCurrency(total));
    $btn.html(`<i class="fa-solid fa-check-circle"></i> Cobrar (${App.formatCurrency(total)})`);
}

function cambiarCantidadPOS(idx, delta) {
    if (!posItems[idx]) return;
    const nueva = posItems[idx].cantidad + delta;
    if (nueva < 1) {
        eliminarItemPOS(idx);
        return;
    }
    posItems[idx].cantidad = nueva;
    posItems[idx].subtotal = nueva * posItems[idx].precio_unitario;
    renderPOSSidebar();
}

function eliminarItemPOS(idx) {
    posItems.splice(idx, 1);
    renderPOSSidebar();
}

function generarFactura() {
    const data = $('#form-factura').serializeArray();
    const items = posItems.map(i => ({
        producto_id: i.producto_id,
        nombre: i.nombre,
        cantidad: i.cantidad,
        precio_unitario: i.precio_unitario,
        subtotal: i.subtotal
    }));
    const total = posItems.reduce((a, i) => a + i.subtotal, 0);
    const cambio = Math.max(0, (parseFloat($('input[name="monto_recibido"]').val()) || total) - total);

    // Generar factura directamente e imprimir
    const facturaNum = 'POS-' + Date.now().toString(36).toUpperCase();
    const cliente = data.find(d => d.name === 'razon_social')?.value || 'Consumidor Final';
    const ruc = data.find(d => d.name === 'ruc')?.value || 'N/A';
    const direccion = data.find(d => d.name === 'direccion')?.value || '';
    const metodo = data.find(d => d.name === 'metodo_pago')?.value || 'EFECTIVO';
    const recibido = parseFloat($('input[name="monto_recibido"]').val()) || total;

    const printWindow = window.open('', '_blank', 'width=400,height=600');
    printWindow.document.write(`
        <html><head><title>Factura ${facturaNum}</title>
        <style>
            body{font-family:'Courier New',monospace;font-size:12px;width:80mm;margin:0 auto;padding:10px;}
            h1{font-size:16px;text-align:center;margin-bottom:5px;}
            h2{font-size:14px;text-align:center;margin-bottom:10px;color:#333;}
            .header{text-align:center;margin-bottom:15px;border-bottom:1px dashed #000;padding-bottom:10px;}
            .info{font-size:11px;margin-bottom:10px;}
            table{width:100%;border-collapse:collapse;margin-bottom:10px;}
            th{border-bottom:1px solid #000;padding:5px 0;text-align:left;font-size:11px;}
            td{padding:4px 0;font-size:11px;}
            .right{text-align:right;}
            .totals{margin-top:10px;border-top:1px dashed #000;padding-top:10px;}
            .total-row{display:flex;justify-content:space-between;padding:3px 0;}
            .grand-total{font-size:16px;font-weight:bold;border-top:1px solid #000;padding-top:5px;margin-top:5px;}
            .footer{text-align:center;margin-top:20px;font-size:10px;border-top:1px dashed #000;padding-top:10px;}
            .badge{display:inline-block;padding:2px 8px;border:1px solid #000;font-size:10px;margin-bottom:10px;}
    </style></head>
    <body>
        <div class="header">
            <h1>${APP_NAME}</h1>
            <h2>PUNTO DE VENTA</h2>
            <div class="badge">FACTURA ${facturaNum}</div>
            <div>Fecha: ${new Date().toLocaleDateString()} ${new Date().toLocaleTimeString()}</div>
        <div class="info">
            <div><strong>Cliente:</strong> ${cliente}</div>
            <div><strong>RUC:</strong> ${ruc}</div>
            <div><strong>Dirección:</strong> ${direccion}</div>
        <table>
            <tr><th>Cant</th><th>Descripción</th><th class="right">Precio</th><th class="right">Total</th></tr>
            ${items.map(i => `
                <tr>
                    <td>${i.cantidad}</td>
                    <td>${i.nombre}</td>
                    <td class="right">${App.formatCurrency(i.precio_unitario)}</td>
                    <td class="right">${App.formatCurrency(i.subtotal)}</td>
                </tr>
            `).join('')}
        </table>
        <div class="totals">
            <div class="total-row"><span>Subtotal</span><span>${App.formatCurrency(total)}</span></div>
            <div class="total-row"><span>Método Pago</span><span>${metodo}</span></div>
            <div class="total-row"><span>Recibido</span><span>${App.formatCurrency(recibido)}</span></div>
            <div class="total-row"><span>Cambio</span><span>${App.formatCurrency(cambio)}</span></div>
            <div class="total-row grand-total"><span>TOTAL</span><span>${App.formatCurrency(total)}</span></div>
        <div class="footer">
            <p>¡Gracias por su compra!</p>
            <p>MarketZone - Todos los derechos reservados</p>
        </div>
    </body></html>`);

    printWindow.document.close();
    setTimeout(() => {
        printWindow.print();
        // Limpiar ticket después de imprimir
        posItems = [];
        renderPOSSidebar();
        $('#form-factura')[0].reset();
        $('#pos-factura-data').slideUp();
        App.notify('Factura generada: ' + facturaNum, 'success');
    }, 500);
}
</script>

<?php require_once __DIR__ . '/../layouts/footer.php'; ?>

/* ==========================================================================
   MARKETPLACE AMAZON - MÓDULO JS DE CARRITO (carrito.js)
   ========================================================================== */

let carritoActual = null;

$(document).ready(function () {
    if ($('#carrito-container').length) {
        loadCarrito();
    }

    // Modal carrito flotante
    $('#open-cart-btn').on('click', function (e) {
        e.preventDefault();
        if ($('#carrito-modal').length === 0) {
            loadCarritoModal();
        } else {
            $('#carrito-modal').toggle();
        }
    });
});

function loadCarrito() {
    App.ajax({
        url: App.baseUrl + 'api/carrito.php',
        method: 'GET',
        success: function (response) {
            if (response.success) {
                carritoActual = response.data;
                renderCarrito(response.data);
                $('#global-cart-badge').text(response.data.total_items || 0);
            }
        }
    });
}

function loadCarritoModal() {
    App.ajax({
        url: App.baseUrl + 'api/carrito.php',
        method: 'GET',
        success: function (response) {
            if (response.success) {
                showCartModal(response.data);
            }
        }
    });
}

function renderCarrito(cart) {
    const $container = $('#carrito-container');
    if (!$container.length) return;

    if (!cart.items || cart.items.length === 0) {
        $container.html(`
            <div class="empty-cart">
                <i class="fa-solid fa-cart-empty" style="font-size:3rem;color:var(--text-secondary)"></i>
                <h3>Tu carrito está vacío</h3>
                <p style="color:var(--text-secondary)">Agrega productos desde el catálogo</p>
                <a href="${App.baseUrl}" class="btn-primary" style="display:inline-block;width:auto;margin-top:15px">
                    <i class="fa-solid fa-store"></i> Ver Productos
                </a>
            </div>
        `);
        return;
    }

    let html = '<div class="carrito-items">';
    cart.items.forEach(item => {
        html += `
            <div class="carrito-item" data-id="${item.id}">
                <img src="${item.imagen_url || 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=100&q=80'}" alt="${item.producto_nombre}">
                <div class="item-info">
                    <h4>${item.producto_nombre}</h4>
                    <p class="item-sku">SKU: ${item.sku}</p>
                    <p class="item-price">${App.formatCurrency(item.precio_unitario)}</p>
                </div>
                <div class="item-qty">
                    <button class="qty-btn minus" data-id="${item.id}">-</button>
                    <span class="qty-value">${item.cantidad}</span>
                    <button class="qty-btn plus" data-id="${item.id}">+</button>
                </div>
                <div class="item-subtotal">${App.formatCurrency(item.subtotal)}</div>
                <button class="item-remove" data-id="${item.id}">
                    <i class="fa-solid fa-trash-can"></i>
                </button>
            </div>
        `;
    });
    html += '</div>';

    html += `
        <div class="carrito-footer">
            <div class="carrito-totals">
                <div class="total-row">
                    <span>Subtotal</span>
                    <span>${App.formatCurrency(cart.subtotal)}</span>
                </div>
                <div class="total-row">
                    <span>Descuentos</span>
                    <span>-${App.formatCurrency(cart.descuentos)}</span>
                </div>
                <div class="total-row grand-total">
                    <span>Total</span>
                    <span>${App.formatCurrency(cart.total)}</span>
                </div>
            </div>
            <div class="carrito-actions">
                <button class="btn-primary" id="btn-checkout">
                    <i class="fa-solid fa-credit-card"></i> Proceder al Pago
                </button>
                <button class="btn-secondary" id="btn-vaciar-carrito">
                    <i class="fa-solid fa-trash"></i> Vaciar Carrito
                </button>
            </div>
        </div>
    `;

    $container.html(html);
    bindCarritoEvents();
}

function showCartModal(cart) {
    const existing = $('#carrito-modal');
    if (existing.length) {
        existing.remove();
    }

    let itemsHtml = '';
    if (cart.items && cart.items.length > 0) {
        cart.items.forEach(item => {
            itemsHtml += `
                <div class="cart-modal-item">
                    <img src="${item.imagen_url || 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=50&q=80'}" width="40" height="40" style="border-radius:6px;object-fit:cover;">
                    <div class="cart-modal-info">
                        <strong>${item.producto_nombre}</strong>
                        <span>x${item.cantidad} - ${App.formatCurrency(item.subtotal)}</span>
                    </div>
                </div>
            `;
        });
    } else {
        itemsHtml = '<p style="color:var(--text-secondary);text-align:center;padding:20px;">Carrito vacío</p>';
    }

    const modal = $(`
        <div id="carrito-modal" class="cart-modal-overlay">
            <div class="cart-modal-content">
                <div class="cart-modal-header">
                    <h3><i class="fa-solid fa-cart-shopping"></i> Mi Carrito (${cart.total_items || 0})</h3>
                    <span class="cart-modal-close">&times;</span>
                </div>
                <div class="cart-modal-body">${itemsHtml}</div>
                <div class="cart-modal-footer">
                    <strong>Total: ${App.formatCurrency(cart.total)}</strong>
                    <a href="${App.baseUrl}views/carrito/index.php" class="btn-primary" style="text-decoration:none;padding:8px 16px;font-size:0.85rem;">
                        <i class="fa-solid fa-eye"></i> Ver Carrito
                    </a>
                </div>
            </div>
        </div>
    `);

    $('body').append(modal);
    modal.find('.cart-modal-close').on('click', function () { modal.remove(); });
    modal.on('click', function (e) { if (e.target === this) modal.remove(); });
}

function bindCarritoEvents() {
    $('.item-remove').off('click').on('click', function () {
        const itemId = $(this).data('id');
        removeFromCart(itemId);
    });

    $('#btn-vaciar-carrito').off('click').on('click', function () {
        if (confirm('¿Vaciar el carrito por completo?')) {
            clearCart();
        }
    });

    $('#btn-checkout').off('click').on('click', function () {
        window.location.href = App.baseUrl + 'views/pagos/checkout.php';
    });

    $('.qty-btn.minus').off('click').on('click', function () {
        const itemId = $(this).data('id');
        updateQty(itemId, -1);
    });

    $('.qty-btn.plus').off('click').on('click', function () {
        const itemId = $(this).data('id');
        updateQty(itemId, 1);
    });
}

function removeFromCart(itemId) {
    App.ajax({
        url: App.baseUrl + 'api/carrito.php?action=remove',
        method: 'POST',
        data: { item_id: itemId },
        success: function (response) {
            if (response.success) {
                App.notify('Producto eliminado del carrito', 'success');
                renderCarrito(response.data);
                $('#global-cart-badge').text(response.data.total_items || 0);
            }
        }
    });
}

function clearCart() {
    App.ajax({
        url: App.baseUrl + 'api/carrito.php?action=clear',
        method: 'POST',
        success: function (response) {
            if (response.success) {
                App.notify('Carrito vaciado', 'info');
                loadCarrito();
                $('#global-cart-badge').text('0');
            }
        }
    });
}

function updateQty(itemId, delta) {
    // Obtener cantidad actual y actualizar
    const $item = $(`.carrito-item[data-id="${itemId}"]`);
    const $qtySpan = $item.find('.qty-value');
    const currentQty = parseInt($qtySpan.text()) || 1;
    const newQty = currentQty + delta;
    
    if (newQty <= 0) {
        removeFromCart(itemId);
        return;
    }
    
    // Llamar a la API para actualizar (re-add con la nueva cantidad)
    App.ajax({
        url: App.baseUrl + 'api/carrito.php?action=update_qty',
        method: 'POST',
        data: {
            item_id: itemId,
            cantidad: newQty
        },
        success: function (response) {
            if (response.success) {
                renderCarrito(response.data);
                if (response.data.total_items !== undefined) {
                    $('#global-cart-badge').text(response.data.total_items);
                }
            }
        }
    });
}


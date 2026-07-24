/* ==========================================================================
   MARKETPLACE AMAZON - MÓDULO JS DE PRODUCTOS (productos.js)
   ========================================================================== */

let currentPage = 1;
let currentSearch = '';

$(document).ready(function () {
    // Si estamos en la página de inicio (index.php)
    if ($('#productos-destacados').length) {
        loadDestacados();
    }

    // Si estamos en el catálogo o gestión de productos
    if ($('#catalogo-productos-grid').length) {
        loadProducts(1);
    }
});

/**
 * Carga productos destacados para la portada de la tienda vía AJAX
 */
function loadDestacados() {
    App.ajax({
        url: App.baseUrl + 'api/productos.php',
        method: 'GET',
        data: { action: 'destacados', limit: 6 },
        success: function (response) {
            if (response.success && response.data.length > 0) {
                renderProductsGrid('#productos-destacados', response.data);
            }
        }
    });
}

/**
 * Carga lista paginada y filtrada de productos vía AJAX
 */
function loadProducts(page = 1, search = '') {
    currentPage = page;
    currentSearch = search;

    App.ajax({
        url: App.baseUrl + 'api/productos.php',
        method: 'GET',
        data: {
            page: page,
            limit: 6,
            search: search
        },
        success: function (response) {
            if (response.success && response.data) {
                renderProductsGrid('#productos-destacados', response.data.productos);
                App.renderPagination('#productos-pagination', response.data.pagination, function (newPage) {
                    loadProducts(newPage, currentSearch);
                });
            }
        }
    });
}

/**
 * Renderiza tarjetas HTML de productos dinámicamente
 */
function renderProductsGrid(containerSelector, products) {
    const $container = $(containerSelector);
    if (!$container.length) return;

    if (!products || products.length === 0) {
        $container.html('<div class="no-products-msg"><p>No se encontraron productos disponibles.</p></div>');
        return;
    }

    let html = '';
    products.forEach(p => {
        const imgUrl = p.imagen_principal || 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&q=80';
        const badge = p.oferta ? '<span class="product-badge">Oferta</span>' : (p.nuevo ? '<span class="product-badge">Nuevo</span>' : '');

        html += `
            <div class="product-card" data-id="${p.id}">
                ${badge}
                <img src="${imgUrl}" alt="${p.nombre}">
                <h3>${p.nombre}</h3>
                <p class="price">${App.formatCurrency(p.precio)}</p>
                <button class="btn-primary add-to-cart-btn" data-id="${p.id}">
                    <i class="fa-solid fa-cart-plus"></i> Agregar al Carrito
                </button>
            </div>
        `;
    });

    $container.html(html);

    // Event listener para agregar al carrito vía AJAX
    $container.find('.add-to-cart-btn').off('click').on('click', function (e) {
        e.preventDefault();
        const productoId = $(this).data('id');
        addToCart(productoId, 1);
    });
}

/**
 * Agrega producto al carrito vía AJAX
 */
function addToCart(productoId, cantidad = 1) {
    App.ajax({
        url: App.baseUrl + 'api/carrito.php?action=add',
        method: 'POST',
        data: {
            producto_id: productoId,
            cantidad: cantidad
        },
        success: function (response) {
            if (response.success) {
                App.notify('Producto agregado al carrito', 'success');
                if (response.data && response.data.total_items !== undefined) {
                    $('#global-cart-badge').text(response.data.total_items);
                }
            }
        }
    });
}

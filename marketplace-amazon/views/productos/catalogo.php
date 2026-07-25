<?php
$page_title = "Catálogo de Productos - MarketZone";
$module_css = "productos.css";
$module_js = "productos.js";
require_once __DIR__ . '/../layouts/header.php';

$search = isset($_GET['search']) ? htmlspecialchars($_GET['search']) : '';
$categoria_id = isset($_GET['categoria_id']) ? (int)$_GET['categoria_id'] : 0;
?>

<div class="welcome-section">
    <h1><i class="fa-solid fa-store"></i> Catálogo de Productos</h1>
    <p>Explora todos nuestros productos disponibles en MarketZone.</p>
</div>

<!-- Barra de búsqueda y filtros -->
<div class="catalogo-filters" style="display:flex;gap:15px;margin-bottom:25px;flex-wrap:wrap;align-items:center;">
    <div class="search-bar" style="flex:2;min-width:250px;position:relative;">
        <input type="text" id="catalogo-search-input" placeholder="Buscar productos, marcas, SKU..." 
               value="<?php echo $search; ?>"
               style="width:100%;padding:12px 16px;background:rgba(255,255,255,0.05);border:1px solid var(--card-border);border-radius:8px;color:var(--text-primary);font-size:0.9rem;outline:none;">
        <button id="catalogo-search-btn" style="position:absolute;right:5px;top:50%;transform:translateY(-50%);background:var(--accent-gradient);border:none;width:36px;height:36px;border-radius:50%;color:#fff;cursor:pointer;">
            <i class="fa-solid fa-magnifying-glass"></i>
        </button>
    </div>
    <select id="catalogo-categoria-select" style="flex:1;min-width:180px;padding:12px 16px;background:rgba(255,255,255,0.05);border:1px solid var(--card-border);border-radius:8px;color:var(--text-primary);font-size:0.9rem;outline:none;">
        <option value="0">Todas las categorías</option>
        <!-- Carga dinámica vía AJAX -->
    </select>
</div>

<!-- Grid de productos -->
<div id="catalogo-productos-grid" class="product-grid">
    <!-- Carga dinámica vía AJAX (productos.js) -->
</div>

<!-- Paginación -->
<div id="catalogo-pagination" class="pagination-wrapper" style="margin-top:20px;display:flex;justify-content:center;gap:8px;">
    <!-- Paginación AJAX -->
</div>

<script>
$(document).ready(function() {
    // Obtener search y categoria de URL
    const urlParams = new URLSearchParams(window.location.search);
    const searchParam = urlParams.get('search') || '';
    const catParam = urlParams.get('categoria_id') || '0';

    if (searchParam) {
        $('#catalogo-search-input').val(searchParam);
        currentSearch = searchParam;
    }
    if (catParam && catParam !== '0') {
        currentCategoryId = parseInt(catParam);
    }

    // Cargar categorías en el select
    App.ajax({
        url: App.baseUrl + 'api/productos.php?action=categorias',
        method: 'GET',
        success: function(response) {
            if (response.success && response.data) {
                const $select = $('#catalogo-categoria-select');
                response.data.forEach(function(c) {
                    const selected = (c.id == currentCategoryId) ? 'selected' : '';
                    $select.append('<option value="' + c.id + '" ' + selected + '>' + c.nombre + '</option>');
                });
                // Cargar productos después de tener las categorías
                loadCatalogoProducts(1, currentSearch, currentCategoryId);
            }
        }
    });

    // Evento de búsqueda
    $('#catalogo-search-btn').on('click', function() {
        currentSearch = $('#catalogo-search-input').val().trim();
        currentCategoryId = parseInt($('#catalogo-categoria-select').val()) || 0;
        loadCatalogoProducts(1, currentSearch, currentCategoryId);
    });

    $('#catalogo-search-input').on('keypress', function(e) {
        if (e.which === 13) {
            $('#catalogo-search-btn').click();
        }
    });

    // Evento cambio de categoría
    $('#catalogo-categoria-select').on('change', function() {
        currentSearch = $('#catalogo-search-input').val().trim();
        currentCategoryId = parseInt($(this).val()) || 0;
        loadCatalogoProducts(1, currentSearch, currentCategoryId);
    });
});

let currentSearch = '';
let currentCategoryId = 0;
let currentPage = 1;

function loadCatalogoProducts(page, search, categoriaId) {
    currentPage = page;
    currentSearch = search || '';
    currentCategoryId = categoriaId || 0;

    App.ajax({
        url: App.baseUrl + 'api/productos.php',
        method: 'GET',
        data: {
            page: page,
            limit: 12,
            search: currentSearch,
            categoria_id: currentCategoryId
        },
        success: function(response) {
            if (response.success && response.data) {
                renderCatalogoProducts(response.data.productos);
                App.renderPagination('#catalogo-pagination', response.data.pagination, function(newPage) {
                    loadCatalogoProducts(newPage, currentSearch, currentCategoryId);
                });
            }
        }
    });
}

function renderCatalogoProducts(productos) {
    const $grid = $('#catalogo-productos-grid');
    if (!$grid.length) return;

    if (!productos || productos.length === 0) {
        $grid.html('<div class="no-products-msg" style="text-align:center;padding:60px;grid-column:1/-1;"><i class="fa-solid fa-box-open" style="font-size:3rem;color:var(--text-secondary);display:block;margin-bottom:15px;"></i><p style="color:var(--text-secondary);font-size:1.1rem;">No se encontraron productos disponibles.</p></div>');
        return;
    }

    let html = '';
    productos.forEach(function(p) {
        var imgUrl = p.imagen_principal || App.baseUrl + 'public/uploads/productos/placeholder.svg';
        var badge = p.oferta ? '<span class="product-badge">Oferta</span>' : (p.nuevo ? '<span class="product-badge">Nuevo</span>' : '');

        html += '<div class="product-card" data-id="' + p.id + '">';
        html += badge;
        html += '<a href="' + App.baseUrl + 'views/productos/detalle.php?id=' + p.id + '" style="text-decoration:none;color:inherit;">';
        html += '<img src="' + imgUrl + '" alt="' + p.nombre + '" loading="lazy">';
        html += '<h3>' + p.nombre + '</h3>';
        html += '</a>';
        html += '<p class="price">' + App.formatCurrency(p.precio) + '</p>';
        html += '<div class="qty-selector">';
        html += '<label>Cant:</label>';
        html += '<input type="number" class="product-qty-input" value="1" min="1" max="' + (p.stock || 99) + '">';
        html += '</div>';
        html += '<button class="btn-primary add-to-cart-btn" data-id="' + p.id + '">';
        html += '<i class="fa-solid fa-cart-plus"></i> Agregar al Carrito';
        html += '</button>';
        html += '</div>';
    });

    $grid.html(html);

    // Event listener para agregar al carrito
    $grid.find('.add-to-cart-btn').off('click').on('click', function(e) {
        e.preventDefault();
        var productoId = $(this).data('id');
        var $card = $(this).closest('.product-card');
        var cantidad = parseInt($card.find('.product-qty-input').val()) || 1;
        addToCart(productoId, cantidad);
    });
}
</script>

<?php require_once __DIR__ . '/../layouts/footer.php'; ?>


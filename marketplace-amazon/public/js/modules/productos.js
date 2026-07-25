/* ==========================================================================
   MARKETPLACE AMAZON - MÓDULO JS DE PRODUCTOS (productos.js)
   ========================================================================== */

let currentPage = 1;
let currentSearch = '';
let currentCategoryId = 0;

$(document).ready(function () {
    // Si estamos en la página de inicio (index.php)
    if ($('#productos-destacados').length) {
        loadIndexProducts(1);
        loadCategoriasIndex();
    }

// Si estamos en el catálogo - NO llamar loadProducts, el catálogo tiene su propia función loadCatalogoProducts
    // if ($('#catalogo-productos-grid').length) {
    //     loadProducts(1);
    // }

    // Si estamos en detalle de producto
    if ($('#producto-detalle-container').length) {
        const productId = $('#producto-detalle-container').data('id');
        if (productId) {
            loadDetalleProducto(productId);
        }
    }

    // Event: Contactar Vendedor
    $(document).on('click', '#btn-contactar-vendedor', function () {
        const vendedorId = $(this).data('vendedor-id');
        const nombreProducto = $(this).data('producto');
        if (vendedorId) {
            contactarVendedor(vendedorId, nombreProducto);
        } else {
            App.notify('Debes iniciar sesión para contactar al vendedor', 'warning');
        }
    });
});

/**
 * Verifica si el usuario está autenticado antes de agregar al carrito
 */
function checkAuthBeforeCart(callback) {
    App.ajax({
        url: App.baseUrl + 'api/auth.php',
        method: 'GET',
        success: function(response) {
            if (response.success && response.data && response.data.authenticated) {
                if (typeof callback === 'function') callback();
            } else {
                App.notify('🔒 Debes iniciar sesión para agregar productos al carrito. Haz clic en "Iniciar Sesión" en la esquina superior derecha.', 'warning');
                setTimeout(function() {
                    window.location.href = App.baseUrl + 'views/auth/login.php';
                }, 2500);
            }
        },
        error: function() {
            App.notify('Error al verificar autenticación. Por favor inicia sesión.', 'error');
        }
    });
}

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
            } else {
                $('#productos-destacados').html('<div class="no-products-msg"><p>No se encontraron productos destacados.</p></div>');
            }
        }
    });
}

/**
 * Carga las categorías en el index para filtrar
 */
function loadCategoriasIndex() {
    App.ajax({
        url: App.baseUrl + 'api/productos.php?action=categorias',
        method: 'GET',
        success: function (response) {
            if (response.success && response.data) {
                renderCategoriasButtons(response.data);
            }
        }
    });
}

function renderCategoriasButtons(categorias) {
    const $container = $('#categorias-filter-container');
    if (!$container.length) return;

    let html = '<button class="cat-btn active" data-id="0">Todos</button>';
    categorias.forEach(c => {
        html += '<button class="cat-btn" data-id="' + c.id + '">' + c.nombre + '</button>';
    });

    $container.html(html);

    $container.find('.cat-btn').on('click', function () {
        $container.find('.cat-btn').removeClass('active');
        $(this).addClass('active');
        currentCategoryId = parseInt($(this).data('id'));
        loadProductsByCategory(currentCategoryId);
    });
}

/**
 * Carga todos los productos paginados para la página de inicio (MarketZone)
 */
function loadIndexProducts(page) {
    page = page || 1;
    currentPage = page;
    currentSearch = '';
    currentCategoryId = 0;

    App.ajax({
        url: App.baseUrl + 'api/productos.php',
        method: 'GET',
        data: {
            page: page,
            limit: 12,
            search: ''
        },
        success: function (response) {
            if (response.success && response.data) {
                renderProductsGrid('#productos-destacados', response.data.productos);
                App.renderPagination('#productos-pagination', response.data.pagination, function (newPage) {
                    loadIndexProducts(newPage);
                });
            } else {
                $('#productos-destacados').html('<div class="no-products-msg"><p>No se encontraron productos disponibles.</p></div>');
                $('#productos-pagination').empty();
            }
        },
        error: function() {
            $('#productos-destacados').html('<div class="no-products-msg"><p>Error al cargar productos.</p></div>');
        }
    });
}

function loadProductsByCategory(categoriaId) {
    App.ajax({
        url: App.baseUrl + 'api/productos.php',
        method: 'GET',
        data: { categoria_id: categoriaId, limit: 12 },
        success: function (response) {
            if (response.success && response.data) {
                renderProductsGrid('#productos-destacados', response.data.productos);
                App.renderPagination('#productos-pagination', response.data.pagination, function (newPage) {
                    loadProductsByCategory(currentCategoryId);
                });
            } else {
                $('#productos-destacados').html('<div class="no-products-msg"><p>No se encontraron productos en esta categoría.</p></div>');
                $('#productos-pagination').empty();
            }
        },
        error: function() {
            $('#productos-destacados').html('<div class="no-products-msg"><p>Error al cargar productos.</p></div>');
        }
    });
}

/**
 * Carga lista paginada y filtrada de productos vía AJAX (catálogo)
 */
function loadProducts(page, search) {
    page = page || 1;
    search = search || '';
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
            } else {
                $('#productos-destacados').html('<div class="no-products-msg"><p>No se encontraron productos disponibles.</p></div>');
                $('#productos-pagination').empty();
            }
        },
        error: function() {
            $('#productos-destacados').html('<div class="no-products-msg"><p>Error al cargar productos.</p></div>');
        }
    });
}

/**
 * Renderiza tarjetas HTML de productos dinámicamente
 */
function renderProductsGrid(containerSelector, products) {
    var $container = $(containerSelector);
    if (!$container.length) return;

    if (!products || products.length === 0) {
        $container.html('<div class="no-products-msg"><p>No se encontraron productos disponibles.</p></div>');
        return;
    }

    var html = '';
    for (var i = 0; i < products.length; i++) {
        var p = products[i];
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
    }

    $container.html(html);

    // Event listener para agregar al carrito con verificación de autenticación
    $container.find('.add-to-cart-btn').off('click').on('click', function (e) {
        e.preventDefault();
        var productoId = $(this).data('id');
        var $card = $(this).closest('.product-card');
        var cantidad = parseInt($card.find('.product-qty-input').val()) || 1;
        
        // Verificar autenticación primero
        checkAuthBeforeCart(function() {
            addToCart(productoId, cantidad);
        });
    });
}

/**
 * Agrega producto al carrito vía AJAX
 */
function addToCart(productoId, cantidad) {
    cantidad = cantidad || 1;
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

/**
 * Carga el detalle de un producto vía AJAX en la página de detalle
 */
function loadDetalleProducto(productId) {
    App.ajax({
        url: App.baseUrl + 'api/productos.php',
        method: 'GET',
        data: { id: productId },
        success: function (response) {
            if (response.success && response.data) {
                renderDetalleProducto(response.data);
                // Cargar reseñas y productos relacionados después del detalle
                loadResenas(productId);
                loadProductosRelacionados(response.data.categoria_id, productId);
            } else {
                $('#producto-detalle-container').html('<div style="text-align:center;padding:60px;color:var(--text-secondary);"><i class="fa-solid fa-triangle-exclamation" style="font-size:2rem;display:block;margin-bottom:10px;"></i><p>Producto no encontrado</p></div>');
            }
        },
        error: function () {
            $('#producto-detalle-container').html('<div style="text-align:center;padding:60px;color:var(--text-secondary);"><i class="fa-solid fa-triangle-exclamation" style="font-size:2rem;display:block;margin-bottom:10px;"></i><p>Error al cargar el producto</p></div>');
        }
    });
}

/**
 * Carga reseñas de un producto
 */
function loadResenas(productId) {
    App.ajax({
        url: App.baseUrl + 'api/productos.php',
        method: 'GET',
        data: { action: 'resenas', producto_id: productId },
        success: function (response) {
            if (response.success && response.data) {
                renderResenas(response.data, productId);
            } else {
                renderResenas([], productId);
            }
        },
        error: function() {
            renderResenas([], productId);
        }
    });
}

/**
 * Renderiza las reseñas del producto
 */
function renderResenas(resenas, productId) {
    var $container = $('#resenas-container');
    if (!$container.length) return;

    var html = '';
    html += '<div class="resenas-list" style="margin-bottom:20px;">';
    
    if (resenas && resenas.length > 0) {
        for (var k = 0; k < resenas.length; k++) {
            var r = resenas[k];
            html += '<div class="resena-item" style="background:var(--bg-card);border:1px solid var(--border-color);border-radius:12px;padding:15px;margin-bottom:12px;">';
            html += '<div style="display:flex;align-items:center;gap:10px;margin-bottom:8px;">';
            html += '<i class="fa-solid fa-user" style="font-size:1.2rem;color:var(--primary-400);"></i>';
            html += '<strong>' + (r.cliente_nombre || 'Cliente') + '</strong>';
            html += '<span style="margin-left:auto;color:var(--secondary-500);">';
            for (var s = 0; s < 5; s++) {
                html += (s < r.calificacion) ? '<i class="fa-solid fa-star"></i>' : '<i class="fa-regular fa-star"></i>';
            }
            html += '</span>';
            html += '</div>';
            html += '<p style="color:var(--text-secondary);font-size:0.9rem;">' + (r.comentario || '') + '</p>';
            html += '<small style="color:var(--text-tertiary);">' + (r.created_at || '') + '</small>';
            html += '</div>';
        }
    } else {
        html += '<p style="color:var(--text-secondary);">No hay reseñas aún. ¡Sé el primero en calificar este producto!</p>';
    }
    html += '</div>';

    // Formulario para dejar reseña (solo visible para usuarios autenticados)
    html += '<div class="resena-form" style="background:var(--bg-card);border:1px solid var(--border-color);border-radius:12px;padding:20px;">';
    html += '<h4 style="margin-bottom:15px;"><i class="fa-solid fa-pen"></i> Deja tu reseña</h4>';
    html += '<form id="form-resena">';
    html += '<input type="hidden" name="producto_id" value="' + productId + '">';
    html += '<input type="hidden" name="action" value="store_resena">';
    html += '<div class="form-group">';
    html += '<label>Calificación</label>';
    html += '<div class="star-rating" style="display:flex;gap:5px;font-size:1.5rem;color:var(--secondary-500);cursor:pointer;">';
    for (var st = 1; st <= 5; st++) {
        html += '<i class="fa-regular fa-star" data-star="' + st + '" onclick="setRating(this, ' + st + ')"></i>';
    }
    html += '</div>';
    html += '<input type="hidden" name="calificacion" id="resena-calificacion" value="0">';
    html += '</div>';
    html += '<div class="form-group">';
    html += '<label>Comentario</label>';
    html += '<textarea name="comentario" class="form-control" rows="3" placeholder="Comparte tu experiencia con este producto..."></textarea>';
    html += '</div>';
    html += '<button type="submit" class="btn-primary" style="width:auto;padding:10px 25px;">';
    html += '<i class="fa-solid fa-paper-plane"></i> Enviar Reseña';
    html += '</button>';
    html += '</form>';
    html += '</div>';

    $container.html(html);

    // Evento submit del formulario de reseña
    $('#form-resena').on('submit', function(e) {
        e.preventDefault();
        var calificacion = $('#resena-calificacion').val();
        if (calificacion === '0') {
            App.notify('Por favor selecciona una calificación', 'warning');
            return;
        }
        
        var formData = $(this).serialize();
        
        App.ajax({
            url: App.baseUrl + 'api/productos.php',
            method: 'POST',
            data: formData,
            success: function(response) {
                if (response.success) {
                    App.notify('Reseña enviada. Gracias por tu opinión!', 'success');
                    $('#form-resena')[0].reset();
                    $('#resena-calificacion').val(0);
                    $('.star-rating i').removeClass('fa-solid').addClass('fa-regular');
                    // Recargar reseñas
                    loadResenas(productId);
                } else {
                    App.notify(response.message || 'Error al enviar la reseña', 'error');
                }
            }
        });
    });
}

/**
 * Establece la calificación en el formulario de reseña
 */
function setRating(element, star) {
    $('#resena-calificacion').val(star);
    $(element).parent().find('i').each(function() {
        var val = parseInt($(this).data('star'));
        if (val <= star) {
            $(this).removeClass('fa-regular').addClass('fa-solid');
        } else {
            $(this).removeClass('fa-solid').addClass('fa-regular');
        }
    });
}

/**
 * Carga productos relacionados (misma categoría)
 */
function loadProductosRelacionados(categoriaId, excludeProductId) {
    if (!categoriaId) return;
    
    App.ajax({
        url: App.baseUrl + 'api/productos.php',
        method: 'GET',
        data: { 
            categoria_id: categoriaId, 
            limit: 4 
        },
        success: function (response) {
            if (response.success && response.data) {
                var relacionados = [];
                if (response.data.productos) {
                    relacionados = response.data.productos.filter(function(p) {
                        return p.id !== excludeProductId;
                    }).slice(0, 4);
                }
                
                var $container = $('#productos-relacionados');
                if (!$container.length) return;
                
                if (relacionados.length > 0) {
                    renderProductsGrid('#productos-relacionados', relacionados);
                } else {
                    $container.html('<p style="color:var(--text-secondary);">No hay productos relacionados disponibles.</p>');
                }
            }
        }
    });
}

function renderDetalleProducto(product) {
    var $container = $('#producto-detalle-container');
    if (!$container.length) return;

    var imgPrincipal = (product.imagenes && product.imagenes.length > 0) 
        ? product.imagenes[0].url 
        : (product.imagen_principal || App.baseUrl + 'public/uploads/productos/placeholder.svg');

    // Imágenes adicionales como thumbnails
    var imagenesHtml = '';
    if (product.imagenes && product.imagenes.length > 1) {
        imagenesHtml = '<div class="producto-thumbnails" style="display:flex;gap:8px;margin-top:10px;">';
        for (var j = 0; j < product.imagenes.length; j++) {
            imagenesHtml += '<img src="' + product.imagenes[j].url + '" alt="' + product.nombre + '" style="width:60px;height:60px;object-fit:cover;border-radius:8px;cursor:pointer;border:2px solid transparent;" onclick="this.parentElement.previousElementSibling.src=this.src">';
        }
        imagenesHtml += '</div>';
    }

    // Precio con oferta
    var precioHtml = '';
    if (product.precio_oferta && product.precio_oferta > 0 && product.precio_oferta < product.precio) {
        precioHtml = '<span class="precio-original" style="text-decoration:line-through;color:var(--text-secondary);font-size:1rem;">' + App.formatCurrency(product.precio) + '</span> ' +
                     '<span class="precio-oferta" style="color:var(--price-color);font-size:1.8rem;font-weight:800;">' + App.formatCurrency(product.precio_oferta) + '</span>';
    } else {
        precioHtml = '<span class="precio-normal" style="font-size:1.8rem;font-weight:800;color:var(--text-primary);">' + App.formatCurrency(product.precio) + '</span>';
    }

    var html = '';
    html += '<div class="producto-imagen">';
    html += '<img src="' + imgPrincipal + '" alt="' + product.nombre + '" id="main-product-image" style="width:100%;max-height:450px;object-fit:contain;border-radius:16px;">';
    html += imagenesHtml;
    html += '</div>';

    html += '<div class="producto-info">';
    html += '<div class="producto-meta">';
    html += '<span class="producto-categoria">' + (product.categoria_nombre || 'General') + '</span>';
    html += '<span class="producto-sku">SKU: ' + product.sku + '</span>';
    html += '</div>';
    html += '<h1>' + product.nombre + '</h1>';
    html += '<div class="producto-vendedor" style="margin:8px 0;color:var(--text-secondary);font-size:0.9rem;">';
    html += '<i class="fa-solid fa-store"></i> Vendido por: <strong>' + (product.vendedor_nombre || product.nombre_tienda || 'MarketZone') + '</strong>';
    html += '</div>';
    html += '<p class="producto-descripcion-corta">' + (product.descripcion_corta || '') + '</p>';
    html += '<div class="producto-precio" style="margin:20px 0;">' + precioHtml + '</div>';
    html += '<div class="producto-stock" style="margin:10px 0;">';
    html += '<span style="color:' + (product.stock > 0 ? 'var(--price-color)' : '#EF4444') + ';">';
    html += (product.stock > 0 ? '<i class="fa-solid fa-check-circle"></i> En stock (' + product.stock + ' disponibles)' : '<i class="fa-solid fa-times-circle"></i> Agotado');
    html += '</span>';
    html += '</div>';

    if (product.descripcion_larga) {
        html += '<div class="producto-descripcion-larga" style="margin-top:20px;padding-top:20px;border-top:1px solid var(--card-border);">';
        html += '<h3>Descripción</h3>';
        html += '<p>' + product.descripcion_larga + '</p>';
        html += '</div>';
    }

    html += '<div class="producto-acciones" style="margin-top:25px;display:flex;gap:15px;flex-wrap:wrap;">';
    html += '<div class="qty-selector" style="display:flex;align-items:center;gap:10px;">';
    html += '<label>Cantidad:</label>';
    html += '<input type="number" id="detalle-cantidad" class="form-control" value="1" min="1" max="' + (product.stock || 1) + '" style="width:80px;text-align:center;">';
    html += '</div>';
    html += '<button class="btn-primary add-to-cart-btn" data-id="' + product.id + '" style="padding:14px 35px;font-size:1rem;">';
    html += '<i class="fa-solid fa-cart-plus"></i> Agregar al Carrito';
    html += '</button>';
    html += '</div>';
    html += '</div>';

    $container.html(html);

    // Mostrar botón contactar vendedor si hay vendedor
    if (product.id_vendedor) {
        $('#contact-vendor-container').show();
        $('#btn-contactar-vendedor').data('vendedor-id', product.id_vendedor);
        $('#btn-contactar-vendedor').data('producto', product.nombre);
    }

    // Agregar al carrito desde detalle con verificación de auth
    $container.find('.add-to-cart-btn').on('click', function () {
        var cantidad = parseInt($('#detalle-cantidad').val()) || 1;
        var productoId = product.id;
        checkAuthBeforeCart(function() {
            addToCart(productoId, cantidad);
        });
    });
}

/**
 * Contacta al vendedor desde la página de detalle de producto
 */
function contactarVendedor(vendedorId, nombreProducto) {
    App.ajax({
        url: App.baseUrl + 'api/mensajeria.php?action=crear',
        method: 'POST',
        data: {
            vendedor_id: vendedorId,
            asunto: 'Consulta sobre: ' + (nombreProducto || 'producto'),
            mensaje: 'Hola, estoy interesado en ' + (nombreProducto || 'tu producto') + '. ¿Podrías darme más información?'
        },
        success: function (response) {
            if (response.success) {
                App.notify('Conversación iniciada. Revisa tu bandeja de mensajes.', 'success');
                window.location.href = App.baseUrl + 'views/mensajeria/chat.php';
            } else {
                App.notify(response.message || 'Error al contactar vendedor', 'error');
            }
        }
    });
}


/* ==========================================================================
   MARKETPLACE AMAZON - LOGICA Y EVENTOS GLOBALES JS (main.js)
   ========================================================================== */

$(document).ready(function () {
    // 1. Verificar estado de autenticación de usuario
    App.ajax({
        url: App.baseUrl + 'api/auth.php',
        method: 'GET',
        success: function (response) {
            if (response.success && response.data.authenticated) {
                const user = response.data.user;
                $('#nav-user-account').html(`<i class="fa-solid fa-user-check"></i> Hola, ${user.nombre}`).attr('href', '#');
            }
        }
    });

    // 2. Cargar contador de carrito en el Header
    App.ajax({
        url: App.baseUrl + 'api/carrito.php',
        method: 'GET',
        success: function (response) {
            if (response.success && response.data) {
                $('#global-cart-badge').text(response.data.total_items || 0);
            }
        }
    });

    // 3. Manejador de búsqueda global
    $('#global-search-btn').on('click', function () {
        const query = $('#global-search-input').val().trim();
        if (query.length > 0) {
            if (typeof loadProducts === 'function') {
                loadProducts(1, query);
            } else {
                console.log('Buscando productos:', query);
            }
        }
    });

    $('#global-search-input').on('keypress', function (e) {
        if (e.which === 13) {
            $('#global-search-btn').click();
        }
    });
});

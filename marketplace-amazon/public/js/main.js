/* ==========================================================================
   MARKETPLACE AMAZON - LOGICA Y EVENTOS GLOBALES JS (main.js)
   ========================================================================== */

$(document).ready(function () {
    // 1. Verificar estado de autenticación de usuario y rol
    App.ajax({
        url: App.baseUrl + 'api/auth.php',
        method: 'GET',
        success: function (response) {
            if (response.success && response.data.authenticated) {
                const user = response.data.user;
                const roleName = (user.rol_nombre || '').toLowerCase();
                
                // Ocultar botón de login, mostrar logout
                $('#nav-user-account').hide();
                $('#btn-logout').show();
                
                // Mostrar SOLO el menú del rol correspondiente (sin solapamiento)
                if (roleName === 'administrador' || roleName === 'admin') {
                    $('#admin-menu').show();
                    // Admin NO ve menú de vendedor ni cliente
                } else if (roleName === 'vendedor' || roleName === 'seller') {
                    $('#seller-menu').show();
                } else {
                    // Cliente regular
                    $('#client-menu').show();
                }
            } else {
                // No autenticado - mostrar login
                $('#nav-user-account').show();
                $('#btn-logout').hide();
                $('#admin-menu').hide();
                $('#seller-menu').hide();
                $('#client-menu').hide();
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

    // 3. Manejador de búsqueda global - Redirige al catálogo
    $('#global-search-btn').on('click', function () {
        const query = $('#global-search-input').val().trim();
        if (query.length > 0) {
            window.location.href = App.baseUrl + 'views/productos/catalogo.php?search=' + encodeURIComponent(query);
        }
    });

    $('#global-search-input').on('keypress', function (e) {
        if (e.which === 13) {
            $('#global-search-btn').click();
        }
    });

    // 4. Cerrar sesión
    $('#btn-logout').on('click', function (e) {
        e.preventDefault();
        if (confirm('¿Cerrar sesión?')) {
            App.ajax({
                url: App.baseUrl + 'api/auth.php?action=logout',
                method: 'POST',
                success: function (response) {
                    if (response.success) {
                        App.notify('Sesión cerrada correctamente', 'info');
                        setTimeout(function () {
                            window.location.href = App.baseUrl;
                        }, 1000);
                    }
                }
            });
        }
    });

    // 5. Abrir carrito - Redirige a la página de carrito
    $('#open-cart-btn').on('click', function (e) {
        e.preventDefault();
        window.location.href = App.baseUrl + 'views/carrito/index.php';
    });

    // 6. Dropdown toggle con click - se mantiene abierto hasta nuevo click o click fuera
    $('.dropdown-trigger').on('click', function (e) {
        e.preventDefault();
        e.stopPropagation();
        const $dropdown = $(this).closest('.nav-dropdown');
        // Cerrar los otros dropdowns
        $('.nav-dropdown').not($dropdown).removeClass('open');
        // Toggle este
        $dropdown.toggleClass('open');
    });

    // Cerrar dropdowns al hacer click fuera
    $(document).on('click', function (e) {
        if (!$(e.target).closest('.nav-dropdown').length) {
            $('.nav-dropdown').removeClass('open');
        }
    });

    // No cerrar al hacer click dentro del contenido del dropdown
    $('.nav-dropdown .dropdown-content').on('click', function (e) {
        e.stopPropagation();
    });
});

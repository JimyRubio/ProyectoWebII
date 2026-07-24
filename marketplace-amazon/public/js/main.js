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

    // 7. Theme Toggle (Dark/Light Mode)
    const themeToggleBtn = document.getElementById('theme-toggle-btn');
    
    if (themeToggleBtn) {
        // Load saved theme from localStorage
        const savedTheme = localStorage.getItem('marketzone-theme');
        const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
        
        // Set initial theme
        if (savedTheme === 'light') {
            document.documentElement.setAttribute('data-theme', 'light');
            themeToggleBtn.querySelector('i').className = 'fa-solid fa-sun';
        } else if (savedTheme === 'dark' || (!savedTheme && prefersDark)) {
            document.documentElement.setAttribute('data-theme', 'dark');
            themeToggleBtn.querySelector('i').className = 'fa-solid fa-moon';
        } else {
            document.documentElement.setAttribute('data-theme', 'dark');
            themeToggleBtn.querySelector('i').className = 'fa-solid fa-moon';
        }
        
        // Toggle theme on click
        themeToggleBtn.addEventListener('click', function() {
            const currentTheme = document.documentElement.getAttribute('data-theme');
            const icon = this.querySelector('i');
            
            if (currentTheme === 'dark') {
                document.documentElement.setAttribute('data-theme', 'light');
                icon.className = 'fa-solid fa-sun';
                localStorage.setItem('marketzone-theme', 'light');
            } else {
                document.documentElement.setAttribute('data-theme', 'dark');
                icon.className = 'fa-solid fa-moon';
                localStorage.setItem('marketzone-theme', 'dark');
            }
            
            // Add rotation animation feedback
            this.style.transform = 'rotate(360deg)';
            setTimeout(() => {
                this.style.transform = '';
            }, 300);
        });
    }

    // 8. Reveal animations on scroll (using Intersection Observer)
    if ('IntersectionObserver' in window) {
        const revealElements = document.querySelectorAll('.reveal');
        
        const revealObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                    revealObserver.unobserve(entry.target);
                }
            });
        }, {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        });
        
        revealElements.forEach(el => revealObserver.observe(el));
    }

    // 9. Ripple effect on buttons
    document.querySelectorAll('.btn-primary, .btn-danger').forEach(btn => {
        btn.addEventListener('click', function(e) {
            const rect = this.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;
            
            const ripple = document.createElement('span');
            ripple.className = 'ripple';
            ripple.style.left = x + 'px';
            ripple.style.top = y + 'px';
            
            this.appendChild(ripple);
            
            setTimeout(() => {
                ripple.remove();
            }, 600);
        });
    });
});

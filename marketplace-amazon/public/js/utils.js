/* ==========================================================================
   MARKETPLACE AMAZON - UTILIDADES GLOBALES AJAX Y JS (utils.js)
   ========================================================================== */

const App = {
    baseUrl: (typeof BASE_URL !== 'undefined') ? BASE_URL : window.location.protocol + '//' + window.location.hostname + (window.location.port ? ':' + window.location.port : '') + '/',

    /**
     * Obtiene el Token CSRF activo desde la etiqueta META
     */
    getCsrfToken: function () {
        const meta = document.querySelector('meta[name="csrf-token"]');
        return meta ? meta.getAttribute('content') : '';
    },

    /**
     * Envoltorio global de jQuery AJAX con inyección automática de CSRF y formato JSON
     */
    ajax: function (options) {
        const defaults = {
            dataType: 'json',
            headers: {
                'X-CSRF-TOKEN': App.getCsrfToken()
            },
            error: function (xhr, status, error) {
                console.error('AJAX Error:', error, xhr.responseJSON);
                const message = (xhr.responseJSON && xhr.responseJSON.message) 
                    ? xhr.responseJSON.message 
                    : 'Error al procesar la solicitud en el servidor.';
                App.notify(message, 'error');
            }
        };

        const settings = $.extend(true, {}, defaults, options);
        return $.ajax(settings);
    },

    /**
     * Formatea valores numéricos a formato de moneda (L. 1,234.56)
     */
    formatCurrency: function (amount) {
        const num = parseFloat(amount) || 0;
        const formatted = num.toLocaleString('es-HN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        return 'L. ' + formatted;
    },

    /**
     * Muestra alertas o notificaciones emergentes sencillas
     */
    notify: function (message, type = 'info') {
        const bgColors = {
            success: '#10B981',
            error: '#EF4444',
            warning: '#F59E0B',
            info: '#3B82F6'
        };

        const toast = document.createElement('div');
        toast.className = 'app-toast-notification';
        toast.style.cssText = `
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: ${bgColors[type] || bgColors.info};
            color: #ffffff;
            padding: 12px 20px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            font-family: 'Poppins', sans-serif;
            font-size: 14px;
            z-index: 9999;
            transition: all 0.3s ease;
        `;
        toast.innerHTML = `<i class="fa-solid fa-circle-info"></i> ${message}`;
        document.body.appendChild(toast);

        setTimeout(() => {
            toast.style.opacity = '0';
            setTimeout(() => toast.remove(), 300);
        }, 3500);
    },

    /**
     * Genera controles de paginación dinámicos sin recargar página
     */
    renderPagination: function (containerSelector, pagination, onPageChange) {
        const $container = $(containerSelector);
        if (!$container.length || pagination.total_pages <= 1) {
            $container.empty();
            return;
        }

        let html = '<div class="pagination-wrapper" style="display: flex; gap: 8px; justify-content: center; margin-top: 20px;">';
        
        // Botón Anterior
        html += `<button class="page-btn ${pagination.current_page === 1 ? 'disabled' : ''}" data-page="${pagination.current_page - 1}">Anterior</button>`;

        for (let i = 1; i <= pagination.total_pages; i++) {
            html += `<button class="page-btn ${i === pagination.current_page ? 'active' : ''}" data-page="${i}">${i}</button>`;
        }

        // Botón Siguiente
        html += `<button class="page-btn ${pagination.current_page === pagination.total_pages ? 'disabled' : ''}" data-page="${pagination.current_page + 1}">Siguiente</button>`;
        html += '</div>';

        $container.html(html);

        $container.find('.page-btn:not(.disabled)').on('click', function () {
            const selectedPage = parseInt($(this).data('page'));
            if (typeof onPageChange === 'function') {
                onPageChange(selectedPage);
            }
        });
    }
};

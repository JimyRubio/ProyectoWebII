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
                console.error('AJAX Error:', error, xhr.responseText);
                let message = 'Error al procesar la solicitud en el servidor.';
                try {
                    if (xhr.responseJSON && xhr.responseJSON.message) {
                        message = xhr.responseJSON.message;
                    } else {
                        // Try to parse responseText if responseJSON is not available
                        const parsed = JSON.parse(xhr.responseText);
                        if (parsed.message) message = parsed.message;
                    }
                } catch (e) {
                    // If HTML was returned (PHP error), show generic message and log details
                    console.error('Respuesta no-JSON recibida (posible error PHP):', xhr.responseText.substring(0, 300));
                    message = 'Error interno del servidor. Ver consola para más detalles.';
                }
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
     * Escapa caracteres HTML para prevenir XSS
     */
    escapeHtml: function (text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    },

    /**
     * Modal de confirmación profesional con animaciones
     * Reemplaza el confirm() nativo. Retorna una Promise<boolean>.
     * @param {string} message - Mensaje a mostrar
     * @param {object} options - Opciones { type: 'danger'|'warning'|'info', confirmText, cancelText, title }
     * @returns {Promise<boolean>}
     */
    confirm: function (message, options = {}) {
        return new Promise((resolve) => {
            const type = options.type || 'danger';
            const confirmText = options.confirmText || 'Confirmar';
            const cancelText = options.cancelText || 'Cancelar';
            const title = options.title || '¿Estás seguro?';

            // Config por tipo
            const configs = {
                danger: {
                    icon: 'fa-solid fa-triangle-exclamation',
                    color: '#F43F5E',
                    gradient: 'linear-gradient(135deg, #F43F5E 0%, #E11D48 100%)',
                    glow: '0 0 20px rgba(244,63,94,0.3)'
                },
                warning: {
                    icon: 'fa-solid fa-circle-exclamation',
                    color: '#F59E0B',
                    gradient: 'linear-gradient(135deg, #F59E0B 0%, #D97706 100%)',
                    glow: '0 0 20px rgba(245,158,11,0.3)'
                },
                info: {
                    icon: 'fa-solid fa-circle-question',
                    color: '#3B82F6',
                    gradient: 'linear-gradient(135deg, #3B82F6 0%, #2563EB 100%)',
                    glow: '0 0 20px rgba(59,130,246,0.3)'
                }
            };
            const cfg = configs[type] || configs.danger;

            // Crear elementos del modal
            const overlay = document.createElement('div');
            overlay.className = 'confirm-overlay';
            overlay.style.cssText = `
                position: fixed; inset: 0; z-index: 9999;
                background: rgba(0,0,0,0.65);
                backdrop-filter: blur(8px);
                -webkit-backdrop-filter: blur(8px);
                display: flex; align-items: center; justify-content: center;
                animation: fadeIn 0.25s ease-out;
                padding: 20px;
            `;

            const card = document.createElement('div');
            card.className = 'confirm-card';
            card.style.cssText = `
                background: var(--bg-card, rgba(30,41,59,0.95));
                backdrop-filter: blur(20px);
                -webkit-backdrop-filter: blur(20px);
                border: 1px solid var(--border-color, rgba(255,255,255,0.08));
                border-radius: 20px;
                padding: 36px 32px 28px;
                max-width: 420px;
                width: 100%;
                text-align: center;
                animation: bounceIn 0.45s cubic-bezier(0.34,1.56,0.64,1) forwards;
                box-shadow: 0 25px 60px rgba(0,0,0,0.4);
                position: relative;
                overflow: hidden;
            `;

            // Barra superior de color
            const topBar = document.createElement('div');
            topBar.style.cssText = `
                position: absolute; top: 0; left: 0; right: 0; height: 4px;
                background: ${cfg.gradient};
            `;

            // Icono animado
            const iconWrapper = document.createElement('div');
            iconWrapper.style.cssText = `
                width: 72px; height: 72px; margin: 0 auto 18px;
                display: flex; align-items: center; justify-content: center;
                border-radius: 50%;
                background: ${type === 'danger' ? 'rgba(244,63,94,0.12)' : type === 'warning' ? 'rgba(245,158,11,0.12)' : 'rgba(59,130,246,0.12)'};
                animation: float 2.5s ease-in-out infinite;
            `;
            const icon = document.createElement('i');
            icon.className = cfg.icon;
            icon.style.cssText = `font-size: 2.2rem; color: ${cfg.color};`;
            iconWrapper.appendChild(icon);

            // Título
            const titleEl = document.createElement('h3');
            titleEl.textContent = title;
            titleEl.style.cssText = `
                font-size: 1.25rem; font-weight: 700; margin-bottom: 10px;
                color: var(--text-primary, #F1F5F9);
                font-family: var(--font-sans, 'Poppins', sans-serif);
            `;

            // Mensaje
            const msgEl = document.createElement('p');
            msgEl.textContent = message;
            msgEl.style.cssText = `
                font-size: 0.95rem; color: var(--text-secondary, #94A3B8);
                margin-bottom: 28px; line-height: 1.6;
                font-family: var(--font-sans, 'Poppins', sans-serif);
            `;

            // Contenedor de botones
            const btnGroup = document.createElement('div');
            btnGroup.style.cssText = `
                display: flex; gap: 12px; justify-content: center;
            `;

            // Botón Cancelar
            const cancelBtn = document.createElement('button');
            cancelBtn.textContent = cancelText;
            cancelBtn.style.cssText = `
                flex: 1; padding: 12px 16px; border-radius: 10px;
                border: 1px solid var(--border-color, rgba(255,255,255,0.08));
                background: var(--bg-input, rgba(255,255,255,0.06));
                color: var(--text-primary, #F1F5F9);
                font-size: 0.9rem; font-weight: 600; cursor: pointer;
                font-family: var(--font-sans, 'Poppins', sans-serif);
                transition: all 0.2s ease;
            `;
            cancelBtn.onmouseenter = () => {
                cancelBtn.style.background = 'var(--bg-input-focus, rgba(255,255,255,0.09))';
                cancelBtn.style.transform = 'translateY(-1px)';
            };
            cancelBtn.onmouseleave = () => {
                cancelBtn.style.background = 'var(--bg-input, rgba(255,255,255,0.06))';
                cancelBtn.style.transform = '';
            };

            // Botón Confirmar
            const confirmBtn = document.createElement('button');
            confirmBtn.textContent = confirmText;
            confirmBtn.style.cssText = `
                flex: 1; padding: 12px 16px; border-radius: 10px;
                border: none; background: ${cfg.gradient};
                color: #FFFFFF; font-size: 0.9rem; font-weight: 600; cursor: pointer;
                font-family: var(--font-sans, 'Poppins', sans-serif);
                box-shadow: ${cfg.glow};
                transition: all 0.2s ease;
            `;
            confirmBtn.onmouseenter = () => {
                confirmBtn.style.transform = 'translateY(-2px)';
                confirmBtn.style.boxShadow = `${cfg.glow}, 0 8px 25px rgba(0,0,0,0.3)`;
            };
            confirmBtn.onmouseleave = () => {
                confirmBtn.style.transform = '';
                confirmBtn.style.boxShadow = cfg.glow;
            };

            btnGroup.appendChild(cancelBtn);
            btnGroup.appendChild(confirmBtn);

            // Ensamblar
            card.appendChild(topBar);
            card.appendChild(iconWrapper);
            card.appendChild(titleEl);
            card.appendChild(msgEl);
            card.appendChild(btnGroup);
            overlay.appendChild(card);
            document.body.appendChild(overlay);

            // Función de cierre
            const close = (result) => {
                card.style.animation = 'scaleIn 0.2s ease-out reverse';
                overlay.style.animation = 'fadeIn 0.2s ease-out reverse';
                setTimeout(() => {
                    overlay.remove();
                    resolve(result);
                }, 200);
            };

            // Event listeners
            confirmBtn.onclick = () => close(true);
            cancelBtn.onclick = () => close(false);
            overlay.onclick = (e) => { if (e.target === overlay) close(false); };
            document.addEventListener('keydown', function handler(e) {
                if (e.key === 'Escape') {
                    document.removeEventListener('keydown', handler);
                    close(false);
                }
            });

            // Focus en botón Cancelar por defecto (seguridad)
            cancelBtn.focus();
        });
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

/* ==========================================================================
   GLOBAL CUSTOM SELECT (Dropdown Personalizado)
   Convierte automáticamente todos los <select> con clase .form-select o
   dentro de .catalogo-filters en un dropdown personalizado. Esto garantiza
   que el panel desplegado use el color de fondo del tema (oscuro en modo
   oscuro, claro en modo claro) en cualquier navegador.
   ========================================================================== */
$(function () {
    function initCustomSelect($select) {
        if ($select.data('custom-select-initialized')) return;
        $select.data('custom-select-initialized', true);

        // Obtener el/los textos de las opciones
        const options = $select.find('option').map(function () {
            return { value: this.value, text: $(this).text() };
        }).get();

        const selectedValue = $select.val();
        const selectedText = $select.find('option:selected').text();

        // Construir el wrapper del dropdown personalizado
        const $wrapper = $('<div class="custom-select"></div>');

        // Trigger
        const $trigger = $(
            '<button type="button" class="custom-select-trigger">' +
                '<span class="custom-select-selected"></span>' +
                '<span class="custom-select-arrow"><i class="fa-solid fa-chevron-down"></i></span>' +
            '</button>'
        );
        $trigger.find('.custom-select-selected').text(selectedText);
        $wrapper.append($trigger);

        // Panel con opciones
        const $panel = $('<div class="custom-select-panel"></div>');
        options.forEach(function (opt, idx) {
            const $opt = $(
                '<div class="custom-select-option' + (opt.value === selectedValue ? ' selected' : '') + '" data-value="' + opt.value + '" data-index="' + idx + '">' + opt.text + '</div>'
            );
            $panel.append($opt);
        });
        $wrapper.append($panel);

        // Mover el select nativo dentro del wrapper (oculto) para mantener el valor
        $select.detach().appendTo($wrapper).attr('tabindex', '-1');

        // Insertar el wrapper en lugar del select
        $select.after($wrapper);
        $wrapper.prepend($select);

        // Eventos
        $trigger.on('click', function (e) {
            e.stopPropagation();
            const $open = $wrapper.hasClass('open');
            $('.custom-select').removeClass('open');
            if (!$open) $wrapper.addClass('open');
        });

        $wrapper.find('.custom-select-option').on('click', function () {
            const val = $(this).data('value');
            const text = $(this).text();
            $select.val(val).trigger('change');
            $trigger.find('.custom-select-selected').text(text);
            $wrapper.find('.custom-select-option').removeClass('selected');
            $(this).addClass('selected');
            $wrapper.removeClass('open');
        });

        // Sincronizar si el valor cambia programáticamente
        $select.on('change', function () {
            const v = $(this).val();
            const text = $(this).find('option:selected').text();
            $trigger.find('.custom-select-selected').text(text);
            $wrapper.find('.custom-select-option').removeClass('selected');
            $wrapper.find('.custom-select-option[data-value="' + v + '"]').addClass('selected');
        });
    }

    // Cerrar todos los dropdowns al hacer click fuera
    $(document).on('click', function (e) {
        if (!$(e.target).closest('.custom-select').length) {
            $('.custom-select').removeClass('open');
        }
    });

    // Inicializar selects existentes en el DOM al cargar
    function initAllCustomSelects() {
        $('.form-select, .catalogo-filters select').each(function () {
            initCustomSelect($(this));
        });
    }

    initAllCustomSelects();

    // Re-inicializar cuando se renderice contenido dinámico (AJAX)
    $(document).on('ajaxComplete', function () {
        initAllCustomSelects();
    });
});

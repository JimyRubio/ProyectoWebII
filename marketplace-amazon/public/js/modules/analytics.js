/* ==========================================================================
   MARKETPLACE AMAZON - MÓDULO JS DE ANALYTICS (analytics.js)
   ========================================================================== */

document.addEventListener('DOMContentLoaded', function () {
    // Configuración global de fuentes y colores en Chart.js para acoplar con analytics.css
    if (typeof Chart !== 'undefined') {
        Chart.defaults.font.family = "'Poppins', sans-serif";
        Chart.defaults.color = "#9CA3AF";
    }

    let salesChart = null;
    let categoryChart = null;

    // Inicializar Gráficas
    initSalesTrendsChart();
    initCategoryChart();
    initFilterHandlers();
});

/**
 * Gráfica de Tendencia de Ventas (Line Chart)
 */
function initSalesTrendsChart() {
    const canvas = document.getElementById('salesTrendsChart');
    if (!canvas) return;

    const ctxSales = canvas.getContext('2d');
    const salesGradient = ctxSales.createLinearGradient(0, 0, 0, 300);
    salesGradient.addColorStop(0, 'rgba(255, 153, 0, 0.4)');
    salesGradient.addColorStop(1, 'rgba(255, 153, 0, 0.0)');

    salesChart = new Chart(ctxSales, {
        type: 'line',
        data: {
            labels: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'],
            datasets: [
                {
                    label: 'Ventas Totales ($)',
                    data: [12400, 18500, 14200, 22100, 28900, 34500, 31200],
                    borderColor: '#FF9900',
                    backgroundColor: salesGradient,
                    fill: true,
                    tension: 0.4,
                    borderWidth: 3,
                    pointBackgroundColor: '#FF9900',
                    pointRadius: 4
                },
                {
                    label: 'Comisiones ($)',
                    data: [1240, 1850, 1420, 2210, 2890, 3450, 3120],
                    borderColor: '#3B82F6',
                    borderDash: [5, 5],
                    fill: false,
                    tension: 0.4,
                    borderWidth: 2,
                    pointBackgroundColor: '#3B82F6',
                    pointRadius: 3
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }
            },
            scales: {
                x: {
                    grid: { color: 'rgba(255, 255, 255, 0.05)' }
                },
                y: {
                    grid: { color: 'rgba(255, 255, 255, 0.05)' },
                    ticks: {
                        callback: function (value) { return '$' + value.toLocaleString(); }
                    }
                }
            }
        }
    });
}

/**
 * Gráfica de Distribución por Categoría (Doughnut Chart)
 */
function initCategoryChart() {
    const canvas = document.getElementById('categoryDistributionChart');
    if (!canvas) return;

    const ctxCat = canvas.getContext('2d');
    categoryChart = new Chart(ctxCat, {
        type: 'doughnut',
        data: {
            labels: ['Electrónica', 'Ropa y Moda', 'Hogar y Cocina', 'Deportes', 'Juegos'],
            datasets: [{
                data: [42, 22, 16, 12, 8],
                backgroundColor: [
                    '#FF9900',
                    '#3B82F6',
                    '#10B981',
                    '#8B5CF6',
                    '#06B6D4'
                ],
                borderWidth: 0,
                hoverOffset: 8
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: { boxWidth: 12, padding: 16 }
                }
            },
            cutout: '70%'
        }
    });
}

/**
 * Manejadores de Eventos y Filtros AJAX
 */
function initFilterHandlers() {
    // Cambio de período
    const periodSelect = document.getElementById('analytics-period-select');
    if (periodSelect) {
        periodSelect.addEventListener('change', function () {
            const selectedPeriod = this.value;
            console.log('Filtrando analytics por período:', selectedPeriod);
            // Aquí se realiza la llamada AJAX para actualizar el dashboard sin recargar la página
        });
    }

    // Tabs de vistas (General, Ventas, Vendedores, Productos)
    const filterTabs = document.querySelectorAll('.filter-tab-btn');
    filterTabs.forEach(tab => {
        tab.addEventListener('click', function () {
            filterTabs.forEach(t => t.classList.remove('active'));
            this.classList.add('active');
            const viewType = this.getAttribute('data-view');
            console.log('Cambiando vista de analytics a:', viewType);
        });
    });
}

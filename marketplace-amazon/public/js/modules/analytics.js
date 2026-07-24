/* ==========================================================================
   MARKETPLACE AMAZON - MÓDULO JS DE ANALYTICS (analytics.js)
   ========================================================================== */

let salesChart = null;
let categoryChart = null;

$(document).ready(function () {
    if (typeof Chart !== 'undefined') {
        Chart.defaults.font.family = "'Poppins', sans-serif";
        Chart.defaults.color = "#9CA3AF";
    }

    loadDashboardAnalytics('7days');
    initFilterHandlers();
});

/**
 * Carga los datos del Dashboard dinámicamente vía AJAX desde la API backend
 */
function loadDashboardAnalytics(period) {
    App.ajax({
        url: App.baseUrl + 'api/analytics.php',
        method: 'GET',
        data: { period: period },
        success: function (response) {
            if (response.success && response.data) {
                const data = response.data;
                updateKPICards(data.kpis);
                renderSalesTrendsChart(data.sales_chart);
                renderCategoryChart(data.category_chart);
                renderTopProductsTable(data.top_products);
                renderActivityFeed(data.activity);
            }
        }
    });
}

function updateKPICards(kpis) {
    if (!kpis) return;
    $('#kpi-total-sales').text(App.formatCurrency(kpis.total_sales));
    $('#kpi-total-orders').text(kpis.total_orders.toLocaleString());
    $('#kpi-active-vendors').text(kpis.active_vendors.toLocaleString());
    $('#kpi-conversion-rate').text(kpis.conversion_rate + '%');
}

function renderSalesTrendsChart(chartData) {
    const canvas = document.getElementById('salesTrendsChart');
    if (!canvas) return;

    const ctxSales = canvas.getContext('2d');

    if (salesChart) {
        salesChart.destroy();
    }

    const salesGradient = ctxSales.createLinearGradient(0, 0, 0, 300);
    salesGradient.addColorStop(0, 'rgba(255, 153, 0, 0.4)');
    salesGradient.addColorStop(1, 'rgba(255, 153, 0, 0.0)');

    salesChart = new Chart(ctxSales, {
        type: 'line',
        data: {
            labels: chartData.labels,
            datasets: [
                {
                    label: 'Ventas Totales ($)',
                    data: chartData.sales,
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
                    data: chartData.commissions,
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
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { color: 'rgba(255, 255, 255, 0.05)' } },
                y: {
                    grid: { color: 'rgba(255, 255, 255, 0.05)' },
                    ticks: { callback: function (val) { return '$' + val.toLocaleString(); } }
                }
            }
        }
    });
}

function renderCategoryChart(chartData) {
    const canvas = document.getElementById('categoryDistributionChart');
    if (!canvas) return;

    const ctxCat = canvas.getContext('2d');

    if (categoryChart) {
        categoryChart.destroy();
    }

    categoryChart = new Chart(ctxCat, {
        type: 'doughnut',
        data: {
            labels: chartData.labels,
            datasets: [{
                data: chartData.data,
                backgroundColor: ['#FF9900', '#3B82F6', '#10B981', '#8B5CF6', '#06B6D4'],
                borderWidth: 0,
                hoverOffset: 8
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'bottom', labels: { boxWidth: 12, padding: 16 } }
            },
            cutout: '70%'
        }
    });
}

function renderTopProductsTable(products) {
    const $tbody = $('.analytics-table tbody');
    if (!$tbody.length || !products) return;

    let html = '';
    const badgeClasses = ['gold', 'silver', 'bronze', 'default', 'default'];

    products.forEach((p, idx) => {
        const rankClass = badgeClasses[idx] || 'default';
        html += `
            <tr>
                <td><span class="rank-badge ${rankClass}">${idx + 1}</span></td>
                <td>
                    <div class="table-entity-cell">
                        <div class="table-entity-info">
                            <span class="title">${p.nombre}</span>
                            <span class="subtitle">SKU: ${p.sku}</span>
                        </div>
                    </div>
                </td>
                <td>${p.nombre_tienda || 'Tienda Oficial'}</td>
                <td>${p.unidades}</td>
                <td><strong>${App.formatCurrency(p.total_generado)}</strong></td>
            </tr>
        `;
    });

    $tbody.html(html);
}

function renderActivityFeed(activities) {
    const $feed = $('.activity-list');
    if (!$feed.length || !activities) return;

    let html = '';
    activities.forEach(act => {
        const iconClass = act.tipo === 'sale' ? 'cart-shopping' : (act.tipo === 'user' ? 'store' : 'hand-holding-dollar');
        html += `
            <div class="activity-item">
                <div class="activity-icon ${act.tipo}"><i class="fa-solid fa-${iconClass}"></i></div>
                <div class="activity-details">
                    <div class="activity-text">${act.text}</div>
                    <div class="activity-time">${act.time}</div>
                </div>
            </div>
        `;
    });
    $feed.html(html);
}

function initFilterHandlers() {
    $('#analytics-period-select').on('change', function () {
        const period = $(this).val();
        loadDashboardAnalytics(period);
    });

    $('.filter-tab-btn').on('click', function () {
        $('.filter-tab-btn').removeClass('active');
        $(this).addClass('active');
        const view = $(this).data('view');
        console.log('Vista seleccionada:', view);
    });
}

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

    salesChart = new Chart(ctxSales, {
        type: 'bar',
        data: {
            labels: chartData.labels,
            datasets: [
                {
                    label: 'Órdenes Procesadas',
                    data: chartData.order_count,
                    backgroundColor: 'rgba(59, 130, 246, 0.8)',
                    borderColor: '#3B82F6',
                    borderWidth: 1,
                    borderRadius: 4,
                    barPercentage: 0.6,
                    order: 2,
                    yAxisID: 'y'
                },
                {
                    label: 'Ticket Promedio ($)',
                    type: 'line',
                    data: chartData.avg_order_value,
                    borderColor: '#10B981',
                    backgroundColor: 'rgba(16, 185, 129, 0.1)',
                    fill: true,
                    tension: 0.4,
                    borderWidth: 3,
                    pointBackgroundColor: '#10B981',
                    pointRadius: 5,
                    pointHoverRadius: 7,
                    order: 1,
                    yAxisID: 'y1'
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            interaction: {
                mode: 'index',
                intersect: false
            },
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: '#1F2937',
                    titleColor: '#F9FAFB',
                    bodyColor: '#D1D5DB',
                    borderColor: '#374151',
                    borderWidth: 1,
                    callbacks: {
                        label: function(context) {
                            if (context.dataset.label === 'Órdenes Procesadas') {
                                return context.dataset.label + ': ' + context.parsed.y.toLocaleString();
                            } else {
                                return context.dataset.label + ': $' + context.parsed.y.toLocaleString();
                            }
                        }
                    }
                }
            },
            scales: {
                x: {
                    grid: { color: 'rgba(255, 255, 255, 0.05)' },
                    ticks: { color: '#9CA3AF' }
                },
                y: {
                    position: 'left',
                    grid: { color: 'rgba(255, 255, 255, 0.05)' },
                    ticks: {
                        color: '#3B82F6',
                        callback: function(val) { return val.toLocaleString(); }
                    },
                    title: {
                        display: true,
                        text: 'Órdenes',
                        color: '#3B82F6'
                    }
                },
                y1: {
                    position: 'right',
                    grid: { drawOnChartArea: false },
                    ticks: {
                        color: '#10B981',
                        callback: function(val) { return '$' + val.toLocaleString(); }
                    },
                    title: {
                        display: true,
                        text: 'Ticket Promedio',
                        color: '#10B981'
                    }
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
        
        // Mostrar/ocultar secciones según la vista seleccionada
        if (view === 'all') {
            // Mostrar todo
            $('.kpi-grid, .analytics-grid').show();
            $('.kpi-card').show();
        } else if (view === 'sales') {
            // Mostrar KPI de ventas/pedidos + gráficas de ventas
            $('.kpi-card').hide();
            $('.kpi-card.amber, .kpi-card.indigo').show();
            $('.analytics-grid').show();
        } else if (view === 'vendors') {
            // Mostrar solo KPI de vendedores + feed de actividad
            $('.kpi-card').hide();
            $('.kpi-card.purple').show();
            $('.analytics-grid').hide();
            $('.analytics-grid').first().hide();
            $('.analytics-grid').last().show();
        } else if (view === 'products') {
            // Mostrar solo la tabla de productos top
            $('.kpi-card').hide();
            $('.analytics-grid').hide();
            $('.analytics-grid').last().show();
        }
    });

    // Botón de exportar CSV
    $('#btn-export-csv').on('click', function() {
        exportTableToCSV('analytics-report.csv');
    });
}

function exportTableToCSV(filename) {
    const rows = document.querySelectorAll('.analytics-table tr');
    if (!rows.length) {
        App.notify('No hay datos para exportar', 'warning');
        return;
    }
    
    let csv = [];
    for (let i = 0; i < rows.length; i++) {
        const cols = rows[i].querySelectorAll('td, th');
        const row = [];
        for (let j = 0; j < cols.length; j++) {
            let data = cols[j].innerText.replace(/,/g, '').replace(/\n/g, ' ');
            row.push('"' + data + '"');
        }
        csv.push(row.join(','));
    }
    
    const csvContent = csv.join('\n');
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    const url = URL.createObjectURL(blob);
    link.setAttribute('href', url);
    link.setAttribute('download', filename || 'export.csv');
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(url);
    
    App.notify('CSV exportado correctamente', 'success');
}

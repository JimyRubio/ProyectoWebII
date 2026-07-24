<?php 
$page_title = "Analytics & Dashboard - Marketplace Amazon";
$module_css = "analytics.css";
$module_js = "analytics.js";
require_once __DIR__ . '/../layouts/header.php'; 
?>

<!-- Encabezado del Módulo Analytics -->
<div class="analytics-header-wrapper">
    <div class="analytics-title-group">
        <h1>
            <i class="fa-solid fa-chart-line"></i> Dashboard de Analytics 
            <span class="live-indicator">
                <span class="pulse-dot"></span> En Vivo
            </span>
        </h1>
        <p>Monitoreo en tiempo real de ventas, vendedores, conversión e inventario del Marketplace.</p>
    </div>

    <!-- Barra de Herramientas y Filtros -->
    <div class="analytics-toolbar">
        <div class="date-range-picker">
            <i class="fa-regular fa-calendar-days"></i>
            <select id="analytics-period-select">
                <option value="today">Hoy</option>
                <option value="7days" selected>Últimos 7 días</option>
                <option value="30days">Últimos 30 días</option>
                <option value="this_month">Este mes</option>
                <option value="custom">Rango personalizado</option>
            </select>
        </div>

        <div class="filter-tabs">
            <button class="filter-tab-btn active" data-view="all">General</button>
            <button class="filter-tab-btn" data-view="sales">Ventas</button>
            <button class="filter-tab-btn" data-view="vendors">Vendedores</button>
            <button class="filter-tab-btn" data-view="products">Productos</button>
        </div>

        <div class="export-btn-group">
            <button class="btn-analytics-action pdf-export" onclick="window.print();" title="Exportar a PDF / Imprimir">
                <i class="fa-solid fa-file-pdf"></i> PDF
            </button>
            <button class="btn-analytics-action excel-export" id="btn-export-csv" title="Exportar datos a CSV/Excel">
                <i class="fa-solid fa-file-excel"></i> CSV
            </button>
        </div>
    </div>
</div>

<!-- Grid de Tarjetas KPI Summary -->
<div class="kpi-grid">
    <!-- KPI 1: Ventas Totales -->
    <div class="kpi-card amber">
        <div class="kpi-top-row">
            <span class="kpi-title">Ventas Totales</span>
            <div class="kpi-icon-box">
                <i class="fa-solid fa-sack-dollar"></i>
            </div>
        </div>
        <div class="kpi-value-container">
            <span class="kpi-value" id="kpi-total-sales">$124,580.00</span>
        </div>
        <div class="kpi-footer">
            <span class="trend-badge up">
                <i class="fa-solid fa-arrow-trend-up"></i> +14.2%
            </span>
            <span class="kpi-comparison-text">vs. periodo anterior</span>
        </div>
    </div>

    <!-- KPI 2: Pedidos Procesados -->
    <div class="kpi-card blue">
        <div class="kpi-top-row">
            <span class="kpi-title">Pedidos Totales</span>
            <div class="kpi-icon-box">
                <i class="fa-solid fa-box-open"></i>
            </div>
        </div>
        <div class="kpi-value-container">
            <span class="kpi-value" id="kpi-total-orders">1,482</span>
        </div>
        <div class="kpi-footer">
            <span class="trend-badge up">
                <i class="fa-solid fa-arrow-trend-up"></i> +8.6%
            </span>
            <span class="kpi-comparison-text">vs. periodo anterior</span>
        </div>
    </div>

    <!-- KPI 3: Vendedores Activos -->
    <div class="kpi-card purple">
        <div class="kpi-top-row">
            <span class="kpi-title">Vendedores Activos</span>
            <div class="kpi-icon-box">
                <i class="fa-solid fa-store"></i>
            </div>
        </div>
        <div class="kpi-value-container">
            <span class="kpi-value" id="kpi-active-vendors">348</span>
        </div>
        <div class="kpi-footer">
            <span class="trend-badge up">
                <i class="fa-solid fa-arrow-trend-up"></i> +5.1%
            </span>
            <span class="kpi-comparison-text">tiendas con ventas</span>
        </div>
    </div>

    <!-- KPI 4: Tasa de Conversión -->
    <div class="kpi-card green">
        <div class="kpi-top-row">
            <span class="kpi-title">Tasa de Conversión</span>
            <div class="kpi-icon-box">
                <i class="fa-solid fa-bullseye"></i>
            </div>
        </div>
        <div class="kpi-value-container">
            <span class="kpi-value" id="kpi-conversion-rate">3.64%</span>
        </div>
        <div class="kpi-footer">
            <span class="trend-badge neutral">
                <i class="fa-solid fa-minus"></i> 0.0%
            </span>
            <span class="kpi-comparison-text">promedio del sector</span>
        </div>
    </div>
</div>

<!-- Sección Principal de Gráficas (Ventas y Distribución) -->
<div class="analytics-grid">
    <!-- Gráfica de Tendencia de Ventas y Comisiones -->
    <div class="chart-card">
        <div class="chart-header">
            <div class="chart-title-area">
                <h3><i class="fa-solid fa-chart-area"></i> Ingresos y Comisiones del Marketplace</h3>
                <span class="chart-subtitle">Volumen de transacciones en los últimos días</span>
            </div>
            <div class="chart-actions">
                <button class="btn-icon-sm" title="Actualizar datos"><i class="fa-solid fa-rotate-right"></i></button>
                <button class="btn-icon-sm" title="Opciones"><i class="fa-solid fa-ellipsis-vertical"></i></button>
            </div>
        </div>
        <div class="chart-body">
            <div class="chart-canvas-wrapper">
                <canvas id="salesTrendsChart"></canvas>
            </div>
        </div>
        <div class="chart-custom-legend">
            <div class="legend-item"><span class="legend-color-dot" style="background: #FF9900;"></span> Ventas Brutales ($)</div>
            <div class="legend-item"><span class="legend-color-dot" style="background: #3B82F6;"></span> Comisiones Marketplace ($)</div>
        </div>
    </div>

    <!-- Distribución de Ventas por Categoría -->
    <div class="chart-card">
        <div class="chart-header">
            <div class="chart-title-area">
                <h3><i class="fa-solid fa-chart-pie"></i> Ventas por Categoría</h3>
                <span class="chart-subtitle">Participación de mercado por rubro</span>
            </div>
        </div>
        <div class="chart-body">
            <div class="chart-canvas-wrapper">
                <canvas id="categoryDistributionChart"></canvas>
            </div>
        </div>
    </div>
</div>

<!-- Grid Inferior: Tabla de Productos Más Vendidos y Actividad en Vivo -->
<div class="analytics-grid">
    <!-- Tabla de Ranking de Productos Destacados -->
    <div class="chart-card">
        <div class="chart-header">
            <div class="chart-title-area">
                <h3><i class="fa-solid fa-trophy"></i> Top 5 Productos Más Vendidos</h3>
                <span class="chart-subtitle">Basado en volumen de venta e ingresos totales</span>
            </div>
        </div>
        <div class="analytics-table-wrapper">
            <table class="analytics-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Producto</th>
                        <th>Vendedor / Tienda</th>
                        <th>Unidades</th>
                        <th>Total Generado</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><span class="rank-badge gold">1</span></td>
                        <td>
                            <div class="table-entity-cell">
                                <div class="table-entity-info">
                                    <span class="title">Smartphone Pro Max 256GB</span>
                                    <span class="subtitle">SKU: TECH-9921</span>
                                </div>
                            </div>
                        </td>
                        <td>TechStore Oficial</td>
                        <td>420</td>
                        <td><strong>$419,580.00</strong></td>
                    </tr>
                    <tr>
                        <td><span class="rank-badge silver">2</span></td>
                        <td>
                            <div class="table-entity-cell">
                                <div class="table-entity-info">
                                    <span class="title">Auriculares Bluetooth Noise-Canceling</span>
                                    <span class="subtitle">SKU: AUDIO-4412</span>
                                </div>
                            </div>
                        </td>
                        <td>AudioPhile Direct</td>
                        <td>315</td>
                        <td><strong>$62,685.00</strong></td>
                    </tr>
                    <tr>
                        <td><span class="rank-badge bronze">3</span></td>
                        <td>
                            <div class="table-entity-cell">
                                <div class="table-entity-info">
                                    <span class="title">Laptop Gaming 16GB RAM RTX4060</span>
                                    <span class="subtitle">SKU: PC-8871</span>
                                </div>
                            </div>
                        </td>
                        <td>GamerZone Hub</td>
                        <td>180</td>
                        <td><strong>$233,820.00</strong></td>
                    </tr>
                    <tr>
                        <td><span class="rank-badge default">4</span></td>
                        <td>
                            <div class="table-entity-cell">
                                <div class="table-entity-info">
                                    <span class="title">Reloj Inteligente Sport Series 8</span>
                                    <span class="subtitle">SKU: WEAR-1092</span>
                                </div>
                            </div>
                        </td>
                        <td>SmartGadgets Co.</td>
                        <td>142</td>
                        <td><strong>$28,258.00</strong></td>
                    </tr>
                    <tr>
                        <td><span class="rank-badge default">5</span></td>
                        <td>
                            <div class="table-entity-cell">
                                <div class="table-entity-info">
                                    <span class="title">Consola Videojuegos NextGen 1TB</span>
                                    <span class="subtitle">SKU: GAME-5541</span>
                                </div>
                            </div>
                        </td>
                        <td>GameCentral Shop</td>
                        <td>98</td>
                        <td><strong>$48,902.00</strong></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Feed de Actividad Reciente del Marketplace -->
    <div class="chart-card">
        <div class="chart-header">
            <div class="chart-title-area">
                <h3><i class="fa-solid fa-bolt"></i> Actividad en Tiempo Real</h3>
                <span class="chart-subtitle">Eventos de ventas y registros</span>
            </div>
        </div>
        <div class="activity-list">
            <div class="activity-item">
                <div class="activity-icon sale"><i class="fa-solid fa-cart-shopping"></i></div>
                <div class="activity-details">
                    <div class="activity-text">Nueva compra de <strong>$1,299.00</strong> en <em>TechStore Oficial</em></div>
                    <div class="activity-time">Hace 2 minutos</div>
                </div>
            </div>
            <div class="activity-item">
                <div class="activity-icon user"><i class="fa-solid fa-store"></i></div>
                <div class="activity-details">
                    <div class="activity-text">Nuevo vendedor registrado: <strong>Fashion Outlet Store</strong></div>
                    <div class="activity-time">Hace 14 minutos</div>
                </div>
            </div>
            <div class="activity-item">
                <div class="activity-icon payout"><i class="fa-solid fa-hand-holding-dollar"></i></div>
                <div class="activity-details">
                    <div class="activity-text">Pago procesado a tienda <strong>GamerZone Hub</strong> por $12,450.00</div>
                    <div class="activity-time">Hace 32 minutos</div>
                </div>
            </div>
            <div class="activity-item">
                <div class="activity-icon sale"><i class="fa-solid fa-cart-shopping"></i></div>
                <div class="activity-details">
                    <div class="activity-text">Nueva compra de <strong>$199.00</strong> en <em>AudioPhile Direct</em></div>
                    <div class="activity-time">Hace 45 minutos</div>
                </div>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/../layouts/footer.php'; ?>
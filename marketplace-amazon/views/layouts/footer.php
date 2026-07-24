</main> <!-- Cierre de container -->

    <footer class="main-footer">
        <p>&copy; <?php echo date('Y'); ?> <?php echo APP_NAME; ?> - Todos los derechos reservados.</p>
    </footer>

    <!-- Variable BASE_URL global para JS -->
    <script>var BASE_URL = '<?php echo BASE_URL; ?>';</script>
    
    <!-- jQuery CDN (Obligatorio por los requerimientos del proyecto) -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    
    <!-- Chart.js CDN (Para dashboards y gráficas) -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <!-- JS Globales y Utilidades AJAX -->
    <script src="<?php echo BASE_URL; ?>public/js/utils.js"></script>
    <script src="<?php echo BASE_URL; ?>public/js/main.js"></script>

    <?php if (isset($module_js) && !empty($module_js)): ?>
        <!-- JS Módulo Específico -->
        <script src="<?php echo BASE_URL; ?>public/js/modules/<?php echo $module_js; ?>"></script>
    <?php endif; ?>
</body>
</html>

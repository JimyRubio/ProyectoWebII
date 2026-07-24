<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Controllers/TiendaController.php';
$c = new TiendaController();
$c->index();

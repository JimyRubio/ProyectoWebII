<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Controllers/PagoController.php';
$c = new PagoController();
$c->metodos();

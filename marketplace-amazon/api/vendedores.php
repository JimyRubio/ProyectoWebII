<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Controllers/VendedorController.php';
$c = new VendedorController();
$c->index();

<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Controllers/PromocionController.php';
$c = new PromocionController();
$c->index();

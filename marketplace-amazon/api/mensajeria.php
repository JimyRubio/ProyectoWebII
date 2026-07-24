<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Controllers/MensajeriaController.php';
$c = new MensajeriaController();
$c->index();

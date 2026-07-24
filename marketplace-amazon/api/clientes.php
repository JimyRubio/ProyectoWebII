<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/Controllers/ClienteController.php';

$controller = new ClienteController();
$controller->profile();

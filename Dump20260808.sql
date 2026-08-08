-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: marketplace_db
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `analytics_vendedores`
--

DROP TABLE IF EXISTS `analytics_vendedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `analytics_vendedores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `vendedor_id` int NOT NULL,
  `fecha` date NOT NULL,
  `total_pedidos` int DEFAULT '0',
  `total_ventas` decimal(12,2) DEFAULT '0.00',
  `total_comisiones` decimal(12,2) DEFAULT '0.00',
  `calificacion_promedio` decimal(3,2) DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_vendedor_fecha` (`vendedor_id`,`fecha`),
  CONSTRAINT `analytics_vendedores_ibfk_1` FOREIGN KEY (`vendedor_id`) REFERENCES `vendedores` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `analytics_vendedores`
--

LOCK TABLES `analytics_vendedores` WRITE;
/*!40000 ALTER TABLE `analytics_vendedores` DISABLE KEYS */;
/*!40000 ALTER TABLE `analytics_vendedores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `atributos_productos`
--

DROP TABLE IF EXISTS `atributos_productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atributos_productos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo` enum('texto','numero','color','talla','select','multiselect') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'texto',
  `valores_posibles` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atributos_productos`
--

LOCK TABLES `atributos_productos` WRITE;
/*!40000 ALTER TABLE `atributos_productos` DISABLE KEYS */;
INSERT INTO `atributos_productos` VALUES (1,'Color','color','[\"Negro\", \"Blanco\", \"Rojo\", \"Azul\", \"Verde\", \"Gris\", \"Dorado\", \"Plata\"]','2026-08-06 13:23:29'),(2,'Talla','talla','[\"S\", \"M\", \"L\", \"XL\", \"XXL\"]','2026-08-06 13:23:29'),(3,'Marca','texto','[\"Samsung\", \"Apple\", \"Sony\", \"LG\", \"Xiaomi\", \"HP\", \"Nike\", \"Adidas\"]','2026-08-06 13:23:29'),(4,'Material','texto','[\"Plástico\", \"Metal\", \"Algodón\", \"Cuero\", \"Vidrio\", \"Madera\"]','2026-08-06 13:23:29'),(5,'Capacidad','select','[\"64GB\", \"128GB\", \"256GB\", \"512GB\", \"1TB\"]','2026-08-06 13:23:29');
/*!40000 ALTER TABLE `atributos_productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auditoria`
--

DROP TABLE IF EXISTS `auditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int DEFAULT NULL,
  `accion` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tabla_afectada` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `registro_id` int DEFAULT NULL,
  `datos_anteriores` json DEFAULT NULL,
  `datos_nuevos` json DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_usuario` (`usuario_id`),
  KEY `idx_accion` (`accion`),
  KEY `idx_fecha` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria`
--

LOCK TABLES `auditoria` WRITE;
/*!40000 ALTER TABLE `auditoria` DISABLE KEYS */;
INSERT INTO `auditoria` VALUES (1,NULL,'ACTUALIZAR_PRODUCTO','productos',3,'{\"stock\": 100, \"estado\": \"activo\", \"precio\": 399.99}','{\"stock\": 99, \"estado\": \"activo\", \"precio\": 399.99}',NULL,NULL,'2026-07-24 04:00:32'),(2,NULL,'ACTUALIZAR_PRODUCTO','productos',3,'{\"stock\": 99, \"estado\": \"activo\", \"precio\": 399.99}','{\"stock\": 99, \"estado\": \"activo\", \"precio\": 399.99}',NULL,NULL,'2026-07-24 04:00:32'),(3,NULL,'ACTUALIZAR_PRODUCTO','productos',1,'{\"stock\": 50, \"estado\": \"activo\", \"precio\": 1299.99}','{\"stock\": 49, \"estado\": \"activo\", \"precio\": 1299.99}',NULL,NULL,'2026-07-24 04:00:32'),(4,NULL,'ACTUALIZAR_PRODUCTO','productos',1,'{\"stock\": 49, \"estado\": \"activo\", \"precio\": 1299.99}','{\"stock\": 49, \"estado\": \"activo\", \"precio\": 1299.99}',NULL,NULL,'2026-07-24 04:00:32'),(5,NULL,'PROCESAR_PEDIDO','pedidos',1,NULL,'{\"estado\": \"confirmado\"}',NULL,NULL,'2026-07-24 04:00:32'),(6,NULL,'PROCESAR_PEDIDO','pedidos',2,NULL,'{\"estado\": \"confirmado\"}',NULL,NULL,'2026-08-03 03:32:21'),(7,NULL,'PROCESAR_PEDIDO','pedidos',3,NULL,'{\"estado\": \"confirmado\"}',NULL,NULL,'2026-08-06 01:50:50'),(8,NULL,'PROCESAR_PEDIDO','pedidos',4,NULL,'{\"estado\": \"confirmado\"}',NULL,NULL,'2026-08-06 01:51:13');
/*!40000 ALTER TABLE `auditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carrito_items`
--

DROP TABLE IF EXISTS `carrito_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carrito_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `carrito_id` int NOT NULL,
  `producto_id` int NOT NULL,
  `variacion_id` int DEFAULT NULL,
  `cantidad` int NOT NULL DEFAULT '1',
  `precio_unitario` decimal(12,2) NOT NULL,
  `descuento` decimal(12,2) DEFAULT '0.00',
  `subtotal` decimal(12,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `producto_id` (`producto_id`),
  KEY `variacion_id` (`variacion_id`),
  KEY `idx_carrito` (`carrito_id`),
  KEY `idx_carrito_cliente` (`carrito_id`),
  CONSTRAINT `carrito_items_ibfk_1` FOREIGN KEY (`carrito_id`) REFERENCES `carritos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `carrito_items_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`),
  CONSTRAINT `carrito_items_ibfk_3` FOREIGN KEY (`variacion_id`) REFERENCES `variaciones_productos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carrito_items`
--

LOCK TABLES `carrito_items` WRITE;
/*!40000 ALTER TABLE `carrito_items` DISABLE KEYS */;
INSERT INTO `carrito_items` VALUES (20,7,10,NULL,1,3500.00,0.00,3500.00,'2026-07-30 00:50:12','2026-07-30 00:50:12'),(28,5,10,NULL,1,3500.00,0.00,3500.00,'2026-08-04 14:24:23','2026-08-04 14:24:23');
/*!40000 ALTER TABLE `carrito_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carritos`
--

DROP TABLE IF EXISTS `carritos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carritos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int NOT NULL,
  `total_items` int DEFAULT '0',
  `subtotal` decimal(12,2) DEFAULT '0.00',
  `descuentos` decimal(12,2) DEFAULT '0.00',
  `total` decimal(12,2) DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cliente_id` (`cliente_id`),
  CONSTRAINT `carritos_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carritos`
--

LOCK TABLES `carritos` WRITE;
/*!40000 ALTER TABLE `carritos` DISABLE KEYS */;
INSERT INTO `carritos` VALUES (4,1,0,0.00,0.00,0.00,'2026-07-24 02:55:19','2026-08-03 02:01:19'),(5,2,1,3500.00,100.00,3400.00,'2026-07-24 02:55:19','2026-08-04 14:24:23'),(6,3,0,0.00,0.00,0.00,'2026-07-24 04:22:29','2026-08-06 02:30:17'),(7,4,1,3500.00,0.00,3500.00,'2026-07-25 03:06:56','2026-07-30 00:50:12'),(8,5,0,0.00,0.00,0.00,'2026-07-25 03:47:12','2026-07-25 03:47:12');
/*!40000 ALTER TABLE `carritos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categorias`
--

DROP TABLE IF EXISTS `categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `parent_id` int DEFAULT NULL,
  `nivel` int DEFAULT '1',
  `activo` tinyint(1) DEFAULT '1',
  `imagen` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orden` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `idx_parent` (`parent_id`),
  CONSTRAINT `categorias_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `categorias` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias`
--

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
INSERT INTO `categorias` VALUES (1,'Electronica','electronica','Categoria de Electronica',NULL,1,1,NULL,0,'2026-07-24 02:55:19','2026-07-24 02:55:19'),(2,'Ropa y Moda','ropa-moda','Categoria de Ropa y Moda',NULL,1,1,NULL,0,'2026-07-24 02:55:19','2026-07-24 02:55:19'),(3,'Hogar y Cocina','hogar-cocina','Categoria de Hogar y Cocina',NULL,1,1,NULL,0,'2026-07-24 02:55:19','2026-07-24 02:55:19'),(4,'Deportes','deportes','Categoria de Deportes',NULL,1,1,NULL,0,'2026-07-24 02:55:19','2026-07-24 02:55:19'),(5,'Juegos y Juguetes','juegos-juguetes','Categoria de Juegos y Juguetes',NULL,1,1,NULL,0,'2026-07-24 02:55:19','2026-07-24 02:55:19');
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categorias_tiendas`
--

DROP TABLE IF EXISTS `categorias_tiendas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias_tiendas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tienda_id` int NOT NULL,
  `categoria_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_tienda_categoria` (`tienda_id`,`categoria_id`),
  KEY `categoria_id` (`categoria_id`),
  CONSTRAINT `categorias_tiendas_ibfk_1` FOREIGN KEY (`tienda_id`) REFERENCES `tiendas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `categorias_tiendas_ibfk_2` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias_tiendas`
--

LOCK TABLES `categorias_tiendas` WRITE;
/*!40000 ALTER TABLE `categorias_tiendas` DISABLE KEYS */;
/*!40000 ALTER TABLE `categorias_tiendas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categorias_vendedores`
--

DROP TABLE IF EXISTS `categorias_vendedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias_vendedores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `vendedor_id` int NOT NULL,
  `categoria_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_vendedor_categoria` (`vendedor_id`,`categoria_id`),
  KEY `categoria_id` (`categoria_id`),
  CONSTRAINT `categorias_vendedores_ibfk_1` FOREIGN KEY (`vendedor_id`) REFERENCES `vendedores` (`id`) ON DELETE CASCADE,
  CONSTRAINT `categorias_vendedores_ibfk_2` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias_vendedores`
--

LOCK TABLES `categorias_vendedores` WRITE;
/*!40000 ALTER TABLE `categorias_vendedores` DISABLE KEYS */;
/*!40000 ALTER TABLE `categorias_vendedores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ciudades`
--

DROP TABLE IF EXISTS `ciudades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ciudades` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pais_id` int NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo_postal` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_pais` (`pais_id`),
  CONSTRAINT `ciudades_ibfk_1` FOREIGN KEY (`pais_id`) REFERENCES `paises` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ciudades`
--

LOCK TABLES `ciudades` WRITE;
/*!40000 ALTER TABLE `ciudades` DISABLE KEYS */;
INSERT INTO `ciudades` VALUES (1,1,'Ciudad de México','01000','2026-07-23 14:47:29'),(2,1,'Guadalajara','44100','2026-07-23 14:47:29'),(3,1,'Monterrey','64000','2026-07-23 14:47:29'),(4,2,'New York','10001','2026-07-23 14:47:29'),(5,2,'Los Angeles','90001','2026-07-23 14:47:29'),(6,3,'Toronto','M5V 2H1','2026-07-23 14:47:29'),(7,4,'Madrid','28001','2026-07-23 14:47:29'),(8,4,'Barcelona','08001','2026-07-23 14:47:29');
/*!40000 ALTER TABLE `ciudades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `tipo_cliente` enum('regular','premium','empresa') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'regular',
  `puntos_lealtad` int DEFAULT '0',
  `total_compras` decimal(12,2) DEFAULT '0.00',
  `total_pedidos` int DEFAULT '0',
  `ultima_compra` datetime DEFAULT NULL,
  `fecha_registro` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario_id` (`usuario_id`),
  KEY `idx_tipo` (`tipo_cliente`),
  CONSTRAINT `clientes_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,1,'regular',100,0.00,0,NULL,'2026-07-23'),(2,3,'regular',100,0.00,0,NULL,'2026-07-23'),(3,4,'regular',0,0.00,0,NULL,'2026-07-23'),(4,5,'regular',0,0.00,0,NULL,'2026-07-24'),(5,6,'regular',0,0.00,0,NULL,'2026-07-24');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comparacion_productos`
--

DROP TABLE IF EXISTS `comparacion_productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comparacion_productos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int NOT NULL,
  `productos_ids` json NOT NULL,
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `cliente_id` (`cliente_id`),
  CONSTRAINT `comparacion_productos_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comparacion_productos`
--

LOCK TABLES `comparacion_productos` WRITE;
/*!40000 ALTER TABLE `comparacion_productos` DISABLE KEYS */;
/*!40000 ALTER TABLE `comparacion_productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configuracion_sistema`
--

DROP TABLE IF EXISTS `configuracion_sistema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `configuracion_sistema` (
  `id` int NOT NULL AUTO_INCREMENT,
  `clave` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tipo` enum('string','int','boolean','json') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'string',
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `grupo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clave` (`clave`),
  KEY `idx_clave` (`clave`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configuracion_sistema`
--

LOCK TABLES `configuracion_sistema` WRITE;
/*!40000 ALTER TABLE `configuracion_sistema` DISABLE KEYS */;
INSERT INTO `configuracion_sistema` VALUES (1,'site_name','Marketplace Pro','string','Nombre del sitio web','general','2026-07-23 14:47:29','2026-07-23 14:47:29'),(2,'currency','MXN','string','Moneda del sistema','general','2026-07-23 14:47:29','2026-07-23 14:47:29'),(3,'tax_rate','16.00','string','Tasa de impuesto (%)','impuestos','2026-07-23 14:47:29','2026-07-23 14:47:29'),(4,'commission_rate','10.00','string','Comisión por venta (%)','vendedores','2026-07-23 14:47:29','2026-07-23 14:47:29'),(5,'max_login_attempts','5','int','Máximo de intentos de login fallidos','seguridad','2026-07-23 14:47:29','2026-07-23 14:47:29'),(6,'session_timeout','30','int','Tiempo de sesión en minutos','seguridad','2026-07-23 14:47:29','2026-07-23 14:47:29'),(7,'min_order_amount','0','string','Monto mínimo de pedido','pedidos','2026-07-23 14:47:29','2026-07-23 14:47:29'),(8,'free_shipping_min','500','string','Monto mínimo para envío gratis','envios','2026-07-23 14:47:29','2026-07-23 14:47:29');
/*!40000 ALTER TABLE `configuracion_sistema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configuracion_usuarios`
--

DROP TABLE IF EXISTS `configuracion_usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `configuracion_usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `idioma` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'es',
  `tema` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'light',
  `notificaciones_email` tinyint(1) DEFAULT '1',
  `notificaciones_push` tinyint(1) DEFAULT '1',
  `notificaciones_sms` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `configuracion_usuarios_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configuracion_usuarios`
--

LOCK TABLES `configuracion_usuarios` WRITE;
/*!40000 ALTER TABLE `configuracion_usuarios` DISABLE KEYS */;
/*!40000 ALTER TABLE `configuracion_usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conversaciones`
--

DROP TABLE IF EXISTS `conversaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conversaciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int NOT NULL,
  `vendedor_id` int NOT NULL,
  `asunto` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ultimo_mensaje` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `estado` enum('abierta','cerrada','archivada') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'abierta',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_cliente` (`cliente_id`),
  KEY `idx_vendedor` (`vendedor_id`),
  CONSTRAINT `conversaciones_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  CONSTRAINT `conversaciones_ibfk_2` FOREIGN KEY (`vendedor_id`) REFERENCES `vendedores` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conversaciones`
--

LOCK TABLES `conversaciones` WRITE;
/*!40000 ALTER TABLE `conversaciones` DISABLE KEYS */;
INSERT INTO `conversaciones` VALUES (1,1,1,'Consulta sobre: Auriculares Bluetooth Pro','Hola, estoy interesado en Auriculares Bluetooth Pro. ¿Podrías darme más información?','abierta','2026-07-24 19:55:11','2026-07-24 19:55:11'),(2,1,1,'Consulta sobre: Auriculares Bluetooth Pro','son tal y tal','abierta','2026-07-24 19:55:18','2026-07-24 19:56:09'),(3,2,1,'Consulta sobre: Smartwatch Deportivo X200','Hola, estoy interesado en Smartwatch Deportivo X200. ¿Podrías darme más información?','abierta','2026-07-24 20:06:30','2026-07-24 20:06:30'),(4,3,1,'Consulta sobre: Casita de Muñecas 3 Pisos','no se de que habla','abierta','2026-08-06 23:20:06','2026-08-06 23:21:32');
/*!40000 ALTER TABLE `conversaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cupones`
--

DROP TABLE IF EXISTS `cupones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cupones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tipo_descuento` enum('porcentaje','monto_fijo') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor` decimal(12,2) NOT NULL,
  `minimo_compra` decimal(12,2) DEFAULT '0.00',
  `maximo_descuento` decimal(12,2) DEFAULT NULL,
  `productos_aplicables` json DEFAULT NULL,
  `categorias_aplicables` json DEFAULT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime NOT NULL,
  `usa_veces` int DEFAULT '1',
  `usa_por_cliente` int DEFAULT '1',
  `activo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`),
  KEY `idx_codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cupones`
--

LOCK TABLES `cupones` WRITE;
/*!40000 ALTER TABLE `cupones` DISABLE KEYS */;
INSERT INTO `cupones` VALUES (1,'BIENVENIDO10','10% de descuento para nuevos clientes','porcentaje',10.00,0.00,NULL,NULL,NULL,'2024-01-01 00:00:00','2030-12-31 23:59:59',0,1,1,'2026-08-03 01:56:31','2026-08-03 01:56:31'),(2,'VERANO25','25% de descuento en ofertas de verano','porcentaje',25.00,500.00,500.00,NULL,NULL,'2024-06-01 00:00:00','2030-08-31 23:59:59',0,1,1,'2026-08-03 01:56:31','2026-08-03 01:56:31'),(3,'DESCUENTO50','L. 50 de descuento en tu compra','monto_fijo',50.00,300.00,NULL,NULL,NULL,'2024-01-01 00:00:00','2030-12-31 23:59:59',0,1,1,'2026-08-03 01:56:31','2026-08-03 01:56:31'),(4,'FREESHIP','Envío gratis en compras mayores a L. 1,000','monto_fijo',100.00,1000.00,NULL,NULL,NULL,'2024-01-01 00:00:00','2030-12-31 23:59:59',0,1,1,'2026-08-03 01:56:31','2026-08-03 01:56:31');
/*!40000 ALTER TABLE `cupones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devoluciones`
--

DROP TABLE IF EXISTS `devoluciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `devoluciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pedido_id` int NOT NULL,
  `cliente_id` int NOT NULL,
  `producto_id` int NOT NULL,
  `cantidad` int NOT NULL,
  `motivo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` enum('solicitada','aprobada','rechazada','completada') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'solicitada',
  `monto_reembolso` decimal(12,2) DEFAULT NULL,
  `fecha_solicitud` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_aprobacion` datetime DEFAULT NULL,
  `fecha_reembolso` datetime DEFAULT NULL,
  `comentarios_internos` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `cliente_id` (`cliente_id`),
  KEY `producto_id` (`producto_id`),
  KEY `idx_pedido` (`pedido_id`),
  CONSTRAINT `devoluciones_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `devoluciones_ibfk_2` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  CONSTRAINT `devoluciones_ibfk_3` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devoluciones`
--

LOCK TABLES `devoluciones` WRITE;
/*!40000 ALTER TABLE `devoluciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `devoluciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `direcciones`
--

DROP TABLE IF EXISTS `direcciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `direcciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int NOT NULL,
  `tipo` enum('envio','facturacion','ambos') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'ambos',
  `calle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `numero` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `complemento` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `colonia` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ciudad` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `pais` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo_postal` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `referencia` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `latitud` decimal(10,8) DEFAULT NULL,
  `longitud` decimal(11,8) DEFAULT NULL,
  `predeterminada` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_cliente` (`cliente_id`),
  CONSTRAINT `direcciones_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `direcciones`
--

LOCK TABLES `direcciones` WRITE;
/*!40000 ALTER TABLE `direcciones` DISABLE KEYS */;
INSERT INTO `direcciones` VALUES (1,4,'ambos','123','25',NULL,'Barrio Sagrado Corazón','Choluteca','Choluteca','México','51110','Casa color amarillo',NULL,NULL,0,'2026-07-30 00:48:31','2026-07-30 00:48:31');
/*!40000 ALTER TABLE `direcciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `envios`
--

DROP TABLE IF EXISTS `envios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `envios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pedido_id` int NOT NULL,
  `transportista_id` int NOT NULL,
  `tipo_envio` enum('standar','express','same_day') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'standar',
  `costo` decimal(12,2) NOT NULL,
  `tracking_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` enum('pendiente','preparando','enviado','en_transito','entregado','fallido') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pendiente',
  `fecha_envio` datetime DEFAULT NULL,
  `fecha_entrega_estimada` datetime DEFAULT NULL,
  `fecha_entrega_real` datetime DEFAULT NULL,
  `direccion_envio` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `observaciones` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pedido_id` (`pedido_id`),
  KEY `transportista_id` (`transportista_id`),
  KEY `idx_pedido` (`pedido_id`),
  KEY `idx_envios_estado` (`estado`),
  CONSTRAINT `envios_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `envios_ibfk_2` FOREIGN KEY (`transportista_id`) REFERENCES `transportistas` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `envios`
--

LOCK TABLES `envios` WRITE;
/*!40000 ALTER TABLE `envios` DISABLE KEYS */;
/*!40000 ALTER TABLE `envios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facturas`
--

DROP TABLE IF EXISTS `facturas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facturas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pedido_id` int NOT NULL,
  `numero_factura` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cliente_id` int NOT NULL,
  `ruc_cliente` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `razon_social` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccion_facturacion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `subtotal` decimal(12,2) NOT NULL,
  `impuestos` decimal(12,2) DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `pdf_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `xml_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_emision` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pedido_id` (`pedido_id`),
  UNIQUE KEY `numero_factura` (`numero_factura`),
  KEY `idx_cliente` (`cliente_id`),
  CONSTRAINT `facturas_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `facturas_ibfk_2` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facturas`
--

LOCK TABLES `facturas` WRITE;
/*!40000 ALTER TABLE `facturas` DISABLE KEYS */;
/*!40000 ALTER TABLE `facturas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historial_busquedas`
--

DROP TABLE IF EXISTS `historial_busquedas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historial_busquedas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int NOT NULL,
  `termino_busqueda` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `resultados` int DEFAULT '0',
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_busqueda` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_cliente` (`cliente_id`),
  CONSTRAINT `historial_busquedas_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historial_busquedas`
--

LOCK TABLES `historial_busquedas` WRITE;
/*!40000 ALTER TABLE `historial_busquedas` DISABLE KEYS */;
/*!40000 ALTER TABLE `historial_busquedas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historial_estados_pedido`
--

DROP TABLE IF EXISTS `historial_estados_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historial_estados_pedido` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pedido_id` int NOT NULL,
  `estado_anterior` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado_nuevo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `comentario` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `usuario_id` int DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `usuario_id` (`usuario_id`),
  KEY `idx_pedido` (`pedido_id`),
  CONSTRAINT `historial_estados_pedido_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `historial_estados_pedido_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historial_estados_pedido`
--

LOCK TABLES `historial_estados_pedido` WRITE;
/*!40000 ALTER TABLE `historial_estados_pedido` DISABLE KEYS */;
INSERT INTO `historial_estados_pedido` VALUES (1,1,NULL,'pendiente','Pedido registrado exitosamente',NULL,NULL,'2026-07-24 04:00:32'),(2,1,'pendiente','confirmado',NULL,NULL,NULL,'2026-07-24 04:00:32'),(3,2,NULL,'pendiente','Pedido registrado exitosamente',NULL,NULL,'2026-08-03 03:32:21'),(4,2,'pendiente','confirmado','Pedido procesado y confirmado exitosamente',NULL,NULL,'2026-08-03 03:32:21'),(5,3,NULL,'pendiente','Pedido registrado exitosamente',NULL,NULL,'2026-08-06 01:50:50'),(6,3,'pendiente','confirmado','Pedido procesado y confirmado exitosamente',NULL,NULL,'2026-08-06 01:50:50'),(7,4,NULL,'pendiente','Pedido registrado exitosamente',NULL,NULL,'2026-08-06 01:51:13'),(8,4,'pendiente','confirmado','Pedido procesado y confirmado exitosamente',NULL,NULL,'2026-08-06 01:51:13');
/*!40000 ALTER TABLE `historial_estados_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historial_precios`
--

DROP TABLE IF EXISTS `historial_precios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historial_precios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `producto_id` int NOT NULL,
  `precio_anterior` decimal(12,2) NOT NULL,
  `precio_nuevo` decimal(12,2) NOT NULL,
  `fecha_cambio` datetime DEFAULT CURRENT_TIMESTAMP,
  `usuario_id` int DEFAULT NULL,
  `razon_cambio` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `usuario_id` (`usuario_id`),
  KEY `idx_producto` (`producto_id`),
  CONSTRAINT `historial_precios_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `historial_precios_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historial_precios`
--

LOCK TABLES `historial_precios` WRITE;
/*!40000 ALTER TABLE `historial_precios` DISABLE KEYS */;
/*!40000 ALTER TABLE `historial_precios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historial_stock`
--

DROP TABLE IF EXISTS `historial_stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historial_stock` (
  `id` int NOT NULL AUTO_INCREMENT,
  `producto_id` int NOT NULL,
  `stock_anterior` int NOT NULL,
  `stock_nuevo` int NOT NULL,
  `tipo_movimiento` enum('entrada','salida','ajuste') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cantidad` int NOT NULL,
  `referencia` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usuario_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `usuario_id` (`usuario_id`),
  KEY `idx_producto` (`producto_id`),
  CONSTRAINT `historial_stock_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `historial_stock_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historial_stock`
--

LOCK TABLES `historial_stock` WRITE;
/*!40000 ALTER TABLE `historial_stock` DISABLE KEYS */;
INSERT INTO `historial_stock` VALUES (1,3,100,99,'salida',1,NULL,NULL,'2026-07-24 04:00:32'),(2,1,50,49,'salida',1,NULL,NULL,'2026-07-24 04:00:32');
/*!40000 ALTER TABLE `historial_stock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `imagenes_productos`
--

DROP TABLE IF EXISTS `imagenes_productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `imagenes_productos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `producto_id` int NOT NULL,
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `alt` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `orden` int DEFAULT '0',
  `principal` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_producto` (`producto_id`),
  CONSTRAINT `imagenes_productos_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=252 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `imagenes_productos`
--

LOCK TABLES `imagenes_productos` WRITE;
/*!40000 ALTER TABLE `imagenes_productos` DISABLE KEYS */;
INSERT INTO `imagenes_productos` VALUES (1,1,'/public/uploads/productos/prod_6a677050844a1_1785163856.webp','Auriculares Bluetooth Pro',0,1,'2026-07-24 02:55:19'),(2,2,'/public/uploads/productos/prod_6a6770277dc61_1785163815.webp','Smartwatch Deportivo X200',0,1,'2026-07-24 02:55:19'),(3,3,'/public/uploads/productos/prod_6a676ff4e9c92_1785163764.jpg','Camiseta Algodon Premium',0,1,'2026-07-24 02:55:19'),(4,4,'/public/uploads/productos/prod_6a676fcb12ab1_1785163723.jpg','Set de Sartenes Antiadherentes',0,1,'2026-07-24 02:55:19'),(5,5,'/public/uploads/productos/prod_6a66764ea9be1_1785099854.jpg','Bicicleta Mountain Bike 21V',0,1,'2026-07-24 02:55:19'),(6,6,'/public/uploads/productos/prod_6a676fa0a5354_1785163680.jpg','Consola Videojuegos NextGen',0,1,'2026-07-24 02:55:19'),(7,8,'/public/uploads/productos/prod_6a6661b9bf7fd_1785094585.jpg','Pulsera',0,1,'2026-07-26 19:36:31'),(8,7,'/public/uploads/productos/prod_6a6668ef61647_1785096431.jpg','Mando Xbox Elite Series 2',0,1,'2026-07-26 20:07:15'),(9,9,'/public/uploads/productos/prod_6a6771a4ab72d_1785164196.jpg','Mando de PlayStation 4',0,1,'2026-07-27 14:56:37'),(10,10,'/public/uploads/productos/prod_6a677287d1da9_1785164423.png','Mando de Play Station 4 X Controller',0,1,'2026-07-27 15:00:27'),(151,153,'/public/uploads/productos/prod_6a77b518b0c14_1786230040.png','Auriculares Inalámbricos ANC',0,1,'2026-08-06 13:33:20'),(152,154,'/public/uploads/productos/prod_6a77b4ba9d6e3_1786229946.png','Teclado Mecánico RGB',0,1,'2026-08-06 13:33:20'),(153,155,'/public/uploads/productos/prod_6a77b492afb45_1786229906.png','Mouse Gamer 16000 DPI',0,1,'2026-08-06 13:33:20'),(154,156,'/public/uploads/productos/prod_6a77b4ef446f7_1786229999.png','Monitor 27\" 144Hz',0,1,'2026-08-06 13:33:20'),(155,157,'/public/uploads/productos/prod_6a77b45437d09_1786229844.png','Laptop Ultraligera 14\"',0,1,'2026-08-06 13:33:20'),(156,158,'/public/uploads/productos/prod_6a77b422b9a77_1786229794.png','Disco SSD NVMe 1TB',0,1,'2026-08-06 13:33:20'),(157,159,'/public/uploads/productos/prod_6a77b3f316773_1786229747.png','Webcam Full HD 1080p',0,1,'2026-08-06 13:33:20'),(158,160,'/public/uploads/productos/prod_6a77b3d05fc57_1786229712.png','Router WiFi 6 AX3000',0,1,'2026-08-06 13:33:20'),(159,161,'/public/uploads/productos/prod_6a77b39f94830_1786229663.png','Impresora Multifuncional',0,1,'2026-08-06 13:33:20'),(160,162,'/public/uploads/productos/prod_6a77b377a0c11_1786229623.png','Tablet 10.4\" 128GB',0,1,'2026-08-06 13:33:20'),(161,163,'/public/uploads/productos/prod_6a77b3446d8f7_1786229572.png','Parlante Bluetooth Portátil',0,1,'2026-08-06 13:33:20'),(162,164,'/public/uploads/productos/prod_6a77b31d5ec7a_1786229533.png','Cámara Web 4K',0,1,'2026-08-06 13:33:20'),(163,165,'/public/uploads/productos/prod_6a77b2f984217_1786229497.png','Hub USB-C 7 en 1',0,1,'2026-08-06 13:33:20'),(164,166,'/public/uploads/productos/prod_6a77b2a4cafd6_1786229412.png','Soporte Monitor Ergonomico',0,1,'2026-08-06 13:33:20'),(165,167,'/public/uploads/productos/prod_6a77b27d660cd_1786229373.png','Audífonos Over-Ear Pro',0,1,'2026-08-06 13:33:20'),(166,168,'/public/uploads/productos/prod_6a77b258c6541_1786229336.png','Micro SD 256GB',0,1,'2026-08-06 13:33:20'),(167,169,'/public/uploads/productos/prod_6a77b2333fd85_1786229299.png','Cargador Inalámbrico 15W',0,1,'2026-08-06 13:33:20'),(168,170,'/public/uploads/productos/prod_6a77b1fb49676_1786229243.png','Power Bank 20000mAh',0,1,'2026-08-06 13:33:20'),(170,172,'/public/uploads/productos/prod_6a77b1c31d8f9_1786229187.png','Licuadora de Mano Inalámbrica',0,1,'2026-08-06 13:33:20'),(171,173,'/public/uploads/productos/prod_6a77b16bd58f5_1786229099.png','Camiseta Premium Algodón',0,1,'2026-08-06 13:33:20'),(172,174,'/public/uploads/productos/prod_6a77b143063cf_1786229059.png','Jeans Clásicos Slim',0,1,'2026-08-06 13:33:20'),(173,175,'/public/uploads/productos/prod_6a77b119755d2_1786229017.png','Chaqueta Impermeable Urbana',0,1,'2026-08-06 13:33:20'),(175,177,'/public/uploads/productos/prod_6a77b0c82d690_1786228936.png','Vestido Elegante Casual',0,1,'2026-08-06 13:33:20'),(176,178,'/public/uploads/productos/prod_6a77b09d55c92_1786228893.png','Bolso de Mano Acolchado',0,1,'2026-08-06 13:33:20'),(177,179,'/public/uploads/productos/prod_6a77b07512ba7_1786228853.png','Reloj Deportivo Chorome',0,1,'2026-08-06 13:33:20'),(178,180,'/public/uploads/productos/prod_6a77b0427e47c_1786228802.png','Gorra Clásica Bordada',0,1,'2026-08-06 13:33:20'),(179,181,'/public/uploads/productos/prod_6a77b01dd88ac_1786228765.png','Bufanda de Lana Suave',0,1,'2026-08-06 13:33:20'),(180,182,'/public/uploads/productos/prod_6a77afb1389e4_1786228657.png','Cinturón de Cuero',0,1,'2026-08-06 13:33:20'),(181,183,'/public/uploads/productos/prod_6a77aefa285ec_1786228474.png','Camisa Oxford Formal',0,1,'2026-08-06 13:33:20'),(182,184,'/public/uploads/productos/prod_6a77aed845abe_1786228440.png','Sudadera con Capucha',0,1,'2026-08-06 13:33:20'),(183,185,'/public/uploads/productos/prod_6a77aeb346dd1_1786228403.png','Pantalón Deportivo Jogger',0,1,'2026-08-06 13:33:21'),(184,186,'/public/uploads/productos/prod_6a77ae93e9a72_1786228371.png','Traje de Baño Hombre',0,1,'2026-08-06 13:33:21'),(185,187,'/public/uploads/productos/prod_6a77ae62a44f1_1786228322.png','Calcetines Deportivos (Pack)',0,1,'2026-08-06 13:33:21'),(186,188,'/public/uploads/productos/prod_6a77ae331933a_1786228275.webp','Gafas de Sol Polarizadas',0,1,'2026-08-06 13:33:21'),(187,189,'/public/uploads/productos/prod_6a77ae1284705_1786228242.png','Cartera Elegante Mujer',0,1,'2026-08-06 13:33:21'),(188,190,'/public/uploads/productos/prod_6a77ad0a35224_1786227978.png','Falda Midi Plisada',0,1,'2026-08-06 13:33:21'),(189,191,'/public/uploads/productos/prod_6a77acc4e5435_1786227908.png','Suéter de Lana Premium',0,1,'2026-08-06 13:33:21'),(190,192,'/public/uploads/productos/prod_6a77ac9be2e3d_1786227867.png','Zapatos Oxford Cuero',0,1,'2026-08-06 13:33:21'),(191,193,'/public/uploads/productos/prod_6a77ac677784c_1786227815.png','Set de Sartenes Antiadherentes',0,1,'2026-08-06 13:33:21'),(192,194,'/public/uploads/productos/prod_6a77ac378fba8_1786227767.webp','Juego de Ollas 8 Piezas',0,1,'2026-08-06 13:33:21'),(193,195,'/public/uploads/productos/prod_6a77ac0a1e13a_1786227722.png','Licuadora 10 Velocidades',0,1,'2026-08-06 13:33:21'),(194,196,'/public/uploads/productos/prod_6a77abbce2e79_1786227644.png','Cafetera Programable 12 Tazas',0,1,'2026-08-06 13:33:21'),(195,197,'/public/uploads/productos/prod_6a77ab955e567_1786227605.png','Lámpara de Mesa LED',0,1,'2026-08-06 13:33:21'),(196,198,'/public/uploads/productos/prod_6a77ab69d3dba_1786227561.png','Cortinas Blackout 2.5m',0,1,'2026-08-06 13:33:21'),(197,199,'/public/uploads/productos/prod_6a77ab3d87283_1786227517.png','Set de Sábanas Queen',0,1,'2026-08-06 13:33:21'),(198,200,'/public/uploads/productos/prod_6a77ab0e95d80_1786227470.png','Tostadora 2 Ranuras',0,1,'2026-08-06 13:33:21'),(199,201,'/public/uploads/productos/prod_6a77aaea5097d_1786227434.png','Batidora de Mano 500W',0,1,'2026-08-06 13:33:21'),(200,202,'/public/uploads/productos/prod_6a77aaaf79624_1786227375.png','Procesador de Alimentos',0,1,'2026-08-06 13:33:21'),(201,203,'/public/uploads/productos/prod_6a77aa7103cdd_1786227313.png','Olla de Presión 6L',0,1,'2026-08-06 13:33:21'),(202,204,'/public/uploads/productos/prod_6a77a9f94e93c_1786227193.png','Exprimidor de Cítricos',0,1,'2026-08-06 13:33:21'),(203,205,'/public/uploads/productos/prod_6a77a9b56e781_1786227125.png','Juego de Cubiertos 24 Piezas',0,1,'2026-08-06 13:33:21'),(204,206,'/public/uploads/productos/prod_6a77a6e06bc85_1786226400.png','Tabla de Cortar Madera',0,1,'2026-08-06 13:33:21'),(205,207,'/public/uploads/productos/prod_6a77a65c9e35f_1786226268.png','Termo Acero Inoxidable 1L',0,1,'2026-08-06 13:33:21'),(206,208,'/public/uploads/productos/prod_6a77a4d5b01a3_1786225877.png','Colador de Acero 3 Piezas',0,1,'2026-08-06 13:33:21'),(207,209,'/public/uploads/productos/prod_6a77a3e4ac139_1786225636.jpg','Organizador de Cocina 4 Niveles',0,1,'2026-08-06 13:33:21'),(208,210,'/public/uploads/productos/prod_6a77a3bb8f80a_1786225595.png','Freidora de Aire 4L',0,1,'2026-08-06 13:33:21'),(209,211,'/public/uploads/productos/prod_6a77a36057ec4_1786225504.png','Batidora de Pedestal 900W',0,1,'2026-08-06 13:33:21'),(210,212,'/public/uploads/productos/prod_6a77a2d6c8418_1786225366.png','Jarra Eléctrica 2L',0,1,'2026-08-06 13:33:21'),(211,213,'/public/uploads/productos/prod_6a77a2af8b7df_1786225327.png','Bicicleta de Montaña 21V',0,1,'2026-08-06 13:33:21'),(212,214,'/public/uploads/productos/prod_6a77a23a50eaa_1786225210.png','Pesas Ajustables 24kg',0,1,'2026-08-06 13:33:21'),(213,215,'/public/uploads/productos/prod_6a77a213d9fc9_1786225171.png','Esterilla Yoga Antideslizante',0,1,'2026-08-06 13:33:21'),(214,216,'/public/uploads/productos/prod_6a77a1c3ec56b_1786225091.png','Balón de Fútbol Oficial',0,1,'2026-08-06 13:33:21'),(215,217,'/public/uploads/productos/prod_6a77a15000b06_1786224976.png','Cuerda de Saltar Ajustable',0,1,'2026-08-06 13:33:21'),(216,218,'/public/uploads/productos/prod_6a77a1246f3d3_1786224932.png','Mancuernas Neopreno 5kg',0,1,'2026-08-06 13:33:21'),(217,219,'/public/uploads/productos/prod_6a77a0af4e876_1786224815.png','Casco de Bicicleta Aero',0,1,'2026-08-06 13:33:21'),(218,220,'/public/uploads/productos/prod_6a77a08876e80_1786224776.png','Rodillera Deportiva',0,1,'2026-08-06 13:33:21'),(219,221,'/public/uploads/productos/prod_6a77a0569b458_1786224726.png','Botella Deportiva 750ml',0,1,'2026-08-06 13:33:21'),(220,222,'/public/uploads/productos/prod_6a77a019e87c0_1786224665.png','Mochila Senderismo 30L',0,1,'2026-08-06 13:33:21'),(221,223,'/public/uploads/productos/prod_6a779faef3a17_1786224558.png','Guantes de Boxeo 12oz',0,1,'2026-08-06 13:33:21'),(222,224,'/public/uploads/productos/prod_6a779f85bb8f5_1786224517.png','Pesa Rusa 12kg',0,1,'2026-08-06 13:33:21'),(223,225,'/public/uploads/productos/prod_6a779f59d53e5_1786224473.png','Banda Elástica Resistencia Set',0,1,'2026-08-06 13:33:21'),(224,226,'/public/uploads/productos/prod_6a779f2800344_1786224424.png','Treadmill Plegable 2HP',0,1,'2026-08-06 13:33:21'),(225,227,'/public/uploads/productos/prod_6a779ef29c965_1786224370.png','Bicicleta Estática Magnética',0,1,'2026-08-06 13:33:21'),(226,228,'/public/uploads/productos/prod_6a779eccc3d8f_1786224332.png','Raqueta de Tenis Pro',0,1,'2026-08-06 13:33:21'),(227,229,'/public/uploads/productos/prod_6a779e7dc08ef_1786224253.png','Set de Yoga Completo',0,1,'2026-08-06 13:33:21'),(228,230,'/public/uploads/productos/prod_6a779e2c79683_1786224172.png','Cronómetro Deportivo',0,1,'2026-08-06 13:33:21'),(229,231,'/public/uploads/productos/prod_6a779e003b121_1786224128.png','Ropa Deportiva Hombre (Set)',0,1,'2026-08-06 13:33:21'),(230,232,'/public/uploads/productos/prod_6a779db8cedb5_1786224056.jpg','Zapatillas Trail Running',0,1,'2026-08-06 13:33:21'),(231,233,'/public/uploads/productos/prod_6a779d6624c68_1786223974.png','Consola de Videojuegos NextGen',0,1,'2026-08-06 13:33:21'),(232,234,'/public/uploads/productos/prod_6a779d0da4c81_1786223885.png','Mando Inalámbrico Pro',0,1,'2026-08-06 13:33:21'),(233,235,'/public/uploads/productos/prod_6a779cd60276a_1786223830.png','Set de Bloques 500 Piezas',0,1,'2026-08-06 13:33:21'),(234,236,'/public/uploads/productos/prod_6a779c255e540_1786223653.png','Robot Educativo Programable',0,1,'2026-08-06 13:33:21'),(235,237,'/public/uploads/productos/prod_6a779bf53eb60_1786223605.png','Muñeca Interactiva 33cm',0,1,'2026-08-06 13:33:21'),(236,238,'/public/uploads/productos/prod_6a779bb43cfc7_1786223540.png','Carro de Control Remoto',0,1,'2026-08-06 13:33:21'),(237,239,'/public/uploads/productos/prod_6a779b1d0eea5_1786223389.png','Juego de Mesa Estrategia',0,1,'2026-08-06 13:33:21'),(238,240,'/public/uploads/productos/prod_6a779accc1d38_1786223308.png','Peluche Gigante 100cm',0,1,'2026-08-06 13:33:21'),(239,241,'/public/uploads/productos/prod_6a779a98b9dd5_1786223256.png','Rompecabezas 1000 Piezas',0,1,'2026-08-06 13:33:21'),(240,242,'/public/uploads/productos/prod_6a779a46e1de7_1786223174.png','Pista de Carreras Electrónica',0,1,'2026-08-06 13:33:21'),(241,243,'/public/uploads/productos/prod_6a779a1c62855_1786223132.png','Kit de Ciencia para Niños',0,1,'2026-08-06 13:33:21'),(242,244,'/public/uploads/productos/prod_6a7799e6c96d0_1786223078.png','Triciclo Plegable Infantil',0,1,'2026-08-06 13:33:21'),(243,245,'/public/uploads/productos/prod_6a7799b115e59_1786223025.png','Jenga de Madera Gigante',0,1,'2026-08-06 13:33:21'),(244,246,'/public/uploads/productos/prod_6a77996896d94_1786222952.png','Figuras de Acción Pack',0,1,'2026-08-06 13:33:21'),(245,247,'/public/uploads/productos/prod_6a779912e0d70_1786222866.png','Casita de Muñecas 3 Pisos',0,1,'2026-08-06 13:33:21'),(246,248,'/public/uploads/productos/prod_6a7798e98777b_1786222825.png','Patineta Doble para Niños',0,1,'2026-08-06 13:33:21'),(247,249,'/public/uploads/productos/prod_6a7798a0c387c_1786222752.png','Lego Clásico 1200 Piezas',0,1,'2026-08-06 13:33:21'),(248,250,'/public/uploads/productos/prod_6a779873121b8_1786222707.png','Videojuego Deportivo Pack',0,1,'2026-08-06 13:33:21'),(249,251,'/public/uploads/productos/prod_6a779802e4b15_1786222594.png','Dron para Niños con Cámara',0,1,'2026-08-06 13:33:21'),(250,252,'/public/uploads/productos/prod_6a7797b4cd047_1786222516.png','Set de Aeróbicos Infantil',0,1,'2026-08-06 13:33:21'),(251,11,'/public/uploads/productos/prod_6a77b53ceac0d_1786230076.png','iPhone 17 Pro Max',0,1,'2026-08-08 23:01:17');
/*!40000 ALTER TABLE `imagenes_productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs_acceso`
--

DROP TABLE IF EXISTS `logs_acceso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs_acceso` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `accion` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `resultado` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_usuario` (`usuario_id`),
  KEY `idx_fecha` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs_acceso`
--

LOCK TABLES `logs_acceso` WRITE;
/*!40000 ALTER TABLE `logs_acceso` DISABLE KEYS */;
INSERT INTO `logs_acceso` VALUES (1,5,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 OPR/133.0.0.0','login_success','Login exitoso','2026-07-30 00:47:06'),(2,5,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 OPR/133.0.0.0','logout','Sesión cerrada','2026-07-30 00:50:49'),(3,5,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 OPR/133.0.0.0','forgot_password','Fallo envío correo','2026-07-30 00:50:56'),(4,5,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 OPR/133.0.0.0','login_fail','Password incorrecto (intento 1)','2026-07-30 00:55:42'),(5,5,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 OPR/133.0.0.0','login_success','Login exitoso','2026-07-30 00:55:47'),(6,5,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 OPR/133.0.0.0','forgot_password','Fallo envío correo','2026-07-30 02:04:03'),(7,5,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 OPR/133.0.0.0','forgot_password','Correo enviado','2026-07-30 02:10:42'),(8,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-07-31 05:30:51'),(9,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-07-31 05:31:50'),(10,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-07-31 05:32:06'),(11,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-07-31 05:32:37'),(12,2,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-07-31 05:32:47'),(13,2,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-07-31 05:34:05'),(14,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','forgot_password','Correo enviado','2026-07-31 05:34:36'),(15,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_fail','Password incorrecto (intento 1)','2026-08-01 00:44:37'),(16,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-01 00:44:50'),(17,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-01 00:45:20'),(18,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-01 00:45:29'),(19,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-01 00:46:05'),(20,2,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_fail','Password incorrecto (intento 1)','2026-08-01 00:46:13'),(21,2,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-01 00:46:19'),(22,2,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-01 00:47:10'),(23,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_fail','Password incorrecto (intento 1)','2026-08-03 02:05:24'),(24,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-03 02:05:30'),(25,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-03 02:06:16'),(26,3,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-03 02:06:29'),(27,3,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-03 03:27:35'),(28,3,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-03 03:28:34'),(29,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-03 03:28:50'),(30,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-03 03:29:34'),(31,3,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-03 03:29:44'),(32,3,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','pago_procesado','Pedido #2 pagado exitosamente','2026-08-03 03:32:21'),(33,3,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-03 03:32:38'),(34,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-03 03:32:45'),(35,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-03 03:34:12'),(36,2,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-03 03:34:22'),(37,2,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-03 03:35:10'),(38,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','forgot_password','Correo enviado','2026-08-03 03:35:34'),(39,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','reset_password_success','Contraseña restablecida exitosamente','2026-08-03 03:35:59'),(40,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_fail','Password incorrecto (intento 1)','2026-08-04 13:21:20'),(41,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-04 13:21:21'),(42,1,'::1','curl/8.21.0','login_fail','Password incorrecto (intento 1)','2026-08-04 13:54:02'),(43,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-04 14:23:24'),(44,3,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-04 14:23:33'),(45,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-04 16:05:00'),(46,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-04 16:06:06'),(47,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-04 16:08:22'),(48,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-05 03:25:50'),(49,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_fail','Password incorrecto (intento 1)','2026-08-06 01:50:20'),(50,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-06 01:50:25'),(51,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','pago_procesado','Pedido #3 pagado exitosamente','2026-08-06 01:50:50'),(52,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','pago_procesado','Pedido #4 pagado exitosamente','2026-08-06 01:51:13'),(53,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-06 02:02:52'),(54,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-06 02:29:26'),(55,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-06 02:30:28'),(56,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-06 02:30:39'),(57,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-06 02:30:55'),(58,2,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-06 02:31:04'),(59,2,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-06 02:32:38'),(60,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-06 02:32:46'),(61,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-06 02:33:58'),(62,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-06 02:34:08'),(63,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-06 02:35:58'),(64,2,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-06 02:36:06'),(65,2,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-06 02:37:18'),(66,2,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_fail','Password incorrecto (intento 1)','2026-08-06 13:03:23'),(67,2,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-06 13:03:27'),(68,2,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-06 13:34:20'),(69,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-06 13:34:28'),(70,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-06 13:37:46'),(71,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-06 13:37:54'),(72,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-06 13:48:47'),(73,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-06 23:09:02'),(74,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-06 23:12:35'),(75,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_fail','Password incorrecto (intento 1)','2026-08-06 23:12:44'),(76,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','forgot_password','Correo enviado','2026-08-06 23:18:22'),(77,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-06 23:19:13'),(78,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-06 23:20:22'),(79,2,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-06 23:20:32'),(80,2,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-06 23:21:35'),(81,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-06 23:21:42'),(82,4,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','logout','Sesión cerrada','2026-08-06 23:21:59'),(83,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_fail','Password incorrecto (intento 1)','2026-08-08 20:53:26'),(84,1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','login_success','Login exitoso','2026-08-08 20:53:31');
/*!40000 ALTER TABLE `logs_acceso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs_sistema`
--

DROP TABLE IF EXISTS `logs_sistema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs_sistema` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nivel` enum('info','warning','error','critical') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `mensaje` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `archivo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `linea` int DEFAULT NULL,
  `trace` json DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usuario_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_nivel` (`nivel`),
  KEY `idx_fecha` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs_sistema`
--

LOCK TABLES `logs_sistema` WRITE;
/*!40000 ALTER TABLE `logs_sistema` DISABLE KEYS */;
/*!40000 ALTER TABLE `logs_sistema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mensajes`
--

DROP TABLE IF EXISTS `mensajes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mensajes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `conversacion_id` int NOT NULL,
  `remitente_id` int NOT NULL,
  `remitente_tipo` enum('cliente','vendedor','admin') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `mensaje` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `adjunto_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `leido` tinyint(1) DEFAULT '0',
  `fecha_lectura` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_conversacion` (`conversacion_id`),
  KEY `idx_leido` (`leido`),
  KEY `idx_mensajes_conversacion_fecha` (`conversacion_id`,`created_at`),
  CONSTRAINT `mensajes_ibfk_1` FOREIGN KEY (`conversacion_id`) REFERENCES `conversaciones` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mensajes`
--

LOCK TABLES `mensajes` WRITE;
/*!40000 ALTER TABLE `mensajes` DISABLE KEYS */;
INSERT INTO `mensajes` VALUES (1,1,1,'cliente','Hola, estoy interesado en Auriculares Bluetooth Pro. ¿Podrías darme más información?',NULL,0,NULL,'2026-07-24 19:55:11'),(2,2,1,'cliente','Hola, estoy interesado en Auriculares Bluetooth Pro. ¿Podrías darme más información?',NULL,0,NULL,'2026-07-24 19:55:18'),(3,2,1,'cliente','hola',NULL,0,NULL,'2026-07-24 19:55:30'),(4,2,2,'vendedor','buenas',NULL,0,NULL,'2026-07-24 19:55:50'),(5,2,2,'vendedor','son tal y tal',NULL,0,NULL,'2026-07-24 19:56:09'),(6,3,2,'cliente','Hola, estoy interesado en Smartwatch Deportivo X200. ¿Podrías darme más información?',NULL,0,NULL,'2026-07-24 20:06:30'),(7,4,3,'cliente','Hola, estoy interesado en Casita de Muñecas 3 Pisos. ¿Podrías darme más información?',NULL,0,NULL,'2026-08-06 23:20:06'),(8,4,4,'cliente','hola quisiera saber de esa muñecota',NULL,0,NULL,'2026-08-06 23:20:16'),(9,4,2,'vendedor','no se de que habla',NULL,0,NULL,'2026-08-06 23:21:32');
/*!40000 ALTER TABLE `mensajes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metodos_envio`
--

DROP TABLE IF EXISTS `metodos_envio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metodos_envio` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `costo_base` decimal(12,2) DEFAULT '0.00',
  `costo_por_kg` decimal(12,2) DEFAULT '0.00',
  `tiempo_entrega_dias` int DEFAULT '3',
  `activo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metodos_envio`
--

LOCK TABLES `metodos_envio` WRITE;
/*!40000 ALTER TABLE `metodos_envio` DISABLE KEYS */;
INSERT INTO `metodos_envio` VALUES (1,'Estándar','STD','Envío estándar de 3-5 días',50.00,10.00,5,1,'2026-07-23 14:47:29','2026-07-23 14:47:29'),(2,'Express','EXP','Envío express de 1-2 días',100.00,15.00,2,1,'2026-07-23 14:47:29','2026-07-23 14:47:29'),(3,'Same Day','SD','Entrega el mismo día',200.00,20.00,1,1,'2026-07-23 14:47:29','2026-07-23 14:47:29');
/*!40000 ALTER TABLE `metodos_envio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metodos_pago`
--

DROP TABLE IF EXISTS `metodos_pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metodos_pago` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `activo` tinyint(1) DEFAULT '1',
  `procesador` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `configuracion` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metodos_pago`
--

LOCK TABLES `metodos_pago` WRITE;
/*!40000 ALTER TABLE `metodos_pago` DISABLE KEYS */;
INSERT INTO `metodos_pago` VALUES (1,'Tarjeta de Crédito/Débito','TC','Pago con tarjeta de crédito o débito',1,'Stripe',NULL,'2026-07-23 14:47:29','2026-07-23 14:47:29'),(2,'PayPal','PP','Pago a través de PayPal',1,'PayPal',NULL,'2026-07-23 14:47:29','2026-07-23 14:47:29'),(3,'Transferencia Bancaria','TB','Pago mediante transferencia bancaria',1,'Banco',NULL,'2026-07-23 14:47:29','2026-07-23 14:47:29'),(4,'Pago en Efectivo','EF','Pago en efectivo contra entrega',1,NULL,NULL,'2026-07-23 14:47:29','2026-07-23 14:47:29');
/*!40000 ALTER TABLE `metodos_pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metricas_diarias`
--

DROP TABLE IF EXISTS `metricas_diarias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metricas_diarias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `total_pedidos` int DEFAULT '0',
  `total_ventas` decimal(12,2) DEFAULT '0.00',
  `total_clientes_nuevos` int DEFAULT '0',
  `total_visitas` int DEFAULT '0',
  `total_productos_vendidos` int DEFAULT '0',
  `promedio_valor_pedido` decimal(12,2) DEFAULT '0.00',
  `conversion_rate` decimal(5,2) DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fecha` (`fecha`),
  KEY `idx_fecha` (`fecha`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metricas_diarias`
--

LOCK TABLES `metricas_diarias` WRITE;
/*!40000 ALTER TABLE `metricas_diarias` DISABLE KEYS */;
INSERT INTO `metricas_diarias` VALUES (1,'2026-07-23',0,0.00,3,150,0,0.00,3.50,'2026-07-24 02:55:19','2026-07-24 02:55:19');
/*!40000 ALTER TABLE `metricas_diarias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificaciones`
--

DROP TABLE IF EXISTS `notificaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notificaciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `tipo_id` int NOT NULL,
  `titulo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `mensaje` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `leido` tinyint(1) DEFAULT '0',
  `fecha_lectura` datetime DEFAULT NULL,
  `prioridad` enum('baja','media','alta') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'media',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `tipo_id` (`tipo_id`),
  KEY `idx_usuario` (`usuario_id`),
  KEY `idx_leido` (`leido`),
  KEY `idx_notificaciones_usuario_leido` (`usuario_id`,`leido`),
  CONSTRAINT `notificaciones_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  CONSTRAINT `notificaciones_ibfk_2` FOREIGN KEY (`tipo_id`) REFERENCES `tipos_notificaciones` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificaciones`
--

LOCK TABLES `notificaciones` WRITE;
/*!40000 ALTER TABLE `notificaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `notificaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `opciones_pago_guardadas`
--

DROP TABLE IF EXISTS `opciones_pago_guardadas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opciones_pago_guardadas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int NOT NULL,
  `tipo` enum('tarjeta','paypal','transferencia') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `datos_pago` json NOT NULL,
  `predeterminado` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_cliente` (`cliente_id`),
  CONSTRAINT `opciones_pago_guardadas_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `opciones_pago_guardadas`
--

LOCK TABLES `opciones_pago_guardadas` WRITE;
/*!40000 ALTER TABLE `opciones_pago_guardadas` DISABLE KEYS */;
/*!40000 ALTER TABLE `opciones_pago_guardadas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagos`
--

DROP TABLE IF EXISTS `pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pedido_id` int NOT NULL,
  `metodo_pago_id` int NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `estado` enum('pendiente','procesando','completado','fallido','reembolsado','cancelado') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pendiente',
  `codigo_transaccion` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `token_pago` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `datos_pago` json DEFAULT NULL,
  `fecha_pago` datetime DEFAULT NULL,
  `fecha_reembolso` datetime DEFAULT NULL,
  `razon_reembolso` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `ip_pago` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pedido_id` (`pedido_id`),
  KEY `metodo_pago_id` (`metodo_pago_id`),
  KEY `idx_pedido` (`pedido_id`),
  KEY `idx_estado` (`estado`),
  KEY `idx_pago_pedido_estado` (`pedido_id`,`estado`),
  CONSTRAINT `pagos_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `pagos_ibfk_2` FOREIGN KEY (`metodo_pago_id`) REFERENCES `metodos_pago` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagos`
--

LOCK TABLES `pagos` WRITE;
/*!40000 ALTER TABLE `pagos` DISABLE KEYS */;
INSERT INTO `pagos` VALUES (1,1,1,1399.98,'completado','TRX-A8D959610439',NULL,NULL,'2026-07-23 22:00:32',NULL,NULL,NULL,NULL,'2026-07-24 04:00:32','2026-07-24 04:00:32'),(2,2,1,26299.98,'completado','TRX-DEC8A1F241E0',NULL,NULL,'2026-08-02 21:32:21',NULL,NULL,NULL,NULL,'2026-08-03 03:32:21','2026-08-03 03:32:21'),(3,3,4,28400.00,'completado','TRX-AD2F5E175221',NULL,NULL,'2026-08-05 19:50:50',NULL,NULL,NULL,NULL,'2026-08-06 01:50:50','2026-08-06 01:50:50'),(4,4,4,5900.00,'completado','TRX-539E366EE2C5',NULL,NULL,'2026-08-05 19:51:13',NULL,NULL,NULL,NULL,'2026-08-06 01:51:13','2026-08-06 01:51:13');
/*!40000 ALTER TABLE `pagos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paises`
--

DROP TABLE IF EXISTS `paises`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paises` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo_telefono` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `moneda` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paises`
--

LOCK TABLES `paises` WRITE;
/*!40000 ALTER TABLE `paises` DISABLE KEYS */;
INSERT INTO `paises` VALUES (1,'México','MX','+52','MXN','2026-07-23 14:47:29'),(2,'Estados Unidos','US','+1','USD','2026-07-23 14:47:29'),(3,'Canadá','CA','+1','CAD','2026-07-23 14:47:29'),(4,'España','ES','+34','EUR','2026-07-23 14:47:29'),(5,'Argentina','AR','+54','ARS','2026-07-23 14:47:29');
/*!40000 ALTER TABLE `paises` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido_items`
--

DROP TABLE IF EXISTS `pedido_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pedido_id` int NOT NULL,
  `producto_id` int NOT NULL,
  `variacion_id` int DEFAULT NULL,
  `cantidad` int NOT NULL,
  `precio_unitario` decimal(12,2) NOT NULL,
  `descuento` decimal(12,2) DEFAULT '0.00',
  `subtotal` decimal(12,2) NOT NULL,
  `estado_item` enum('pendiente','confirmado','preparando','enviado','entregado','cancelado','devuelto') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pendiente',
  PRIMARY KEY (`id`),
  KEY `producto_id` (`producto_id`),
  KEY `variacion_id` (`variacion_id`),
  KEY `idx_pedido` (`pedido_id`),
  CONSTRAINT `pedido_items_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `pedido_items_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`),
  CONSTRAINT `pedido_items_ibfk_3` FOREIGN KEY (`variacion_id`) REFERENCES `variaciones_productos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido_items`
--

LOCK TABLES `pedido_items` WRITE;
/*!40000 ALTER TABLE `pedido_items` DISABLE KEYS */;
INSERT INTO `pedido_items` VALUES (1,1,3,NULL,1,399.99,0.00,399.99,'pendiente'),(2,1,1,NULL,1,999.99,0.00,999.99,'pendiente'),(3,2,1,NULL,1,999.99,0.00,999.99,'pendiente'),(4,2,11,NULL,1,25000.00,0.00,25000.00,'pendiente'),(5,2,3,NULL,1,399.99,0.00,399.99,'pendiente'),(6,3,10,NULL,1,3500.00,0.00,3500.00,'pendiente'),(7,3,11,NULL,1,25000.00,0.00,25000.00,'pendiente'),(8,4,9,NULL,2,3000.00,0.00,6000.00,'pendiente');
/*!40000 ALTER TABLE `pedido_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int NOT NULL,
  `numero_pedido` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` enum('pendiente','confirmado','preparando','enviado','entregado','cancelado','devuelto') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pendiente',
  `estado_pago` enum('pendiente','pagado','fallido','reembolsado') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pendiente',
  `subtotal` decimal(12,2) NOT NULL,
  `descuentos` decimal(12,2) DEFAULT '0.00',
  `impuestos` decimal(12,2) DEFAULT '0.00',
  `costo_envio` decimal(12,2) DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `direccion_envio_id` int DEFAULT NULL,
  `direccion_facturacion_id` int DEFAULT NULL,
  `notas_cliente` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `notas_internas` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_pedido` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_confirmacion` datetime DEFAULT NULL,
  `fecha_envio` datetime DEFAULT NULL,
  `fecha_entrega` datetime DEFAULT NULL,
  `fecha_cancelacion` datetime DEFAULT NULL,
  `razon_cancelacion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tracking_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `transportista` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `numero_pedido` (`numero_pedido`),
  KEY `direccion_envio_id` (`direccion_envio_id`),
  KEY `direccion_facturacion_id` (`direccion_facturacion_id`),
  KEY `idx_cliente` (`cliente_id`),
  KEY `idx_estado` (`estado`),
  KEY `idx_fecha` (`fecha_pedido`),
  KEY `idx_pedidos_cliente_estado` (`cliente_id`,`estado`),
  KEY `idx_pedidos_fecha_estado` (`fecha_pedido`,`estado`),
  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  CONSTRAINT `pedidos_ibfk_2` FOREIGN KEY (`direccion_envio_id`) REFERENCES `direcciones` (`id`),
  CONSTRAINT `pedidos_ibfk_3` FOREIGN KEY (`direccion_facturacion_id`) REFERENCES `direcciones` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (1,2,'ORD-6A62E3605C7E6','confirmado','pagado',1399.98,0.00,0.00,0.00,1399.98,NULL,NULL,NULL,NULL,'2026-07-23 22:00:32','2026-07-23 22:00:32',NULL,NULL,NULL,NULL,NULL,NULL),(2,2,'ORD-6A700BC59719E','confirmado','pagado',26399.98,100.00,0.00,0.00,26299.98,NULL,NULL,NULL,NULL,'2026-08-02 21:32:21',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3,3,'ORD-6A73E87AB8533','confirmado','pagado',28500.00,100.00,0.00,0.00,28400.00,NULL,NULL,NULL,NULL,'2026-08-05 19:50:50',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(4,3,'ORD-6A73E8916D9F0','confirmado','pagado',6000.00,100.00,0.00,0.00,5900.00,NULL,NULL,NULL,NULL,'2026-08-05 19:51:13',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plataformas_pago`
--

DROP TABLE IF EXISTS `plataformas_pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plataformas_pago` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `api_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `api_secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `webhook_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ambiente` enum('test','production') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'test',
  `activo` tinyint(1) DEFAULT '1',
  `configuracion` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plataformas_pago`
--

LOCK TABLES `plataformas_pago` WRITE;
/*!40000 ALTER TABLE `plataformas_pago` DISABLE KEYS */;
INSERT INTO `plataformas_pago` VALUES (1,'Stripe','STRIPE',NULL,NULL,NULL,'test',1,NULL,'2026-07-23 14:47:29','2026-07-23 14:47:29'),(2,'PayPal','PAYPAL',NULL,NULL,NULL,'test',1,NULL,'2026-07-23 14:47:29','2026-07-23 14:47:29'),(3,'Mercado Pago','MERCADO',NULL,NULL,NULL,'test',1,NULL,'2026-07-23 14:47:29','2026-07-23 14:47:29');
/*!40000 ALTER TABLE `plataformas_pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preguntas_productos`
--

DROP TABLE IF EXISTS `preguntas_productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `preguntas_productos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `producto_id` int NOT NULL,
  `cliente_id` int NOT NULL,
  `pregunta` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `respuesta` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_pregunta` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_respuesta` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cliente_id` (`cliente_id`),
  KEY `idx_producto` (`producto_id`),
  CONSTRAINT `preguntas_productos_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `preguntas_productos_ibfk_2` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preguntas_productos`
--

LOCK TABLES `preguntas_productos` WRITE;
/*!40000 ALTER TABLE `preguntas_productos` DISABLE KEYS */;
/*!40000 ALTER TABLE `preguntas_productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `producto_atributos`
--

DROP TABLE IF EXISTS `producto_atributos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `producto_atributos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `producto_id` int NOT NULL,
  `atributo_id` int NOT NULL,
  `valor` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_atributo` (`producto_id`,`atributo_id`),
  KEY `atributo_id` (`atributo_id`),
  CONSTRAINT `producto_atributos_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `producto_atributos_ibfk_2` FOREIGN KEY (`atributo_id`) REFERENCES `atributos_productos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=722 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `producto_atributos`
--

LOCK TABLES `producto_atributos` WRITE;
/*!40000 ALTER TABLE `producto_atributos` DISABLE KEYS */;
INSERT INTO `producto_atributos` VALUES (419,153,1,'Azul'),(420,153,2,'S'),(421,153,3,'LG'),(422,153,4,'Madera'),(423,154,1,'Verde'),(424,154,2,'S'),(425,154,3,'Apple'),(426,154,4,'Cuero'),(427,155,1,'Blanco'),(428,155,2,'XL'),(429,155,3,'Apple'),(430,155,4,'Plástico'),(431,156,1,'Blanco'),(432,156,2,'XL'),(433,157,1,'Verde'),(434,157,4,'Madera'),(435,158,1,'Negro'),(436,158,4,'Vidrio'),(437,159,1,'Negro'),(438,159,2,'M'),(439,159,3,'Sony'),(440,159,4,'Metal'),(441,160,1,'Rojo'),(442,160,3,'Sony'),(443,161,1,'Blanco'),(444,161,4,'Cuero'),(445,162,2,'XL'),(446,162,3,'Xiaomi'),(447,163,1,'Blanco'),(448,163,2,'L'),(449,163,3,'LG'),(450,163,4,'Algodón'),(451,164,3,'Adidas'),(452,164,4,'Plástico'),(453,165,1,'Negro'),(454,165,2,'XXL'),(455,165,3,'Sony'),(456,166,1,'Azul'),(457,166,3,'Sony'),(458,167,1,'Azul'),(459,167,2,'XXL'),(460,167,3,'LG'),(461,168,1,'Negro'),(462,168,2,'L'),(463,168,3,'Apple'),(464,168,4,'Algodón'),(465,169,1,'Negro'),(466,169,2,'S'),(467,169,3,'Xiaomi'),(468,169,4,'Cuero'),(469,170,1,'Blanco'),(470,170,3,'Apple'),(475,172,1,'Rojo'),(476,172,3,'Sony'),(477,173,1,'Blanco'),(478,173,3,'Samsung'),(479,173,4,'Vidrio'),(480,174,2,'S'),(481,174,4,'Metal'),(482,175,1,'Negro'),(483,175,2,'L'),(484,175,4,'Algodón'),(489,177,1,'Verde'),(490,177,2,'S'),(491,177,3,'Xiaomi'),(492,177,4,'Madera'),(493,178,2,'XXL'),(494,178,4,'Cuero'),(495,179,1,'Gris'),(496,179,2,'S'),(497,179,3,'Nike'),(498,179,4,'Metal'),(499,180,3,'LG'),(500,180,4,'Madera'),(501,181,1,'Gris'),(502,181,2,'S'),(503,181,4,'Algodón'),(504,182,1,'Negro'),(505,182,2,'L'),(506,182,3,'Xiaomi'),(507,182,4,'Plástico'),(508,183,2,'XXL'),(509,183,3,'Adidas'),(510,184,1,'Rojo'),(511,184,2,'M'),(512,184,3,'HP'),(513,184,4,'Algodón'),(514,185,1,'Rojo'),(515,185,2,'L'),(516,185,3,'Sony'),(517,186,1,'Gris'),(518,186,2,'L'),(519,186,3,'LG'),(520,186,4,'Madera'),(521,187,1,'Gris'),(522,187,2,'M'),(523,187,3,'HP'),(524,187,4,'Cuero'),(525,188,1,'Gris'),(526,188,2,'XXL'),(527,188,3,'HP'),(528,188,4,'Plástico'),(529,189,1,'Blanco'),(530,189,3,'Xiaomi'),(531,189,4,'Plástico'),(532,190,1,'Gris'),(533,190,2,'S'),(534,190,3,'Sony'),(535,190,4,'Vidrio'),(536,191,1,'Verde'),(537,191,2,'XL'),(538,191,3,'HP'),(539,192,1,'Azul'),(540,192,3,'Adidas'),(541,192,4,'Vidrio'),(542,193,1,'Azul'),(543,193,2,'M'),(544,193,3,'Nike'),(545,193,4,'Cuero'),(546,194,1,'Negro'),(547,194,2,'M'),(548,194,4,'Metal'),(549,195,2,'L'),(550,195,3,'Nike'),(551,195,4,'Metal'),(552,196,2,'S'),(553,196,4,'Cuero'),(554,197,1,'Rojo'),(555,197,4,'Vidrio'),(556,198,1,'Negro'),(557,198,4,'Plástico'),(558,199,1,'Verde'),(559,199,2,'XL'),(560,199,3,'Xiaomi'),(561,200,2,'XL'),(562,200,3,'LG'),(563,201,1,'Verde'),(564,201,3,'LG'),(565,202,2,'M'),(566,202,4,'Plástico'),(567,203,1,'Gris'),(568,203,2,'XXL'),(569,203,3,'Adidas'),(570,203,4,'Madera'),(571,204,1,'Rojo'),(572,204,2,'L'),(573,204,3,'Apple'),(574,204,4,'Vidrio'),(575,205,1,'Rojo'),(576,205,2,'M'),(577,205,3,'Apple'),(578,205,4,'Madera'),(579,206,1,'Rojo'),(580,206,3,'Sony'),(581,207,2,'XL'),(582,207,3,'Sony'),(583,207,4,'Madera'),(584,208,1,'Azul'),(585,208,2,'S'),(586,208,3,'Adidas'),(587,208,4,'Vidrio'),(588,209,1,'Verde'),(589,209,2,'M'),(590,209,3,'LG'),(591,209,4,'Metal'),(592,210,1,'Verde'),(593,210,2,'XXL'),(594,210,3,'Xiaomi'),(595,210,4,'Metal'),(596,211,1,'Blanco'),(597,211,2,'M'),(598,211,3,'Sony'),(599,212,3,'HP'),(600,212,4,'Algodón'),(601,213,1,'Rojo'),(602,213,2,'XL'),(603,214,1,'Rojo'),(604,214,2,'S'),(605,214,3,'Apple'),(606,214,4,'Plástico'),(607,215,1,'Negro'),(608,215,2,'M'),(609,215,3,'HP'),(610,215,4,'Madera'),(611,216,1,'Negro'),(612,216,4,'Metal'),(613,217,1,'Blanco'),(614,217,3,'Adidas'),(615,218,1,'Blanco'),(616,218,2,'L'),(617,219,2,'M'),(618,219,4,'Madera'),(619,220,1,'Rojo'),(620,220,4,'Cuero'),(621,221,2,'XXL'),(622,221,3,'Apple'),(623,222,2,'M'),(624,222,3,'HP'),(625,222,4,'Madera'),(626,223,2,'S'),(627,223,4,'Madera'),(628,224,1,'Blanco'),(629,224,2,'XL'),(630,224,3,'LG'),(631,224,4,'Vidrio'),(632,225,1,'Azul'),(633,225,2,'XL'),(634,225,3,'HP'),(635,225,4,'Madera'),(636,226,1,'Verde'),(637,226,2,'S'),(638,226,3,'Adidas'),(639,226,4,'Madera'),(640,227,1,'Negro'),(641,227,2,'L'),(642,227,3,'HP'),(643,227,4,'Madera'),(644,228,2,'M'),(645,228,4,'Vidrio'),(646,229,1,'Rojo'),(647,229,2,'S'),(648,229,3,'Adidas'),(649,229,4,'Madera'),(650,230,1,'Verde'),(651,230,2,'XL'),(652,230,3,'Xiaomi'),(653,230,4,'Cuero'),(654,231,1,'Verde'),(655,231,3,'Xiaomi'),(656,231,4,'Vidrio'),(657,232,1,'Rojo'),(658,232,2,'L'),(659,232,3,'HP'),(660,232,4,'Metal'),(661,233,1,'Verde'),(662,233,2,'S'),(663,233,3,'Xiaomi'),(664,233,4,'Cuero'),(665,234,2,'M'),(666,234,3,'Apple'),(667,234,4,'Plástico'),(668,235,1,'Negro'),(669,235,2,'L'),(670,235,3,'Adidas'),(671,235,4,'Algodón'),(672,236,1,'Blanco'),(673,236,2,'S'),(674,236,3,'Xiaomi'),(675,236,4,'Cuero'),(676,237,1,'Verde'),(677,237,3,'Apple'),(678,238,1,'Rojo'),(679,238,4,'Vidrio'),(680,239,1,'Verde'),(681,239,3,'Adidas'),(682,239,4,'Metal'),(683,240,1,'Verde'),(684,240,2,'L'),(685,240,3,'Nike'),(686,240,4,'Plástico'),(687,241,1,'Verde'),(688,241,4,'Plástico'),(689,242,1,'Negro'),(690,242,4,'Vidrio'),(691,243,1,'Gris'),(692,243,2,'XXL'),(693,243,3,'Xiaomi'),(694,243,4,'Cuero'),(695,244,1,'Gris'),(696,244,2,'XL'),(697,244,3,'Samsung'),(698,244,4,'Madera'),(699,245,3,'LG'),(700,245,4,'Vidrio'),(701,246,1,'Azul'),(702,246,2,'L'),(703,246,3,'Sony'),(704,246,4,'Metal'),(705,247,1,'Blanco'),(706,247,2,'M'),(707,247,3,'Samsung'),(708,247,4,'Vidrio'),(709,248,2,'XXL'),(710,248,3,'Nike'),(711,248,4,'Madera'),(712,249,1,'Azul'),(713,249,3,'LG'),(714,249,4,'Plástico'),(715,250,2,'XXL'),(716,250,4,'Metal'),(717,251,1,'Negro'),(718,251,2,'XL'),(719,251,4,'Madera'),(720,252,2,'L'),(721,252,3,'Sony');
/*!40000 ALTER TABLE `producto_atributos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `producto_tags`
--

DROP TABLE IF EXISTS `producto_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `producto_tags` (
  `id` int NOT NULL AUTO_INCREMENT,
  `producto_id` int NOT NULL,
  `tag_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_producto_tag` (`producto_id`,`tag_id`),
  KEY `tag_id` (`tag_id`),
  CONSTRAINT `producto_tags_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `producto_tags_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=483 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `producto_tags`
--

LOCK TABLES `producto_tags` WRITE;
/*!40000 ALTER TABLE `producto_tags` DISABLE KEYS */;
INSERT INTO `producto_tags` VALUES (286,153,1),(287,153,7),(288,154,1),(289,154,2),(290,154,4),(291,155,1),(292,155,3),(293,156,2),(294,157,2),(295,157,3),(296,157,7),(297,158,4),(298,159,4),(299,159,7),(300,160,1),(301,160,2),(302,160,6),(303,161,6),(304,161,7),(305,162,2),(306,162,3),(307,162,4),(308,163,2),(309,164,7),(310,165,2),(311,166,1),(312,166,3),(313,166,7),(314,167,3),(315,167,4),(316,168,2),(317,168,4),(318,169,1),(319,169,2),(320,170,3),(324,172,1),(325,172,4),(326,172,7),(327,173,2),(328,173,3),(329,174,2),(330,175,3),(333,177,6),(334,177,7),(335,178,3),(336,178,7),(337,179,6),(338,180,1),(339,180,4),(340,180,7),(341,181,6),(342,182,2),(343,182,4),(344,182,7),(345,183,2),(346,184,6),(347,185,2),(348,186,1),(349,186,3),(350,186,6),(351,187,4),(352,188,6),(353,189,2),(354,189,4),(355,189,7),(356,190,1),(357,190,6),(358,190,7),(359,191,1),(360,191,3),(361,191,4),(362,192,2),(363,192,4),(364,192,6),(365,193,1),(366,193,3),(367,193,4),(368,194,1),(369,194,3),(370,194,7),(371,195,3),(372,195,4),(373,195,6),(374,196,1),(375,197,1),(376,197,2),(377,198,3),(378,198,4),(379,199,1),(380,199,3),(381,199,7),(382,200,3),(383,201,2),(384,201,7),(385,202,3),(386,202,6),(387,202,7),(388,203,3),(389,204,2),(390,204,3),(391,204,7),(392,205,3),(393,205,4),(394,205,6),(395,206,1),(396,206,3),(397,207,1),(398,208,2),(399,209,2),(400,209,3),(401,210,1),(402,210,6),(403,210,7),(404,211,4),(405,211,6),(406,212,1),(407,212,2),(408,212,3),(409,213,1),(410,213,4),(411,214,1),(412,214,2),(413,214,6),(414,215,1),(415,215,2),(416,216,2),(417,216,4),(418,217,4),(419,218,4),(420,218,6),(421,219,2),(422,220,1),(423,220,2),(424,220,7),(425,221,4),(426,221,6),(427,222,1),(428,223,7),(429,224,3),(430,224,4),(431,224,7),(432,225,1),(433,225,2),(434,225,6),(435,226,1),(436,227,2),(437,227,3),(438,227,6),(439,228,6),(440,229,3),(441,230,4),(442,231,3),(443,231,6),(444,232,7),(445,233,1),(446,233,6),(447,234,2),(448,234,7),(449,235,6),(450,236,4),(451,237,2),(452,237,7),(453,238,2),(454,239,1),(455,239,4),(456,240,1),(457,240,2),(458,240,7),(459,241,7),(460,242,2),(461,242,4),(462,242,6),(463,243,7),(464,244,1),(465,244,7),(466,245,3),(467,246,1),(468,246,6),(469,246,7),(470,247,2),(471,247,4),(472,247,7),(473,248,1),(474,248,7),(475,249,3),(476,250,1),(477,250,3),(478,251,3),(479,251,6),(480,252,1),(481,252,3),(482,252,7);
/*!40000 ALTER TABLE `producto_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tienda_id` int NOT NULL,
  `categoria_id` int NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion_corta` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `descripcion_larga` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `sku` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `precio` decimal(12,2) NOT NULL,
  `precio_oferta` decimal(12,2) DEFAULT NULL,
  `costo` decimal(12,2) DEFAULT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `stock_minimo` int DEFAULT '5',
  `stock_maximo` int DEFAULT '1000',
  `peso` decimal(10,2) DEFAULT NULL,
  `ancho` decimal(10,2) DEFAULT NULL,
  `alto` decimal(10,2) DEFAULT NULL,
  `profundidad` decimal(10,2) DEFAULT NULL,
  `estado` enum('activo','inactivo','agotado','descontinuado') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'activo',
  `destacado` tinyint(1) DEFAULT '0',
  `nuevo` tinyint(1) DEFAULT '0',
  `oferta` tinyint(1) DEFAULT '0',
  `calificacion_promedio` decimal(3,2) DEFAULT '0.00',
  `total_vendidos` int DEFAULT '0',
  `visitas` int DEFAULT '0',
  `fecha_publicacion` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  UNIQUE KEY `sku` (`sku`),
  KEY `tienda_id` (`tienda_id`),
  KEY `idx_categoria` (`categoria_id`),
  KEY `idx_precio` (`precio`),
  KEY `idx_estado` (`estado`),
  KEY `idx_destacado` (`destacado`),
  KEY `idx_productos_precio_estado` (`precio`,`estado`),
  KEY `idx_productos_categoria_estado` (`categoria_id`,`estado`),
  CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`tienda_id`) REFERENCES `tiendas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `productos_ibfk_2` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=253 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (1,1,1,'Auriculares Bluetooth Pro','auriculares-bluetooth-pro','Auriculares Bluetooth Pro - Producto de alta calidad','','SKU-DDAE55EB',1299.99,999.99,NULL,48,5,1000,NULL,NULL,NULL,NULL,'agotado',1,1,0,4.00,122,0,'2026-07-23 20:55:19','2026-07-24 02:55:19','2026-08-08 21:38:51'),(2,1,1,'Smartwatch Deportivo X200','smartwatch-deportivo-x200','Smartwatch Deportivo X200 - Producto de alta calidad','','SKU-81723085',2499.99,1999.99,NULL,30,5,1000,NULL,NULL,NULL,NULL,'inactivo',1,0,1,4.00,85,0,'2026-07-23 20:55:19','2026-07-24 02:55:19','2026-08-08 21:38:51'),(3,1,2,'Camiseta Algodon Premium','camiseta-algodon-premium','Camiseta Algodon Premium - Producto de alta calidad','','SKU-697CAB65',399.99,NULL,NULL,98,5,1000,NULL,NULL,NULL,NULL,'activo',0,1,0,3.50,202,0,'2026-07-23 20:55:19','2026-07-24 02:55:19','2026-08-08 21:38:51'),(4,1,3,'Set de Sartenes Antiadherentes','set-de-sartenes-antiadherentes','Set de Sartenes Antiadherentes - Producto de alta calidad','','SKU-CCAAF51E',899.99,749.99,NULL,25,5,1000,NULL,NULL,NULL,NULL,'activo',1,0,1,3.75,45,0,'2026-07-23 20:55:19','2026-07-24 02:55:19','2026-08-08 21:38:51'),(5,1,4,'Bicicleta Mountain Bike 21V','bicicleta-mountain-bike-21v','Bicicleta Mountain Bike 21V - Producto de alta calidad','','SKU-131A6896',5499.99,5000.00,NULL,10,5,1000,NULL,NULL,NULL,NULL,'activo',0,1,1,3.50,12,0,'2026-07-23 20:55:19','2026-07-24 02:55:19','2026-08-08 21:38:51'),(6,1,5,'Consola Videojuegos NextGen','consola-videojuegos-nextgen','Consola Videojuegos NextGen - Producto de alta calidad','','SKU-00B1BB87',8999.99,7999.99,NULL,15,5,1000,NULL,NULL,NULL,NULL,'activo',1,0,1,4.00,30,0,'2026-07-23 20:55:19','2026-07-24 02:55:19','2026-08-08 21:38:51'),(7,1,5,'Mando Xbox Elite Series 2','mando-xbox-elite-series-2','Mando ideal para videojuegos exigentes, fabricación con materiales de alta calidad y múltiples funciones extras útiles para videojuegos.','','MKT-20260726-3131',3600.00,3500.00,NULL,50,5,1000,NULL,NULL,NULL,NULL,'activo',0,1,0,3.83,0,0,'2026-07-26 13:19:32','2026-07-26 19:19:32','2026-08-08 21:38:51'),(8,1,2,'Pulsera','pulsera','Pulseras bonitas','','MKT-20260726-6331',100.00,90.00,NULL,100,5,1000,NULL,NULL,NULL,NULL,'activo',0,1,0,3.00,0,0,'2026-07-26 13:36:31','2026-07-26 19:36:31','2026-08-08 21:38:51'),(9,1,1,'Mando de PlayStation 4','mando-de-playstation-4','Mando de PlayStation 4','Un mando ideal para videojuegos demandantes por su fabricación de alta calidad.','MKT-20260727-1068',3000.00,NULL,NULL,98,5,1000,NULL,NULL,NULL,NULL,'activo',0,1,0,3.80,2,0,'2026-07-27 08:56:37','2026-07-27 14:56:37','2026-08-08 21:38:51'),(10,1,5,'Mando de Play Station 4 X Controller','mando-de-play-station-4-x-controller','Mando de PlayStation 4 X controller','Mando de PlayStation 4, que incluye palancas y mejores joysticck anti drift, ideal para videojuegos de alta demanda o para gamer dedicados.','MKT-20260727-3795',4000.00,3500.00,NULL,99,5,1000,NULL,NULL,NULL,NULL,'activo',0,1,0,3.60,1,0,'2026-07-27 09:00:27','2026-07-27 15:00:27','2026-08-08 21:38:51'),(11,1,1,'iPhone 17 Pro Max','iphone-17-pro-max','iPhone 17 Pro Max','','MKT-20260727-5770',25000.00,NULL,NULL,18,5,1000,NULL,NULL,NULL,NULL,'activo',0,1,0,3.60,2,0,'2026-07-27 09:03:37','2026-07-27 15:03:37','2026-08-08 23:01:17'),(153,1,1,'Auriculares Inalámbricos ANC','auriculares-inal-mbricos-anc','Auriculares Inalámbricos ANC - Producto de alta calidad con garantía. Ideal para uso diario.','Auriculares Inalámbricos ANC. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-001-2479',1200.00,NULL,720.00,16,6,1819,54.70,NULL,NULL,NULL,'activo',0,0,0,3.50,120,1978,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 23:00:41'),(154,1,1,'Teclado Mecánico RGB','teclado-mec-nico-rgb','Teclado Mecánico RGB - Producto de alta calidad con garantía. Ideal para uso diario.','Teclado Mecánico RGB. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-002-2322',850.00,603.50,510.00,230,4,1146,28.51,NULL,NULL,NULL,'activo',0,0,1,4.50,388,1521,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:59:08'),(155,1,1,'Mouse Gamer 16000 DPI','mouse-gamer-16000-dpi','Mouse Gamer 16000 DPI - Producto de alta calidad con garantía. Ideal para uso diario.','Mouse Gamer 16000 DPI. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-003-8392',450.00,345.15,270.00,371,14,937,3.24,NULL,NULL,NULL,'activo',0,0,1,4.00,440,4083,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:58:27'),(156,1,1,'Monitor 27&quot; 144Hz','monitor-27-144hz','Monitor 27&quot; 144Hz - Producto de alta calidad con garantía. Ideal para uso diario.','Monitor 27&quot; 144Hz. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-004-5938',5400.00,NULL,3240.00,424,3,916,48.66,NULL,NULL,NULL,'activo',0,0,0,3.50,75,4084,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 23:00:00'),(157,1,1,'Laptop Ultraligera 14&quot;','laptop-ultraligera-14','Laptop Ultraligera 14&quot; - Producto de alta calidad con garantía. Ideal para uso diario.','Laptop Ultraligera 14&quot;. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-005-0480',14500.00,NULL,8700.00,5,10,1260,137.01,NULL,NULL,NULL,'activo',0,1,0,3.75,321,4743,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:57:25'),(158,1,1,'Disco SSD NVMe 1TB','disco-ssd-nvme-1tb','Disco SSD NVMe 1TB - Producto de alta calidad con garantía. Ideal para uso diario.','Disco SSD NVMe 1TB. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-006-8601',1400.00,NULL,840.00,454,5,1990,118.58,NULL,NULL,NULL,'activo',0,0,0,2.50,16,914,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:56:35'),(159,1,1,'Webcam Full HD 1080p','webcam-full-hd-1080p','Webcam Full HD 1080p - Producto de alta calidad con garantía. Ideal para uso diario.','Webcam Full HD 1080p. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-007-0431',560.00,NULL,336.00,136,12,1001,126.92,NULL,NULL,NULL,'activo',1,1,0,4.25,356,4851,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:55:47'),(160,1,1,'Router WiFi 6 AX3000','router-wifi-6-ax3000','Router WiFi 6 AX3000 - Producto de alta calidad con garantía. Ideal para uso diario.','Router WiFi 6 AX3000. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-008-3622',980.00,NULL,588.00,327,7,535,108.91,NULL,NULL,NULL,'inactivo',0,1,0,3.00,164,2407,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:55:13'),(161,1,1,'Impresora Multifuncional','impresora-multifuncional','Impresora Multifuncional - Producto de alta calidad con garantía. Ideal para uso diario.','Impresora Multifuncional. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-009-5171',2100.00,1665.30,1260.00,139,9,880,30.07,NULL,NULL,NULL,'activo',0,1,1,3.60,425,798,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:54:24'),(162,1,1,'Tablet 10.4&quot; 128GB','tablet-10-4-128gb','Tablet 10.4&quot; 128GB - Producto de alta calidad con garantía. Ideal para uso diario.','Tablet 10.4&quot; 128GB. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-010-6930',3200.00,NULL,1920.00,366,6,850,117.25,NULL,NULL,NULL,'activo',0,0,0,3.80,187,4899,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:53:44'),(163,1,1,'Parlante Bluetooth Portátil','parlante-bluetooth-port-til','Parlante Bluetooth Portátil - Producto de alta calidad con garantía. Ideal para uso diario.','Parlante Bluetooth Portátil. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-011-7352',390.00,NULL,234.00,158,4,798,126.43,NULL,NULL,NULL,'inactivo',0,1,0,4.00,80,3332,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:52:54'),(164,1,1,'Cámara Web 4K','c-mara-web-4k','Cámara Web 4K - Producto de alta calidad con garantía. Ideal para uso diario.','Cámara Web 4K. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-012-5235',780.00,NULL,468.00,351,13,1246,149.04,NULL,NULL,NULL,'activo',1,1,0,3.00,231,1084,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:52:14'),(165,1,1,'Hub USB-C 7 en 1','hub-usb-c-7-en-1','Hub USB-C 7 en 1 - Producto de alta calidad con garantía. Ideal para uso diario.','Hub USB-C 7 en 1. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-013-7695',320.00,NULL,192.00,368,7,1844,7.51,NULL,NULL,NULL,'activo',0,0,0,4.25,453,2028,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:51:38'),(166,1,1,'Soporte Monitor Ergonomico','soporte-monitor-ergonomico','Soporte Monitor Ergonomico - Producto de alta calidad con garantía. Ideal para uso diario.','Soporte Monitor Ergonomico. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-014-8612',280.00,NULL,168.00,212,5,724,100.32,NULL,NULL,NULL,'inactivo',0,0,0,3.33,474,979,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:50:13'),(167,1,1,'Audífonos Over-Ear Pro','aud-fonos-over-ear-pro','Audífonos Over-Ear Pro - Producto de alta calidad con garantía. Ideal para uso diario.','Audífonos Over-Ear Pro. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-015-7626',1500.00,NULL,900.00,337,15,1385,20.48,NULL,NULL,NULL,'activo',0,0,0,2.50,101,4082,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:49:34'),(168,1,1,'Micro SD 256GB','micro-sd-256gb','Micro SD 256GB - Producto de alta calidad con garantía. Ideal para uso diario.','Micro SD 256GB. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-016-6228',180.00,NULL,108.00,315,5,1525,88.43,NULL,NULL,NULL,'activo',0,0,0,4.00,386,3170,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:48:57'),(169,1,1,'Cargador Inalámbrico 15W','cargador-inal-mbrico-15w','Cargador Inalámbrico 15W - Producto de alta calidad con garantía. Ideal para uso diario.','Cargador Inalámbrico 15W. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-017-2887',240.00,NULL,144.00,390,4,1078,75.57,NULL,NULL,NULL,'activo',0,0,0,3.80,207,96,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:48:20'),(170,1,1,'Power Bank 20000mAh','power-bank-20000mah','Power Bank 20000mAh - Producto de alta calidad con garantía. Ideal para uso diario.','Power Bank 20000mAh. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-018-2596',480.00,NULL,288.00,213,15,1073,50.79,NULL,NULL,NULL,'activo',1,0,0,3.50,374,2702,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:47:24'),(172,1,1,'protoboard 400 puntos','licuadora-de-mano-inal-mbrica','protoboard 400 puntos - Producto de alta calidad con garantía. Ideal para uso diario.','protoboard 400 puntos. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-020-0318',260.00,167.70,156.00,174,15,1267,76.97,NULL,NULL,NULL,'activo',0,0,1,3.80,121,3027,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:46:28'),(173,1,2,'Camiseta Premium Algodón','camiseta-premium-algod-n','Camiseta Premium Algodón - Producto de alta calidad con garantía. Ideal para uso diario.','Camiseta Premium Algodón. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-021-1650',180.00,NULL,108.00,274,6,1900,128.80,NULL,NULL,NULL,'activo',0,0,0,3.60,146,275,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:45:00'),(174,1,2,'Jeans Clásicos Slim','jeans-cl-sicos-slim','Jeans Clásicos Slim - Producto de alta calidad con garantía. Ideal para uso diario.','Jeans Clásicos Slim. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-022-3856',420.00,234.78,252.00,486,15,1876,74.41,NULL,NULL,NULL,'activo',1,0,1,3.60,464,988,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:44:19'),(175,1,2,'Chaqueta Impermeable Urbana','chaqueta-impermeable-urbana','Chaqueta Impermeable Urbana - Producto de alta calidad con garantía. Ideal para uso diario.','Chaqueta Impermeable Urbana. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-023-3558',850.00,549.95,510.00,462,11,1455,127.46,NULL,NULL,NULL,'activo',0,0,1,3.50,351,3343,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:43:38'),(177,1,2,'Vestido Elegante Casual','vestido-elegante-casual','Vestido Elegante Casual - Producto de alta calidad con garantía. Ideal para uso diario.','Vestido Elegante Casual. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-025-1909',650.00,344.50,390.00,196,11,886,76.67,NULL,NULL,NULL,'activo',0,0,1,3.50,314,4094,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:42:17'),(178,1,2,'Bolso de Mano Acolchado','bolso-de-mano-acolchado','Bolso de Mano Acolchado - Producto de alta calidad con garantía. Ideal para uso diario.','Bolso de Mano Acolchado. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-026-8116',980.00,NULL,588.00,372,9,1336,34.31,NULL,NULL,NULL,'activo',0,0,0,3.40,238,3197,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:41:34'),(179,1,2,'Reloj Deportivo Chrome','reloj-deportivo-chorome','Reloj Deportivo Chorome - Producto de alta calidad con garantía. Ideal para uso diario.','Reloj Deportivo Chorome. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-027-2651',720.00,NULL,432.00,442,15,1064,135.20,NULL,NULL,NULL,'activo',1,0,0,3.75,151,2900,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:40:54'),(180,1,2,'Gorra Clásica Bordada','gorra-cl-sica-bordada','Gorra Clásica Bordada - Producto de alta calidad con garantía. Ideal para uso diario.','Gorra Clásica Bordada. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-028-6855',150.00,122.40,90.00,323,11,1714,28.50,NULL,NULL,NULL,'inactivo',0,0,1,4.00,479,2566,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:40:04'),(181,1,2,'Bufanda de Lana Suave','bufanda-de-lana-suave','Bufanda de Lana Suave - Producto de alta calidad con garantía. Ideal para uso diario.','Bufanda de Lana Suave. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-029-3363',130.00,NULL,78.00,492,6,700,10.70,NULL,NULL,NULL,'activo',0,1,0,3.50,264,3263,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:39:26'),(182,1,2,'Cinturón de Cuero','cintur-n-de-cuero','Cinturón de Cuero - Producto de alta calidad con garantía. Ideal para uso diario.','Cinturón de Cuero. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-030-1899',190.00,138.32,114.00,179,8,1052,107.54,NULL,NULL,NULL,'activo',0,0,1,3.75,281,305,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:37:38'),(183,1,2,'Camisa Oxford Formal','camisa-oxford-formal','Camisa Oxford Formal - Producto de alta calidad con garantía. Ideal para uso diario.','Camisa Oxford Formal. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-031-4436',380.00,NULL,228.00,376,8,931,129.79,NULL,NULL,NULL,'activo',0,1,0,3.33,297,552,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:34:35'),(184,1,2,'Sudadera con Capucha','sudadera-con-capucha','Sudadera con Capucha - Producto de alta calidad con garantía. Ideal para uso diario.','Sudadera con Capucha. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-032-2002',460.00,NULL,276.00,111,7,1243,13.57,NULL,NULL,NULL,'activo',1,0,0,3.60,371,838,'2026-08-06 07:33:20','2026-08-06 13:33:20','2026-08-08 22:34:01'),(185,1,2,'Pantalón Deportivo Jogger','pantal-n-deportivo-jogger','Pantalón Deportivo Jogger - Producto de alta calidad con garantía. Ideal para uso diario.','Pantalón Deportivo Jogger. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-033-5158',340.00,227.12,204.00,279,12,957,83.17,NULL,NULL,NULL,'activo',0,1,1,3.60,344,4933,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 22:33:24'),(186,1,2,'Traje de Baño Hombre','traje-de-ba-o-hombre','Traje de Baño Hombre - Producto de alta calidad con garantía. Ideal para uso diario.','Traje de Baño Hombre. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-034-7147',280.00,NULL,168.00,143,14,505,113.57,NULL,NULL,NULL,'activo',0,1,0,4.50,227,4993,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 22:32:52'),(187,1,2,'Calcetines Deportivos (Pack)','calcetines-deportivos-pack','Calcetines Deportivos (Pack) - Producto de alta calidad con garantía. Ideal para uso diario.','Calcetines Deportivos (Pack). Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-035-7018',120.00,NULL,72.00,490,8,925,18.86,NULL,NULL,NULL,'activo',0,0,0,2.50,480,2646,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 22:32:04'),(188,1,2,'Gafas de Sol Polarizadas','gafas-de-sol-polarizadas','Gafas de Sol Polarizadas - Producto de alta calidad con garantía. Ideal para uso diario.','Gafas de Sol Polarizadas. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-036-6028',380.00,NULL,228.00,33,10,796,134.48,NULL,NULL,NULL,'activo',1,0,0,4.50,319,4092,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 22:31:15'),(189,1,2,'Cartera Elegante Mujer','cartera-elegante-mujer','Cartera Elegante Mujer - Producto de alta calidad con garantía. Ideal para uso diario.','Cartera Elegante Mujer. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-037-8818',540.00,NULL,324.00,332,6,1437,36.41,NULL,NULL,NULL,'activo',0,1,0,3.50,107,500,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 22:30:44'),(190,1,2,'Falda Midi Plisada','falda-midi-plisada','Falda Midi Plisada - Producto de alta calidad con garantía. Ideal para uso diario.','Falda Midi Plisada. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-038-0339',320.00,255.36,192.00,35,9,1969,74.80,NULL,NULL,NULL,'inactivo',0,0,1,4.25,264,1684,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 22:26:19'),(191,1,2,'Suéter de Lana Premium','su-ter-de-lana-premium','Suéter de Lana Premium - Producto de alta calidad con garantía. Ideal para uso diario.','Suéter de Lana Premium. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-039-7913',520.00,433.16,312.00,156,10,1188,99.63,NULL,NULL,NULL,'activo',0,1,1,2.50,467,1152,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 22:25:09'),(192,1,2,'Zapatos Oxford Cuero','zapatos-oxford-cuero','Zapatos Oxford Cuero - Producto de alta calidad con garantía. Ideal para uso diario.','Zapatos Oxford Cuero. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-040-9837',1100.00,814.00,660.00,32,8,752,119.21,NULL,NULL,NULL,'activo',0,0,1,4.00,129,1120,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 22:24:28'),(193,1,3,'Set de Sartenes Antiadherentes','set-de-sartenes-antiadherentes-1','Set de Sartenes Antiadherentes - Producto de alta calidad con garantía. Ideal para uso diario.','Set de Sartenes Antiadherentes. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-041-2661',980.00,NULL,588.00,459,12,1452,131.09,NULL,NULL,NULL,'inactivo',0,0,0,3.50,157,2748,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 22:23:38'),(194,1,3,'Juego de Ollas 8 Piezas','juego-de-ollas-8-piezas','Juego de Ollas 8 Piezas - Producto de alta calidad con garantía. Ideal para uso diario.','Juego de Ollas 8 Piezas. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-042-4812',1800.00,1035.00,1080.00,75,14,742,25.29,NULL,NULL,NULL,'activo',0,0,1,4.00,168,2010,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 22:22:48'),(195,1,3,'Licuadora 10 Velocidades','licuadora-10-velocidades','Licuadora 10 Velocidades - Producto de alta calidad con garantía. Ideal para uso diario.','Licuadora 10 Velocidades. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-043-1034',480.00,NULL,288.00,236,11,522,130.88,NULL,NULL,NULL,'activo',0,0,0,3.50,332,3619,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 22:22:02'),(196,1,3,'Cafetera Programable 12 Tazas','cafetera-programable-12-tazas','Cafetera Programable 12 Tazas - Producto de alta calidad con garantía. Ideal para uso diario.','Cafetera Programable 12 Tazas. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-044-8582',950.00,627.00,570.00,24,6,1727,34.69,NULL,NULL,NULL,'inactivo',1,0,1,3.75,75,578,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 22:20:46'),(197,1,3,'Lámpara de Mesa LED','l-mpara-de-mesa-led','Lámpara de Mesa LED - Producto de alta calidad con garantía. Ideal para uso diario.','Lámpara de Mesa LED. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-045-0663',350.00,NULL,210.00,334,12,546,62.10,NULL,NULL,NULL,'activo',0,0,0,2.50,108,1907,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 22:20:06'),(198,1,3,'Cortinas Blackout 2.5m','cortinas-blackout-2-5m','Cortinas Blackout 2.5m - Producto de alta calidad con garantía. Ideal para uso diario.','Cortinas Blackout 2.5m. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-046-5109',480.00,341.28,288.00,354,14,1584,91.15,NULL,NULL,NULL,'activo',0,1,1,4.20,125,3377,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 22:19:22'),(199,1,3,'Set de Sábanas Queen','set-de-s-banas-queen','Set de Sábanas Queen - Producto de alta calidad con garantía. Ideal para uso diario.','Set de Sábanas Queen. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-047-0060',650.00,NULL,390.00,426,10,1594,2.79,NULL,NULL,NULL,'activo',0,0,0,3.80,472,3586,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 22:18:38'),(200,1,3,'Tostadora 2 Ranuras','tostadora-2-ranuras','Tostadora 2 Ranuras - Producto de alta calidad con garantía. Ideal para uso diario.','Tostadora 2 Ranuras. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-048-9754',280.00,NULL,168.00,187,12,508,138.42,NULL,NULL,NULL,'activo',0,1,0,3.25,396,3098,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 22:17:51'),(201,1,3,'Batidora de Mano 500W','batidora-de-mano-500w','Batidora de Mano 500W - Producto de alta calidad con garantía. Ideal para uso diario.','Batidora de Mano 500W. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-049-7366',420.00,346.92,252.00,192,7,1949,64.79,NULL,NULL,NULL,'activo',1,1,1,3.80,419,4052,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 22:17:15'),(202,1,3,'Procesador de Alimentos','procesador-de-alimentos','Procesador de Alimentos - Producto de alta calidad con garantía. Ideal para uso diario.','Procesador de Alimentos. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-050-8187',780.00,445.38,468.00,53,14,1580,146.39,NULL,NULL,NULL,'activo',0,1,1,3.50,349,3047,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 22:16:16'),(203,1,3,'Olla de Presión 6L','olla-de-presi-n-6l','Olla de Presión 6L - Producto de alta calidad con garantía. Ideal para uso diario.','Olla de Presión 6L. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-051-9433',890.00,594.52,534.00,313,7,674,118.42,NULL,NULL,NULL,'activo',0,0,1,3.50,252,4875,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 22:15:14'),(204,1,3,'Exprimidor de Cítricos','exprimidor-de-c-tricos','Exprimidor de Cítricos - Producto de alta calidad con garantía. Ideal para uso diario.','Exprimidor de Cítricos. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-052-7050',240.00,149.28,144.00,153,15,765,101.46,NULL,NULL,NULL,'activo',0,0,1,3.80,185,845,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 22:13:20'),(205,1,3,'Juego de Cubiertos 24 Piezas','juego-de-cubiertos-24-piezas','Juego de Cubiertos 24 Piezas - Producto de alta calidad con garantía. Ideal para uso diario.','Juego de Cubiertos 24 Piezas. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-053-5602',320.00,NULL,192.00,302,9,1823,60.44,NULL,NULL,NULL,'inactivo',0,0,0,3.50,461,1888,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 22:12:06'),(206,1,3,'Tabla de Cortar Madera','tabla-de-cortar-madera','Tabla de Cortar Madera - Producto de alta calidad con garantía. Ideal para uso diario.','Tabla de Cortar Madera. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-054-9855',150.00,NULL,90.00,275,11,608,77.23,NULL,NULL,NULL,'activo',0,1,0,4.00,144,1809,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 22:00:01'),(207,1,3,'Termo Acero Inoxidable 1L','termo-acero-inoxidable-1l','Termo Acero Inoxidable 1L - Producto de alta calidad con garantía. Ideal para uso diario.','Termo Acero Inoxidable 1L. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-055-6841',180.00,112.68,108.00,364,5,1014,120.76,NULL,NULL,NULL,'activo',0,1,1,3.60,278,131,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:57:49'),(208,1,3,'Colador de Acero 3 Piezas','colador-de-acero-3-piezas','Colador de Acero 3 Piezas - Producto de alta calidad con garantía. Ideal para uso diario.','Colador de Acero 3 Piezas. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-056-4896',140.00,102.76,84.00,302,9,754,107.50,NULL,NULL,NULL,'inactivo',1,0,1,3.80,45,4615,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:51:18'),(209,1,3,'Organizador de Cocina 4 Niveles','organizador-de-cocina-4-niveles','Organizador de Cocina 4 Niveles - Producto de alta calidad con garantía. Ideal para uso diario.','Organizador de Cocina 4 Niveles. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-057-2128',380.00,NULL,228.00,422,3,1040,115.15,NULL,NULL,NULL,'activo',1,0,0,3.60,280,2884,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:47:17'),(210,1,3,'Freidora de Aire 4L','freidora-de-aire-4l','Freidora de Aire 4L - Producto de alta calidad con garantía. Ideal para uso diario.','Freidora de Aire 4L. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-058-8355',1500.00,NULL,900.00,491,4,1400,123.67,NULL,NULL,NULL,'inactivo',0,1,0,3.33,75,1375,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:46:36'),(211,1,3,'Batidora de Pedestal 900W','batidora-de-pedestal-900w','Batidora de Pedestal 900W - Producto de alta calidad con garantía. Ideal para uso diario.','Batidora de Pedestal 900W. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-059-9238',2200.00,NULL,1320.00,17,6,1988,103.96,NULL,NULL,NULL,'activo',0,1,0,3.75,83,4907,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:45:05'),(212,1,3,'Jarra Eléctrica 2L','jarra-el-ctrica-2l','Jarra Eléctrica 2L - Producto de alta calidad con garantía. Ideal para uso diario.','Jarra Eléctrica 2L. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-060-6690',260.00,195.52,156.00,497,3,1289,115.08,NULL,NULL,NULL,'activo',0,0,1,3.60,132,3983,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:42:47'),(213,1,4,'Bicicleta de Montaña 21V','bicicleta-de-monta-a-21v','Bicicleta de Montaña 21V - Producto de alta calidad con garantía. Ideal para uso diario.','Bicicleta de Montaña 21V. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-061-5702',6800.00,5494.40,4080.00,212,9,955,28.37,NULL,NULL,NULL,'activo',0,1,1,4.00,451,2180,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:42:08'),(214,1,4,'Pesas Ajustables 24kg','pesas-ajustables-24kg','Pesas Ajustables 24kg - Producto de alta calidad con garantía. Ideal para uso diario.','Pesas Ajustables 24kg. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-062-0470',2600.00,1302.60,1560.00,63,12,1670,10.40,NULL,NULL,NULL,'inactivo',1,0,1,4.50,399,1858,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:40:11'),(215,1,4,'Esterilla Yoga Antideslizante','esterilla-yoga-antideslizante','Esterilla Yoga Antideslizante - Producto de alta calidad con garantía. Ideal para uso diario.','Esterilla Yoga Antideslizante. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-063-0019',180.00,NULL,108.00,438,14,1777,17.56,NULL,NULL,NULL,'activo',1,0,0,3.25,441,3376,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:39:32'),(216,1,4,'Balón de Fútbol Oficial','bal-n-de-f-tbol-oficial','Balón de Fútbol Oficial - Producto de alta calidad con garantía. Ideal para uso diario.','Balón de Fútbol Oficial. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-064-2963',320.00,NULL,192.00,132,4,1654,26.29,NULL,NULL,NULL,'inactivo',0,0,0,3.67,313,1502,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(217,1,4,'Cuerda de Saltar Ajustable','cuerda-de-saltar-ajustable','Cuerda de Saltar Ajustable - Producto de alta calidad con garantía. Ideal para uso diario.','Cuerda de Saltar Ajustable. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-065-7697',90.00,NULL,54.00,68,4,1925,99.35,NULL,NULL,NULL,'activo',0,0,0,4.00,260,2542,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(218,1,4,'Mancuernas Neopreno 5kg','mancuernas-neopreno-5kg','Mancuernas Neopreno 5kg - Producto de alta calidad con garantía. Ideal para uso diario.','Mancuernas Neopreno 5kg. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-066-5052',220.00,117.48,132.00,486,12,1733,29.30,NULL,NULL,NULL,'activo',0,0,1,3.50,154,4609,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(219,1,4,'Casco de Bicicleta Aero','casco-de-bicicleta-aero','Casco de Bicicleta Aero - Producto de alta calidad con garantía. Ideal para uso diario.','Casco de Bicicleta Aero. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-067-6262',540.00,355.86,324.00,73,10,1616,51.28,NULL,NULL,NULL,'activo',1,1,1,3.75,177,3423,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(220,1,4,'Rodillera Deportiva','rodillera-deportiva','Rodillera Deportiva - Producto de alta calidad con garantía. Ideal para uso diario.','Rodillera Deportiva. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-068-4595',160.00,129.76,96.00,136,13,722,88.25,NULL,NULL,NULL,'activo',0,0,1,3.50,438,911,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(221,1,4,'Botella Deportiva 750ml','botella-deportiva-750ml','Botella Deportiva 750ml - Producto de alta calidad con garantía. Ideal para uso diario.','Botella Deportiva 750ml. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-069-6395',120.00,78.84,72.00,218,5,919,17.81,NULL,NULL,NULL,'activo',1,0,1,3.80,326,1759,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(222,1,4,'Mochila Senderismo 30L','mochila-senderismo-30l','Mochila Senderismo 30L - Producto de alta calidad con garantía. Ideal para uso diario.','Mochila Senderismo 30L. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-070-7075',680.00,487.56,408.00,423,6,1752,104.88,NULL,NULL,NULL,'inactivo',0,0,1,3.50,103,3596,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(223,1,4,'Guantes de Boxeo 12oz','guantes-de-boxeo-12oz','Guantes de Boxeo 12oz - Producto de alta calidad con garantía. Ideal para uso diario.','Guantes de Boxeo 12oz. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-071-5494',480.00,333.60,288.00,471,14,1506,119.39,NULL,NULL,NULL,'activo',1,0,1,3.33,276,4968,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(224,1,4,'Pesa Rusa 12kg','pesa-rusa-12kg','Pesa Rusa 12kg - Producto de alta calidad con garantía. Ideal para uso diario.','Pesa Rusa 12kg. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-072-7089',480.00,327.36,288.00,343,5,1489,89.40,NULL,NULL,NULL,'inactivo',0,0,1,4.00,246,2521,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(225,1,4,'Banda Elástica Resistencia Set','banda-el-stica-resistencia-set','Banda Elástica Resistencia Set - Producto de alta calidad con garantía. Ideal para uso diario.','Banda Elástica Resistencia Set. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-073-6572',120.00,NULL,72.00,266,5,641,128.76,NULL,NULL,NULL,'activo',1,0,0,3.50,231,4118,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(226,1,4,'Treadmill Plegable 2HP','treadmill-plegable-2hp','Treadmill Plegable 2HP - Producto de alta calidad con garantía. Ideal para uso diario.','Treadmill Plegable 2HP. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-074-3539',9200.00,5915.60,5520.00,497,5,1709,134.27,NULL,NULL,NULL,'inactivo',0,0,1,4.50,329,4158,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(227,1,4,'Bicicleta Estática Magnética','bicicleta-est-tica-magn-tica','Bicicleta Estática Magnética - Producto de alta calidad con garantía. Ideal para uso diario.','Bicicleta Estática Magnética. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-075-4679',5400.00,2883.60,3240.00,452,6,862,30.63,NULL,NULL,NULL,'activo',0,0,1,3.80,198,3246,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:26:11'),(228,1,4,'Raqueta de Tenis Pro','raqueta-de-tenis-pro','Raqueta de Tenis Pro - Producto de alta calidad con garantía. Ideal para uso diario.','Raqueta de Tenis Pro. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-076-2694',980.00,675.22,588.00,97,3,1979,96.68,NULL,NULL,NULL,'activo',1,1,1,3.00,371,4239,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(229,1,4,'Set de Yoga Completo','set-de-yoga-completo','Set de Yoga Completo - Producto de alta calidad con garantía. Ideal para uso diario.','Set de Yoga Completo. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-077-8419',380.00,NULL,228.00,134,3,1767,44.29,NULL,NULL,NULL,'activo',1,1,0,4.25,227,3047,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(230,1,4,'Cronómetro Deportivo','cron-metro-deportivo','Cronómetro Deportivo - Producto de alta calidad con garantía. Ideal para uso diario.','Cronómetro Deportivo. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-078-2325',140.00,106.68,84.00,460,15,756,13.34,NULL,NULL,NULL,'activo',1,0,1,3.60,346,406,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(231,1,4,'Ropa Deportiva Hombre (Set)','ropa-deportiva-hombre-set','Ropa Deportiva Hombre (Set) - Producto de alta calidad con garantía. Ideal para uso diario.','Ropa Deportiva Hombre (Set). Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-079-3269',450.00,NULL,270.00,448,12,1226,118.51,NULL,NULL,NULL,'activo',1,1,0,3.33,357,4110,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(232,1,4,'Zapatillas Trail Running','zapatillas-trail-running','Zapatillas Trail Running - Producto de alta calidad con garantía. Ideal para uso diario.','Zapatillas Trail Running. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-080-0070',1300.00,NULL,780.00,140,9,1470,55.20,NULL,NULL,NULL,'activo',1,1,0,4.00,205,452,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(233,1,5,'Consola de Videojuegos Xbox Serie S','consola-de-videojuegos-nextgen','Consola de Videojuegos NextGen Xbox Serie S - Producto de alta calidad con garantía. Ideal para uso diario.','Consola de Videojuegos NextGen. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-081-7314',12000.00,NULL,5880.00,134,12,847,97.75,NULL,NULL,NULL,'inactivo',1,0,0,3.50,74,2734,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(234,1,5,'Mando Inalámbrico Pro','mando-inal-mbrico-pro','Mando Inalámbrico Pro - Producto de alta calidad con garantía. Ideal para uso diario.','Mando Inalámbrico Pro. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-082-6091',780.00,NULL,468.00,206,14,1406,138.14,NULL,NULL,NULL,'activo',0,0,0,3.50,114,1468,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(235,1,5,'Set de Bloques 500 Piezas','set-de-bloques-500-piezas','Set de Bloques 500 Piezas - Producto de alta calidad con garantía. Ideal para uso diario.','Set de Bloques 500 Piezas. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-083-2856',650.00,NULL,390.00,492,4,1814,67.22,NULL,NULL,NULL,'inactivo',0,0,0,3.67,374,4537,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(236,1,5,'Robot Educativo Programable','robot-educativo-programable','Robot Educativo Programable - Producto de alta calidad con garantía. Ideal para uso diario.','Robot Educativo Programable. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-084-7582',980.00,NULL,588.00,472,12,635,77.30,NULL,NULL,NULL,'inactivo',0,0,0,3.60,351,3814,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(237,1,5,'Muñeca Interactiva 33cm','mu-eca-interactiva-33cm','Muñeca Interactiva 33cm - Producto de alta calidad con garantía. Ideal para uso diario.','Muñeca Interactiva 33cm. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-085-4305',320.00,NULL,192.00,83,15,1494,106.04,NULL,NULL,NULL,'activo',0,0,0,3.80,181,1139,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(238,1,5,'Carro de Control Remoto','carro-de-control-remoto','Carro de Control Remoto - Producto de alta calidad con garantía. Ideal para uso diario.','Carro de Control Remoto. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-086-6734',780.00,NULL,468.00,70,13,1482,105.83,NULL,NULL,NULL,'activo',1,1,0,3.60,202,225,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(239,1,5,'Juego de Mesa Estrategia','juego-de-mesa-estrategia','Juego de Mesa Estrategia - Producto de alta calidad con garantía. Ideal para uso diario.','Juego de Mesa Estrategia. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-087-8590',540.00,442.80,324.00,211,11,604,67.38,NULL,NULL,NULL,'activo',0,0,1,4.00,72,2517,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(240,1,5,'Peluche Gigante 100cm','peluche-gigante-100cm','Peluche Gigante 100cm - Producto de alta calidad con garantía. Ideal para uso diario.','Peluche Gigante 100cm. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-088-3078',460.00,352.82,276.00,416,15,1697,20.70,NULL,NULL,NULL,'activo',0,0,1,3.00,22,3405,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(241,1,5,'Rompecabezas 1000 Piezas Pokemon','rompecabezas-1000-piezas','Rompecabezas 1000 Piezas - Producto de alta calidad con garantía. Ideal para uso diario.','Rompecabezas 1000 Piezas Pokemon. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-089-1266',210.00,NULL,126.00,161,15,1354,30.41,NULL,NULL,NULL,'activo',0,0,0,4.50,309,3953,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(242,1,5,'Pista de Carreras Electrónica','pista-de-carreras-electr-nica','Pista de Carreras Electrónica - Producto de alta calidad con garantía. Ideal para uso diario.','Pista de Carreras Electrónica. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-090-3548',1100.00,631.40,660.00,433,6,1105,50.15,NULL,NULL,NULL,'activo',0,1,1,3.33,296,2166,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(243,1,5,'Kit de Ciencia para Niños','kit-de-ciencia-para-ni-os','Kit de Ciencia para Niños - Producto de alta calidad con garantía. Ideal para uso diario.','Kit de Ciencia para Niños. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-091-0658',440.00,NULL,264.00,347,15,1185,106.69,NULL,NULL,NULL,'activo',0,0,0,3.60,207,4806,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:05:34'),(244,1,5,'Triciclo Plegable Infantil','triciclo-plegable-infantil','Triciclo Plegable Infantil - Producto de alta calidad con garantía. Ideal para uso diario.','Triciclo Plegable Infantil. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-092-9044',890.00,504.63,534.00,91,9,998,31.31,NULL,NULL,NULL,'activo',0,0,1,4.00,475,1845,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(245,1,5,'Jenga de Madera Gigante','jenga-de-madera-gigante','Jenga de Madera Gigante - Producto de alta calidad con garantía. Ideal para uso diario.','Jenga de Madera Gigante. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-093-7154',380.00,NULL,228.00,321,4,831,28.20,NULL,NULL,NULL,'activo',0,0,0,3.50,139,4733,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(246,1,5,'Figuras de Acción Pack','figuras-de-acci-n-pack','Figuras de Acción Pack - Producto de alta calidad con garantía. Ideal para uso diario.','Figuras de Acción Pack. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-094-9291',460.00,NULL,276.00,322,10,1541,119.20,NULL,NULL,NULL,'activo',0,1,0,3.80,343,3673,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(247,1,5,'Casita de Muñecas 3 Pisos','casita-de-mu-ecas-3-pisos','Casita de Muñecas 3 Pisos - Producto de alta calidad con garantía. Ideal para uso diario.','Casita de Muñecas 3 Pisos. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-095-8182',1200.00,992.40,720.00,138,9,982,137.12,NULL,NULL,NULL,'activo',0,0,1,3.50,277,1921,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(248,1,5,'Patineta Doble para Niños','patineta-doble-para-ni-os','Patineta Doble para Niños - Producto de alta calidad con garantía. Ideal para uso diario.','Patineta Doble para Niños. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-096-1678',680.00,557.60,408.00,429,12,1853,71.92,NULL,NULL,NULL,'activo',0,1,1,4.25,4,2145,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(249,1,5,'Lego Clásico 1200 Piezas','lego-cl-sico-1200-piezas','Lego Clásico 1200 Piezas - Producto de alta calidad con garantía. Ideal para uso diario.','Lego Clásico 1200 Piezas. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-097-3104',980.00,NULL,588.00,431,13,1944,84.41,NULL,NULL,NULL,'activo',0,1,0,3.33,213,3714,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(250,1,5,'Videojuego Deportivo Pack','videojuego-deportivo-pack','Videojuego Deportivo Pack - Producto de alta calidad con garantía. Ideal para uso diario.','Videojuego Deportivo Pack. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-098-2031',1500.00,NULL,900.00,201,5,1642,113.89,NULL,NULL,NULL,'activo',1,0,0,2.50,238,3397,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(251,1,5,'Dron para Niños con Cámara','dron-para-ni-os-con-c-mara','Dron para Niños con Cámara - Producto de alta calidad con garantía. Ideal para uso diario.','Dron para Niños con Cámara. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-099-9952',680.00,NULL,408.00,326,12,1201,29.02,NULL,NULL,NULL,'activo',0,0,0,4.25,418,1126,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52'),(252,1,5,'Set de Aeróbicos Infantil','set-de-aer-bicos-infantil','Set de Aeróbicos Infantil - Producto de alta calidad con garantía. Ideal para uso diario.','Set de Aeróbicos Infantil. Producto seleccionado de nuestra tienda oficial. Fabricado con materiales\r\nde primera calidad. Incluye garantía de 12 meses. Envío a todo el país.\r\n\r\nCaracterísticas destacadas:\r\n- Material resistente y duradero\r\n- Envío a todo el país\r\n- Garantía oficial del fabricante','SKU-100-1872',320.00,NULL,192.00,371,8,972,136.93,NULL,NULL,NULL,'activo',0,0,0,3.00,250,989,'2026-08-06 07:33:21','2026-08-06 13:33:21','2026-08-08 21:38:52');
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos_top`
--

DROP TABLE IF EXISTS `productos_top`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos_top` (
  `id` int NOT NULL AUTO_INCREMENT,
  `producto_id` int NOT NULL,
  `periodo` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ventas_totales` int DEFAULT '0',
  `ingresos_totales` decimal(12,2) DEFAULT '0.00',
  `fecha_actualizacion` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_producto` (`producto_id`),
  CONSTRAINT `productos_top_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos_top`
--

LOCK TABLES `productos_top` WRITE;
/*!40000 ALTER TABLE `productos_top` DISABLE KEYS */;
/*!40000 ALTER TABLE `productos_top` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promociones`
--

DROP TABLE IF EXISTS `promociones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promociones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tipo` enum('porcentaje','monto_fijo','envio_gratis','combo') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor` decimal(12,2) NOT NULL,
  `minimo_compra` decimal(12,2) DEFAULT '0.00',
  `maximo_descuento` decimal(12,2) DEFAULT NULL,
  `productos_aplicables` json DEFAULT NULL,
  `categorias_aplicables` json DEFAULT NULL,
  `clientes_aplicables` json DEFAULT NULL,
  `usa_veces` int DEFAULT '1',
  `usa_por_cliente` int DEFAULT '1',
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime NOT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`),
  KEY `idx_codigo` (`codigo`),
  KEY `idx_activo` (`activo`),
  KEY `idx_fechas` (`fecha_inicio`,`fecha_fin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promociones`
--

LOCK TABLES `promociones` WRITE;
/*!40000 ALTER TABLE `promociones` DISABLE KEYS */;
/*!40000 ALTER TABLE `promociones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promociones_aplicadas`
--

DROP TABLE IF EXISTS `promociones_aplicadas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promociones_aplicadas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `promocion_id` int NOT NULL,
  `pedido_id` int NOT NULL,
  `cliente_id` int NOT NULL,
  `monto_descuento` decimal(12,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `promocion_id` (`promocion_id`),
  KEY `cliente_id` (`cliente_id`),
  KEY `idx_pedido` (`pedido_id`),
  CONSTRAINT `promociones_aplicadas_ibfk_1` FOREIGN KEY (`promocion_id`) REFERENCES `promociones` (`id`),
  CONSTRAINT `promociones_aplicadas_ibfk_2` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `promociones_aplicadas_ibfk_3` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promociones_aplicadas`
--

LOCK TABLES `promociones_aplicadas` WRITE;
/*!40000 ALTER TABLE `promociones_aplicadas` DISABLE KEYS */;
/*!40000 ALTER TABLE `promociones_aplicadas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recompensas`
--

DROP TABLE IF EXISTS `recompensas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recompensas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int NOT NULL,
  `puntos` int NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_obtenida` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_expiracion` datetime DEFAULT NULL,
  `usada` tinyint(1) DEFAULT '0',
  `fecha_uso` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cliente` (`cliente_id`),
  CONSTRAINT `recompensas_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recompensas`
--

LOCK TABLES `recompensas` WRITE;
/*!40000 ALTER TABLE `recompensas` DISABLE KEYS */;
/*!40000 ALTER TABLE `recompensas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reseñas_productos`
--

DROP TABLE IF EXISTS `reseñas_productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reseñas_productos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `producto_id` int NOT NULL,
  `cliente_id` int NOT NULL,
  `calificacion` int NOT NULL,
  `titulo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comentario` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `verificado` tinyint(1) DEFAULT '0',
  `aprobado` tinyint(1) DEFAULT '0',
  `likes` int DEFAULT '0',
  `dislikes` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `cliente_id` (`cliente_id`),
  KEY `idx_producto` (`producto_id`),
  KEY `idx_calificacion` (`calificacion`),
  CONSTRAINT `reseñas_productos_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reseñas_productos_ibfk_2` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  CONSTRAINT `reseñas_productos_chk_1` CHECK ((`calificacion` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=398 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reseñas_productos`
--

LOCK TABLES `reseñas_productos` WRITE;
/*!40000 ALTER TABLE `reseñas_productos` DISABLE KEYS */;
INSERT INTO `reseñas_productos` VALUES (1,7,4,5,NULL,'Es un mando bastante bueno lo recomiendo mucho.',0,1,0,0,'2026-07-27 14:53:34','2026-07-27 14:53:34'),(2,1,1,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',1,1,36,1,'2026-07-22 22:10:31','2026-08-08 21:38:51'),(3,1,2,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',1,1,12,1,'2026-01-09 19:24:56','2026-08-08 21:38:51'),(4,1,3,3,'Promedio','Es un producto promedio, cumple pero sin sorprender.',1,1,9,5,'2025-12-16 01:11:26','2026-08-08 21:38:51'),(5,2,4,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,24,1,'2025-12-31 10:46:56','2026-08-08 21:38:51'),(6,2,5,4,'Satisfecho','Buen producto, cumple con lo prometido. La relación calidad precio es justa.',1,1,22,1,'2026-07-25 17:58:23','2026-08-08 21:38:51'),(7,2,1,2,'Regular','Tuve problemas con el producto, la calidad deja mucho que desear.',1,1,5,1,'2026-03-11 00:34:54','2026-08-08 21:38:51'),(8,2,2,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',1,1,19,2,'2026-03-03 23:53:32','2026-08-08 21:38:51'),(9,3,3,3,'Regular','El producto funciona pero la calidad no es la mejor. Por el precio está aceptable.',1,1,30,7,'2026-06-16 08:25:56','2026-08-08 21:38:51'),(10,3,4,4,'Satisfecho','Buen producto, cumple con lo prometido. La relación calidad precio es justa.',0,1,29,1,'2026-01-10 22:18:04','2026-08-08 21:38:51'),(11,4,5,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',0,1,23,6,'2026-02-20 05:43:14','2026-08-08 21:38:51'),(12,4,1,1,'No funciona','No cumple con lo prometido, una pérdida de dinero.',1,1,22,1,'2026-01-14 15:52:53','2026-08-08 21:38:51'),(13,4,2,4,'Buena compra','La calidad es buena por el precio. Lo usaría de nuevo sin dudarlo.',1,1,33,2,'2026-01-17 23:37:23','2026-08-08 21:38:51'),(14,4,3,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',1,1,22,4,'2026-07-01 05:12:08','2026-08-08 21:38:51'),(15,5,4,3,'Más o menos','No está mal, pero hay mejores opciones. Decente para el precio.',1,1,35,6,'2026-07-10 04:56:02','2026-08-08 21:38:51'),(16,5,5,2,'No me convenció','Funciona pero se siente frágil. Esperaba más por el precio.',0,1,19,0,'2026-03-31 15:14:32','2026-08-08 21:38:51'),(17,5,1,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',0,1,14,0,'2025-12-30 03:46:12','2026-08-08 21:38:51'),(18,5,2,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',1,1,27,7,'2026-08-05 08:18:32','2026-08-08 21:38:51'),(19,6,3,3,'Aceptable','Está bien pero esperaba algo mejor según las fotos. Cumple con lo básico.',1,1,1,1,'2026-01-18 23:52:59','2026-08-08 21:38:51'),(20,6,4,5,'Increíble calidad','Llevo un mes usándolo y sigue como nuevo. Definitivamente volveré a comprar.',0,1,26,2,'2026-03-06 12:23:23','2026-08-08 21:38:51'),(21,7,5,4,'Buena compra','La calidad es buena por el precio. Lo usaría de nuevo sin dudarlo.',1,1,8,5,'2026-05-08 16:31:38','2026-08-08 21:38:51'),(22,7,1,2,'No lo recomiendo','Llegó con un pequeño defecto y el material no es resistente.',1,1,44,2,'2025-12-13 05:23:12','2026-08-08 21:38:51'),(23,7,2,5,'Increíble calidad','Llevo un mes usándolo y sigue como nuevo. Definitivamente volveré a comprar.',1,1,36,1,'2026-03-29 02:39:25','2026-08-08 21:38:51'),(24,7,3,3,'Promedio','Es un producto promedio, cumple pero sin sorprender.',0,1,30,2,'2026-06-16 05:10:58','2026-08-08 21:38:51'),(25,7,4,4,'Buena compra','La calidad es buena por el precio. Lo usaría de nuevo sin dudarlo.',1,1,3,8,'2026-03-31 00:04:08','2026-08-08 21:38:51'),(26,8,5,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',0,1,42,1,'2026-07-01 04:47:51','2026-08-08 21:38:51'),(27,8,1,1,'Muy malo','No funciona correctamente, muy decepcionado con la compra.',1,1,38,8,'2026-04-12 14:50:24','2026-08-08 21:38:51'),(28,9,2,4,'Bueno, recomendado','Funciona muy bien, calidad aceptable y llegó en tiempo. Lo recomiendo.',1,1,29,3,'2026-02-02 18:13:43','2026-08-08 21:38:51'),(29,9,3,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',1,1,35,7,'2026-03-15 15:03:33','2026-08-08 21:38:51'),(30,9,4,3,'Regular','El producto funciona pero la calidad no es la mejor. Por el precio está aceptable.',1,1,6,4,'2026-06-01 20:21:09','2026-08-08 21:38:51'),(31,9,5,2,'No me convenció','Funciona pero se siente frágil. Esperaba más por el precio.',1,1,14,2,'2026-02-12 06:19:54','2026-08-08 21:38:51'),(32,9,1,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',1,1,28,3,'2026-05-04 16:20:18','2026-08-08 21:38:51'),(33,10,2,4,'Muy bueno','Muy buen producto, solo le falta un pequeño detalle pero en general excelente.',0,1,34,2,'2026-03-06 17:05:36','2026-08-08 21:38:51'),(34,10,3,3,'Más o menos','No está mal, pero hay mejores opciones. Decente para el precio.',0,1,8,5,'2026-01-20 06:03:02','2026-08-08 21:38:51'),(35,10,4,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',1,1,13,0,'2026-02-21 02:23:40','2026-08-08 21:38:51'),(36,10,5,4,'Bueno, recomendado','Funciona muy bien, calidad aceptable y llegó en tiempo. Lo recomiendo.',1,1,43,5,'2026-01-31 14:59:40','2026-08-08 21:38:51'),(37,10,1,2,'Deficiente','No cumplió mis expectativas. La calidad es inferior a la descripción.',1,1,40,3,'2025-12-31 01:58:09','2026-08-08 21:38:51'),(38,11,2,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',1,1,9,5,'2026-07-27 15:29:55','2026-08-08 21:38:51'),(39,11,3,3,'Más o menos','No está mal, pero hay mejores opciones. Decente para el precio.',1,1,28,1,'2026-06-12 16:06:52','2026-08-08 21:38:51'),(40,11,4,4,'Satisfecho','Buen producto, cumple con lo prometido. La relación calidad precio es justa.',1,1,31,0,'2026-06-03 06:04:43','2026-08-08 21:38:51'),(41,11,5,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,18,4,'2026-05-11 10:43:20','2026-08-08 21:38:51'),(42,11,1,1,'No funciona','No cumple con lo prometido, una pérdida de dinero.',1,1,40,4,'2026-02-08 13:35:02','2026-08-08 21:38:51'),(43,153,2,4,'Muy bueno','Muy buen producto, solo le falta un pequeño detalle pero en general excelente.',0,1,38,3,'2026-03-17 03:25:35','2026-08-08 21:38:51'),(44,153,3,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',0,1,38,8,'2026-03-30 12:10:45','2026-08-08 21:38:51'),(45,153,4,3,'Más o menos','No está mal, pero hay mejores opciones. Decente para el precio.',1,1,20,1,'2026-02-27 19:16:51','2026-08-08 21:38:51'),(46,153,5,2,'Deficiente','No cumplió mis expectativas. La calidad es inferior a la descripción.',1,1,3,3,'2026-01-21 08:50:39','2026-08-08 21:38:51'),(47,154,1,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',1,1,31,2,'2026-03-04 16:36:12','2026-08-08 21:38:51'),(48,154,2,4,'Muy bueno','Muy buen producto, solo le falta un pequeño detalle pero en general excelente.',0,1,38,1,'2026-01-16 18:26:29','2026-08-08 21:38:51'),(49,155,3,3,'Normal','Cumple su función pero le falta terminación. Llegó bien empaquetado.',1,1,5,1,'2026-04-20 04:08:28','2026-08-08 21:38:51'),(50,155,4,5,'Increíble calidad','Llevo un mes usándolo y sigue como nuevo. Definitivamente volveré a comprar.',1,1,21,8,'2026-08-04 06:15:55','2026-08-08 21:38:51'),(51,155,5,4,'Muy bueno','Muy buen producto, solo le falta un pequeño detalle pero en general excelente.',1,1,2,4,'2026-06-20 01:13:45','2026-08-08 21:38:51'),(52,156,1,2,'No lo recomiendo','Llegó con un pequeño defecto y el material no es resistente.',1,1,37,1,'2026-03-26 11:14:26','2026-08-08 21:38:51'),(53,156,2,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',1,1,29,8,'2025-12-30 12:28:59','2026-08-08 21:38:51'),(54,156,3,3,'Normal','Cumple su función pero le falta terminación. Llegó bien empaquetado.',0,1,44,3,'2026-02-25 13:29:03','2026-08-08 21:38:51'),(55,156,4,4,'Muy bueno','Muy buen producto, solo le falta un pequeño detalle pero en general excelente.',0,1,33,8,'2026-04-02 18:48:36','2026-08-08 21:38:51'),(56,157,5,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',0,1,7,4,'2026-05-15 23:17:01','2026-08-08 21:38:51'),(57,157,1,1,'Defectuoso','Llegó dañado y no funciona como debería. Pésima experiencia.',1,1,12,1,'2026-05-03 20:55:27','2026-08-08 21:38:51'),(58,157,2,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',1,1,45,1,'2026-03-29 18:11:31','2026-08-08 21:38:51'),(59,157,3,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,42,3,'2026-01-24 05:22:52','2026-08-08 21:38:51'),(60,158,4,3,'Promedio','Es un producto promedio, cumple pero sin sorprender.',1,1,1,3,'2025-12-17 18:25:40','2026-08-08 21:38:51'),(61,158,5,2,'No lo recomiendo','Llegó con un pequeño defecto y el material no es resistente.',1,1,13,7,'2026-08-07 16:28:48','2026-08-08 21:38:51'),(62,159,1,5,'Increíble calidad','Llevo un mes usándolo y sigue como nuevo. Definitivamente volveré a comprar.',1,1,24,6,'2026-05-31 05:20:34','2026-08-08 21:38:51'),(63,159,2,4,'Buena compra','La calidad es buena por el precio. Lo usaría de nuevo sin dudarlo.',1,1,25,3,'2026-01-09 18:00:58','2026-08-08 21:38:51'),(64,159,3,3,'Más o menos','No está mal, pero hay mejores opciones. Decente para el precio.',1,1,3,6,'2026-02-23 09:43:43','2026-08-08 21:38:51'),(65,159,4,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,43,3,'2025-12-16 05:59:14','2026-08-08 21:38:51'),(66,160,5,4,'Buena compra','La calidad es buena por el precio. Lo usaría de nuevo sin dudarlo.',1,1,45,7,'2026-07-07 09:00:56','2026-08-08 21:38:51'),(67,160,1,2,'Regular','Tuve problemas con el producto, la calidad deja mucho que desear.',1,1,24,6,'2026-03-24 07:08:14','2026-08-08 21:38:51'),(68,161,2,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',1,1,4,7,'2026-01-19 16:46:36','2026-08-08 21:38:51'),(69,161,3,3,'Regular','El producto funciona pero la calidad no es la mejor. Por el precio está aceptable.',1,1,32,6,'2026-02-21 13:43:27','2026-08-08 21:38:51'),(70,161,4,4,'Muy bueno','Muy buen producto, solo le falta un pequeño detalle pero en general excelente.',0,1,1,7,'2026-05-09 06:17:55','2026-08-08 21:38:51'),(71,161,5,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',1,1,16,1,'2026-03-20 18:32:44','2026-08-08 21:38:51'),(72,161,1,1,'No funciona','No cumple con lo prometido, una pérdida de dinero.',1,1,5,5,'2026-01-27 11:41:37','2026-08-08 21:38:51'),(73,162,2,4,'Bueno, recomendado','Funciona muy bien, calidad aceptable y llegó en tiempo. Lo recomiendo.',1,1,30,5,'2026-06-01 05:55:44','2026-08-08 21:38:51'),(74,162,3,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',0,1,0,4,'2026-03-25 18:04:56','2026-08-08 21:38:51'),(75,162,4,3,'Aceptable','Está bien pero esperaba algo mejor según las fotos. Cumple con lo básico.',0,1,15,2,'2026-07-15 18:00:23','2026-08-08 21:38:51'),(76,162,5,2,'Deficiente','No cumplió mis expectativas. La calidad es inferior a la descripción.',0,1,30,5,'2026-02-25 20:46:46','2026-08-08 21:38:51'),(77,162,1,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',1,1,8,3,'2026-02-28 10:22:02','2026-08-08 21:38:51'),(78,163,2,4,'Muy bueno','Muy buen producto, solo le falta un pequeño detalle pero en general excelente.',1,1,23,1,'2026-03-24 08:54:24','2026-08-08 21:38:51'),(79,163,3,3,'Promedio','Es un producto promedio, cumple pero sin sorprender.',1,1,1,5,'2026-05-06 05:56:06','2026-08-08 21:38:51'),(80,163,4,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',0,1,34,4,'2025-12-15 17:34:31','2026-08-08 21:38:51'),(81,164,5,4,'Bueno, recomendado','Funciona muy bien, calidad aceptable y llegó en tiempo. Lo recomiendo.',1,1,13,1,'2026-06-03 04:29:52','2026-08-08 21:38:51'),(82,164,1,2,'No me convenció','Funciona pero se siente frágil. Esperaba más por el precio.',1,1,3,4,'2026-05-02 10:58:20','2026-08-08 21:38:51'),(83,165,2,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',0,1,40,7,'2026-03-07 02:03:08','2026-08-08 21:38:51'),(84,165,3,3,'Promedio','Es un producto promedio, cumple pero sin sorprender.',0,1,2,6,'2026-01-23 14:54:40','2026-08-08 21:38:51'),(85,165,4,4,'Muy bueno','Muy buen producto, solo le falta un pequeño detalle pero en general excelente.',1,1,26,6,'2025-12-15 21:42:31','2026-08-08 21:38:51'),(86,165,5,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',0,1,8,2,'2026-07-25 02:40:59','2026-08-08 21:38:51'),(87,166,1,1,'Pésimo','La calidad es terrible, no vale la pena. No lo compren.',1,1,33,0,'2026-03-29 00:59:12','2026-08-08 21:38:51'),(88,166,2,4,'Muy bueno','Muy buen producto, solo le falta un pequeño detalle pero en general excelente.',1,1,7,3,'2026-04-29 10:39:22','2026-08-08 21:38:51'),(89,166,3,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',0,1,2,3,'2025-12-14 11:19:08','2026-08-08 21:38:51'),(90,167,4,3,'Más o menos','No está mal, pero hay mejores opciones. Decente para el precio.',1,1,26,1,'2026-05-04 13:42:29','2026-08-08 21:38:51'),(91,167,5,2,'Regular','Tuve problemas con el producto, la calidad deja mucho que desear.',1,1,19,8,'2026-06-22 14:58:56','2026-08-08 21:38:51'),(92,168,1,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',1,1,31,6,'2025-12-18 10:04:34','2026-08-08 21:38:51'),(93,168,2,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',1,1,0,6,'2026-06-14 05:14:35','2026-08-08 21:38:51'),(94,168,3,3,'Regular','El producto funciona pero la calidad no es la mejor. Por el precio está aceptable.',1,1,4,5,'2026-05-09 05:51:05','2026-08-08 21:38:51'),(95,169,4,5,'Increíble calidad','Llevo un mes usándolo y sigue como nuevo. Definitivamente volveré a comprar.',1,1,6,5,'2026-06-03 00:54:03','2026-08-08 21:38:51'),(96,169,5,4,'Muy bueno','Muy buen producto, solo le falta un pequeño detalle pero en general excelente.',1,1,45,6,'2026-03-19 23:39:21','2026-08-08 21:38:51'),(97,169,1,2,'Deficiente','No cumplió mis expectativas. La calidad es inferior a la descripción.',1,1,9,0,'2026-01-29 07:19:59','2026-08-08 21:38:51'),(98,169,2,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',0,1,12,3,'2026-04-21 23:19:30','2026-08-08 21:38:51'),(99,169,3,3,'Más o menos','No está mal, pero hay mejores opciones. Decente para el precio.',0,1,33,5,'2026-02-26 05:34:25','2026-08-08 21:38:51'),(100,170,4,4,'Satisfecho','Buen producto, cumple con lo prometido. La relación calidad precio es justa.',1,1,3,1,'2026-03-04 10:42:49','2026-08-08 21:38:51'),(101,170,5,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',0,1,40,8,'2026-07-08 10:48:24','2026-08-08 21:38:51'),(102,170,1,1,'Defectuoso','Llegó dañado y no funciona como debería. Pésima experiencia.',0,1,11,7,'2026-08-06 22:18:59','2026-08-08 21:38:51'),(103,170,2,4,'Satisfecho','Buen producto, cumple con lo prometido. La relación calidad precio es justa.',1,1,24,5,'2026-01-12 09:01:01','2026-08-08 21:38:51'),(106,172,5,2,'No lo recomiendo','Llegó con un pequeño defecto y el material no es resistente.',1,1,7,6,'2026-02-12 09:01:25','2026-08-08 21:38:51'),(107,172,1,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,2,5,'2026-04-12 04:53:42','2026-08-08 21:38:51'),(108,172,2,4,'Satisfecho','Buen producto, cumple con lo prometido. La relación calidad precio es justa.',1,1,27,8,'2025-12-25 14:15:53','2026-08-08 21:38:51'),(109,172,3,3,'Normal','Cumple su función pero le falta terminación. Llegó bien empaquetado.',1,1,10,7,'2026-01-22 23:29:20','2026-08-08 21:38:51'),(110,172,4,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',1,1,4,0,'2026-01-18 14:53:54','2026-08-08 21:38:51'),(111,173,5,4,'Bueno, recomendado','Funciona muy bien, calidad aceptable y llegó en tiempo. Lo recomiendo.',1,1,13,5,'2026-03-06 15:08:59','2026-08-08 21:38:51'),(112,173,1,2,'No me convenció','Funciona pero se siente frágil. Esperaba más por el precio.',1,1,8,6,'2026-06-28 10:52:10','2026-08-08 21:38:51'),(113,173,2,5,'Increíble calidad','Llevo un mes usándolo y sigue como nuevo. Definitivamente volveré a comprar.',0,1,32,8,'2026-04-24 00:22:57','2026-08-08 21:38:51'),(114,173,3,3,'Promedio','Es un producto promedio, cumple pero sin sorprender.',0,1,11,3,'2025-12-12 11:00:16','2026-08-08 21:38:51'),(115,173,4,4,'Buena compra','La calidad es buena por el precio. Lo usaría de nuevo sin dudarlo.',0,1,24,5,'2026-03-29 20:55:31','2026-08-08 21:38:51'),(116,174,5,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,32,1,'2026-04-29 07:44:50','2026-08-08 21:38:51'),(117,174,1,1,'Defectuoso','Llegó dañado y no funciona como debería. Pésima experiencia.',1,1,36,8,'2026-04-03 20:06:33','2026-08-08 21:38:51'),(118,174,2,4,'Satisfecho','Buen producto, cumple con lo prometido. La relación calidad precio es justa.',1,1,21,7,'2026-03-24 06:57:30','2026-08-08 21:38:51'),(119,174,3,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',1,1,4,6,'2025-12-25 20:27:59','2026-08-08 21:38:51'),(120,174,4,3,'Promedio','Es un producto promedio, cumple pero sin sorprender.',1,1,33,0,'2026-08-06 20:00:05','2026-08-08 21:38:51'),(121,175,5,2,'Regular','Tuve problemas con el producto, la calidad deja mucho que desear.',1,1,33,7,'2026-08-06 22:45:10','2026-08-08 21:38:51'),(122,175,1,5,'Increíble calidad','Llevo un mes usándolo y sigue como nuevo. Definitivamente volveré a comprar.',1,1,38,1,'2026-02-18 22:02:06','2026-08-08 21:38:51'),(123,175,2,4,'Satisfecho','Buen producto, cumple con lo prometido. La relación calidad precio es justa.',1,1,1,6,'2026-08-06 16:24:23','2026-08-08 21:38:51'),(124,175,3,3,'Normal','Cumple su función pero le falta terminación. Llegó bien empaquetado.',1,1,38,0,'2026-04-22 13:39:28','2026-08-08 21:38:51'),(127,177,1,2,'No lo recomiendo','Llegó con un pequeño defecto y el material no es resistente.',1,1,39,6,'2026-02-12 13:04:06','2026-08-08 21:38:51'),(128,177,2,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',0,1,27,6,'2026-03-05 13:51:22','2026-08-08 21:38:51'),(129,178,3,3,'Promedio','Es un producto promedio, cumple pero sin sorprender.',1,1,20,5,'2026-06-04 00:01:31','2026-08-08 21:38:51'),(130,178,4,4,'Bueno, recomendado','Funciona muy bien, calidad aceptable y llegó en tiempo. Lo recomiendo.',0,1,18,8,'2026-06-08 12:31:02','2026-08-08 21:38:51'),(131,178,5,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',1,1,24,2,'2026-05-03 22:07:59','2026-08-08 21:38:51'),(132,178,1,1,'No funciona','No cumple con lo prometido, una pérdida de dinero.',0,1,36,6,'2026-01-03 16:05:54','2026-08-08 21:38:51'),(133,178,2,4,'Satisfecho','Buen producto, cumple con lo prometido. La relación calidad precio es justa.',0,1,18,8,'2026-07-05 23:52:16','2026-08-08 21:38:51'),(134,179,3,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',0,1,8,4,'2026-02-22 20:52:51','2026-08-08 21:38:51'),(135,179,4,3,'Más o menos','No está mal, pero hay mejores opciones. Decente para el precio.',0,1,27,6,'2026-01-16 05:07:15','2026-08-08 21:38:51'),(136,179,5,2,'Regular','Tuve problemas con el producto, la calidad deja mucho que desear.',0,1,5,8,'2026-07-30 00:59:17','2026-08-08 21:38:51'),(137,179,1,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',1,1,31,6,'2026-01-05 07:33:10','2026-08-08 21:38:51'),(138,180,2,4,'Muy bueno','Muy buen producto, solo le falta un pequeño detalle pero en general excelente.',1,1,30,5,'2026-02-25 20:56:51','2026-08-08 21:38:51'),(139,180,3,3,'Promedio','Es un producto promedio, cumple pero sin sorprender.',1,1,23,8,'2026-01-20 21:15:17','2026-08-08 21:38:51'),(140,180,4,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',0,1,21,5,'2026-05-27 11:19:08','2026-08-08 21:38:51'),(141,180,5,4,'Bueno, recomendado','Funciona muy bien, calidad aceptable y llegó en tiempo. Lo recomiendo.',1,1,15,3,'2026-07-26 08:38:31','2026-08-08 21:38:51'),(142,181,1,2,'Regular','Tuve problemas con el producto, la calidad deja mucho que desear.',1,1,40,4,'2026-06-19 16:00:32','2026-08-08 21:38:51'),(143,181,2,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',0,1,8,0,'2026-07-18 15:31:34','2026-08-08 21:38:51'),(144,181,3,3,'Aceptable','Está bien pero esperaba algo mejor según las fotos. Cumple con lo básico.',0,1,39,3,'2026-06-24 02:52:18','2026-08-08 21:38:51'),(145,181,4,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',0,1,11,8,'2026-04-08 01:15:20','2026-08-08 21:38:51'),(146,182,5,5,'Increíble calidad','Llevo un mes usándolo y sigue como nuevo. Definitivamente volveré a comprar.',0,1,45,1,'2026-06-23 17:10:17','2026-08-08 21:38:51'),(147,182,1,1,'Pésimo','La calidad es terrible, no vale la pena. No lo compren.',0,1,13,0,'2026-06-20 11:45:11','2026-08-08 21:38:51'),(148,182,2,4,'Buena compra','La calidad es buena por el precio. Lo usaría de nuevo sin dudarlo.',1,1,7,7,'2026-03-02 13:48:23','2026-08-08 21:38:51'),(149,182,3,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',1,1,45,5,'2026-04-21 09:46:07','2026-08-08 21:38:51'),(150,183,4,3,'Aceptable','Está bien pero esperaba algo mejor según las fotos. Cumple con lo básico.',1,1,24,2,'2026-06-27 04:42:11','2026-08-08 21:38:51'),(151,183,5,2,'No lo recomiendo','Llegó con un pequeño defecto y el material no es resistente.',0,1,41,8,'2026-03-21 19:38:04','2026-08-08 21:38:51'),(152,183,1,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',1,1,16,5,'2026-04-30 10:10:24','2026-08-08 21:38:51'),(153,184,2,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',1,1,30,7,'2026-01-01 17:34:44','2026-08-08 21:38:51'),(154,184,3,3,'Más o menos','No está mal, pero hay mejores opciones. Decente para el precio.',1,1,45,5,'2026-05-31 18:15:48','2026-08-08 21:38:51'),(155,184,4,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,12,4,'2026-04-28 01:12:21','2026-08-08 21:38:51'),(156,184,5,4,'Buena compra','La calidad es buena por el precio. Lo usaría de nuevo sin dudarlo.',0,1,45,5,'2025-12-25 15:55:24','2026-08-08 21:38:51'),(157,184,1,2,'Deficiente','No cumplió mis expectativas. La calidad es inferior a la descripción.',1,1,32,4,'2025-12-18 17:44:28','2026-08-08 21:38:51'),(158,185,2,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',1,1,34,2,'2026-03-01 05:15:21','2026-08-08 21:38:51'),(159,185,3,3,'Promedio','Es un producto promedio, cumple pero sin sorprender.',0,1,18,3,'2026-03-13 13:30:42','2026-08-08 21:38:51'),(160,185,4,4,'Bueno, recomendado','Funciona muy bien, calidad aceptable y llegó en tiempo. Lo recomiendo.',0,1,42,5,'2026-07-13 02:24:10','2026-08-08 21:38:51'),(161,185,5,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,32,4,'2026-06-29 04:32:18','2026-08-08 21:38:51'),(162,185,1,1,'Defectuoso','Llegó dañado y no funciona como debería. Pésima experiencia.',1,1,35,7,'2026-06-27 11:37:00','2026-08-08 21:38:51'),(163,186,2,4,'Buena compra','La calidad es buena por el precio. Lo usaría de nuevo sin dudarlo.',1,1,24,5,'2026-06-30 12:27:11','2026-08-08 21:38:52'),(164,186,3,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,6,8,'2026-01-15 19:20:31','2026-08-08 21:38:52'),(165,187,4,3,'Regular','El producto funciona pero la calidad no es la mejor. Por el precio está aceptable.',1,1,17,3,'2026-02-20 10:59:43','2026-08-08 21:38:52'),(166,187,5,2,'Regular','Tuve problemas con el producto, la calidad deja mucho que desear.',1,1,39,7,'2026-04-04 02:44:15','2026-08-08 21:38:52'),(167,188,1,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',1,1,38,8,'2026-03-14 22:17:28','2026-08-08 21:38:52'),(168,188,2,4,'Muy bueno','Muy buen producto, solo le falta un pequeño detalle pero en general excelente.',1,1,4,8,'2025-12-12 17:28:25','2026-08-08 21:38:52'),(169,189,3,3,'Promedio','Es un producto promedio, cumple pero sin sorprender.',1,1,39,0,'2026-05-03 01:29:54','2026-08-08 21:38:52'),(170,189,4,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',0,1,0,6,'2026-05-09 22:44:22','2026-08-08 21:38:52'),(171,189,5,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',0,1,41,3,'2026-01-23 04:07:35','2026-08-08 21:38:52'),(172,189,1,2,'No lo recomiendo','Llegó con un pequeño defecto y el material no es resistente.',1,1,20,1,'2026-05-14 08:15:09','2026-08-08 21:38:52'),(173,190,2,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',0,1,24,0,'2026-04-04 19:48:10','2026-08-08 21:38:52'),(174,190,3,3,'Aceptable','Está bien pero esperaba algo mejor según las fotos. Cumple con lo básico.',1,1,3,2,'2026-08-02 16:02:44','2026-08-08 21:38:52'),(175,190,4,4,'Satisfecho','Buen producto, cumple con lo prometido. La relación calidad precio es justa.',0,1,3,4,'2026-02-20 12:26:11','2026-08-08 21:38:52'),(176,190,5,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',1,1,45,4,'2026-05-14 20:18:52','2026-08-08 21:38:52'),(177,191,1,1,'Muy malo','No funciona correctamente, muy decepcionado con la compra.',0,1,31,8,'2026-01-09 09:18:14','2026-08-08 21:38:52'),(178,191,2,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',1,1,41,2,'2026-01-20 23:11:51','2026-08-08 21:38:52'),(179,192,3,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',0,1,32,1,'2026-03-15 07:29:52','2026-08-08 21:38:52'),(180,192,4,3,'Promedio','Es un producto promedio, cumple pero sin sorprender.',1,1,22,7,'2026-05-15 17:12:33','2026-08-08 21:38:52'),(181,193,5,2,'No me convenció','Funciona pero se siente frágil. Esperaba más por el precio.',1,1,2,2,'2026-08-07 06:30:06','2026-08-08 21:38:52'),(182,193,1,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',0,1,16,3,'2026-06-23 21:22:31','2026-08-08 21:38:52'),(183,194,2,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',1,1,24,6,'2026-01-23 14:10:28','2026-08-08 21:38:52'),(184,194,3,3,'Regular','El producto funciona pero la calidad no es la mejor. Por el precio está aceptable.',1,1,11,6,'2026-06-06 13:40:40','2026-08-08 21:38:52'),(185,194,4,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',0,1,25,0,'2026-06-07 11:26:51','2026-08-08 21:38:52'),(186,194,5,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',1,1,8,2,'2025-12-24 02:25:42','2026-08-08 21:38:52'),(187,195,1,2,'No me convenció','Funciona pero se siente frágil. Esperaba más por el precio.',1,1,39,5,'2026-05-02 16:53:10','2026-08-08 21:38:52'),(188,195,2,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',1,1,37,4,'2026-04-02 18:13:46','2026-08-08 21:38:52'),(189,195,3,3,'Más o menos','No está mal, pero hay mejores opciones. Decente para el precio.',0,1,13,2,'2026-01-04 14:37:52','2026-08-08 21:38:52'),(190,195,4,4,'Muy bueno','Muy buen producto, solo le falta un pequeño detalle pero en general excelente.',0,1,26,6,'2026-01-08 15:08:46','2026-08-08 21:38:52'),(191,196,5,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',1,1,5,5,'2026-01-02 16:40:33','2026-08-08 21:38:52'),(192,196,1,1,'No funciona','No cumple con lo prometido, una pérdida de dinero.',0,1,12,6,'2026-05-06 22:05:43','2026-08-08 21:38:52'),(193,196,2,4,'Buena compra','La calidad es buena por el precio. Lo usaría de nuevo sin dudarlo.',0,1,3,2,'2026-07-19 02:37:17','2026-08-08 21:38:52'),(194,196,3,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',0,1,40,2,'2026-04-29 12:31:12','2026-08-08 21:38:52'),(195,197,4,3,'Promedio','Es un producto promedio, cumple pero sin sorprender.',1,1,1,1,'2026-05-13 17:56:01','2026-08-08 21:38:52'),(196,197,5,2,'No lo recomiendo','Llegó con un pequeño defecto y el material no es resistente.',1,1,36,3,'2026-02-22 21:18:12','2026-08-08 21:38:52'),(197,198,1,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',1,1,44,7,'2026-04-30 09:54:56','2026-08-08 21:38:52'),(198,198,2,4,'Muy bueno','Muy buen producto, solo le falta un pequeño detalle pero en general excelente.',1,1,16,2,'2026-02-06 09:08:17','2026-08-08 21:38:52'),(199,198,3,3,'Aceptable','Está bien pero esperaba algo mejor según las fotos. Cumple con lo básico.',1,1,11,8,'2026-02-03 16:02:48','2026-08-08 21:38:52'),(200,198,4,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',0,1,44,5,'2026-02-03 18:07:22','2026-08-08 21:38:52'),(201,198,5,4,'Bueno, recomendado','Funciona muy bien, calidad aceptable y llegó en tiempo. Lo recomiendo.',0,1,3,6,'2026-07-13 11:58:06','2026-08-08 21:38:52'),(202,199,1,2,'Deficiente','No cumplió mis expectativas. La calidad es inferior a la descripción.',0,1,45,7,'2026-04-03 16:13:16','2026-08-08 21:38:52'),(203,199,2,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',0,1,35,4,'2026-06-28 03:04:01','2026-08-08 21:38:52'),(204,199,3,3,'Regular','El producto funciona pero la calidad no es la mejor. Por el precio está aceptable.',1,1,7,4,'2025-12-26 04:05:07','2026-08-08 21:38:52'),(205,199,4,4,'Buena compra','La calidad es buena por el precio. Lo usaría de nuevo sin dudarlo.',1,1,21,4,'2026-02-27 00:27:57','2026-08-08 21:38:52'),(206,199,5,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',1,1,5,1,'2026-04-14 12:39:00','2026-08-08 21:38:52'),(207,200,1,1,'Defectuoso','Llegó dañado y no funciona como debería. Pésima experiencia.',1,1,42,6,'2026-04-25 10:46:13','2026-08-08 21:38:52'),(208,200,2,4,'Satisfecho','Buen producto, cumple con lo prometido. La relación calidad precio es justa.',1,1,19,3,'2026-02-15 23:48:06','2026-08-08 21:38:52'),(209,200,3,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,20,3,'2026-06-16 02:56:41','2026-08-08 21:38:52'),(210,200,4,3,'Aceptable','Está bien pero esperaba algo mejor según las fotos. Cumple con lo básico.',1,1,2,3,'2025-12-30 00:52:58','2026-08-08 21:38:52'),(211,201,5,2,'No me convenció','Funciona pero se siente frágil. Esperaba más por el precio.',1,1,31,2,'2026-03-09 23:54:39','2026-08-08 21:38:52'),(212,201,1,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,34,6,'2026-05-29 16:03:40','2026-08-08 21:38:52'),(213,201,2,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',0,1,24,0,'2026-01-31 18:32:10','2026-08-08 21:38:52'),(214,201,3,3,'Aceptable','Está bien pero esperaba algo mejor según las fotos. Cumple con lo básico.',0,1,26,6,'2026-01-23 18:41:51','2026-08-08 21:38:52'),(215,201,4,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',1,1,4,0,'2026-01-29 01:38:20','2026-08-08 21:38:52'),(216,202,5,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',1,1,13,3,'2025-12-13 10:24:06','2026-08-08 21:38:52'),(217,202,1,2,'Deficiente','No cumplió mis expectativas. La calidad es inferior a la descripción.',0,1,24,8,'2026-07-29 08:15:09','2026-08-08 21:38:52'),(218,202,2,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',1,1,26,1,'2026-04-01 13:41:53','2026-08-08 21:38:52'),(219,202,3,3,'Aceptable','Está bien pero esperaba algo mejor según las fotos. Cumple con lo básico.',0,1,15,1,'2026-04-12 10:11:34','2026-08-08 21:38:52'),(220,203,4,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',1,1,26,6,'2026-06-21 13:47:27','2026-08-08 21:38:52'),(221,203,5,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',1,1,13,3,'2026-06-20 02:34:07','2026-08-08 21:38:52'),(222,203,1,1,'Pésimo','La calidad es terrible, no vale la pena. No lo compren.',1,1,30,5,'2026-01-12 13:11:50','2026-08-08 21:38:52'),(223,203,2,4,'Muy bueno','Muy buen producto, solo le falta un pequeño detalle pero en general excelente.',1,1,9,8,'2026-04-16 02:21:56','2026-08-08 21:38:52'),(224,204,3,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',0,1,10,6,'2026-06-22 09:42:50','2026-08-08 21:38:52'),(225,204,4,3,'Aceptable','Está bien pero esperaba algo mejor según las fotos. Cumple con lo básico.',1,1,42,8,'2026-03-21 09:42:47','2026-08-08 21:38:52'),(226,204,5,2,'No me convenció','Funciona pero se siente frágil. Esperaba más por el precio.',0,1,26,8,'2026-08-03 18:02:17','2026-08-08 21:38:52'),(227,204,1,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,5,3,'2026-06-21 06:18:06','2026-08-08 21:38:52'),(228,204,2,4,'Muy bueno','Muy buen producto, solo le falta un pequeño detalle pero en general excelente.',1,1,7,2,'2026-04-02 17:07:59','2026-08-08 21:38:52'),(229,205,3,3,'Más o menos','No está mal, pero hay mejores opciones. Decente para el precio.',1,1,42,4,'2026-07-08 02:42:36','2026-08-08 21:38:52'),(230,205,4,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',0,1,37,2,'2026-02-19 16:33:41','2026-08-08 21:38:52'),(231,205,5,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',1,1,32,6,'2026-05-21 22:06:26','2026-08-08 21:38:52'),(232,205,1,2,'No me convenció','Funciona pero se siente frágil. Esperaba más por el precio.',1,1,35,2,'2026-06-20 04:36:21','2026-08-08 21:38:52'),(233,206,2,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',1,1,16,3,'2025-12-27 14:31:28','2026-08-08 21:38:52'),(234,206,3,3,'Normal','Cumple su función pero le falta terminación. Llegó bien empaquetado.',1,1,45,1,'2026-07-23 20:59:05','2026-08-08 21:38:52'),(235,206,4,4,'Bueno, recomendado','Funciona muy bien, calidad aceptable y llegó en tiempo. Lo recomiendo.',1,1,30,2,'2026-07-03 01:18:18','2026-08-08 21:38:52'),(236,207,5,5,'Increíble calidad','Llevo un mes usándolo y sigue como nuevo. Definitivamente volveré a comprar.',1,1,43,0,'2026-01-08 11:27:44','2026-08-08 21:38:52'),(237,207,1,1,'Muy malo','No funciona correctamente, muy decepcionado con la compra.',1,1,27,0,'2026-03-03 21:16:54','2026-08-08 21:38:52'),(238,207,2,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',0,1,44,7,'2026-06-06 13:33:33','2026-08-08 21:38:52'),(239,207,3,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,29,4,'2026-03-07 02:59:34','2026-08-08 21:38:52'),(240,207,4,3,'Normal','Cumple su función pero le falta terminación. Llegó bien empaquetado.',0,1,19,2,'2026-07-08 12:41:04','2026-08-08 21:38:52'),(241,208,5,2,'Regular','Tuve problemas con el producto, la calidad deja mucho que desear.',0,1,28,7,'2026-03-08 14:19:09','2026-08-08 21:38:52'),(242,208,1,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',1,1,12,1,'2026-02-07 18:23:24','2026-08-08 21:38:52'),(243,208,2,4,'Satisfecho','Buen producto, cumple con lo prometido. La relación calidad precio es justa.',1,1,23,6,'2026-01-17 04:55:16','2026-08-08 21:38:52'),(244,208,3,3,'Normal','Cumple su función pero le falta terminación. Llegó bien empaquetado.',1,1,33,0,'2025-12-23 22:36:01','2026-08-08 21:38:52'),(245,208,4,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',1,1,12,7,'2026-06-15 05:57:50','2026-08-08 21:38:52'),(246,209,5,4,'Bueno, recomendado','Funciona muy bien, calidad aceptable y llegó en tiempo. Lo recomiendo.',1,1,20,7,'2026-06-24 14:45:29','2026-08-08 21:38:52'),(247,209,1,2,'No me convenció','Funciona pero se siente frágil. Esperaba más por el precio.',0,1,34,4,'2026-01-17 03:38:03','2026-08-08 21:38:52'),(248,209,2,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',0,1,24,1,'2026-02-05 04:10:27','2026-08-08 21:38:52'),(249,209,3,3,'Normal','Cumple su función pero le falta terminación. Llegó bien empaquetado.',1,1,27,2,'2026-03-14 17:41:52','2026-08-08 21:38:52'),(250,209,4,4,'Muy bueno','Muy buen producto, solo le falta un pequeño detalle pero en general excelente.',1,1,19,0,'2026-04-05 20:21:47','2026-08-08 21:38:52'),(251,210,5,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',0,1,34,8,'2025-12-25 20:27:03','2026-08-08 21:38:52'),(252,210,1,1,'Pésimo','La calidad es terrible, no vale la pena. No lo compren.',1,1,44,4,'2026-04-15 19:08:14','2026-08-08 21:38:52'),(253,210,2,4,'Bueno, recomendado','Funciona muy bien, calidad aceptable y llegó en tiempo. Lo recomiendo.',1,1,22,3,'2026-05-12 20:45:47','2026-08-08 21:38:52'),(254,211,3,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',0,1,31,5,'2026-06-09 16:41:00','2026-08-08 21:38:52'),(255,211,4,3,'Aceptable','Está bien pero esperaba algo mejor según las fotos. Cumple con lo básico.',1,1,38,4,'2026-04-08 14:12:30','2026-08-08 21:38:52'),(256,211,5,2,'No lo recomiendo','Llegó con un pequeño defecto y el material no es resistente.',0,1,21,1,'2026-02-04 12:58:39','2026-08-08 21:38:52'),(257,211,1,5,'Increíble calidad','Llevo un mes usándolo y sigue como nuevo. Definitivamente volveré a comprar.',1,1,35,4,'2026-01-30 04:58:53','2026-08-08 21:38:52'),(258,212,2,4,'Satisfecho','Buen producto, cumple con lo prometido. La relación calidad precio es justa.',1,1,2,0,'2026-01-21 19:02:00','2026-08-08 21:38:52'),(259,212,3,3,'Normal','Cumple su función pero le falta terminación. Llegó bien empaquetado.',0,1,0,0,'2026-02-16 16:06:06','2026-08-08 21:38:52'),(260,212,4,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',0,1,17,0,'2025-12-12 14:57:14','2026-08-08 21:38:52'),(261,212,5,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',0,1,14,0,'2026-03-05 18:38:42','2026-08-08 21:38:52'),(262,212,1,2,'No me convenció','Funciona pero se siente frágil. Esperaba más por el precio.',1,1,15,8,'2026-04-06 13:39:13','2026-08-08 21:38:52'),(263,213,2,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',0,1,33,4,'2026-06-04 03:36:55','2026-08-08 21:38:52'),(264,213,3,3,'Normal','Cumple su función pero le falta terminación. Llegó bien empaquetado.',1,1,37,2,'2026-02-10 03:33:31','2026-08-08 21:38:52'),(265,214,4,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',1,1,2,6,'2026-06-05 02:52:06','2026-08-08 21:38:52'),(266,214,5,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',1,1,10,0,'2026-05-18 15:31:02','2026-08-08 21:38:52'),(267,215,1,1,'Muy malo','No funciona correctamente, muy decepcionado con la compra.',1,1,25,2,'2026-04-28 20:36:16','2026-08-08 21:38:52'),(268,215,2,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',0,1,42,2,'2026-07-27 08:58:08','2026-08-08 21:38:52'),(269,215,3,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,28,7,'2026-05-15 05:36:09','2026-08-08 21:38:52'),(270,215,4,3,'Normal','Cumple su función pero le falta terminación. Llegó bien empaquetado.',1,1,29,2,'2026-06-08 06:26:32','2026-08-08 21:38:52'),(271,216,5,2,'No lo recomiendo','Llegó con un pequeño defecto y el material no es resistente.',1,1,37,8,'2026-06-08 18:09:15','2026-08-08 21:38:52'),(272,216,1,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',1,1,12,8,'2026-01-04 20:25:21','2026-08-08 21:38:52'),(273,216,2,4,'Satisfecho','Buen producto, cumple con lo prometido. La relación calidad precio es justa.',1,1,6,2,'2026-02-17 10:27:43','2026-08-08 21:38:52'),(274,217,3,3,'Aceptable','Está bien pero esperaba algo mejor según las fotos. Cumple con lo básico.',1,1,0,0,'2026-01-18 00:10:04','2026-08-08 21:38:52'),(275,217,4,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,40,8,'2026-06-08 12:53:05','2026-08-08 21:38:52'),(276,217,5,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',0,1,21,8,'2026-03-24 03:02:01','2026-08-08 21:38:52'),(277,218,1,2,'No me convenció','Funciona pero se siente frágil. Esperaba más por el precio.',0,1,14,4,'2026-03-23 00:22:16','2026-08-08 21:38:52'),(278,218,2,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,36,6,'2026-05-27 05:42:44','2026-08-08 21:38:52'),(279,218,3,3,'Aceptable','Está bien pero esperaba algo mejor según las fotos. Cumple con lo básico.',0,1,1,1,'2026-07-15 23:29:42','2026-08-08 21:38:52'),(280,218,4,4,'Buena compra','La calidad es buena por el precio. Lo usaría de nuevo sin dudarlo.',1,1,5,6,'2026-07-18 03:57:02','2026-08-08 21:38:52'),(281,219,5,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,12,5,'2026-01-08 10:16:43','2026-08-08 21:38:52'),(282,219,1,1,'No funciona','No cumple con lo prometido, una pérdida de dinero.',1,1,22,1,'2026-06-12 19:18:34','2026-08-08 21:38:52'),(283,219,2,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',0,1,4,1,'2026-03-13 21:22:41','2026-08-08 21:38:52'),(284,219,3,5,'Increíble calidad','Llevo un mes usándolo y sigue como nuevo. Definitivamente volveré a comprar.',0,1,6,1,'2026-05-12 23:04:57','2026-08-08 21:38:52'),(285,220,4,3,'Promedio','Es un producto promedio, cumple pero sin sorprender.',1,1,22,1,'2026-08-08 09:23:56','2026-08-08 21:38:52'),(286,220,5,2,'Deficiente','No cumplió mis expectativas. La calidad es inferior a la descripción.',1,1,18,1,'2026-01-02 17:09:29','2026-08-08 21:38:52'),(287,220,1,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',1,1,10,5,'2026-02-25 05:11:05','2026-08-08 21:38:52'),(288,220,2,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',0,1,13,5,'2026-04-02 18:05:22','2026-08-08 21:38:52'),(289,221,3,3,'Más o menos','No está mal, pero hay mejores opciones. Decente para el precio.',1,1,20,4,'2026-05-03 12:49:22','2026-08-08 21:38:52'),(290,221,4,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',1,1,30,1,'2026-04-21 13:33:33','2026-08-08 21:38:52'),(291,221,5,4,'Bueno, recomendado','Funciona muy bien, calidad aceptable y llegó en tiempo. Lo recomiendo.',1,1,30,2,'2026-07-01 23:48:39','2026-08-08 21:38:52'),(292,221,1,2,'Deficiente','No cumplió mis expectativas. La calidad es inferior a la descripción.',1,1,5,8,'2026-07-30 04:46:03','2026-08-08 21:38:52'),(293,221,2,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',1,1,2,6,'2026-07-29 09:52:41','2026-08-08 21:38:52'),(294,222,3,3,'Promedio','Es un producto promedio, cumple pero sin sorprender.',1,1,42,8,'2026-07-06 21:31:59','2026-08-08 21:38:52'),(295,222,4,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',1,1,39,7,'2026-03-08 07:04:52','2026-08-08 21:38:52'),(296,223,5,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',1,1,23,6,'2026-03-22 21:59:07','2026-08-08 21:38:52'),(297,223,1,1,'Muy malo','No funciona correctamente, muy decepcionado con la compra.',0,1,19,7,'2026-02-22 05:10:32','2026-08-08 21:38:52'),(298,223,2,4,'Buena compra','La calidad es buena por el precio. Lo usaría de nuevo sin dudarlo.',0,1,12,7,'2026-02-26 07:18:00','2026-08-08 21:38:52'),(299,224,3,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',1,1,8,2,'2026-08-06 14:49:07','2026-08-08 21:38:52'),(300,224,4,3,'Más o menos','No está mal, pero hay mejores opciones. Decente para el precio.',1,1,21,4,'2026-01-01 06:24:09','2026-08-08 21:38:52'),(301,225,5,2,'No lo recomiendo','Llegó con un pequeño defecto y el material no es resistente.',1,1,22,2,'2026-03-14 12:26:52','2026-08-08 21:38:52'),(302,225,1,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,3,2,'2026-01-15 08:55:22','2026-08-08 21:38:52'),(303,225,2,4,'Bueno, recomendado','Funciona muy bien, calidad aceptable y llegó en tiempo. Lo recomiendo.',1,1,18,8,'2026-02-11 04:51:11','2026-08-08 21:38:52'),(304,225,3,3,'Regular','El producto funciona pero la calidad no es la mejor. Por el precio está aceptable.',0,1,9,8,'2026-07-04 11:15:54','2026-08-08 21:38:52'),(305,226,4,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',1,1,7,3,'2026-04-19 12:14:26','2026-08-08 21:38:52'),(306,226,5,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',1,1,12,2,'2026-06-25 08:17:47','2026-08-08 21:38:52'),(307,227,1,2,'Regular','Tuve problemas con el producto, la calidad deja mucho que desear.',1,1,36,4,'2026-06-04 23:31:06','2026-08-08 21:38:52'),(308,227,2,5,'Increíble calidad','Llevo un mes usándolo y sigue como nuevo. Definitivamente volveré a comprar.',1,1,20,6,'2026-03-06 02:39:39','2026-08-08 21:38:52'),(309,227,3,3,'Más o menos','No está mal, pero hay mejores opciones. Decente para el precio.',0,1,35,2,'2026-02-10 23:42:57','2026-08-08 21:38:52'),(310,227,4,4,'Bueno, recomendado','Funciona muy bien, calidad aceptable y llegó en tiempo. Lo recomiendo.',1,1,41,5,'2026-02-07 04:17:50','2026-08-08 21:38:52'),(311,227,5,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',1,1,18,1,'2026-07-31 10:41:44','2026-08-08 21:38:52'),(312,228,1,1,'Muy malo','No funciona correctamente, muy decepcionado con la compra.',1,1,41,0,'2025-12-24 13:34:44','2026-08-08 21:38:52'),(313,228,2,4,'Satisfecho','Buen producto, cumple con lo prometido. La relación calidad precio es justa.',1,1,18,4,'2026-04-26 14:26:28','2026-08-08 21:38:52'),(314,228,3,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',1,1,34,1,'2025-12-11 21:51:30','2026-08-08 21:38:52'),(315,228,4,3,'Aceptable','Está bien pero esperaba algo mejor según las fotos. Cumple con lo básico.',1,1,33,7,'2026-04-15 00:49:28','2026-08-08 21:38:52'),(316,228,5,2,'No me convenció','Funciona pero se siente frágil. Esperaba más por el precio.',0,1,10,1,'2025-12-27 13:20:17','2026-08-08 21:38:52'),(317,229,1,5,'Increíble calidad','Llevo un mes usándolo y sigue como nuevo. Definitivamente volveré a comprar.',0,1,0,0,'2026-03-22 01:32:54','2026-08-08 21:38:52'),(318,229,2,4,'Satisfecho','Buen producto, cumple con lo prometido. La relación calidad precio es justa.',1,1,4,0,'2026-06-23 16:10:51','2026-08-08 21:38:52'),(319,229,3,3,'Regular','El producto funciona pero la calidad no es la mejor. Por el precio está aceptable.',1,1,12,2,'2026-06-21 17:32:03','2026-08-08 21:38:52'),(320,229,4,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',1,1,2,4,'2026-02-18 19:28:03','2026-08-08 21:38:52'),(321,230,5,4,'Bueno, recomendado','Funciona muy bien, calidad aceptable y llegó en tiempo. Lo recomiendo.',1,1,8,1,'2026-06-02 17:53:01','2026-08-08 21:38:52'),(322,230,1,2,'Deficiente','No cumplió mis expectativas. La calidad es inferior a la descripción.',1,1,32,7,'2026-04-18 08:49:40','2026-08-08 21:38:52'),(323,230,2,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',0,1,18,1,'2026-01-04 08:44:28','2026-08-08 21:38:52'),(324,230,3,3,'Regular','El producto funciona pero la calidad no es la mejor. Por el precio está aceptable.',1,1,21,6,'2026-02-08 01:27:52','2026-08-08 21:38:52'),(325,230,4,4,'Satisfecho','Buen producto, cumple con lo prometido. La relación calidad precio es justa.',1,1,28,5,'2026-02-21 23:23:04','2026-08-08 21:38:52'),(326,231,5,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',1,1,12,3,'2026-07-30 02:36:06','2026-08-08 21:38:52'),(327,231,1,1,'Muy malo','No funciona correctamente, muy decepcionado con la compra.',0,1,6,7,'2026-08-08 17:57:42','2026-08-08 21:38:52'),(328,231,2,4,'Satisfecho','Buen producto, cumple con lo prometido. La relación calidad precio es justa.',1,1,19,5,'2026-01-27 21:41:03','2026-08-08 21:38:52'),(329,232,3,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,34,4,'2026-07-30 09:48:22','2026-08-08 21:38:52'),(330,232,4,3,'Normal','Cumple su función pero le falta terminación. Llegó bien empaquetado.',1,1,4,2,'2026-05-22 05:15:51','2026-08-08 21:38:52'),(331,233,5,2,'No me convenció','Funciona pero se siente frágil. Esperaba más por el precio.',0,1,19,5,'2026-01-22 18:08:42','2026-08-08 21:38:52'),(332,233,1,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',1,1,7,1,'2026-01-25 08:59:37','2026-08-08 21:38:52'),(333,234,2,4,'Satisfecho','Buen producto, cumple con lo prometido. La relación calidad precio es justa.',0,1,19,6,'2025-12-26 14:29:02','2026-08-08 21:38:52'),(334,234,3,3,'Aceptable','Está bien pero esperaba algo mejor según las fotos. Cumple con lo básico.',0,1,14,0,'2026-01-04 10:49:13','2026-08-08 21:38:52'),(335,235,4,5,'Increíble calidad','Llevo un mes usándolo y sigue como nuevo. Definitivamente volveré a comprar.',1,1,21,4,'2026-05-26 18:36:03','2026-08-08 21:38:52'),(336,235,5,4,'Satisfecho','Buen producto, cumple con lo prometido. La relación calidad precio es justa.',0,1,38,6,'2026-02-28 01:54:07','2026-08-08 21:38:52'),(337,235,1,2,'No lo recomiendo','Llegó con un pequeño defecto y el material no es resistente.',0,1,30,2,'2026-04-26 03:11:09','2026-08-08 21:38:52'),(338,236,2,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',1,1,39,1,'2026-08-01 06:17:31','2026-08-08 21:38:52'),(339,236,3,3,'Promedio','Es un producto promedio, cumple pero sin sorprender.',1,1,23,8,'2026-05-05 20:15:08','2026-08-08 21:38:52'),(340,236,4,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',1,1,21,5,'2026-05-13 06:37:30','2026-08-08 21:38:52'),(341,236,5,5,'Increíble calidad','Llevo un mes usándolo y sigue como nuevo. Definitivamente volveré a comprar.',1,1,35,7,'2026-05-08 07:04:04','2026-08-08 21:38:52'),(342,236,1,1,'Pésimo','La calidad es terrible, no vale la pena. No lo compren.',0,1,2,2,'2026-07-27 06:02:25','2026-08-08 21:38:52'),(343,237,2,4,'Bueno, recomendado','Funciona muy bien, calidad aceptable y llegó en tiempo. Lo recomiendo.',1,1,44,5,'2026-02-21 18:05:58','2026-08-08 21:38:52'),(344,237,3,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',1,1,5,0,'2026-06-06 06:37:20','2026-08-08 21:38:52'),(345,237,4,3,'Aceptable','Está bien pero esperaba algo mejor según las fotos. Cumple con lo básico.',1,1,31,5,'2026-03-03 21:00:51','2026-08-08 21:38:52'),(346,237,5,2,'No me convenció','Funciona pero se siente frágil. Esperaba más por el precio.',1,1,17,6,'2025-12-27 22:30:33','2026-08-08 21:38:52'),(347,237,1,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',1,1,32,2,'2026-03-06 03:34:32','2026-08-08 21:38:52'),(348,238,2,4,'Satisfecho','Buen producto, cumple con lo prometido. La relación calidad precio es justa.',0,1,22,7,'2026-08-03 05:58:00','2026-08-08 21:38:52'),(349,238,3,3,'Aceptable','Está bien pero esperaba algo mejor según las fotos. Cumple con lo básico.',0,1,16,2,'2026-04-27 14:43:28','2026-08-08 21:38:52'),(350,238,4,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',1,1,31,6,'2026-06-13 12:16:16','2026-08-08 21:38:52'),(351,238,5,4,'Buena compra','La calidad es buena por el precio. Lo usaría de nuevo sin dudarlo.',1,1,2,2,'2026-05-15 18:55:03','2026-08-08 21:38:52'),(352,238,1,2,'No lo recomiendo','Llegó con un pequeño defecto y el material no es resistente.',0,1,35,5,'2025-12-24 21:53:28','2026-08-08 21:38:52'),(353,239,2,5,'Increíble calidad','Llevo un mes usándolo y sigue como nuevo. Definitivamente volveré a comprar.',1,1,37,2,'2026-01-25 12:28:20','2026-08-08 21:38:52'),(354,239,3,3,'Regular','El producto funciona pero la calidad no es la mejor. Por el precio está aceptable.',0,1,6,0,'2026-03-28 16:56:03','2026-08-08 21:38:52'),(355,239,4,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',1,1,12,8,'2026-03-11 08:47:59','2026-08-08 21:38:52'),(356,240,5,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',0,1,45,2,'2026-05-31 08:43:49','2026-08-08 21:38:52'),(357,240,1,1,'Muy malo','No funciona correctamente, muy decepcionado con la compra.',0,1,27,4,'2026-02-04 16:19:41','2026-08-08 21:38:52'),(358,241,2,4,'Bueno, recomendado','Funciona muy bien, calidad aceptable y llegó en tiempo. Lo recomiendo.',1,1,8,8,'2026-01-01 01:47:00','2026-08-08 21:38:52'),(359,241,3,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',1,1,8,3,'2026-07-26 06:32:32','2026-08-08 21:38:52'),(360,242,4,3,'Normal','Cumple su función pero le falta terminación. Llegó bien empaquetado.',1,1,15,7,'2026-02-14 01:33:03','2026-08-08 21:38:52'),(361,242,5,2,'Deficiente','No cumplió mis expectativas. La calidad es inferior a la descripción.',1,1,40,3,'2026-08-08 04:40:12','2026-08-08 21:38:52'),(362,242,1,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,11,7,'2026-04-17 13:19:50','2026-08-08 21:38:52'),(363,243,2,4,'Cumple su función','Es tal cual la descripción. Le quito una estrella por el tiempo de entrega.',1,1,12,2,'2026-05-19 11:27:56','2026-08-08 21:38:52'),(364,243,3,3,'Regular','El producto funciona pero la calidad no es la mejor. Por el precio está aceptable.',1,1,14,5,'2026-01-20 01:03:15','2026-08-08 21:38:52'),(365,243,4,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',1,1,36,5,'2026-01-10 12:16:03','2026-08-08 21:38:52'),(366,243,5,4,'Bueno, recomendado','Funciona muy bien, calidad aceptable y llegó en tiempo. Lo recomiendo.',1,1,0,1,'2026-07-10 06:14:41','2026-08-08 21:38:52'),(367,243,1,2,'No lo recomiendo','Llegó con un pequeño defecto y el material no es resistente.',1,1,20,4,'2026-06-07 21:59:32','2026-08-08 21:38:52'),(368,244,2,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,38,7,'2026-06-16 16:04:27','2026-08-08 21:38:52'),(369,244,3,3,'Más o menos','No está mal, pero hay mejores opciones. Decente para el precio.',0,1,12,2,'2026-06-18 18:48:49','2026-08-08 21:38:52'),(370,245,4,4,'Buena compra','La calidad es buena por el precio. Lo usaría de nuevo sin dudarlo.',1,1,45,4,'2026-06-03 11:59:22','2026-08-08 21:38:52'),(371,245,5,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',1,1,35,3,'2026-02-27 16:12:38','2026-08-08 21:38:52'),(372,245,1,1,'Muy malo','No funciona correctamente, muy decepcionado con la compra.',1,1,31,1,'2026-08-06 22:19:09','2026-08-08 21:38:52'),(373,245,2,4,'Buena compra','La calidad es buena por el precio. Lo usaría de nuevo sin dudarlo.',1,1,31,8,'2026-01-25 16:34:04','2026-08-08 21:38:52'),(374,246,3,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,15,5,'2026-01-22 09:54:34','2026-08-08 21:38:52'),(375,246,4,3,'Regular','El producto funciona pero la calidad no es la mejor. Por el precio está aceptable.',1,1,21,2,'2026-03-12 07:06:55','2026-08-08 21:38:52'),(376,246,5,2,'Regular','Tuve problemas con el producto, la calidad deja mucho que desear.',1,1,44,2,'2025-12-19 21:28:15','2026-08-08 21:38:52'),(377,246,1,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',1,1,1,8,'2026-04-05 13:07:34','2026-08-08 21:38:52'),(378,246,2,4,'Muy bueno','Muy buen producto, solo le falta un pequeño detalle pero en general excelente.',1,1,11,5,'2026-01-21 08:07:00','2026-08-08 21:38:52'),(379,247,3,3,'Más o menos','No está mal, pero hay mejores opciones. Decente para el precio.',0,1,31,8,'2025-12-30 09:47:50','2026-08-08 21:38:52'),(380,247,4,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',1,1,32,1,'2026-02-04 21:53:07','2026-08-08 21:38:52'),(381,247,5,4,'Muy bueno','Muy buen producto, solo le falta un pequeño detalle pero en general excelente.',1,1,24,3,'2025-12-30 10:53:01','2026-08-08 21:38:52'),(382,247,1,2,'Regular','Tuve problemas con el producto, la calidad deja mucho que desear.',0,1,4,6,'2026-03-03 08:50:59','2026-08-08 21:38:52'),(383,248,2,5,'Súper recomendado','Cumple con la descripción al pie de la letra. La atención del vendedor fue excelente.',1,1,20,3,'2026-08-01 00:58:57','2026-08-08 21:38:52'),(384,248,3,3,'Regular','El producto funciona pero la calidad no es la mejor. Por el precio está aceptable.',1,1,42,8,'2026-03-24 06:40:10','2026-08-08 21:38:52'),(385,248,4,4,'Buena compra','La calidad es buena por el precio. Lo usaría de nuevo sin dudarlo.',0,1,7,8,'2026-03-24 21:11:50','2026-08-08 21:38:52'),(386,248,5,5,'Mejor de lo que esperaba','La calidad es sorprendente, el acabado es premium. Vale cada centavo.',1,1,8,0,'2026-02-09 00:11:46','2026-08-08 21:38:52'),(387,249,1,1,'No funciona','No cumple con lo prometido, una pérdida de dinero.',1,1,36,2,'2026-05-30 22:33:21','2026-08-08 21:38:52'),(388,249,2,4,'Bueno, recomendado','Funciona muy bien, calidad aceptable y llegó en tiempo. Lo recomiendo.',0,1,24,4,'2026-05-20 07:04:07','2026-08-08 21:38:52'),(389,249,3,5,'Perfecto, 100% recomendado','Excelente relación calidad-precio. El envío fue rápido y el empaque muy seguro.',1,1,4,5,'2026-01-25 04:00:05','2026-08-08 21:38:52'),(390,250,4,3,'Regular','El producto funciona pero la calidad no es la mejor. Por el precio está aceptable.',1,1,31,4,'2026-01-31 07:03:28','2026-08-08 21:38:52'),(391,250,5,2,'No lo recomiendo','Llegó con un pequeño defecto y el material no es resistente.',1,1,38,6,'2026-08-06 12:32:45','2026-08-08 21:38:52'),(392,251,1,5,'Excelente producto','Cumple totalmente con lo esperado, calidad superior y llegó rápido. Muy recomendado.',1,1,12,7,'2026-01-29 03:19:12','2026-08-08 21:38:52'),(393,251,2,4,'Bueno, recomendado','Funciona muy bien, calidad aceptable y llegó en tiempo. Lo recomiendo.',0,1,9,5,'2026-02-20 15:57:29','2026-08-08 21:38:52'),(394,251,3,3,'Regular','El producto funciona pero la calidad no es la mejor. Por el precio está aceptable.',1,1,18,5,'2026-07-18 03:16:07','2026-08-08 21:38:52'),(395,251,4,5,'Increíble calidad','Llevo un mes usándolo y sigue como nuevo. Definitivamente volveré a comprar.',1,1,32,0,'2026-04-02 06:08:55','2026-08-08 21:38:52'),(396,252,5,4,'Buena compra','La calidad es buena por el precio. Lo usaría de nuevo sin dudarlo.',0,1,14,8,'2026-05-24 20:29:53','2026-08-08 21:38:52'),(397,252,1,2,'Deficiente','No cumplió mis expectativas. La calidad es inferior a la descripción.',1,1,18,1,'2026-03-22 04:48:02','2026-08-08 21:38:52');
/*!40000 ALTER TABLE `reseñas_productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `nivel` int DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Administrador','Acceso completo al sistema',100,'2026-07-23 14:47:29','2026-07-23 14:47:29'),(2,'Vendedor','Gestiona productos y tienda',50,'2026-07-23 14:47:29','2026-07-23 14:47:29'),(3,'Cliente','Compra productos',10,'2026-07-23 14:47:29','2026-07-23 14:47:29'),(4,'Soporte','Atiende consultas de clientes',30,'2026-07-23 14:47:29','2026-07-23 14:47:29'),(5,'Analista','Acceso a reportes y estadísticas',40,'2026-07-23 14:47:29','2026-07-23 14:47:29');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seguimiento_envios`
--

DROP TABLE IF EXISTS `seguimiento_envios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seguimiento_envios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `envio_id` int NOT NULL,
  `estado` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ubicacion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_envio` (`envio_id`),
  CONSTRAINT `seguimiento_envios_ibfk_1` FOREIGN KEY (`envio_id`) REFERENCES `envios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seguimiento_envios`
--

LOCK TABLES `seguimiento_envios` WRITE;
/*!40000 ALTER TABLE `seguimiento_envios` DISABLE KEYS */;
/*!40000 ALTER TABLE `seguimiento_envios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sesiones`
--

DROP TABLE IF EXISTS `sesiones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sesiones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `session_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `ultima_actividad` datetime DEFAULT NULL,
  `activa` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `session_id` (`session_id`),
  KEY `usuario_id` (`usuario_id`),
  KEY `idx_session` (`session_id`),
  CONSTRAINT `sesiones_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sesiones`
--

LOCK TABLES `sesiones` WRITE;
/*!40000 ALTER TABLE `sesiones` DISABLE KEYS */;
/*!40000 ALTER TABLE `sesiones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suscripciones_push`
--

DROP TABLE IF EXISTS `suscripciones_push`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suscripciones_push` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `endpoint` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `p256dh_key` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `auth_key` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_endpoint` (`endpoint`(255)),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `suscripciones_push_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suscripciones_push`
--

LOCK TABLES `suscripciones_push` WRITE;
/*!40000 ALTER TABLE `suscripciones_push` DISABLE KEYS */;
/*!40000 ALTER TABLE `suscripciones_push` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tags` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
INSERT INTO `tags` VALUES (1,'nuevo','Tag generado por script de siembra','2026-08-06 13:23:29'),(2,'oferta','Tag generado por script de siembra','2026-08-06 13:23:29'),(3,'top ventas','Tag generado por script de siembra','2026-08-06 13:23:29'),(4,'envío gratis','Tag generado por script de siembra','2026-08-06 13:23:29'),(5,'edición limitada','Tag generado por script de siembra','2026-08-06 13:23:29'),(6,'garantía','Tag generado por script de siembra','2026-08-06 13:23:29'),(7,'original','Tag generado por script de siembra','2026-08-06 13:23:29'),(8,'importado','Tag generado por script de siembra','2026-08-06 13:23:29');
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tiendas`
--

DROP TABLE IF EXISTS `tiendas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tiendas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `vendedor_id` int NOT NULL,
  `nombre_tienda` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `banner` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `categoria_principal` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activa` tinyint(1) DEFAULT '1',
  `fecha_creacion` date DEFAULT NULL,
  `url_personalizada` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `template_theme` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'default',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `vendedor_id` (`vendedor_id`),
  KEY `idx_activa` (`activa`),
  KEY `idx_slug` (`slug`),
  CONSTRAINT `tiendas_ibfk_1` FOREIGN KEY (`vendedor_id`) REFERENCES `vendedores` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tiendas`
--

LOCK TABLES `tiendas` WRITE;
/*!40000 ALTER TABLE `tiendas` DISABLE KEYS */;
INSERT INTO `tiendas` VALUES (1,1,'TechStore Oficial','techstore-oficial','Tu tienda de tecnologia de confianza',NULL,NULL,'electronica',1,'2026-07-23',NULL,'default','2026-07-24 02:55:19','2026-07-24 02:55:19');
/*!40000 ALTER TABLE `tiendas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipos_notificaciones`
--

DROP TABLE IF EXISTS `tipos_notificaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_notificaciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_notificaciones`
--

LOCK TABLES `tipos_notificaciones` WRITE;
/*!40000 ALTER TABLE `tipos_notificaciones` DISABLE KEYS */;
INSERT INTO `tipos_notificaciones` VALUES (1,'Nuevo pedido','nuevo_pedido','Notificación cuando se realiza un nuevo pedido','2026-07-23 14:47:29'),(2,'Pedido enviado','pedido_enviado','Notificación cuando el pedido es enviado','2026-07-23 14:47:29'),(3,'Producto en stock','producto_stock','Notificación cuando un producto vuelve a estar disponible','2026-07-23 14:47:29'),(4,'Promoción especial','promocion_especial','Notificación de promociones especiales','2026-07-23 14:47:29'),(5,'Mensaje nuevo','mensaje_nuevo','Notificación de mensajes nuevos','2026-07-23 14:47:29'),(6,'Reseña recibida','reseña_recibida','Notificación de nuevas reseñas','2026-07-23 14:47:29');
/*!40000 ALTER TABLE `tipos_notificaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tokens_autenticacion`
--

DROP TABLE IF EXISTS `tokens_autenticacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tokens_autenticacion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo` enum('login','reset_password','verificacion','refresh') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expira_en` datetime NOT NULL,
  `usado` tinyint(1) DEFAULT '0',
  `ip_creacion` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `usuario_id` (`usuario_id`),
  KEY `idx_token` (`token`),
  KEY `idx_expira` (`expira_en`),
  CONSTRAINT `tokens_autenticacion_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tokens_autenticacion`
--

LOCK TABLES `tokens_autenticacion` WRITE;
/*!40000 ALTER TABLE `tokens_autenticacion` DISABLE KEYS */;
INSERT INTO `tokens_autenticacion` VALUES (1,5,'ce0ecb6eddf5fabca4d58e1aafe7d01056bd769b41fb8e9c5d2e8e2c0a669625','reset_password','2026-07-27 10:08:21',1,NULL,NULL,'2026-07-27 15:08:21'),(2,4,'5e759dfc0f1df8af9507463b1d12136df2781c002ca8a17e7b1ca2ea4237b5e4','reset_password','2026-07-27 10:10:43',1,NULL,NULL,'2026-07-27 15:10:43'),(3,5,'2a32f0dc570f0e007a7c5f5a0afba87c70e8bcd5e9e5aec5ece834558e1a4987','reset_password','2026-07-27 10:31:09',1,NULL,NULL,'2026-07-27 15:31:09'),(4,5,'68f841eb1cd0a1ebcb6a7954cbf933af251deab350b7a0dc37e85ecd75b7251e','reset_password','2026-07-27 11:26:15',1,NULL,NULL,'2026-07-27 16:26:15'),(5,5,'996973e530826f58e61fff89b1d0f372d0cac4f02507e8d4cdcc61628ca5e7db','reset_password','2026-07-29 19:50:55',1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 OPR/133.0.0.0','2026-07-30 00:50:55'),(6,5,'88de01f0aa7072bc3bf38fa19bee60b4a1bfa906c01740b40f75dd35cd424ae6','reset_password','2026-07-29 21:04:03',1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 OPR/133.0.0.0','2026-07-30 02:04:03'),(7,5,'faa8a07d9df5b9b51655bc3d5c33cf4f89813c826b71624e1972cc7c989a40b3','reset_password','2026-07-29 21:10:39',0,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 OPR/133.0.0.0','2026-07-30 02:10:39'),(8,4,'8058a1370e5a78526bdf683128d257197cc27fdfc31750aaf85fc5443d70fca3','reset_password','2026-07-31 00:34:34',1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-07-31 05:34:34'),(9,4,'70b08a710528678cc49177c7a9ad6d23aa297442a3d8eb044cf6d785bd8e826d','reset_password','2026-08-02 22:35:32',1,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-03 03:35:32'),(10,4,'6024460af4d41ca64a729c4e6cdea3b665843335bccaf09277f6750e5b275974','reset_password','2026-08-06 18:18:20',0,'::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-06 23:18:20');
/*!40000 ALTER TABLE `tokens_autenticacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transportistas`
--

DROP TABLE IF EXISTS `transportistas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transportistas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `website` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transportistas`
--

LOCK TABLES `transportistas` WRITE;
/*!40000 ALTER TABLE `transportistas` DISABLE KEYS */;
INSERT INTO `transportistas` VALUES (1,'DHL Express','DHL','01-800-345-6789','servicio@dhl.com',NULL,1,'2026-07-23 14:47:29','2026-07-23 14:47:29'),(2,'FedEx','FEDEX','01-800-333-3456','servicio@fedex.com',NULL,1,'2026-07-23 14:47:29','2026-07-23 14:47:29'),(3,'UPS','UPS','01-800-222-1234','servicio@ups.com',NULL,1,'2026-07-23 14:47:29','2026-07-23 14:47:29'),(4,'Estafeta','EST','01-800-111-4567','servicio@estafeta.com',NULL,1,'2026-07-23 14:47:29','2026-07-23 14:47:29'),(5,'Correos de México','CORREOS','01-800-666-7890','servicio@correos.com',NULL,1,'2026-07-23 14:47:29','2026-07-23 14:47:29');
/*!40000 ALTER TABLE `transportistas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_nacimiento` date DEFAULT NULL,
  `genero` enum('M','F','O') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rol_id` int NOT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `bloqueado` tinyint(1) DEFAULT '0',
  `razon_bloqueo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `intentos_fallidos` int DEFAULT '0',
  `ultimo_intento` datetime DEFAULT NULL,
  `ultimo_acceso` datetime DEFAULT NULL,
  `ip_registro` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `rol_id` (`rol_id`),
  KEY `idx_email` (`email`),
  KEY `idx_activo` (`activo`),
  CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'admin@marketzone.com','$2y$10$xqNhmjJBKkZcqv8X7g3Jve6fkKSybb5gTUHZIf5e9s4XOE9NZhR56','Admin','Sistema',NULL,NULL,NULL,NULL,NULL,1,1,0,NULL,0,NULL,NULL,NULL,'2026-07-24 02:55:19','2026-08-08 20:53:31'),(2,'vendedor@marketzone.com','$2y$10$kK.m9sRoMXxgDcskg/GAF.KSN5zUrxa50eOZ33A4DmwPM717wArMW','Juan','Vendedor',NULL,NULL,NULL,NULL,NULL,2,1,0,NULL,0,NULL,NULL,NULL,'2026-07-24 02:55:19','2026-08-06 13:03:27'),(3,'cliente@marketzone.com','$2y$10$SYMVpbtXIE2ncXqgiJSTDOfhCveatvbh3/kuzkOcB74QaxYsty9bG','Maria','Paz','33926669','Barrio la libertad',NULL,NULL,NULL,3,1,0,NULL,0,NULL,NULL,NULL,'2026-07-24 02:55:19','2026-08-03 03:30:36'),(4,'jimya.rubio@gmail.com','$2y$10$Kololx2BGsKIYdxLrQJJ7.HiEhU/aEFfTm3.kvn71UuhacIW0qYbS','Jimy','Rubio','33926669','Barrio la libertad',NULL,NULL,'/public/uploads/avatares/avatar_4_1786058367.jpg',3,1,0,NULL,0,NULL,NULL,NULL,'2026-07-24 04:22:29','2026-08-06 23:19:27'),(5,'jonathanhn709@gmail.com','$2y$10$BWgf0ocQLiZvLQT.B6jDxe8PUPkF3eEXb157nQEx4W97r3Y55f7he','Jonathan','Ponce','95322500','Choluteca',NULL,NULL,NULL,3,1,0,NULL,0,NULL,NULL,NULL,'2026-07-25 03:06:56','2026-07-30 00:55:47'),(6,'elreyreyes3y7@gmail.com','$2y$10$Q7KENSJ41wBDHsse.TpfTuNaoaOVdqVZPB2TngU16ilDwTd0w6XUe','Jonathan','Najar',NULL,NULL,NULL,NULL,NULL,3,0,0,NULL,0,NULL,NULL,NULL,'2026-07-25 03:47:12','2026-08-04 14:16:12');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_clientes_top`
--

DROP TABLE IF EXISTS `v_clientes_top`;
/*!50001 DROP VIEW IF EXISTS `v_clientes_top`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_clientes_top` AS SELECT 
 1 AS `id`,
 1 AS `nombre_completo`,
 1 AS `email`,
 1 AS `total_compras`,
 1 AS `total_pedidos`,
 1 AS `puntos_lealtad`,
 1 AS `pedidos_completados`,
 1 AS `total_gastado`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_pedidos_completos`
--

DROP TABLE IF EXISTS `v_pedidos_completos`;
/*!50001 DROP VIEW IF EXISTS `v_pedidos_completos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_pedidos_completos` AS SELECT 
 1 AS `id`,
 1 AS `numero_pedido`,
 1 AS `cliente_id`,
 1 AS `cliente_nombre`,
 1 AS `total`,
 1 AS `estado`,
 1 AS `fecha_pedido`,
 1 AS `fecha_entrega`,
 1 AS `vendedor_id`,
 1 AS `vendedor_nombre`,
 1 AS `total_items`,
 1 AS `total_cantidad`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_productos_stock`
--

DROP TABLE IF EXISTS `v_productos_stock`;
/*!50001 DROP VIEW IF EXISTS `v_productos_stock`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_productos_stock` AS SELECT 
 1 AS `id`,
 1 AS `nombre`,
 1 AS `sku`,
 1 AS `precio`,
 1 AS `stock`,
 1 AS `stock_minimo`,
 1 AS `estado`,
 1 AS `categoria_nombre`,
 1 AS `tienda_nombre`,
 1 AS `vendedor_nombre`,
 1 AS `nivel_stock`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_ventas_vendedor`
--

DROP TABLE IF EXISTS `v_ventas_vendedor`;
/*!50001 DROP VIEW IF EXISTS `v_ventas_vendedor`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_ventas_vendedor` AS SELECT 
 1 AS `vendedor_id`,
 1 AS `nombre_empresa`,
 1 AS `fecha`,
 1 AS `total_pedidos`,
 1 AS `total_ventas`,
 1 AS `comision_total`,
 1 AS `clientes_unicos`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `variaciones_productos`
--

DROP TABLE IF EXISTS `variaciones_productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `variaciones_productos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `producto_id` int NOT NULL,
  `sku` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `atributos` json NOT NULL,
  `precio` decimal(12,2) DEFAULT NULL,
  `precio_oferta` decimal(12,2) DEFAULT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `peso` decimal(10,2) DEFAULT NULL,
  `imagen` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sku` (`sku`),
  KEY `idx_producto` (`producto_id`),
  CONSTRAINT `variaciones_productos_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variaciones_productos`
--

LOCK TABLES `variaciones_productos` WRITE;
/*!40000 ALTER TABLE `variaciones_productos` DISABLE KEYS */;
INSERT INTO `variaciones_productos` VALUES (60,155,'SKU-003-8392-V1','{\"Color\": \"Blanco\", \"Marca\": \"Apple\", \"Talla\": \"XL\", \"Material\": \"Plástico\"}',450.00,345.15,17,3.24,NULL,'2026-08-06 13:33:20','2026-08-06 13:33:20'),(61,160,'SKU-008-3622-V1','{\"Color\": \"Rojo\", \"Marca\": \"Sony\"}',980.00,NULL,26,108.91,NULL,'2026-08-06 13:33:20','2026-08-06 13:33:20'),(62,161,'SKU-009-5171-V1','{\"Color\": \"Blanco\", \"Material\": \"Cuero\"}',2100.00,1665.30,63,30.07,NULL,'2026-08-06 13:33:20','2026-08-06 13:33:20'),(63,163,'SKU-011-7352-V1','{\"Color\": \"Blanco\", \"Marca\": \"LG\", \"Talla\": \"L\", \"Material\": \"Algodón\"}',390.00,NULL,64,126.43,NULL,'2026-08-06 13:33:20','2026-08-06 13:33:20'),(64,164,'SKU-012-5235-V1','{\"Marca\": \"Adidas\", \"Material\": \"Plástico\"}',780.00,NULL,97,149.04,NULL,'2026-08-06 13:33:20','2026-08-06 13:33:20'),(65,167,'SKU-015-7626-V1','{\"Color\": \"Azul\", \"Marca\": \"LG\", \"Talla\": \"XXL\"}',1500.00,NULL,52,20.48,NULL,'2026-08-06 13:33:20','2026-08-06 13:33:20'),(66,168,'SKU-016-6228-V1','{\"Color\": \"Negro\", \"Marca\": \"Apple\", \"Talla\": \"L\", \"Material\": \"Algodón\"}',180.00,NULL,23,88.43,NULL,'2026-08-06 13:33:20','2026-08-06 13:33:20'),(67,170,'SKU-018-2596-V1','{\"Color\": \"Blanco\", \"Marca\": \"Apple\"}',480.00,NULL,2,50.79,NULL,'2026-08-06 13:33:20','2026-08-06 13:33:20'),(68,172,'SKU-020-0318-V1','{\"Color\": \"Rojo\", \"Marca\": \"Sony\"}',260.00,167.70,26,76.97,NULL,'2026-08-06 13:33:20','2026-08-06 13:33:20'),(69,173,'SKU-021-1650-V1','{\"Color\": \"Blanco\", \"Marca\": \"Samsung\", \"Material\": \"Vidrio\"}',180.00,NULL,24,128.80,NULL,'2026-08-06 13:33:20','2026-08-06 13:33:20'),(70,177,'SKU-025-1909-V1','{\"Color\": \"Verde\", \"Marca\": \"Xiaomi\", \"Talla\": \"S\", \"Material\": \"Madera\"}',650.00,344.50,1,76.67,NULL,'2026-08-06 13:33:20','2026-08-06 13:33:20'),(71,178,'SKU-026-8116-V1','{\"Talla\": \"XXL\", \"Material\": \"Cuero\"}',980.00,NULL,7,34.31,NULL,'2026-08-06 13:33:20','2026-08-06 13:33:20'),(72,179,'SKU-027-2651-V1','{\"Color\": \"Gris\", \"Marca\": \"Nike\", \"Talla\": \"S\", \"Material\": \"Metal\"}',720.00,NULL,45,135.20,NULL,'2026-08-06 13:33:20','2026-08-06 13:33:20'),(73,184,'SKU-032-2002-V1','{\"Color\": \"Rojo\", \"Marca\": \"HP\", \"Talla\": \"M\", \"Material\": \"Algodón\"}',460.00,NULL,96,13.57,NULL,'2026-08-06 13:33:20','2026-08-06 13:33:20'),(74,186,'SKU-034-7147-V1','{\"Color\": \"Gris\", \"Marca\": \"LG\", \"Talla\": \"L\", \"Material\": \"Madera\"}',280.00,NULL,54,113.57,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(75,189,'SKU-037-8818-V1','{\"Color\": \"Blanco\", \"Marca\": \"Xiaomi\", \"Material\": \"Plástico\"}',540.00,NULL,92,36.41,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(76,194,'SKU-042-4812-V1','{\"Color\": \"Negro\", \"Talla\": \"M\", \"Material\": \"Metal\"}',1800.00,1035.00,32,25.29,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(77,196,'SKU-044-8582-V1','{\"Talla\": \"S\", \"Material\": \"Cuero\"}',950.00,627.00,75,34.69,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(78,197,'SKU-045-0663-V1','{\"Color\": \"Rojo\", \"Material\": \"Vidrio\"}',350.00,NULL,97,62.10,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(79,198,'SKU-046-5109-V1','{\"Color\": \"Negro\", \"Material\": \"Plástico\"}',480.00,341.28,2,91.15,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(80,200,'SKU-048-9754-V1','{\"Marca\": \"LG\", \"Talla\": \"XL\"}',280.00,NULL,15,138.42,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(81,201,'SKU-049-7366-V1','{\"Color\": \"Verde\", \"Marca\": \"LG\"}',420.00,346.92,54,64.79,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(82,202,'SKU-050-8187-V1','{\"Talla\": \"M\", \"Material\": \"Plástico\"}',780.00,445.38,44,146.39,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(83,205,'SKU-053-5602-V1','{\"Color\": \"Rojo\", \"Marca\": \"Apple\", \"Talla\": \"M\", \"Material\": \"Madera\"}',320.00,NULL,34,60.44,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(84,209,'SKU-057-2128-V1','{\"Color\": \"Verde\", \"Marca\": \"LG\", \"Talla\": \"M\", \"Material\": \"Metal\"}',380.00,NULL,99,115.15,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(85,212,'SKU-060-6690-V1','{\"Marca\": \"HP\", \"Material\": \"Algodón\"}',260.00,195.52,68,115.08,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(86,215,'SKU-063-0019-V1','{\"Color\": \"Negro\", \"Marca\": \"HP\", \"Talla\": \"M\", \"Material\": \"Madera\"}',180.00,NULL,54,17.56,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(87,217,'SKU-065-7697-V1','{\"Color\": \"Blanco\", \"Marca\": \"Adidas\"}',90.00,NULL,68,99.35,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(88,218,'SKU-066-5052-V1','{\"Color\": \"Blanco\", \"Talla\": \"L\"}',220.00,117.48,30,29.30,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(89,220,'SKU-068-4595-V1','{\"Color\": \"Rojo\", \"Material\": \"Cuero\"}',160.00,129.76,76,88.25,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(90,226,'SKU-074-3539-V1','{\"Color\": \"Verde\", \"Marca\": \"Adidas\", \"Talla\": \"S\", \"Material\": \"Madera\"}',9200.00,5915.60,70,134.27,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(91,227,'SKU-075-4679-V1','{\"Color\": \"Negro\", \"Marca\": \"HP\", \"Talla\": \"L\", \"Material\": \"Madera\"}',5400.00,2883.60,74,30.63,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(92,234,'SKU-082-6091-V1','{\"Marca\": \"Apple\", \"Talla\": \"M\", \"Material\": \"Plástico\"}',780.00,NULL,64,138.14,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(93,237,'SKU-085-4305-V1','{\"Color\": \"Verde\", \"Marca\": \"Apple\"}',320.00,NULL,70,106.04,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(94,243,'SKU-091-0658-V1','{\"Color\": \"Gris\", \"Marca\": \"Xiaomi\", \"Talla\": \"XXL\", \"Material\": \"Cuero\"}',440.00,NULL,61,106.69,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(95,244,'SKU-092-9044-V1','{\"Color\": \"Gris\", \"Marca\": \"Samsung\", \"Talla\": \"XL\", \"Material\": \"Madera\"}',890.00,504.63,60,31.31,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(96,246,'SKU-094-9291-V1','{\"Color\": \"Azul\", \"Marca\": \"Sony\", \"Talla\": \"L\", \"Material\": \"Metal\"}',460.00,NULL,33,119.20,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21'),(97,252,'SKU-100-1872-V1','{\"Marca\": \"Sony\", \"Talla\": \"L\"}',320.00,NULL,52,136.93,NULL,'2026-08-06 13:33:21','2026-08-06 13:33:21');
/*!40000 ALTER TABLE `variaciones_productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vendedores`
--

DROP TABLE IF EXISTS `vendedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vendedores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `nombre_empresa` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ruc` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono_empresa` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_empresa` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `banner` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `categoria_principal` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reputacion` decimal(3,2) DEFAULT '0.00',
  `nivel` enum('basic','silver','gold','platinum') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'basic',
  `verificado` tinyint(1) DEFAULT '0',
  `comision_venta` decimal(5,2) DEFAULT '10.00',
  `total_ventas` decimal(12,2) DEFAULT '0.00',
  `total_productos` int DEFAULT '0',
  `fecha_registro` date DEFAULT NULL,
  `horario_atencion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario_id` (`usuario_id`),
  UNIQUE KEY `ruc` (`ruc`),
  KEY `idx_verificado` (`verificado`),
  CONSTRAINT `vendedores_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vendedores`
--

LOCK TABLES `vendedores` WRITE;
/*!40000 ALTER TABLE `vendedores` DISABLE KEYS */;
INSERT INTO `vendedores` VALUES (1,2,'TechStore Oficial','RUC-12345678','+52 55 1234 5678','ventas@techstore.com','Tienda oficial de tecnologia y electronica',NULL,NULL,NULL,0.00,'gold',1,8.00,0.00,111,'2026-07-23',NULL);
/*!40000 ALTER TABLE `vendedores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vistas_productos`
--

DROP TABLE IF EXISTS `vistas_productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vistas_productos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `producto_id` int NOT NULL,
  `cliente_id` int DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_vista` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `cliente_id` (`cliente_id`),
  KEY `idx_producto` (`producto_id`),
  KEY `idx_vistas_producto_fecha` (`producto_id`,`fecha_vista`),
  CONSTRAINT `vistas_productos_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `vistas_productos_ibfk_2` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vistas_productos`
--

LOCK TABLES `vistas_productos` WRITE;
/*!40000 ALTER TABLE `vistas_productos` DISABLE KEYS */;
/*!40000 ALTER TABLE `vistas_productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist`
--

DROP TABLE IF EXISTS `wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishlist` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int NOT NULL,
  `producto_id` int NOT NULL,
  `variacion_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_wishlist` (`cliente_id`,`producto_id`),
  KEY `producto_id` (`producto_id`),
  KEY `variacion_id` (`variacion_id`),
  CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `wishlist_ibfk_3` FOREIGN KEY (`variacion_id`) REFERENCES `variaciones_productos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist`
--

LOCK TABLES `wishlist` WRITE;
/*!40000 ALTER TABLE `wishlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `wishlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `v_clientes_top`
--

/*!50001 DROP VIEW IF EXISTS `v_clientes_top`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_clientes_top` AS select `c`.`id` AS `id`,concat(`u`.`nombre`,' ',`u`.`apellido`) AS `nombre_completo`,`u`.`email` AS `email`,`c`.`total_compras` AS `total_compras`,`c`.`total_pedidos` AS `total_pedidos`,`c`.`puntos_lealtad` AS `puntos_lealtad`,count(distinct `p`.`id`) AS `pedidos_completados`,sum(`p`.`total`) AS `total_gastado` from ((`clientes` `c` join `usuarios` `u` on((`c`.`usuario_id` = `u`.`id`))) left join `pedidos` `p` on(((`c`.`id` = `p`.`cliente_id`) and (`p`.`estado` = 'entregado')))) group by `c`.`id` order by `total_gastado` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_pedidos_completos`
--

/*!50001 DROP VIEW IF EXISTS `v_pedidos_completos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_pedidos_completos` AS select `p`.`id` AS `id`,`p`.`numero_pedido` AS `numero_pedido`,`c`.`id` AS `cliente_id`,concat(`u`.`nombre`,' ',`u`.`apellido`) AS `cliente_nombre`,`p`.`total` AS `total`,`p`.`estado` AS `estado`,`p`.`fecha_pedido` AS `fecha_pedido`,`p`.`fecha_entrega` AS `fecha_entrega`,`v`.`id` AS `vendedor_id`,`v`.`nombre_empresa` AS `vendedor_nombre`,count(`pi`.`id`) AS `total_items`,sum(`pi`.`cantidad`) AS `total_cantidad` from ((((((`pedidos` `p` join `clientes` `c` on((`p`.`cliente_id` = `c`.`id`))) join `usuarios` `u` on((`c`.`usuario_id` = `u`.`id`))) left join `pedido_items` `pi` on((`p`.`id` = `pi`.`pedido_id`))) left join `productos` `pr` on((`pi`.`producto_id` = `pr`.`id`))) left join `tiendas` `t` on((`pr`.`tienda_id` = `t`.`id`))) left join `vendedores` `v` on((`t`.`vendedor_id` = `v`.`id`))) group by `p`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_productos_stock`
--

/*!50001 DROP VIEW IF EXISTS `v_productos_stock`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_productos_stock` AS select `p`.`id` AS `id`,`p`.`nombre` AS `nombre`,`p`.`sku` AS `sku`,`p`.`precio` AS `precio`,`p`.`stock` AS `stock`,`p`.`stock_minimo` AS `stock_minimo`,`p`.`estado` AS `estado`,`c`.`nombre` AS `categoria_nombre`,`t`.`nombre_tienda` AS `tienda_nombre`,`v`.`nombre_empresa` AS `vendedor_nombre`,(case when (`p`.`stock` <= `p`.`stock_minimo`) then 'BAJO' when (`p`.`stock` <= (`p`.`stock_minimo` * 2)) then 'MEDIO' else 'ALTO' end) AS `nivel_stock` from (((`productos` `p` join `categorias` `c` on((`p`.`categoria_id` = `c`.`id`))) join `tiendas` `t` on((`p`.`tienda_id` = `t`.`id`))) join `vendedores` `v` on((`t`.`vendedor_id` = `v`.`id`))) where (`p`.`estado` = 'activo') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_ventas_vendedor`
--

/*!50001 DROP VIEW IF EXISTS `v_ventas_vendedor`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_ventas_vendedor` AS select `v`.`id` AS `vendedor_id`,`v`.`nombre_empresa` AS `nombre_empresa`,cast(`p`.`fecha_pedido` as date) AS `fecha`,count(distinct `p`.`id`) AS `total_pedidos`,sum(`p`.`total`) AS `total_ventas`,sum(((`p`.`total` * `v`.`comision_venta`) / 100)) AS `comision_total`,count(distinct `p`.`cliente_id`) AS `clientes_unicos` from ((((`vendedores` `v` join `tiendas` `t` on((`v`.`id` = `t`.`vendedor_id`))) join `productos` `pr` on((`t`.`id` = `pr`.`tienda_id`))) join `pedido_items` `pi` on((`pr`.`id` = `pi`.`producto_id`))) join `pedidos` `p` on((`pi`.`pedido_id` = `p`.`id`))) where (`p`.`estado` <> 'cancelado') group by `v`.`id`,cast(`p`.`fecha_pedido` as date) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-08 17:02:47

-- ======================================================
-- PROYECTO 3: MARKETPLACE TIPO AMAZON
-- BASE DE DATOS: marketplace_db (60 TABLAS COMPLETAS)
-- ======================================================

CREATE DATABASE IF NOT EXISTS marketplace_db;
USE marketplace_db;

-- ======================================================
-- 1. TABLAS DE SEGURIDAD Y AUTENTICACIÓN (5 tablas)
-- ======================================================

-- Tabla 1: roles
CREATE TABLE roles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    nivel INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 2: usuarios
CREATE TABLE usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    direccion TEXT,
    fecha_nacimiento DATE,
    genero ENUM('M', 'F', 'O'),
    avatar VARCHAR(255),
    rol_id INT NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    bloqueado BOOLEAN DEFAULT FALSE,
    razon_bloqueo TEXT,
    intentos_fallidos INT DEFAULT 0,
    ultimo_intento DATETIME,
    ultimo_acceso DATETIME,
    ip_registro VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (rol_id) REFERENCES roles(id),
    INDEX idx_email (email),
    INDEX idx_activo (activo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 3: tokens_autenticacion
CREATE TABLE tokens_autenticacion (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    token VARCHAR(255) NOT NULL UNIQUE,
    tipo ENUM('login', 'reset_password', 'verificacion', 'refresh') NOT NULL,
    expira_en DATETIME NOT NULL,
    usado BOOLEAN DEFAULT FALSE,
    ip_creacion VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    INDEX idx_token (token),
    INDEX idx_expira (expira_en)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 4: sesiones
CREATE TABLE sesiones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    session_id VARCHAR(255) NOT NULL UNIQUE,
    ip_address VARCHAR(45),
    user_agent TEXT,
    ultima_actividad DATETIME,
    activa BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    INDEX idx_session (session_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 5: auditoria
CREATE TABLE auditoria (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT,
    accion VARCHAR(100) NOT NULL,
    tabla_afectada VARCHAR(50),
    registro_id INT,
    datos_anteriores JSON,
    datos_nuevos JSON,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_usuario (usuario_id),
    INDEX idx_accion (accion),
    INDEX idx_fecha (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================================
-- 2. TABLAS DE CLIENTES Y DIRECCIONES (2 tablas)
-- ======================================================

-- Tabla 6: clientes
CREATE TABLE clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL UNIQUE,
    tipo_cliente ENUM('regular', 'premium', 'empresa') DEFAULT 'regular',
    puntos_lealtad INT DEFAULT 0,
    total_compras DECIMAL(12,2) DEFAULT 0,
    total_pedidos INT DEFAULT 0,
    ultima_compra DATETIME,
    fecha_registro DATE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    INDEX idx_tipo (tipo_cliente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 7: direcciones
CREATE TABLE direcciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    tipo ENUM('envio', 'facturacion', 'ambos') DEFAULT 'ambos',
    calle VARCHAR(255) NOT NULL,
    numero VARCHAR(20),
    complemento VARCHAR(100),
    colonia VARCHAR(100),
    ciudad VARCHAR(100) NOT NULL,
    estado VARCHAR(100) NOT NULL,
    pais VARCHAR(100) NOT NULL,
    codigo_postal VARCHAR(20) NOT NULL,
    referencia TEXT,
    latitud DECIMAL(10,8),
    longitud DECIMAL(11,8),
    predeterminada BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE,
    INDEX idx_cliente (cliente_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================================
-- 3. TABLAS DE VENDEDORES Y TIENDAS (2 tablas)
-- ======================================================

-- Tabla 8: vendedores
CREATE TABLE vendedores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL UNIQUE,
    nombre_empresa VARCHAR(255) NOT NULL,
    ruc VARCHAR(50) UNIQUE,
    telefono_empresa VARCHAR(20),
    email_empresa VARCHAR(100),
    descripcion TEXT,
    logo VARCHAR(255),
    banner VARCHAR(255),
    categoria_principal VARCHAR(50),
    reputacion DECIMAL(3,2) DEFAULT 0,
    nivel ENUM('basic', 'silver', 'gold', 'platinum') DEFAULT 'basic',
    verificado BOOLEAN DEFAULT FALSE,
    comision_venta DECIMAL(5,2) DEFAULT 10.00,
    total_ventas DECIMAL(12,2) DEFAULT 0,
    total_productos INT DEFAULT 0,
    fecha_registro DATE,
    horario_atencion TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    INDEX idx_verificado (verificado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 9: tiendas
CREATE TABLE tiendas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    vendedor_id INT NOT NULL,
    nombre_tienda VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    descripcion TEXT,
    logo VARCHAR(255),
    banner VARCHAR(255),
    categoria_principal VARCHAR(50),
    activa BOOLEAN DEFAULT TRUE,
    fecha_creacion DATE,
    url_personalizada VARCHAR(255),
    template_theme VARCHAR(50) DEFAULT 'default',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (vendedor_id) REFERENCES vendedores(id) ON DELETE CASCADE,
    INDEX idx_activa (activa),
    INDEX idx_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================================
-- 4. TABLAS DE CATEGORÍAS Y PRODUCTOS (10 tablas)
-- ======================================================

-- Tabla 10: categorias
CREATE TABLE categorias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    descripcion TEXT,
    parent_id INT,
    nivel INT DEFAULT 1,
    activo BOOLEAN DEFAULT TRUE,
    imagen VARCHAR(255),
    orden INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES categorias(id) ON DELETE CASCADE,
    INDEX idx_parent (parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 11: productos
CREATE TABLE productos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tienda_id INT NOT NULL,
    categoria_id INT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    descripcion_corta TEXT,
    descripcion_larga LONGTEXT,
    sku VARCHAR(50) UNIQUE NOT NULL,
    precio DECIMAL(12,2) NOT NULL,
    precio_oferta DECIMAL(12,2),
    costo DECIMAL(12,2),
    stock INT NOT NULL DEFAULT 0,
    stock_minimo INT DEFAULT 5,
    stock_maximo INT DEFAULT 1000,
    peso DECIMAL(10,2),
    ancho DECIMAL(10,2),
    alto DECIMAL(10,2),
    profundidad DECIMAL(10,2),
    estado ENUM('activo', 'inactivo', 'agotado', 'descontinuado') DEFAULT 'activo',
    destacado BOOLEAN DEFAULT FALSE,
    nuevo BOOLEAN DEFAULT FALSE,
    oferta BOOLEAN DEFAULT FALSE,
    calificacion_promedio DECIMAL(3,2) DEFAULT 0,
    total_vendidos INT DEFAULT 0,
    visitas INT DEFAULT 0,
    fecha_publicacion DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (tienda_id) REFERENCES tiendas(id) ON DELETE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id),
    INDEX idx_categoria (categoria_id),
    INDEX idx_precio (precio),
    INDEX idx_estado (estado),
    INDEX idx_destacado (destacado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 12: atributos_productos
CREATE TABLE atributos_productos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    tipo ENUM('texto', 'numero', 'color', 'talla', 'select', 'multiselect') DEFAULT 'texto',
    valores_posibles JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 13: producto_atributos
CREATE TABLE producto_atributos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    producto_id INT NOT NULL,
    atributo_id INT NOT NULL,
    valor TEXT NOT NULL,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    FOREIGN KEY (atributo_id) REFERENCES atributos_productos(id),
    UNIQUE KEY unique_atributo (producto_id, atributo_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 14: imagenes_productos
CREATE TABLE imagenes_productos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    producto_id INT NOT NULL,
    url VARCHAR(255) NOT NULL,
    alt TEXT,
    orden INT DEFAULT 0,
    principal BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    INDEX idx_producto (producto_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 15: variaciones_productos
CREATE TABLE variaciones_productos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    producto_id INT NOT NULL,
    sku VARCHAR(50) UNIQUE NOT NULL,
    atributos JSON NOT NULL,
    precio DECIMAL(12,2),
    precio_oferta DECIMAL(12,2),
    stock INT NOT NULL DEFAULT 0,
    peso DECIMAL(10,2),
    imagen VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    INDEX idx_producto (producto_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 16: reseñas_productos
CREATE TABLE reseñas_productos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    producto_id INT NOT NULL,
    cliente_id INT NOT NULL,
    calificacion INT NOT NULL CHECK (calificacion BETWEEN 1 AND 5),
    titulo VARCHAR(255),
    comentario TEXT,
    verificado BOOLEAN DEFAULT FALSE,
    aprobado BOOLEAN DEFAULT FALSE,
    likes INT DEFAULT 0,
    dislikes INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    INDEX idx_producto (producto_id),
    INDEX idx_calificacion (calificacion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 17: tags
CREATE TABLE tags (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 18: producto_tags
CREATE TABLE producto_tags (
    id INT PRIMARY KEY AUTO_INCREMENT,
    producto_id INT NOT NULL,
    tag_id INT NOT NULL,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE,
    UNIQUE KEY unique_producto_tag (producto_id, tag_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 19: preguntas_productos
CREATE TABLE preguntas_productos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    producto_id INT NOT NULL,
    cliente_id INT NOT NULL,
    pregunta TEXT NOT NULL,
    respuesta TEXT,
    fecha_pregunta DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_respuesta DATETIME,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    INDEX idx_producto (producto_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================================
-- 5. TABLAS DE CARRITO DE COMPRAS (3 tablas)
-- ======================================================

-- Tabla 20: carritos
CREATE TABLE carritos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL UNIQUE,
    total_items INT DEFAULT 0,
    subtotal DECIMAL(12,2) DEFAULT 0,
    descuentos DECIMAL(12,2) DEFAULT 0,
    total DECIMAL(12,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 21: carrito_items
CREATE TABLE carrito_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    carrito_id INT NOT NULL,
    producto_id INT NOT NULL,
    variacion_id INT,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(12,2) NOT NULL,
    descuento DECIMAL(12,2) DEFAULT 0,
    subtotal DECIMAL(12,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (carrito_id) REFERENCES carritos(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id),
    FOREIGN KEY (variacion_id) REFERENCES variaciones_productos(id),
    INDEX idx_carrito (carrito_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 22: wishlist
CREATE TABLE wishlist (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    producto_id INT NOT NULL,
    variacion_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    FOREIGN KEY (variacion_id) REFERENCES variaciones_productos(id),
    UNIQUE KEY unique_wishlist (cliente_id, producto_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================================
-- 6. TABLAS DE PEDIDOS (3 tablas)
-- ======================================================

-- Tabla 23: pedidos
CREATE TABLE pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    numero_pedido VARCHAR(50) UNIQUE NOT NULL,
    estado ENUM('pendiente', 'confirmado', 'preparando', 'enviado', 'entregado', 'cancelado', 'devuelto') DEFAULT 'pendiente',
    estado_pago ENUM('pendiente', 'pagado', 'fallido', 'reembolsado') DEFAULT 'pendiente',
    subtotal DECIMAL(12,2) NOT NULL,
    descuentos DECIMAL(12,2) DEFAULT 0,
    impuestos DECIMAL(12,2) DEFAULT 0,
    costo_envio DECIMAL(12,2) DEFAULT 0,
    total DECIMAL(12,2) NOT NULL,
    direccion_envio_id INT,
    direccion_facturacion_id INT,
    notas_cliente TEXT,
    notas_internas TEXT,
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_confirmacion DATETIME,
    fecha_envio DATETIME,
    fecha_entrega DATETIME,
    fecha_cancelacion DATETIME,
    razon_cancelacion TEXT,
    tracking_number VARCHAR(100),
    transportista VARCHAR(50),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (direccion_envio_id) REFERENCES direcciones(id),
    FOREIGN KEY (direccion_facturacion_id) REFERENCES direcciones(id),
    INDEX idx_cliente (cliente_id),
    INDEX idx_estado (estado),
    INDEX idx_fecha (fecha_pedido)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 24: pedido_items
CREATE TABLE pedido_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    variacion_id INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(12,2) NOT NULL,
    descuento DECIMAL(12,2) DEFAULT 0,
    subtotal DECIMAL(12,2) NOT NULL,
    estado_item ENUM('pendiente', 'confirmado', 'preparando', 'enviado', 'entregado', 'cancelado', 'devuelto') DEFAULT 'pendiente',
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id),
    FOREIGN KEY (variacion_id) REFERENCES variaciones_productos(id),
    INDEX idx_pedido (pedido_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 25: historial_estados_pedido
CREATE TABLE historial_estados_pedido (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT NOT NULL,
    estado_anterior VARCHAR(50),
    estado_nuevo VARCHAR(50) NOT NULL,
    comentario TEXT,
    usuario_id INT,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    INDEX idx_pedido (pedido_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================================
-- 7. TABLAS DE PAGOS Y FACTURACIÓN (5 tablas)
-- ======================================================

-- Tabla 26: metodos_pago
CREATE TABLE metodos_pago (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    descripcion TEXT,
    activo BOOLEAN DEFAULT TRUE,
    procesador VARCHAR(50),
    configuracion JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 27: pagos
CREATE TABLE pagos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT NOT NULL UNIQUE,
    metodo_pago_id INT NOT NULL,
    monto DECIMAL(12,2) NOT NULL,
    estado ENUM('pendiente', 'procesando', 'completado', 'fallido', 'reembolsado', 'cancelado') DEFAULT 'pendiente',
    codigo_transaccion VARCHAR(100),
    token_pago VARCHAR(255),
    datos_pago JSON,
    fecha_pago DATETIME,
    fecha_reembolso DATETIME,
    razon_reembolso TEXT,
    ip_pago VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (metodo_pago_id) REFERENCES metodos_pago(id),
    INDEX idx_pedido (pedido_id),
    INDEX idx_estado (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 28: facturas
CREATE TABLE facturas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT NOT NULL UNIQUE,
    numero_factura VARCHAR(50) UNIQUE NOT NULL,
    cliente_id INT NOT NULL,
    ruc_cliente VARCHAR(50),
    razon_social VARCHAR(255),
    direccion_facturacion TEXT,
    subtotal DECIMAL(12,2) NOT NULL,
    impuestos DECIMAL(12,2) DEFAULT 0,
    total DECIMAL(12,2) NOT NULL,
    pdf_url VARCHAR(255),
    xml_url VARCHAR(255),
    fecha_emision DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    INDEX idx_cliente (cliente_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 29: opciones_pago_guardadas
CREATE TABLE opciones_pago_guardadas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    tipo ENUM('tarjeta', 'paypal', 'transferencia') NOT NULL,
    datos_pago JSON NOT NULL,
    predeterminado BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE,
    INDEX idx_cliente (cliente_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 30: devoluciones
CREATE TABLE devoluciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT NOT NULL,
    cliente_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    motivo TEXT NOT NULL,
    estado ENUM('solicitada', 'aprobada', 'rechazada', 'completada') DEFAULT 'solicitada',
    monto_reembolso DECIMAL(12,2),
    fecha_solicitud DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_aprobacion DATETIME,
    fecha_reembolso DATETIME,
    comentarios_internos TEXT,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id),
    INDEX idx_pedido (pedido_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================================
-- 8. TABLAS DE PROMOCIONES Y DESCUENTOS (4 tablas)
-- ======================================================

-- Tabla 31: promociones
CREATE TABLE promociones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    tipo ENUM('porcentaje', 'monto_fijo', 'envio_gratis', 'combo') NOT NULL,
    valor DECIMAL(12,2) NOT NULL,
    minimo_compra DECIMAL(12,2) DEFAULT 0,
    maximo_descuento DECIMAL(12,2),
    productos_aplicables JSON,
    categorias_aplicables JSON,
    clientes_aplicables JSON,
    usa_veces INT DEFAULT 1,
    usa_por_cliente INT DEFAULT 1,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_codigo (codigo),
    INDEX idx_activo (activo),
    INDEX idx_fechas (fecha_inicio, fecha_fin)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 32: promociones_aplicadas
CREATE TABLE promociones_aplicadas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    promocion_id INT NOT NULL,
    pedido_id INT NOT NULL,
    cliente_id INT NOT NULL,
    monto_descuento DECIMAL(12,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (promocion_id) REFERENCES promociones(id),
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    INDEX idx_pedido (pedido_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 33: cupones
CREATE TABLE cupones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    descripcion TEXT,
    tipo_descuento ENUM('porcentaje', 'monto_fijo') NOT NULL,
    valor DECIMAL(12,2) NOT NULL,
    minimo_compra DECIMAL(12,2) DEFAULT 0,
    maximo_descuento DECIMAL(12,2),
    productos_aplicables JSON,
    categorias_aplicables JSON,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL,
    usa_veces INT DEFAULT 1,
    usa_por_cliente INT DEFAULT 1,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_codigo (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 34: recompensas
CREATE TABLE recompensas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    puntos INT NOT NULL,
    descripcion TEXT,
    fecha_obtenida DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_expiracion DATETIME,
    usada BOOLEAN DEFAULT FALSE,
    fecha_uso DATETIME,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE,
    INDEX idx_cliente (cliente_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================================
-- 9. TABLAS DE MENSAJERÍA (2 tablas)
-- ======================================================

-- Tabla 35: conversaciones
CREATE TABLE conversaciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    vendedor_id INT NOT NULL,
    asunto VARCHAR(255),
    ultimo_mensaje TEXT,
    estado ENUM('abierta', 'cerrada', 'archivada') DEFAULT 'abierta',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (vendedor_id) REFERENCES vendedores(id),
    INDEX idx_cliente (cliente_id),
    INDEX idx_vendedor (vendedor_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 36: mensajes
CREATE TABLE mensajes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    conversacion_id INT NOT NULL,
    remitente_id INT NOT NULL,
    remitente_tipo ENUM('cliente', 'vendedor', 'admin') NOT NULL,
    mensaje TEXT NOT NULL,
    adjunto_url VARCHAR(255),
    leido BOOLEAN DEFAULT FALSE,
    fecha_lectura DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conversacion_id) REFERENCES conversaciones(id) ON DELETE CASCADE,
    INDEX idx_conversacion (conversacion_id),
    INDEX idx_leido (leido)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================================
-- 10. TABLAS DE NOTIFICACIONES (3 tablas)
-- ======================================================

-- Tabla 37: tipos_notificaciones
CREATE TABLE tipos_notificaciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    codigo VARCHAR(30) UNIQUE NOT NULL,
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 38: notificaciones
CREATE TABLE notificaciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    tipo_id INT NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    mensaje TEXT NOT NULL,
    url VARCHAR(255),
    leido BOOLEAN DEFAULT FALSE,
    fecha_lectura DATETIME,
    prioridad ENUM('baja', 'media', 'alta') DEFAULT 'media',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (tipo_id) REFERENCES tipos_notificaciones(id),
    INDEX idx_usuario (usuario_id),
    INDEX idx_leido (leido)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 39: suscripciones_push
CREATE TABLE suscripciones_push (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    endpoint VARCHAR(500) NOT NULL,
    p256dh_key VARCHAR(200),
    auth_key VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    UNIQUE KEY unique_endpoint (endpoint(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================================
-- 11. TABLAS DE LOGÍSTICA Y ENVÍOS (3 tablas)
-- ======================================================

-- Tabla 40: transportistas
CREATE TABLE transportistas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(255),
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 41: envios
CREATE TABLE envios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT NOT NULL UNIQUE,
    transportista_id INT NOT NULL,
    tipo_envio ENUM('standar', 'express', 'same_day') DEFAULT 'standar',
    costo DECIMAL(12,2) NOT NULL,
    tracking_number VARCHAR(100),
    estado ENUM('pendiente', 'preparando', 'enviado', 'en_transito', 'entregado', 'fallido') DEFAULT 'pendiente',
    fecha_envio DATETIME,
    fecha_entrega_estimada DATETIME,
    fecha_entrega_real DATETIME,
    direccion_envio TEXT,
    observaciones TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (transportista_id) REFERENCES transportistas(id),
    INDEX idx_pedido (pedido_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 42: seguimiento_envios
CREATE TABLE seguimiento_envios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    envio_id INT NOT NULL,
    estado VARCHAR(50) NOT NULL,
    ubicacion VARCHAR(255),
    descripcion TEXT,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (envio_id) REFERENCES envios(id) ON DELETE CASCADE,
    INDEX idx_envio (envio_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================================
-- 12. TABLAS DE ANALYTICS Y ESTADÍSTICAS (4 tablas)
-- ======================================================

-- Tabla 43: metricas_diarias
CREATE TABLE metricas_diarias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fecha DATE NOT NULL UNIQUE,
    total_pedidos INT DEFAULT 0,
    total_ventas DECIMAL(12,2) DEFAULT 0,
    total_clientes_nuevos INT DEFAULT 0,
    total_visitas INT DEFAULT 0,
    total_productos_vendidos INT DEFAULT 0,
    promedio_valor_pedido DECIMAL(12,2) DEFAULT 0,
    conversion_rate DECIMAL(5,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_fecha (fecha)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 44: productos_top
CREATE TABLE productos_top (
    id INT PRIMARY KEY AUTO_INCREMENT,
    producto_id INT NOT NULL,
    periodo VARCHAR(20),
    ventas_totales INT DEFAULT 0,
    ingresos_totales DECIMAL(12,2) DEFAULT 0,
    fecha_actualizacion DATETIME,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    INDEX idx_producto (producto_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 45: analytics_vendedores
CREATE TABLE analytics_vendedores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    vendedor_id INT NOT NULL,
    fecha DATE NOT NULL,
    total_pedidos INT DEFAULT 0,
    total_ventas DECIMAL(12,2) DEFAULT 0,
    total_comisiones DECIMAL(12,2) DEFAULT 0,
    calificacion_promedio DECIMAL(3,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (vendedor_id) REFERENCES vendedores(id) ON DELETE CASCADE,
    UNIQUE KEY unique_vendedor_fecha (vendedor_id, fecha)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 46: historial_busquedas
CREATE TABLE historial_busquedas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    termino_busqueda VARCHAR(255) NOT NULL,
    resultados INT DEFAULT 0,
    ip_address VARCHAR(45),
    fecha_busqueda DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE,
    INDEX idx_cliente (cliente_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================================
-- 13. TABLAS DE CONFIGURACIÓN Y PARÁMETROS (4 tablas)
-- ======================================================

-- Tabla 47: configuracion_sistema
CREATE TABLE configuracion_sistema (
    id INT PRIMARY KEY AUTO_INCREMENT,
    clave VARCHAR(100) UNIQUE NOT NULL,
    valor TEXT,
    tipo ENUM('string', 'int', 'boolean', 'json') DEFAULT 'string',
    descripcion TEXT,
    grupo VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_clave (clave)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 48: logs_sistema
CREATE TABLE logs_sistema (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nivel ENUM('info', 'warning', 'error', 'critical') NOT NULL,
    mensaje TEXT NOT NULL,
    archivo VARCHAR(255),
    linea INT,
    trace JSON,
    ip_address VARCHAR(45),
    usuario_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_nivel (nivel),
    INDEX idx_fecha (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 49: logs_acceso
CREATE TABLE logs_acceso (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    accion VARCHAR(100),
    resultado VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_usuario (usuario_id),
    INDEX idx_fecha (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 50: vistas_productos
CREATE TABLE vistas_productos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    producto_id INT NOT NULL,
    cliente_id INT,
    ip_address VARCHAR(45),
    fecha_vista DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE SET NULL,
    INDEX idx_producto (producto_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================================
-- 14. TABLAS ADICIONALES (10 tablas para completar 60)
-- ======================================================

-- Tabla 51: categorias_vendedores
CREATE TABLE categorias_vendedores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    vendedor_id INT NOT NULL,
    categoria_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vendedor_id) REFERENCES vendedores(id) ON DELETE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id),
    UNIQUE KEY unique_vendedor_categoria (vendedor_id, categoria_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 52: historial_precios
CREATE TABLE historial_precios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    producto_id INT NOT NULL,
    precio_anterior DECIMAL(12,2) NOT NULL,
    precio_nuevo DECIMAL(12,2) NOT NULL,
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario_id INT,
    razon_cambio TEXT,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    INDEX idx_producto (producto_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 53: historial_stock
CREATE TABLE historial_stock (
    id INT PRIMARY KEY AUTO_INCREMENT,
    producto_id INT NOT NULL,
    stock_anterior INT NOT NULL,
    stock_nuevo INT NOT NULL,
    tipo_movimiento ENUM('entrada', 'salida', 'ajuste') NOT NULL,
    cantidad INT NOT NULL,
    referencia VARCHAR(100),
    usuario_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    INDEX idx_producto (producto_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 54: comparacion_productos
CREATE TABLE comparacion_productos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    productos_ids JSON NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 55: metodos_envio
CREATE TABLE metodos_envio (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    descripcion TEXT,
    costo_base DECIMAL(12,2) DEFAULT 0,
    costo_por_kg DECIMAL(12,2) DEFAULT 0,
    tiempo_entrega_dias INT DEFAULT 3,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 56: categorias_tiendas
CREATE TABLE categorias_tiendas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tienda_id INT NOT NULL,
    categoria_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tienda_id) REFERENCES tiendas(id) ON DELETE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id),
    UNIQUE KEY unique_tienda_categoria (tienda_id, categoria_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 57: configuracion_usuarios
CREATE TABLE configuracion_usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL UNIQUE,
    idioma VARCHAR(10) DEFAULT 'es',
    tema VARCHAR(20) DEFAULT 'light',
    notificaciones_email BOOLEAN DEFAULT TRUE,
    notificaciones_push BOOLEAN DEFAULT TRUE,
    notificaciones_sms BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 58: plataformas_pago
CREATE TABLE plataformas_pago (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    api_key VARCHAR(255),
    api_secret VARCHAR(255),
    webhook_url VARCHAR(255),
    ambiente ENUM('test', 'production') DEFAULT 'test',
    activo BOOLEAN DEFAULT TRUE,
    configuracion JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 59: paises
CREATE TABLE paises (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(3) UNIQUE NOT NULL,
    codigo_telefono VARCHAR(5),
    moneda VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 60: ciudades
CREATE TABLE ciudades (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pais_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    codigo_postal VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pais_id) REFERENCES paises(id) ON DELETE CASCADE,
    INDEX idx_pais (pais_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================================
-- INSERCIÓN DE DATOS INICIALES
-- ======================================================

-- Insertar roles
INSERT INTO roles (nombre, descripcion, nivel) VALUES
('Administrador', 'Acceso completo al sistema', 100),
('Vendedor', 'Gestiona productos y tienda', 50),
('Cliente', 'Compra productos', 10),
('Soporte', 'Atiende consultas de clientes', 30),
('Analista', 'Acceso a reportes y estadísticas', 40);

-- Insertar tipos de notificaciones
INSERT INTO tipos_notificaciones (nombre, codigo, descripcion) VALUES
('Nuevo pedido', 'nuevo_pedido', 'Notificación cuando se realiza un nuevo pedido'),
('Pedido enviado', 'pedido_enviado', 'Notificación cuando el pedido es enviado'),
('Producto en stock', 'producto_stock', 'Notificación cuando un producto vuelve a estar disponible'),
('Promoción especial', 'promocion_especial', 'Notificación de promociones especiales'),
('Mensaje nuevo', 'mensaje_nuevo', 'Notificación de mensajes nuevos'),
('Reseña recibida', 'reseña_recibida', 'Notificación de nuevas reseñas');

-- Insertar métodos de pago
INSERT INTO metodos_pago (nombre, codigo, descripcion, procesador) VALUES
('Tarjeta de Crédito/Débito', 'TC', 'Pago con tarjeta de crédito o débito', 'Stripe'),
('PayPal', 'PP', 'Pago a través de PayPal', 'PayPal'),
('Transferencia Bancaria', 'TB', 'Pago mediante transferencia bancaria', 'Banco'),
('Pago en Efectivo', 'EF', 'Pago en efectivo contra entrega', NULL);

-- Insertar transportistas
INSERT INTO transportistas (nombre, codigo, telefono, email) VALUES
('DHL Express', 'DHL', '01-800-345-6789', 'servicio@dhl.com'),
('FedEx', 'FEDEX', '01-800-333-3456', 'servicio@fedex.com'),
('UPS', 'UPS', '01-800-222-1234', 'servicio@ups.com'),
('Estafeta', 'EST', '01-800-111-4567', 'servicio@estafeta.com'),
('Correos de México', 'CORREOS', '01-800-666-7890', 'servicio@correos.com');

-- Insertar configuración inicial
INSERT INTO configuracion_sistema (clave, valor, tipo, descripcion, grupo) VALUES
('site_name', 'Marketplace Pro', 'string', 'Nombre del sitio web', 'general'),
('currency', 'MXN', 'string', 'Moneda del sistema', 'general'),
('tax_rate', '16.00', 'string', 'Tasa de impuesto (%)', 'impuestos'),
('commission_rate', '10.00', 'string', 'Comisión por venta (%)', 'vendedores'),
('max_login_attempts', '5', 'int', 'Máximo de intentos de login fallidos', 'seguridad'),
('session_timeout', '30', 'int', 'Tiempo de sesión en minutos', 'seguridad'),
('min_order_amount', '0', 'string', 'Monto mínimo de pedido', 'pedidos'),
('free_shipping_min', '500', 'string', 'Monto mínimo para envío gratis', 'envios');

-- Insertar países
INSERT INTO paises (nombre, codigo, codigo_telefono, moneda) VALUES
('México', 'MX', '+52', 'MXN'),
('Estados Unidos', 'US', '+1', 'USD'),
('Canadá', 'CA', '+1', 'CAD'),
('España', 'ES', '+34', 'EUR'),
('Argentina', 'AR', '+54', 'ARS');

-- Insertar ciudades
INSERT INTO ciudades (pais_id, nombre, codigo_postal) VALUES
(1, 'Ciudad de México', '01000'),
(1, 'Guadalajara', '44100'),
(1, 'Monterrey', '64000'),
(2, 'New York', '10001'),
(2, 'Los Angeles', '90001'),
(3, 'Toronto', 'M5V 2H1'),
(4, 'Madrid', '28001'),
(4, 'Barcelona', '08001');

-- Insertar métodos de envío
INSERT INTO metodos_envio (nombre, codigo, descripcion, costo_base, costo_por_kg, tiempo_entrega_dias) VALUES
('Estándar', 'STD', 'Envío estándar de 3-5 días', 50.00, 10.00, 5),
('Express', 'EXP', 'Envío express de 1-2 días', 100.00, 15.00, 2),
('Same Day', 'SD', 'Entrega el mismo día', 200.00, 20.00, 1);

-- Insertar plataformas de pago
INSERT INTO plataformas_pago (nombre, codigo, ambiente, activo) VALUES
('Stripe', 'STRIPE', 'test', TRUE),
('PayPal', 'PAYPAL', 'test', TRUE),
('Mercado Pago', 'MERCADO', 'test', TRUE);

-- ======================================================
-- VISTAS PARA REPORTES Y DASHBOARDS
-- ======================================================

-- Vista de pedidos completos
CREATE VIEW v_pedidos_completos AS
SELECT 
    p.id,
    p.numero_pedido,
    c.id as cliente_id,
    CONCAT(u.nombre, ' ', u.apellido) as cliente_nombre,
    p.total,
    p.estado,
    p.fecha_pedido,
    p.fecha_entrega,
    v.id as vendedor_id,
    v.nombre_empresa as vendedor_nombre,
    COUNT(pi.id) as total_items,
    SUM(pi.cantidad) as total_cantidad
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id
INNER JOIN usuarios u ON c.usuario_id = u.id
LEFT JOIN pedido_items pi ON p.id = pi.pedido_id
LEFT JOIN productos pr ON pi.producto_id = pr.id
LEFT JOIN tiendas t ON pr.tienda_id = t.id
LEFT JOIN vendedores v ON t.vendedor_id = v.id
GROUP BY p.id;

-- Vista de productos con stock
CREATE VIEW v_productos_stock AS
SELECT 
    p.id,
    p.nombre,
    p.sku,
    p.precio,
    p.stock,
    p.stock_minimo,
    p.estado,
    c.nombre as categoria_nombre,
    t.nombre_tienda as tienda_nombre,
    v.nombre_empresa as vendedor_nombre,
    CASE 
        WHEN p.stock <= p.stock_minimo THEN 'BAJO'
        WHEN p.stock <= p.stock_minimo * 2 THEN 'MEDIO'
        ELSE 'ALTO'
    END as nivel_stock
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
INNER JOIN tiendas t ON p.tienda_id = t.id
INNER JOIN vendedores v ON t.vendedor_id = v.id
WHERE p.estado = 'activo';

-- Vista de ventas por vendedor
CREATE VIEW v_ventas_vendedor AS
SELECT 
    v.id as vendedor_id,
    v.nombre_empresa,
    DATE(p.fecha_pedido) as fecha,
    COUNT(DISTINCT p.id) as total_pedidos,
    SUM(p.total) as total_ventas,
    SUM(p.total * v.comision_venta / 100) as comision_total,
    COUNT(DISTINCT p.cliente_id) as clientes_unicos
FROM vendedores v
INNER JOIN tiendas t ON v.id = t.vendedor_id
INNER JOIN productos pr ON t.id = pr.tienda_id
INNER JOIN pedido_items pi ON pr.id = pi.producto_id
INNER JOIN pedidos p ON pi.pedido_id = p.id
WHERE p.estado != 'cancelado'
GROUP BY v.id, DATE(p.fecha_pedido);

-- Vista de clientes top
CREATE VIEW v_clientes_top AS
SELECT 
    c.id,
    CONCAT(u.nombre, ' ', u.apellido) as nombre_completo,
    u.email,
    c.total_compras,
    c.total_pedidos,
    c.puntos_lealtad,
    COUNT(DISTINCT p.id) as pedidos_completados,
    SUM(p.total) as total_gastado
FROM clientes c
INNER JOIN usuarios u ON c.usuario_id = u.id
LEFT JOIN pedidos p ON c.id = p.cliente_id AND p.estado = 'entregado'
GROUP BY c.id
ORDER BY total_gastado DESC;

-- ======================================================
-- PROCEDIMIENTOS ALMACENADOS
-- ======================================================

-- Procedimiento para actualizar stock
DELIMITER //
CREATE PROCEDURE actualizar_stock(
    IN p_producto_id INT,
    IN p_cantidad INT,
    IN p_tipo_movimiento VARCHAR(10)
)
BEGIN
    DECLARE v_stock_actual INT;
    DECLARE v_stock_nuevo INT;
    DECLARE v_error_msg VARCHAR(255);
    
    -- Obtener stock actual
    SELECT stock INTO v_stock_actual FROM productos WHERE id = p_producto_id FOR UPDATE;
    
    -- Calcular nuevo stock
    IF p_tipo_movimiento = 'entrada' THEN
        SET v_stock_nuevo = v_stock_actual + p_cantidad;
    ELSEIF p_tipo_movimiento = 'salida' THEN
        IF v_stock_actual < p_cantidad THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente';
        END IF;
        SET v_stock_nuevo = v_stock_actual - p_cantidad;
    ELSEIF p_tipo_movimiento = 'ajuste' THEN
        SET v_stock_nuevo = p_cantidad;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tipo de movimiento inválido';
    END IF;
    
    -- Actualizar stock
    UPDATE productos SET stock = v_stock_nuevo, updated_at = NOW() WHERE id = p_producto_id;
    
    -- Registrar en historial
    INSERT INTO historial_stock (producto_id, stock_anterior, stock_nuevo, tipo_movimiento, cantidad)
    VALUES (p_producto_id, v_stock_actual, v_stock_nuevo, p_tipo_movimiento, p_cantidad);
    
    -- Actualizar estado si es necesario
    IF v_stock_nuevo <= 0 THEN
        UPDATE productos SET estado = 'agotado' WHERE id = p_producto_id;
    ELSEIF v_stock_nuevo > 0 AND v_stock_actual <= 0 THEN
        UPDATE productos SET estado = 'activo' WHERE id = p_producto_id;
    END IF;
END //
DELIMITER ;

-- Procedimiento para procesar pedido
DELIMITER //
CREATE PROCEDURE procesar_pedido(
    IN p_pedido_id INT
)
BEGIN
    DECLARE v_producto_id INT;
    DECLARE v_cantidad INT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur_items CURSOR FOR 
        SELECT producto_id, cantidad FROM pedido_items WHERE pedido_id = p_pedido_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    START TRANSACTION;
    
    -- Actualizar estado del pedido
    UPDATE pedidos SET estado = 'confirmado', fecha_confirmacion = NOW() 
    WHERE id = p_pedido_id;
    
    -- Actualizar stock para cada producto
    OPEN cur_items;
    
    read_loop: LOOP
        FETCH cur_items INTO v_producto_id, v_cantidad;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        CALL actualizar_stock(v_producto_id, v_cantidad, 'salida');
        
        -- Actualizar total vendidos del producto
        UPDATE productos SET total_vendidos = total_vendidos + v_cantidad 
        WHERE id = v_producto_id;
    END LOOP;
    
    CLOSE cur_items;
    
    -- Registrar en auditoría
    INSERT INTO auditoria (usuario_id, accion, tabla_afectada, registro_id, datos_nuevos)
    VALUES (NULL, 'PROCESAR_PEDIDO', 'pedidos', p_pedido_id, JSON_OBJECT('estado', 'confirmado'));
    
    COMMIT;
END //
DELIMITER ;

-- Procedimiento para calcular comisiones de vendedor
DELIMITER //
CREATE PROCEDURE calcular_comisiones_vendedor(
    IN p_vendedor_id INT,
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE
)
BEGIN
    DECLARE v_total_ventas DECIMAL(12,2);
    DECLARE v_comision_total DECIMAL(12,2);
    DECLARE v_comision_porcentaje DECIMAL(5,2);
    
    -- Obtener comisión del vendedor
    SELECT comision_venta INTO v_comision_porcentaje 
    FROM vendedores WHERE id = p_vendedor_id;
    
    -- Calcular total de ventas en el período
    SELECT SUM(p.total) INTO v_total_ventas
    FROM pedidos p
    INNER JOIN pedido_items pi ON p.id = pi.pedido_id
    INNER JOIN productos pr ON pi.producto_id = pr.id
    INNER JOIN tiendas t ON pr.tienda_id = t.id
    WHERE t.vendedor_id = p_vendedor_id
    AND p.estado = 'entregado'
    AND p.fecha_entrega BETWEEN p_fecha_inicio AND p_fecha_fin;
    
    -- Calcular comisión
    SET v_comision_total = v_total_ventas * (v_comision_porcentaje / 100);
    
    -- Insertar en analytics
    INSERT INTO analytics_vendedores (vendedor_id, fecha, total_ventas, total_comisiones)
    VALUES (p_vendedor_id, CURDATE(), v_total_ventas, v_comision_total)
    ON DUPLICATE KEY UPDATE
        total_ventas = v_total_ventas,
        total_comisiones = v_comision_total;
    
    -- Retornar resultados
    SELECT v_total_ventas as total_ventas, v_comision_total as comision_total;
END //
DELIMITER ;

-- ======================================================
-- TRIGGERS
-- ======================================================

-- Trigger para actualizar el historial de estado de pedidos
DELIMITER //
CREATE TRIGGER tr_pedido_estado_update
AFTER UPDATE ON pedidos
FOR EACH ROW
BEGIN
    IF OLD.estado != NEW.estado THEN
        INSERT INTO historial_estados_pedido (pedido_id, estado_anterior, estado_nuevo)
        VALUES (NEW.id, OLD.estado, NEW.estado);
    END IF;
END //
DELIMITER ;

-- Trigger para actualizar métricas al cambiar estado de pedido
DELIMITER //
CREATE TRIGGER tr_pedido_metrics_update
AFTER UPDATE ON pedidos
FOR EACH ROW
BEGIN
    IF NEW.estado = 'entregado' AND OLD.estado != 'entregado' THEN
        -- Actualizar métricas del cliente
        UPDATE clientes 
        SET total_compras = total_compras + NEW.total,
            total_pedidos = total_pedidos + 1,
            ultima_compra = NOW()
        WHERE id = NEW.cliente_id;
        
        -- Actualizar métricas diarias
        INSERT INTO metricas_diarias (fecha, total_pedidos, total_ventas, total_productos_vendidos)
        VALUES (CURDATE(), 1, NEW.total, (SELECT SUM(cantidad) FROM pedido_items WHERE pedido_id = NEW.id))
        ON DUPLICATE KEY UPDATE
            total_pedidos = total_pedidos + 1,
            total_ventas = total_ventas + NEW.total;
            
        -- Actualizar analytics de vendedores
        UPDATE analytics_vendedores av
        INNER JOIN pedido_items pi ON pi.pedido_id = NEW.id
        INNER JOIN productos pr ON pi.producto_id = pr.id
        INNER JOIN tiendas t ON pr.tienda_id = t.id
        SET av.total_pedidos = av.total_pedidos + 1,
            av.total_ventas = av.total_ventas + (pi.subtotal)
        WHERE av.vendedor_id = t.vendedor_id AND av.fecha = CURDATE();
    END IF;
END //
DELIMITER ;

-- Trigger para auditoría de productos
DELIMITER //
CREATE TRIGGER tr_producto_audit
AFTER UPDATE ON productos
FOR EACH ROW
BEGIN
    INSERT INTO auditoria (usuario_id, accion, tabla_afectada, registro_id, datos_anteriores, datos_nuevos)
    VALUES (NULL, 'ACTUALIZAR_PRODUCTO', 'productos', NEW.id,
        JSON_OBJECT('precio', OLD.precio, 'stock', OLD.stock, 'estado', OLD.estado),
        JSON_OBJECT('precio', NEW.precio, 'stock', NEW.stock, 'estado', NEW.estado));
END //
DELIMITER ;

-- Trigger para actualizar carrito al agregar items
DELIMITER //
CREATE TRIGGER tr_carrito_update
AFTER INSERT ON carrito_items
FOR EACH ROW
BEGIN
    UPDATE carritos 
    SET total_items = total_items + 1,
        subtotal = subtotal + NEW.subtotal,
        total = total + NEW.subtotal
    WHERE id = NEW.carrito_id;
END //
DELIMITER ;

-- ======================================================
-- FUNCIONES
-- ======================================================

-- Función para calcular impuestos
DELIMITER //
CREATE FUNCTION calcular_impuestos(
    monto DECIMAL(12,2),
    tasa_impuesto DECIMAL(5,2)
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    RETURN ROUND(monto * tasa_impuesto / 100, 2);
END //
DELIMITER ;

-- Función para obtener nivel de stock
DELIMITER //
CREATE FUNCTION nivel_stock(
    stock_actual INT,
    stock_minimo INT
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF stock_actual <= 0 THEN
        RETURN 'AGOTADO';
    ELSEIF stock_actual <= stock_minimo THEN
        RETURN 'BAJO';
    ELSEIF stock_actual <= stock_minimo * 2 THEN
        RETURN 'MEDIO';
    ELSE
        RETURN 'ALTO';
    END IF;
END //
DELIMITER ;

-- Función para calcular descuento
DELIMITER //
CREATE FUNCTION calcular_descuento(
    precio DECIMAL(12,2),
    porcentaje_descuento DECIMAL(5,2)
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    RETURN ROUND(precio - (precio * porcentaje_descuento / 100), 2);
END //
DELIMITER ;

-- Función para obtener total de pedidos por cliente
DELIMITER //
CREATE FUNCTION total_pedidos_cliente(
    p_cliente_id INT
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_total INT;
    SELECT COUNT(*) INTO v_total 
    FROM pedidos 
    WHERE cliente_id = p_cliente_id AND estado = 'entregado';
    RETURN v_total;
END //
DELIMITER ;

-- ======================================================
-- ÍNDICES ADICIONALES PARA OPTIMIZACIÓN
-- ======================================================

CREATE INDEX idx_pedidos_cliente_estado ON pedidos(cliente_id, estado);
CREATE INDEX idx_pedidos_fecha_estado ON pedidos(fecha_pedido, estado);
CREATE INDEX idx_productos_precio_estado ON productos(precio, estado);
CREATE INDEX idx_productos_categoria_estado ON productos(categoria_id, estado);
CREATE INDEX idx_pago_pedido_estado ON pagos(pedido_id, estado);
CREATE INDEX idx_carrito_cliente ON carrito_items(carrito_id);
CREATE INDEX idx_mensajes_conversacion_fecha ON mensajes(conversacion_id, created_at);
CREATE INDEX idx_envios_estado ON envios(estado);
CREATE INDEX idx_notificaciones_usuario_leido ON notificaciones(usuario_id, leido);
CREATE INDEX idx_vistas_producto_fecha ON vistas_productos(producto_id, fecha_vista);

-- ======================================================
-- FIN DEL SCRIPT - 60 TABLAS COMPLETAS
-- ======================================================
<?php
require_once __DIR__ . '/Model.php';

class ProductoModel extends Model {
    /**
     * Obtiene una lista paginada y filtrada de productos
     */
    public function getAll(int $limit = 10, int $offset = 0, string $search = '', ?int $categoria_id = null, ?int $tienda_id = null): array {
        $sql = "SELECT p.*, c.nombre as categoria_nombre, t.nombre_tienda, 
                       (SELECT url FROM imagenes_productos WHERE producto_id = p.id ORDER BY principal DESC, orden ASC LIMIT 1) as imagen_principal
                FROM productos p
                INNER JOIN categorias c ON p.categoria_id = c.id
                INNER JOIN tiendas t ON p.tienda_id = t.id
                WHERE 1=1";
        
        $params = [];

        if (!empty($search)) {
            $sql .= " AND (p.nombre LIKE :search OR p.sku LIKE :search OR p.descripcion_corta LIKE :search)";
            $params[':search'] = '%' . $search . '%';
        }

        if ($categoria_id !== null && $categoria_id > 0) {
            $sql .= " AND p.categoria_id = :categoria_id";
            $params[':categoria_id'] = $categoria_id;
        }

        if ($tienda_id !== null && $tienda_id > 0) {
            $sql .= " AND p.tienda_id = :tienda_id";
            $params[':tienda_id'] = $tienda_id;
        }

        $sql .= " ORDER BY p.id DESC LIMIT :limit OFFSET :offset";

        $stmt = $this->db->prepare($sql);

        foreach ($params as $key => $val) {
            $stmt->bindValue($key, $val);
        }

        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->fetchAll();
    }

    /**
     * Cuenta el total de productos según los filtros aplicados
     */
    public function countFiltered(string $search = '', ?int $categoria_id = null, ?int $tienda_id = null): int {
        $sql = "SELECT COUNT(*) as total FROM productos p WHERE 1=1";
        $params = [];

        if (!empty($search)) {
            $sql .= " AND (p.nombre LIKE :search OR p.sku LIKE :search OR p.descripcion_corta LIKE :search)";
            $params[':search'] = '%' . $search . '%';
        }

        if ($categoria_id !== null && $categoria_id > 0) {
            $sql .= " AND p.categoria_id = :categoria_id";
            $params[':categoria_id'] = $categoria_id;
        }

        if ($tienda_id !== null && $tienda_id > 0) {
            $sql .= " AND p.tienda_id = :tienda_id";
            $params[':tienda_id'] = $tienda_id;
        }

        $stmt = $this->db->prepare($sql);
        $stmt->execute($params);
        $row = $stmt->fetch();
        return (int)($row['total'] ?? 0);
    }

    /**
     * Obtiene productos destacados para el Home
     */
    public function getDestacados(int $limit = 6): array {
        $sql = "SELECT p.*, c.nombre as categoria_nombre, t.nombre_tienda,
                       (SELECT url FROM imagenes_productos WHERE producto_id = p.id ORDER BY principal DESC, orden ASC LIMIT 1) as imagen_principal
                FROM productos p
                INNER JOIN categorias c ON p.categoria_id = c.id
                INNER JOIN tiendas t ON p.tienda_id = t.id
                WHERE p.estado = 'activo' AND (p.destacado = 1 OR p.oferta = 1 OR p.nuevo = 1)
                ORDER BY p.total_vendidos DESC, p.id DESC
                LIMIT :limit";
        
        $stmt = $this->db->prepare($sql);
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    /**
     * Obtiene el detalle de un producto por ID
     */
    public function getById(int $id): ?array {
        $sql = "SELECT p.*, c.nombre as categoria_nombre, t.nombre_tienda, v.nombre_empresa as vendedor_nombre
                FROM productos p
                INNER JOIN categorias c ON p.categoria_id = c.id
                INNER JOIN tiendas t ON p.tienda_id = t.id
                INNER JOIN vendedores v ON t.vendedor_id = v.id
                WHERE p.id = :id";
        
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':id' => $id]);
        $product = $stmt->fetch();

        if (!$product) return null;

        // Cargar imágenes
        $sqlImg = "SELECT * FROM imagenes_productos WHERE producto_id = :id ORDER BY principal DESC, orden ASC";
        $stmtImg = $this->db->prepare($sqlImg);
        $stmtImg->execute([':id' => $id]);
        $product['imagenes'] = $stmtImg->fetchAll();

        return $product;
    }

    /**
     * Crea un nuevo producto
     */
    public function create(array $data): int {
        $this->beginTransaction();
        try {
            $sql = "INSERT INTO productos (tienda_id, categoria_id, nombre, slug, descripcion_corta, descripcion_larga, sku, precio, precio_oferta, stock, stock_minimo, estado, destacado, nuevo, oferta, fecha_publicacion)
                    VALUES (:tienda_id, :categoria_id, :nombre, :slug, :descripcion_corta, :descripcion_larga, :sku, :precio, :precio_oferta, :stock, :stock_minimo, :estado, :destacado, :nuevo, :oferta, NOW())";
            
            $stmt = $this->db->prepare($sql);
            $stmt->execute([
                ':tienda_id' => $data['tienda_id'],
                ':categoria_id' => $data['categoria_id'],
                ':nombre' => $data['nombre'],
                ':slug' => $data['slug'],
                ':descripcion_corta' => $data['descripcion_corta'] ?? '',
                ':descripcion_larga' => $data['descripcion_larga'] ?? '',
                ':sku' => $data['sku'],
                ':precio' => $data['precio'],
                ':precio_oferta' => $data['precio_oferta'] ?? null,
                ':stock' => $data['stock'] ?? 0,
                ':stock_minimo' => $data['stock_minimo'] ?? 5,
                ':estado' => $data['estado'] ?? 'activo',
                ':destacado' => $data['destacado'] ?? 0,
                ':nuevo' => $data['nuevo'] ?? 1,
                ':oferta' => $data['oferta'] ?? 0
            ]);

            $productoId = (int)$this->db->lastInsertId();

            // Insertar imagen principal si existe
            if (!empty($data['imagen_url'])) {
                $sqlImg = "INSERT INTO imagenes_productos (producto_id, url, alt, principal) VALUES (:producto_id, :url, :alt, 1)";
                $stmtImg = $this->db->prepare($sqlImg);
                $stmtImg->execute([
                    ':producto_id' => $productoId,
                    ':url' => $data['imagen_url'],
                    ':alt' => $data['nombre']
                ]);
            }

            $this->commit();
            return $productoId;
        } catch (Exception $e) {
            $this->rollBack();
            throw $e;
        }
    }

    /**
     * Actualiza un producto existente
     */
    public function update(int $id, array $data): bool {
        $sql = "UPDATE productos SET
                    categoria_id = :categoria_id,
                    nombre = :nombre,
                    descripcion_corta = :descripcion_corta,
                    descripcion_larga = :descripcion_larga,
                    precio = :precio,
                    precio_oferta = :precio_oferta,
                    stock = :stock,
                    estado = :estado,
                    destacado = :destacado,
                    oferta = :oferta,
                    updated_at = NOW()
                WHERE id = :id";
        
        $stmt = $this->db->prepare($sql);
        return $stmt->execute([
            ':id' => $id,
            ':categoria_id' => $data['categoria_id'],
            ':nombre' => $data['nombre'],
            ':descripcion_corta' => $data['descripcion_corta'] ?? '',
            ':descripcion_larga' => $data['descripcion_larga'] ?? '',
            ':precio' => $data['precio'],
            ':precio_oferta' => $data['precio_oferta'] ?? null,
            ':stock' => $data['stock'],
            ':estado' => $data['estado'] ?? 'activo',
            ':destacado' => $data['destacado'] ?? 0,
            ':oferta' => $data['oferta'] ?? 0
        ]);
    }

    /**
     * Elimina un producto por ID
     */
    public function delete(int $id): bool {
        $stmt = $this->db->prepare("DELETE FROM productos WHERE id = :id");
        return $stmt->execute([':id' => $id]);
    }

    /**
     * Invoca el Procedimiento Almacenado CALL actualizar_stock(?, ?, ?)
     */
    public function updateStockSP(int $productoId, int $cantidad, string $tipoMovimiento = 'salida'): bool {
        $stmt = $this->db->prepare("CALL actualizar_stock(:producto_id, :cantidad, :tipo_movimiento)");
        return $stmt->execute([
            ':producto_id' => $productoId,
            ':cantidad' => $cantidad,
            ':tipo_movimiento' => $tipoMovimiento
        ]);
    }

    /**
     * Obtiene la lista de categorías activas
     */
    public function getCategorias(): array {
        $stmt = $this->db->query("SELECT id, nombre, slug FROM categorias WHERE activo = 1 ORDER BY nombre ASC");
        return $stmt->fetchAll();
    }
}

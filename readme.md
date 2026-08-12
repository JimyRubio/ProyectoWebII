# ProyectoWebII

Instrucciones básicas para poner en funcionamiento el proyecto.

## Pasos para ejecutar

1. Asegúrate de tener MySQL corriendo. Puedes usar MySQL Workbench o cualquier cliente.
	- Puerto: el puerto predeterminado es `3306`.
	- Usuario: `root` (sin contraseña por defecto).

2. Configura la conexión de la aplicación a la base de datos si es necesario (host, puerto, usuario).

3. En la carpeta raíz del proyecto ejecuta (o haz doble clic en) `start.bat` para levantar el servidor:

```bat
start.bat
```

4. Abre tu navegador y accede a la URL que use la aplicación (por ejemplo `http://localhost:<puerto>`).

**Nota:** Si tu instalación de MySQL requiere contraseña para `root`, actualiza la configuración de la aplicación con las credenciales correspondientes.

## Configuración y respaldo de la base de datos

Dentro del proyecto hay un archivo `dump.sql` que es el respaldo (backup) de la base de datos.

Restaurar el `dump.sql`:

- Usando MySQL Workbench: `Server` → `Data Import` → `Import from Self-Contained File` → seleccionar `dump.sql` → `Start Import`.
- Desde la línea de comandos (Windows):

```bat
mysql -u root < path\to\dump.sql
# Si tu root tiene contraseña usa:
mysql -u root -p < path\to\dump.sql
```

Ejemplo de variables de entorno (archivo `.env` o configuración equivalente):

```
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASS=
DB_NAME=nombre_de_bd
```

Después de ajustar la configuración de la base de datos, ejecuta `start.bat` para levantar el servidor.


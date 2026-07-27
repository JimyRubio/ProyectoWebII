<?php
/**
 * CertHelper - Utilidad para gestionar certificados SSL CA
 * 
 * Descarga automáticamente el bundle de certificados CA de Mozilla
 * necesario para verificar conexiones SSL/TLS (SMTP, cURL, etc.)
 * 
 * El bundle se descarga de https://curl.se/ca/cacert.pem
 * y se almacena en la carpeta certs/ del proyecto.
 */

class CertHelper {
    
    /**
     * Ruta donde se almacena el archivo cacert.pem
     */
    private static string $certDir = '';
    private static string $certFile = '';

    /**
     * Inicializa las rutas de certificados
     */
    private static function init(): void {
        if (empty(self::$certDir)) {
            // La carpeta certs estará en la raíz del proyecto (junto a config/)
            self::$certDir = dirname(__DIR__, 2) . DIRECTORY_SEPARATOR . 'certs' . DIRECTORY_SEPARATOR;
            self::$certFile = self::$certDir . 'cacert.pem';
        }
    }

    /**
     * Verifica si el archivo cacert.pem existe y es válido
     */
    public static function certExists(): bool {
        self::init();
        return file_exists(self::$certFile) && filesize(self::$certFile) > 1000;
    }

    /**
     * Obtiene la ruta absoluta al archivo cacert.pem
     */
    public static function getCertPath(): string {
        self::init();
        return self::$certFile;
    }

    /**
     * Obtiene la ruta absoluta al directorio de certificados
     */
    public static function getCertDir(): string {
        self::init();
        return self::$certDir;
    }

    /**
     * Descarga el bundle de certificados CA desde curl.se
     * 
     * @param bool $force Si true, descarga aunque ya exista
     * @return array ['success' => bool, 'message' => string]
     */
    public static function downloadCertificates(bool $force = false): array {
        self::init();

        // Si ya existe y no se fuerza la descarga, retornar éxito
        if (!$force && self::certExists()) {
            return [
                'success' => true,
                'message' => 'El archivo cacert.pem ya existe y es válido'
            ];
        }

        // Crear el directorio si no existe
        if (!is_dir(self::$certDir)) {
            if (!@mkdir(self::$certDir, 0777, true)) {
                return [
                    'success' => false,
                    'message' => 'No se pudo crear el directorio: ' . self::$certDir
                ];
            }
        }

        // URL del bundle oficial de certificados CA (Mozilla)
        $url = 'https://curl.se/ca/cacert.pem';

        // Intentar descargar con file_get_contents
        $ctx = stream_context_create([
            'ssl' => [
                'verify_peer' => false,
                'verify_peer_name' => false,
                'allow_self_signed' => true,
            ],
            'http' => [
                'timeout' => 30,
                'user_agent' => 'MarketZone CertHelper/1.0',
            ],
        ]);

        $certContent = @file_get_contents($url, false, $ctx);

        if ($certContent === false) {
            // Intentar con cURL como fallback
            if (function_exists('curl_init')) {
                $ch = curl_init();
                curl_setopt_array($ch, [
                    CURLOPT_URL => $url,
                    CURLOPT_RETURNTRANSFER => true,
                    CURLOPT_TIMEOUT => 30,
                    CURLOPT_SSL_VERIFYPEER => false,
                    CURLOPT_USERAGENT => 'MarketZone CertHelper/1.0',
                    CURLOPT_FOLLOWLOCATION => true,
                ]);
                $certContent = curl_exec($ch);
                $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
                curl_close($ch);

                if ($certContent === false || $httpCode !== 200) {
                    return [
                        'success' => false,
                        'message' => 'No se pudo descargar el bundle de certificados. ' .
                                     'Verifica tu conexión a internet e intenta de nuevo.'
                    ];
                }
            } else {
                // Como último recurso, crear un archivo con la advertencia
                $certContent = self::generateWarningPem();
                file_put_contents(self::$certFile, $certContent);
                return [
                    'success' => false,
                    'message' => 'No se pudo descargar el bundle de certificados. ' .
                                 'Descarga manualmente desde: https://curl.se/ca/cacert.pem ' .
                                 'y colócalo en: ' . self::$certFile
                ];
            }
        }

        // Validar que el contenido sea un PEM válido
        if (strpos($certContent, 'BEGIN CERTIFICATE') === false) {
            file_put_contents(self::$certFile, $certContent); // Guardar para depuración
            return [
                'success' => false,
                'message' => 'El archivo descargado no parece ser un bundle PEM válido'
            ];
        }

        // Guardar el archivo
        $bytes = file_put_contents(self::$certFile, $certContent);
        if ($bytes === false) {
            return [
                'success' => false,
                'message' => 'No se pudo escribir el archivo: ' . self::$certFile
            ];
        }

        return [
            'success' => true,
            'message' => 'Bundle de certificados descargado correctamente (' . 
                         round($bytes / 1024) . ' KB)'
        ];
    }

    /**
     * Genera un archivo PEM con instrucciones (fallback cuando no se puede descargar)
     */
    private static function generateWarningPem(): string {
        return "# ============================================================\n" .
               "# IMPORTANTE: Descarga el bundle oficial de certificados CA\n" .
               "# ============================================================\n" .
               "# \n" .
               "# Visita: https://curl.se/ca/cacert.pem\n" .
               "# Descarga el archivo y colócalo en:\n" .
               "# " . self::$certFile . "\n" .
               "# \n" .
               "# O ejecuta este script PHP desde la terminal:\n" .
               "# php -r \"require 'app/Helpers/CertHelper.php'; CertHelper::downloadCertificates(true);\"\n" .
               "# \n" .
               "# Mientras tanto, PHPMailer usará verificación SSL deshabilitada.\n" .
               "# ============================================================\n";
    }

    /**
     * Configura las opciones SSL predeterminadas para PHPMailer
     * Usa el certificado si está disponible, sino deshabilita verificación
     * 
     * @param PHPMailer\PHPMailer\PHPMailer $mail Instancia de PHPMailer
     */
    public static function configureMailerSSL($mail): void {
        self::init();

        if (self::certExists()) {
            // Certificado disponible: habilitar verificación SSL
            $mail->SMTPOptions = [
                'ssl' => [
                    'verify_peer' => true,
                    'verify_peer_name' => true,
                    'allow_self_signed' => false,
                    'cafile' => self::$certFile,
                    'CN_match' => 'smtp.gmail.com',
                ],
            ];
            // Dejar que PHPMailer maneje TLS automáticamente
            $mail->SMTPAutoTLS = true;
        } else {
            // Sin certificado: deshabilitar verificación SSL
            $mail->SMTPOptions = [
                'ssl' => [
                    'verify_peer' => false,
                    'verify_peer_name' => false,
                    'allow_self_signed' => true,
                ],
            ];
            $mail->SMTPAutoTLS = false;
        }
    }
}

// ============================================================
// EJECUCIÓN AUTOMÁTICA al incluir este archivo
// ============================================================
// Si el archivo cacert.pem no existe, intenta descargarlo
if (!CertHelper::certExists()) {
    $result = CertHelper::downloadCertificates();
    if (!$result['success']) {
        error_log('[CertHelper] ' . $result['message']);
    }
}


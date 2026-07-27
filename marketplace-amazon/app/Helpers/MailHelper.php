<?php
/**
 * MailHelper - Clase para enviar correos electrónicos usando PHPMailer
 * Configurado para Gmail SMTP
 */

// Cargar PHPMailer manualmente
require_once ROOT_PATH . '../PHPMailer-master/src/PHPMailer.php';
require_once ROOT_PATH . '../PHPMailer-master/src/SMTP.php';
require_once ROOT_PATH . '../PHPMailer-master/src/Exception.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

class MailHelper {

    /**
     * Envía un correo electrónico usando SMTP de Gmail
     *
     * @param string $toEmail Correo del destinatario
     * @param string $toName Nombre del destinatario
     * @param string $subject Asunto del correo
     * @param string $bodyHTML Cuerpo del correo en HTML
     * @param string $altBody Cuerpo alternativo en texto plano (opcional)
     * @return array ['success' => bool, 'message' => string]
     */
    public static function sendEmail(string $toEmail, string $toName, string $subject, string $bodyHTML, string $altBody = ''): array {
        // Intentar primero con STARTTLS (puerto 587), si falla probar con SSL (puerto 465)
        $configs = [
            ['secure' => PHPMailer::ENCRYPTION_STARTTLS, 'port' => 587],
            ['secure' => PHPMailer::ENCRYPTION_SMTPS,   'port' => 465],
        ];

        $lastError = '';

        foreach ($configs as $config) {
            try {
                $mail = new PHPMailer(true);
                
                // Configuración del servidor SMTP (Gmail)
                $mail->isSMTP();
                $mail->Host       = SMTP_HOST;
                $mail->SMTPAuth   = SMTP_AUTH;
                $mail->Username   = SMTP_USER;
                $mail->Password   = SMTP_PASS;
                $mail->SMTPSecure = $config['secure'];
                $mail->Port       = $config['port'];

                // === IMPORTANTE: Deshabilitar verificación SSL para evitar errores de certificado ===
                // En Windows/entornos locales los certificados CA suelen no estar configurados.
                // Esto permite que el envío funcione sin importar el entorno.
                $mail->SMTPOptions = [
                    'ssl' => [
                        'verify_peer'       => false,
                        'verify_peer_name'  => false,
                        'allow_self_signed' => true,
                    ],
                ];
                // Deshabilitar TLS automático para evitar conflictos
                $mail->SMTPAutoTLS = false;
                
                // Deshabilitar debug en producción
                $mail->SMTPDebug  = SMTP_DEBUG;
                
                // Configuración del charset
                $mail->CharSet = 'UTF-8';
                
                // Remitente
                $mail->setFrom(SMTP_FROM_EMAIL, SMTP_FROM_NAME);
                
                // Destinatario
                $mail->addAddress($toEmail, $toName);
                
                // Responder a
                $mail->addReplyTo(SMTP_FROM_EMAIL, SMTP_FROM_NAME);
                
                // Contenido
                $mail->isHTML(true);
                $mail->Subject = $subject;
                $mail->Body    = $bodyHTML;
                $mail->AltBody = !empty($altBody) ? $altBody : strip_tags($bodyHTML);
                
                $mail->send();
                return [
                    'success' => true,
                    'message' => 'Correo enviado exitosamente'
                ];
            } catch (Exception $e) {
                $lastError = "Error con {$config['secure']}: {$mail->ErrorInfo}";
                error_log($lastError);
                continue; // Probar siguiente configuración
            }
        }

        // Si llegamos aquí, ambos métodos fallaron
        $errorMsg = "Error al enviar correo: {$lastError}";
        error_log($errorMsg);
        return [
            'success' => false,
            'message' => $errorMsg
        ];
    }

    /**
     * Envía el correo de recuperación de contraseña
     *
     * @param string $toEmail Correo del destinatario
     * @param string $toName Nombre del destinatario
     * @param string $token Token de recuperación
     * @param string $resetURL URL completa para restablecer
     * @return array ['success' => bool, 'message' => string]
     */
    public static function sendPasswordResetEmail(string $toEmail, string $toName, string $token, string $resetURL): array {
        $subject = 'Recuperación de Contraseña - ' . APP_NAME;
        
        $bodyHTML = '
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <style>
                body { font-family: Arial, Helvetica, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; }
                .container { max-width: 600px; margin: 20px auto; background: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 16px rgba(0,0,0,0.1); }
                .header { background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%); padding: 30px; text-align: center; }
                .header h1 { color: #ffffff; margin: 0; font-size: 24px; }
                .header p { color: rgba(255,255,255,0.85); margin: 8px 0 0; font-size: 14px; }
                .content { padding: 30px; }
                .content h2 { color: #1f2937; font-size: 20px; margin: 0 0 15px; }
                .content p { color: #4b5563; line-height: 1.6; margin: 0 0 20px; font-size: 14px; }
                .btn { display: inline-block; padding: 14px 32px; background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%); color: #ffffff !important; text-decoration: none; border-radius: 8px; font-weight: 600; font-size: 15px; margin: 10px 0; }
                .btn:hover { opacity: 0.9; }
                .token-box { background: #f3f4f6; border: 1px solid #e5e7eb; border-radius: 8px; padding: 16px; margin: 20px 0; text-align: center; }
                .token-box p { margin: 0 0 8px; font-size: 12px; color: #6b7280; text-transform: uppercase; letter-spacing: 1px; }
                .token-box .token { font-family: monospace; font-size: 14px; color: #1f2937; background: #ffffff; padding: 8px 16px; border-radius: 4px; border: 1px solid #d1d5db; display: inline-block; word-break: break-all; }
                .footer { background: #f9fafb; padding: 20px 30px; text-align: center; border-top: 1px solid #e5e7eb; }
                .footer p { color: #9ca3af; font-size: 12px; margin: 0; }
                .footer a { color: #6366f1; text-decoration: none; }
                .info { background: #eef2ff; border-left: 4px solid #6366f1; padding: 12px 16px; margin: 20px 0; border-radius: 4px; }
                .info p { margin: 0; font-size: 13px; color: #4338ca; }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>' . APP_NAME . '</h1>
                    <p>Recuperación de Contraseña</p>
                </div>
                <div class="content">
                    <h2>Hola, ' . htmlspecialchars($toName) . '</h2>
                    <p>Hemos recibido una solicitud para restablecer la contraseña de tu cuenta. Si no realizaste esta solicitud, puedes ignorar este correo.</p>
                    
                    <div style="text-align: center;">
                        <a href="' . $resetURL . '" class="btn">Restablecer Contraseña</a>
                    </div>
                    
                    <p style="text-align: center; font-size: 13px; color: #6b7280;">O copia y pega el siguiente enlace en tu navegador:</p>
                    <p style="text-align: center; font-size: 12px; word-break: break-all; color: #6366f1;">' . $resetURL . '</p>
                    
                    <div class="info">
                        <p>⏰ Este enlace expirará en 1 hora por seguridad.</p>
                    </div>
                    
                    <div class="token-box">
                        <p>Token de recuperación</p>
                        <div class="token">' . htmlspecialchars($token) . '</div>
                    </div>
                    
                    <p style="font-size: 13px; color: #6b7280; margin-top: 20px;">Si tienes problemas con el enlace, copia el token de recuperación y pégalo en la página de restablecimiento de contraseña.</p>
                </div>
                <div class="footer">
                    <p>&copy; ' . date('Y') . ' ' . APP_NAME . '. Todos los derechos reservados.</p>
                    <p>Este es un correo automático, por favor no respondas a este mensaje.</p>
                </div>
            </div>
        </body>
        </html>';
        
        $altBody = "Hola $toName,\n\nHemos recibido una solicitud para restablecer la contraseña de tu cuenta.\n\n"
                 . "Para restablecer tu contraseña, visita el siguiente enlace:\n$resetURL\n\n"
                 . "O usa el siguiente token en la página de restablecimiento:\n$token\n\n"
                 . "Este enlace expirará en 1 hora por seguridad.\n\n"
                 . "Si no solicitaste este cambio, ignora este correo.\n\n- " . APP_NAME;
        
        return self::sendEmail($toEmail, $toName, $subject, $bodyHTML, $altBody);
    }
}


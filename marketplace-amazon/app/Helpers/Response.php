<?php

class Response {
    /**
     * Retorna una respuesta JSON estandarizada y finaliza la ejecución
     */
    public static function json(bool $success, $data = null, string $message = '', int $code = 200): void {
        http_response_code($code);
        header('Content-Type: application/json; charset=utf-8');
        
        $response = [
            'success' => $success,
            'message' => $message,
            'data'    => $data,
            'timestamp' => date('Y-m-d H:i:s')
        ];

        echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
        exit;
    }

    /**
     * Respuesta rápida de éxito (200 OK)
     */
    public static function success($data = null, string $message = 'Operación realizada con éxito', int $code = 200): void {
        self::json(true, $data, $message, $code);
    }

    /**
     * Respuesta rápida de error
     */
    public static function error(string $message = 'Ocurrió un error en la solicitud', int $code = 400, $data = null): void {
        self::json(false, $data, $message, $code);
    }
}

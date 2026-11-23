<?php
// config/Conexion.php - Clase Singleton PDO para SQL Server
class Conexion {
    private static ?PDO $instancia = null;

    public static function obtenerConexion(): PDO {
        if (self::$instancia === null) {
            $servidor = "localhost";
            $baseDatos = "hospedaje_glorys_bd";
            $usuario = "sa";
            $password = "TuPasswordSeguro123";

            // DSN para Microsoft SQL Server via PDO_SQLSRV
            $dsn = "sqlsrv:Server=$servidor;Database=$baseDatos";

            try {
                self::$instancia = new PDO($dsn, $usuario, $password, [
                    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
                ]);
            } catch (PDOException $e) {
                http_response_code(500);
                echo json_encode([
                    'exito' => false,
                    'error' => 'Error de conexión a la base de datos SQL Server: ' . $e->getMessage()
                ]);
                exit;
            }
        }
        return self::$instancia;
    }
}
?>
<?php
// models/ClienteModel.php
require_once __DIR__ . '/../config/Conexion.php';

class ClienteModel {
    private PDO $db;

    public function __construct() {
        $this->db = Conexion::obtenerConexion();
    }

    public function listar(): array {
        $sql = "SELECT id_cliente, tipo_documento, numero_documento, nombres, apellidos, telefono, email, fecha_registro 
                FROM clientes ORDER BY id_cliente DESC";
        $stmt = $this->db->prepare($sql);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public function obtenerPorId(int $id): ?array {
        $sql = "SELECT * FROM clientes WHERE id_cliente = :id";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':id' => $id]);
        $res = $stmt->fetch();
        return $res ?: null;
    }

    public function crear(array $d): int {
        $sql = "INSERT INTO clientes (tipo_documento, numero_documento, nombres, apellidos, telefono, email) 
                VALUES (:tipo, :num, :nombres, :apellidos, :tel, :email)";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([
            ':tipo'      => $d['tipo_documento'] ?? 'DNI',
            ':num'       => $d['numero_documento'],
            ':nombres'   => $d['nombres'],
            ':apellidos' => $d['apellidos'],
            ':tel'       => $d['telefono'] ?? null,
            ':email'     => $d['email'] ?? null
        ]);
        return (int)$this->db->lastInsertId();
    }

    public function actualizar(int $id, array $d): bool {
        $sql = "UPDATE clientes 
                SET tipo_documento = :tipo, numero_documento = :num, nombres = :nombres, 
                    apellidos = :apellidos, telefono = :tel, email = :email 
                WHERE id_cliente = :id";
        $stmt = $this->db->prepare($sql);
        return $stmt->execute([
            ':id'        => $id,
            ':tipo'      => $d['tipo_documento'],
            ':num'       => $d['numero_documento'],
            ':nombres'   => $d['nombres'],
            ':apellidos' => $d['apellidos'],
            ':tel'       => $d['telefono'] ?? null,
            ':email'     => $d['email'] ?? null
        ]);
    }

    public function eliminar(int $id): bool {
        $sql = "DELETE FROM clientes WHERE id_cliente = :id";
        $stmt = $this->db->prepare($sql);
        return $stmt->execute([':id' => $id]);
    }
}
?>
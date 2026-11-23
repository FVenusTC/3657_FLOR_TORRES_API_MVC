<?php
// models/ReservaModel.php
require_once __DIR__ . '/../config/Conexion.php';

class ReservaModel {
    private PDO $db;

    public function __construct() {
        $this->db = Conexion::obtenerConexion();
    }

    public function listar(): array {
        $sql = "SELECT r.id_reserva, r.codigo_reserva, CONCAT(c.nombres, ' ', c.apellidos) AS cliente, 
                    h.numero_habitacion, r.fecha_checkin, r.fecha_checkout, r.monto_total, r.estado_reserva
                FROM reservas r
                INNER JOIN clientes c ON r.id_cliente = c.id_cliente
                INNER JOIN habitaciones h ON r.id_habitacion = h.id_habitacion
                ORDER BY r.id_reserva DESC";
        $stmt = $this->db->prepare($sql);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public function obtenerPorId(int $id): ?array {
        $sql = "SELECT * FROM reservas WHERE id_reserva = :id";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':id' => $id]);
        $res = $stmt->fetch();
        return $res ?: null;
    }

    public function crearConSP(int $idCliente, int $idHabitacion, string $checkin, string $checkout): array {
        $sql = "EXEC sp_registrar_reserva 
                    @p_id_cliente = :cliente, 
                    @p_id_habitacion = :habitacion, 
                    @p_fecha_checkin = :checkin, 
                    @p_fecha_checkout = :checkout, 
                    @p_codigo_reserva = :codigo OUTPUT, 
                    @p_monto_total = :monto OUTPUT";

        $stmt = $this->db->prepare($sql);
        $stmt->bindParam(':cliente', $idCliente, PDO::PARAM_INT);
        $stmt->bindParam(':habitacion', $idHabitacion, PDO::PARAM_INT);
        $stmt->bindParam(':checkin', $checkin);
        $stmt->bindParam(':checkout', $checkout);

        $codigo = '';
        $monto = 0.0;
        $stmt->bindParam(':codigo', $codigo, PDO::PARAM_STR | PDO::PARAM_INPUT_OUTPUT, 12);
        $stmt->bindParam(':monto', $monto, PDO::PARAM_STR | PDO::PARAM_INPUT_OUTPUT, 10);

        $stmt->execute();
        return ['codigo_reserva' => $codigo, 'monto_total' => $monto];
    }

    public function actualizarEstado(int $id, string $estado): bool {
        $sql = "UPDATE reservas SET estado_reserva = :estado WHERE id_reserva = :id";
        $stmt = $this->db->prepare($sql);
        return $stmt->execute([':id' => $id, ':estado' => $estado]);
    }

    public function eliminar(int $id): bool {
        $sql = "DELETE FROM reservas WHERE id_reserva = :id";
        $stmt = $this->db->prepare($sql);
        return $stmt->execute([':id' => $id]);
    }
}
?>
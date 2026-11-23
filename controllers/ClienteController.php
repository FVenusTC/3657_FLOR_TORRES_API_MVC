<?php
// controllers/ClienteController.php
require_once __DIR__ . '/../models/ClienteModel.php';

class ClienteController {
    private ClienteModel $model;

    public function __construct() {
        $this->model = new ClienteModel();
    }

    public function listar(): void {
        $datos = $this->model->listar();
        http_response_code(200);
        echo json_encode(['exito' => true, 'total' => count($datos), 'datos' => $datos]);
    }

    public function obtenerPorId(?int $id): void {
        if (!$id || $id <= 0) {
            http_response_code(400);
            echo json_encode(['exito' => false, 'mensaje' => 'El identificador del cliente es inválido']);
            return;
        }

        $cliente = $this->model->obtenerPorId($id);
        if (!$cliente) {
            http_response_code(404);
            echo json_encode(['exito' => false, 'mensaje' => 'Cliente no encontrado']);
            return;
        }

        http_response_code(200);
        echo json_encode(['exito' => true, 'datos' => $cliente]);
    }

    public function crear(array $datos): void {
        if (empty($datos['numero_documento']) || empty($datos['nombres']) || empty($datos['apellidos'])) {
            http_response_code(400);
            echo json_encode(['exito' => false, 'mensaje' => 'Campos obligatorios: numero_documento, nombres, apellidos']);
            return;
        }

        try {
            $nuevoId = $this->model->crear($datos);
            http_response_code(201);
            echo json_encode(['exito' => true, 'mensaje' => 'Cliente registrado correctamente', 'id_cliente' => $nuevoId]);
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['exito' => false, 'mensaje' => 'Error al registrar el cliente: ' . $e->getMessage()]);
        }
    }

    public function actualizar(int $id, array $datos): void {
        if (!$id || $id <= 0) {
            http_response_code(400);
            echo json_encode(['exito' => false, 'mensaje' => 'Identificador inválido']);
            return;
        }

        if (!$this->model->obtenerPorId($id)) {
            http_response_code(404);
            echo json_encode(['exito' => false, 'mensaje' => 'El cliente a actualizar no existe']);
            return;
        }

        $exito = $this->model->actualizar($id, $datos);
        http_response_code(200);
        echo json_encode(['exito' => $exito, 'mensaje' => 'Cliente actualizado con éxito']);
    }

    public function eliminar(int $id): void {
        if (!$id || $id <= 0) {
            http_response_code(400);
            echo json_encode(['exito' => false, 'mensaje' => 'Identificador inválido']);
            return;
        }

        if (!$this->model->obtenerPorId($id)) {
            http_response_code(404);
            echo json_encode(['exito' => false, 'mensaje' => 'El cliente a eliminar no existe']);
            return;
        }

        try {
            $this->model->eliminar($id);
            http_response_code(200);
            echo json_encode(['exito' => true, 'mensaje' => 'Cliente eliminado correctamente']);
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['exito' => false, 'mensaje' => 'No se puede eliminar el cliente porque posee reservas vinculadas']);
        }
    }
}
?>
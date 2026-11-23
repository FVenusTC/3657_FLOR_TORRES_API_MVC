<?php
// api/clientes.php - Endpoint REST para la entidad Clientes
header('Content-Type: application/json; charset=UTF-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');

require_once __DIR__ . '/../controllers/ClienteController.php';

$controller = new ClienteController();
$method = $_SERVER['REQUEST_METHOD'];
$id = isset($_GET['id']) ? (int)$_GET['id'] : null;

switch ($method) {
    case 'GET':
        if ($id) {
            $controller->obtenerPorId($id);
        } else {
            $controller->listar();
        }
        break;

    case 'POST':
        $body = json_decode(file_get_contents('php://input'), true) ?? [];
        $controller->crear($body);
        break;

    case 'PUT':
        $body = json_decode(file_get_contents('php://input'), true) ?? [];
        $controller->actualizar($id ?? ($body['id_cliente'] ?? 0), $body);
        break;

    case 'DELETE':
        $body = json_decode(file_get_contents('php://input'), true) ?? [];
        $controller->eliminar($id ?? ($body['id_cliente'] ?? 0));
        break;

    default:
        http_response_code(405);
        echo json_encode(['exito' => false, 'mensaje' => 'Método HTTP no permitido']);
        break;
}
?>
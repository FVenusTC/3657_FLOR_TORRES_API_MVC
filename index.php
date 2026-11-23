<?php
// index.php - Información principal de la API REST Hospedaje Glory's
header('Content-Type: application/json; charset=UTF-8');

echo json_encode([
    'sistema'     => 'API RESTful - Hospedaje Glorys',
    'version'     => '1.0.0',
    'estudiante'  => 'Flor de Venus Torres Condori',
    'evaluacion'  => 'Proceso de Aprendizaje 4 (PA4)',
    'endpoints'   => [
        'categorias'   => '/api/categorias.php',
        'habitaciones' => '/api/habitaciones.php',
        'clientes'     => '/api/clientes.php',
        'reservas'     => '/api/reservas.php',
        'pagos'        => '/api/pagos.php',
        'servicios'    => '/api/servicios.php'
    ]
]);
?>
-- =============================================================================
-- PROCESO DE APRENDIZAJE III - PROGRAMACIÓN WEB BÁSICA
-- Estudiante: Torres Condori, Flor de Venus 
-- Correo: 47806623@mail.isil.pe
-- Proyecto: Hospedaje Glory's (Sistema de Gestión Administrativa y Reservas)
-- Motor de Base de Datos: Microsoft SQL Server (T-SQL)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. CREACIÓN Y SELECCIÓN DE LA BASE DE DATOS
-- -----------------------------------------------------------------------------
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'hospedaje_glorys_bd')
BEGIN
    DROP DATABASE hospedaje_glorys_bd;
END
GO

CREATE DATABASE hospedaje_glorys_bd;
GO

USE hospedaje_glorys_bd;
GO

-- -----------------------------------------------------------------------------
-- 2. CREACIÓN DE TABLAS (ESTRUCTURA T-SQL CON PK, FK Y RESTRICCIONES CHECK)
-- -----------------------------------------------------------------------------

-- TABLA 1: Categorías de Habitación
CREATE TABLE categorias_habitacion (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria NVARCHAR(50) NOT NULL UNIQUE,
    descripcion NVARCHAR(MAX),
    precio_base_noche DECIMAL(10,2) NOT NULL CHECK (precio_base_noche > 0),
    capacidad_maxima INT NOT NULL CHECK (capacidad_maxima > 0)
);
GO

-- TABLA 2: Habitaciones
CREATE TABLE habitaciones (
    id_habitacion INT IDENTITY(1,1) PRIMARY KEY,
    numero_habitacion NVARCHAR(10) NOT NULL UNIQUE,
    piso INT NOT NULL CHECK (piso > 0),
    id_categoria INT NOT NULL,
    estado NVARCHAR(20) NOT NULL DEFAULT 'Disponible' 
        CHECK (estado IN ('Disponible', 'Ocupada', 'Mantenimiento', 'Reservada')),
    CONSTRAINT FK_habitaciones_categorias FOREIGN KEY (id_categoria) 
        REFERENCES categorias_habitacion(id_categoria) ON UPDATE CASCADE
);
GO

-- TABLA 3: Clientes (Huéspedes)
CREATE TABLE clientes (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    tipo_documento NVARCHAR(10) NOT NULL DEFAULT 'DNI' 
        CHECK (tipo_documento IN ('DNI', 'Pasaporte', 'CE')),
    numero_documento NVARCHAR(15) NOT NULL UNIQUE,
    nombres NVARCHAR(80) NOT NULL,
    apellidos NVARCHAR(80) NOT NULL,
    telefono NVARCHAR(15),
    email NVARCHAR(100) UNIQUE,
    fecha_registro DATETIME2 DEFAULT GETDATE()
);
GO

-- TABLA 4: Reservas
CREATE TABLE reservas (
    id_reserva INT IDENTITY(1,1) PRIMARY KEY,
    codigo_reserva NVARCHAR(12) NOT NULL UNIQUE,
    id_cliente INT NOT NULL,
    id_habitacion INT NOT NULL,
    fecha_reserva DATETIME2 DEFAULT GETDATE(),
    fecha_checkin DATE NOT NULL,
    fecha_checkout DATE NOT NULL,
    monto_total DECIMAL(10,2) NOT NULL CHECK (monto_total >= 0),
    estado_reserva NVARCHAR(20) NOT NULL DEFAULT 'Pendiente' 
        CHECK (estado_reserva IN ('Pendiente', 'Confirmada', 'Completada', 'Cancelada')),
    CONSTRAINT CHK_fechas CHECK (fecha_checkout > fecha_checkin),
    CONSTRAINT FK_reservas_clientes FOREIGN KEY (id_cliente) 
        REFERENCES clientes(id_cliente) ON UPDATE CASCADE,
    CONSTRAINT FK_reservas_habitaciones FOREIGN KEY (id_habitacion) 
        REFERENCES habitaciones(id_habitacion) ON UPDATE CASCADE
);
GO

-- TABLA 5: Pagos
CREATE TABLE pagos (
    id_pago INT IDENTITY(1,1) PRIMARY KEY,
    id_reserva INT NOT NULL,
    fecha_pago DATETIME2 DEFAULT GETDATE(),
    monto_pagado DECIMAL(10,2) NOT NULL CHECK (monto_pagado > 0),
    metodo_pago NVARCHAR(20) NOT NULL 
        CHECK (metodo_pago IN ('Efectivo', 'Tarjeta', 'Yape/Plin', 'Transferencia')),
    num_operacion NVARCHAR(30),
    estado_pago NVARCHAR(20) NOT NULL DEFAULT 'Completado' 
        CHECK (estado_pago IN ('Completado', 'Pendiente', 'Anulado')),
    CONSTRAINT FK_pagos_reservas FOREIGN KEY (id_reserva) 
        REFERENCES reservas(id_reserva) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- TABLA 6: Servicios Adicionales
CREATE TABLE servicios_adicionales (
    id_servicio INT IDENTITY(1,1) PRIMARY KEY,
    id_reserva INT NOT NULL,
    descripcion_servicio NVARCHAR(100) NOT NULL,
    costo_servicio DECIMAL(10,2) NOT NULL CHECK (costo_servicio >= 0),
    fecha_solicitud DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_servicios_reservas FOREIGN KEY (id_reserva) 
        REFERENCES reservas(id_reserva) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- -----------------------------------------------------------------------------
-- 3. CREACIÓN DE ÍNDICES PARA OPTIMIZACIÓN DE CONSULTAS
-- -----------------------------------------------------------------------------
CREATE INDEX idx_habitaciones_categoria ON habitaciones(id_categoria);
CREATE INDEX idx_reservas_cliente ON reservas(id_cliente);
CREATE INDEX idx_reservas_habitacion ON reservas(id_habitacion);
CREATE INDEX idx_reservas_fechas ON reservas(fecha_checkin, fecha_checkout);
CREATE INDEX idx_pagos_reserva ON pagos(id_reserva);
GO

-- -----------------------------------------------------------------------------
-- 4. POBLACIÓN DE DATOS DE PRUEBA (MÁXIMO 10 REGISTROS POR TABLA)
-- -----------------------------------------------------------------------------

INSERT INTO categorias_habitacion (nombre_categoria, descripcion, precio_base_noche, capacidad_maxima) VALUES
('Matrimonial', N'Habitación acogedora con cama King Size, TV Smart y baño privado', 120.00, 2),
('Doble', N'Habitación espaciosa con dos camas de 2 plazas, ideal para amigos o colegas', 150.00, 2),
('Familiar', N'Suite amplia con cama King + 2 camas de 1.5 plazas y vista panorámica', 220.00, 4),
('Ejecutiva', N'Suite de lujo con escritorio de trabajo, frigobar, hidromasaje y balcón', 280.00, 2);

INSERT INTO habitaciones (numero_habitacion, piso, id_categoria, estado) VALUES
('101', 1, 1, 'Disponible'),
('102', 1, 2, 'Reservada'),
('201', 2, 1, 'Ocupada'),
('202', 2, 3, 'Disponible'),
('301', 3, 4, 'Reservada'),
('302', 3, 2, 'Disponible'),
('401', 4, 3, 'Mantenimiento'),
('402', 4, 4, 'Disponible');

INSERT INTO clientes (tipo_documento, numero_documento, nombres, apellidos, telefono, email) VALUES
('DNI', '72849102', N'Carlos Eduardo', N'Mendoza Ríos', '987654321', 'carlos.mendoza@gmail.com'),
('DNI', '45892011', N'Ana María', N'Sánchez Gutiérrez', '912345678', 'ana.sanchez@outlook.com'),
('CE', '001293842', N'John David', N'Smith Miller', '955112233', 'jsmith@yahoo.com'),
('DNI', '70112233', N'Lucía Fernanda', N'Torres Benítez', '944332211', 'lucia.torres@gmail.com'),
('Pasaporte', 'P8392011', N'Pierre', N'Dubois', '977889900', 'pierre.dubois@mail.fr'),
('DNI', '10293847', N'Jorge Luis', N'Vargas Huamán', '966554433', 'jorge.vargas@hotmail.com');

INSERT INTO reservas (codigo_reserva, id_cliente, id_habitacion, fecha_checkin, fecha_checkout, monto_total, estado_reserva) VALUES
('RES-2026-001', 1, 1, '2026-11-05', '2026-11-07', 240.00, 'Confirmada'),
('RES-2026-002', 2, 2, '2026-11-10', '2026-11-13', 450.00, 'Pendiente'),
('RES-2026-003', 3, 3, '2026-11-01', '2026-11-03', 240.00, 'Completada'),
('RES-2026-004', 4, 4, '2026-11-15', '2026-11-18', 660.00, 'Confirmada'),
('RES-2026-005', 5, 5, '2026-11-20', '2026-11-22', 560.00, 'Confirmada'),
('RES-2026-006', 6, 6, '2026-10-25', '2026-10-27', 300.00, 'Cancelada');

INSERT INTO pagos (id_reserva, monto_pagado, metodo_pago, num_operacion, estado_pago) VALUES
(1, 240.00, 'Yape/Plin', 'OP-99201', 'Completado'),
(2, 100.00, 'Transferencia', 'TR-88192', 'Pendiente'),
(3, 240.00, 'Tarjeta', 'VISA-44210', 'Completado'),
(4, 660.00, 'Efectivo', 'EF-00123', 'Completado'),
(5, 560.00, 'Tarjeta', 'MC-11029', 'Completado');

INSERT INTO servicios_adicionales (id_reserva, descripcion_servicio, costo_servicio) VALUES
(1, N'Desayuno Buffet Continental (2 personas x 2 días)', 50.00),
(3, N'Servicio de Lavandería Exprés', 35.00),
(4, N'Traslado Aeropuerto - Hospedaje (Pick Up)', 60.00),
(5, N'Cochera Privada y Servicio de Frigobar VIP', 80.00),
(1, N'Acceso a Zona de Spa e Hidromasaje', 40.00);
GO

-- -----------------------------------------------------------------------------
-- 5. PROCEDIMIENTO ALMACENADO (STORED PROCEDURE T-SQL)
-- -----------------------------------------------------------------------------
CREATE PROCEDURE sp_registrar_reserva
    @p_id_cliente INT,
    @p_id_habitacion INT,
    @p_fecha_checkin DATE,
    @p_fecha_checkout DATE,
    @p_codigo_reserva NVARCHAR(12) OUTPUT,
    @p_monto_total DECIMAL(10,2) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @v_precio_noche DECIMAL(10,2);
    DECLARE @v_dias INT;
    
    -- Calcular la cantidad de días de estancia en T-SQL
    SET @v_dias = DATEDIFF(DAY, @p_fecha_checkin, @p_fecha_checkout);
    
    IF @v_dias <= 0
    BEGIN
        RAISERROR('Error: La fecha de checkout debe ser posterior a la fecha de checkin', 16, 1);
        RETURN;
    END
    
    -- Obtener el precio por noche de la categoría asociada
    SELECT @v_precio_noche = c.precio_base_noche
    FROM habitaciones h
    INNER JOIN categorias_habitacion c ON h.id_categoria = c.id_categoria
    WHERE h.id_habitacion = @p_id_habitacion;
    
    -- Calcular el monto total
    SET @p_monto_total = @v_precio_noche * @v_dias;
    
    -- Generar código único de reserva (ej. RES-2026-4821)
    SET @p_codigo_reserva = 'RES-' + CAST(YEAR(GETDATE()) AS NVARCHAR(4)) + '-' + 
                            RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS NVARCHAR(4)), 4);
    
    -- Insertar el registro de reserva
    INSERT INTO reservas (codigo_reserva, id_cliente, id_habitacion, fecha_checkin, fecha_checkout, monto_total, estado_reserva)
    VALUES (@p_codigo_reserva, @p_id_cliente, @p_id_habitacion, @p_fecha_checkin, @p_fecha_checkout, @p_monto_total, 'Confirmada');
    
    -- Actualizar estado de la habitación a 'Reservada'
    UPDATE habitaciones 
    SET estado = 'Reservada' 
    WHERE id_habitacion = @p_id_habitacion;
END;
GO

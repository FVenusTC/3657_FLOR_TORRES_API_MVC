# Hospedaje Glory's - API RESTful MVC (PA4)

**Estudiante:** Flor de Venus Torres Condori  
**Correo:** 47806623@mail.isil.pe  
**Asignatura:** Programación Web Básica (ISIL)  
**Evaluación:** Proceso de Aprendizaje 4  

---

## 🚀 Arquitectura y Requisitos

* **Lenguaje & Patrón:** PHP 8.x con Programación Orientada a Objetos (POO) y arquitectura Modelo-Vista-Controlador (MVC).
* **Motor de BD:** Microsoft SQL Server (T-SQL) mediante la extensión `pdo_sqlsrv`.
* **Formato de Respuesta:** JSON estandarizado con códigos de estado HTTP (`200`, `201`, `400`, `404`, `500`).

---

## 📋 Endpoints Disponibles (CRUD Completo)

1. `/api/categorias.php` - Categorías de Habitación
2. `/api/habitaciones.php` - Inventario de Cuartos
3. `/api/clientes.php` - Registro de Huéspedes
4. `/api/reservas.php` - Control de Estancias (Invoca `sp_registrar_reserva`)
5. `/api/pagos.php` - Transacciones Financieras
6. `/api/servicios.php` - Consumos Adicionales

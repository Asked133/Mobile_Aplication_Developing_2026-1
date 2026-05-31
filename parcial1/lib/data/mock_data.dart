import 'package:flutter/material.dart';
import 'package:parcial1/models/producto.dart';
import 'package:parcial1/models/venta.dart';
import 'package:parcial1/models/empleado.dart';
import 'package:parcial1/models/proveedor.dart';
import 'package:parcial1/models/cliente.dart';

class MockData {
  static final List<Producto> productos = [
    Producto(id: 'P001', nombre: 'Coca-Cola 600ml', categoria: 'Bebidas', precio: 18.00, stock: 120, proveedor: 'FEMSA', icono: Icons.local_drink, fechaIngreso: '10/01/2026'),
    Producto(id: 'P002', nombre: 'Sabritas Original 45g', categoria: 'Botanas', precio: 22.00, stock: 85, proveedor: 'PepsiCo', icono: Icons.fastfood, fechaIngreso: '12/01/2026'),
    Producto(id: 'P003', nombre: 'Pan Bimbo Blanco', categoria: 'Panadería', precio: 52.00, stock: 30, proveedor: 'Bimbo', icono: Icons.bakery_dining, fechaIngreso: '15/01/2026'),
    Producto(id: 'P004', nombre: 'Leche Lala 1L', categoria: 'Lácteos', precio: 28.50, stock: 60, proveedor: 'Lala', icono: Icons.water_drop, fechaIngreso: '08/02/2026'),
    Producto(id: 'P005', nombre: 'Marlboro Rojo', categoria: 'Tabaco', precio: 72.00, stock: 45, proveedor: 'Philip Morris', icono: Icons.smoking_rooms, fechaIngreso: '20/01/2026'),
    Producto(id: 'P006', nombre: 'Gansito Marinela', categoria: 'Pastelería', precio: 18.50, stock: 90, proveedor: 'Bimbo', icono: Icons.cake, fechaIngreso: '05/02/2026'),
    Producto(id: 'P007', nombre: 'Red Bull 250ml', categoria: 'Bebidas', precio: 35.00, stock: 40, proveedor: 'Red Bull MX', icono: Icons.flash_on, fechaIngreso: '18/02/2026'),
    Producto(id: 'P008', nombre: 'Nescafé Clásico 200g', categoria: 'Abarrotes', precio: 95.00, stock: 25, proveedor: 'Nestlé', icono: Icons.coffee, fechaIngreso: '22/01/2026'),
    Producto(id: 'P009', nombre: 'Cloralex 1L', categoria: 'Limpieza', precio: 32.00, stock: 35, proveedor: 'Alen', icono: Icons.clean_hands, fechaIngreso: '10/02/2026'),
    Producto(id: 'P010', nombre: 'Papel Higiénico Pétalo 4pz', categoria: 'Higiene', precio: 42.00, stock: 50, proveedor: 'Kimberly-Clark', icono: Icons.inventory_2, fechaIngreso: '14/02/2026'),
    Producto(id: 'P011', nombre: 'Hot Dog OXXO', categoria: 'Alimentos Preparados', precio: 30.00, stock: 15, proveedor: 'Interno', icono: Icons.lunch_dining, fechaIngreso: '01/03/2026'),
    Producto(id: 'P012', nombre: 'Agua Ciel 1L', categoria: 'Bebidas', precio: 14.00, stock: 200, proveedor: 'FEMSA', icono: Icons.water, fechaIngreso: '03/03/2026'),
    Producto(id: 'P013', nombre: 'Doritos Nacho 62g', categoria: 'Botanas', precio: 24.00, stock: 70, proveedor: 'PepsiCo', icono: Icons.fastfood, fechaIngreso: '05/03/2026'),
    Producto(id: 'P014', nombre: 'Condones Trojan 3pz', categoria: 'Salud', precio: 85.00, stock: 20, proveedor: 'Church & Dwight', icono: Icons.health_and_safety, fechaIngreso: '10/03/2026'),
    Producto(id: 'P015', nombre: 'Recarga Telcel \$100 ', categoria: 'Servicios', precio: 100.00, stock: 999, proveedor: 'Telcel', icono: Icons.phone_android, fechaIngreso: '01/01/2026'),
  ];

  static final List<Venta> ventas = [
    Venta(id: 'V001', producto: 'Coca-Cola 600ml', cantidad: 3, total: 54.00, fecha: '15/03/2026', metodoPago: 'Efectivo', empleado: 'Carlos López'),
    Venta(id: 'V002', producto: 'Sabritas Original 45g', cantidad: 2, total: 44.00, fecha: '15/03/2026', metodoPago: 'Tarjeta', empleado: 'María García'),
    Venta(id: 'V003', producto: 'Marlboro Rojo', cantidad: 1, total: 72.00, fecha: '15/03/2026', metodoPago: 'Efectivo', empleado: 'Carlos López'),
    Venta(id: 'V004', producto: 'Red Bull 250ml', cantidad: 2, total: 70.00, fecha: '16/03/2026', metodoPago: 'Tarjeta', empleado: 'Ana Martínez'),
    Venta(id: 'V005', producto: 'Hot Dog OXXO', cantidad: 4, total: 120.00, fecha: '16/03/2026', metodoPago: 'Efectivo', empleado: 'Carlos López'),
    Venta(id: 'V006', producto: 'Gansito Marinela', cantidad: 5, total: 92.50, fecha: '16/03/2026', metodoPago: 'Efectivo', empleado: 'María García'),
    Venta(id: 'V007', producto: 'Nescafé Clásico 200g', cantidad: 1, total: 95.00, fecha: '17/03/2026', metodoPago: 'Tarjeta', empleado: 'Ana Martínez'),
    Venta(id: 'V008', producto: 'Recarga Telcel \$100', cantidad: 1, total: 100.00, fecha: '17/03/2026', metodoPago: 'Efectivo', empleado: 'Carlos López'),
    Venta(id: 'V009', producto: 'Agua Ciel 1L', cantidad: 6, total: 84.00, fecha: '17/03/2026', metodoPago: 'Efectivo', empleado: 'María García'),
    Venta(id: 'V010', producto: 'Pan Bimbo Blanco', cantidad: 2, total: 104.00, fecha: '18/03/2026', metodoPago: 'Tarjeta', empleado: 'Ana Martínez'),
    Venta(id: 'V011', producto: 'Leche Lala 1L', cantidad: 3, total: 85.50, fecha: '18/03/2026', metodoPago: 'Efectivo', empleado: 'Carlos López'),
    Venta(id: 'V012', producto: 'Doritos Nacho 62g', cantidad: 4, total: 96.00, fecha: '18/03/2026', metodoPago: 'Efectivo', empleado: 'María García'),
  ];

  static final List<Empleado> empleados = [
    Empleado(id: 'E001', nombre: 'Carlos López', puesto: 'Cajero', turno: 'Matutino', telefono: '614-123-4567', email: 'carlos.lopez@oxxo.com', fechaIngreso: '15/06/2024', salario: 8500.00),
    Empleado(id: 'E002', nombre: 'María García', puesto: 'Cajera', turno: 'Vespertino', telefono: '614-234-5678', email: 'maria.garcia@oxxo.com', fechaIngreso: '20/08/2024', salario: 8500.00),
    Empleado(id: 'E003', nombre: 'Ana Martínez', puesto: 'Encargada de Turno', turno: 'Nocturno', telefono: '614-345-6789', email: 'ana.martinez@oxxo.com', fechaIngreso: '10/03/2023', salario: 12000.00),
    Empleado(id: 'E004', nombre: 'Roberto Hernández', puesto: 'Gerente de Tienda', turno: 'Matutino', telefono: '614-456-7890', email: 'roberto.hdz@oxxo.com', fechaIngreso: '05/01/2022', salario: 18000.00),
    Empleado(id: 'E005', nombre: 'Laura Sánchez', puesto: 'Cajera', turno: 'Matutino', telefono: '614-567-8901', email: 'laura.sanchez@oxxo.com', fechaIngreso: '12/11/2025', salario: 8500.00),
    Empleado(id: 'E006', nombre: 'Pedro Ramírez', puesto: 'Almacenista', turno: 'Vespertino', telefono: '614-678-9012', email: 'pedro.ramirez@oxxo.com', fechaIngreso: '03/09/2024', salario: 9000.00),
  ];

  static final List<Proveedor> proveedores = [
    Proveedor(id: 'PR001', nombre: 'FEMSA', contacto: 'Juan Pérez', telefono: '81-1234-5678', email: 'ventas@femsa.com', categoria: 'Bebidas', direccion: 'Monterrey, NL'),
    Proveedor(id: 'PR002', nombre: 'PepsiCo México', contacto: 'Andrea Ruiz', telefono: '55-2345-6789', email: 'distribuidores@pepsico.mx', categoria: 'Botanas y Bebidas', direccion: 'CDMX'),
    Proveedor(id: 'PR003', nombre: 'Grupo Bimbo', contacto: 'Miguel Torres', telefono: '55-3456-7890', email: 'ventas@bimbo.com.mx', categoria: 'Panadería y Pastelería', direccion: 'CDMX'),
    Proveedor(id: 'PR004', nombre: 'Grupo Lala', contacto: 'Sofía Díaz', telefono: '871-456-7890', email: 'distribuidores@lala.com.mx', categoria: 'Lácteos', direccion: 'Torreón, Coah.'),
    Proveedor(id: 'PR005', nombre: 'Philip Morris México', contacto: 'Ricardo Muñoz', telefono: '55-5678-9012', email: 'ventas@pmi.com', categoria: 'Tabaco', direccion: 'CDMX'),
    Proveedor(id: 'PR006', nombre: 'Nestlé México', contacto: 'Carmen Vega', telefono: '55-6789-0123', email: 'proveedores@nestle.mx', categoria: 'Abarrotes', direccion: 'CDMX'),
    Proveedor(id: 'PR007', nombre: 'Kimberly-Clark', contacto: 'Luis Mora', telefono: '55-7890-1234', email: 'distribuidores@kcc.com', categoria: 'Higiene', direccion: 'Ecatepec, Edo. Mex.'),
    Proveedor(id: 'PR008', nombre: 'Red Bull México', contacto: 'Elena Castro', telefono: '55-8901-2345', email: 'ventas@redbull.mx', categoria: 'Bebidas Energéticas', direccion: 'CDMX'),
  ];

  static final List<Cliente> clientes = [
    Cliente(id: 'C001', nombre: 'José Rodríguez', telefono: '614-111-2222', email: 'jose.rdz@gmail.com', puntos: 1250, nivel: 'Oro', fechaRegistro: '10/05/2024', totalCompras: 4500.00),
    Cliente(id: 'C002', nombre: 'Patricia Flores', telefono: '614-222-3333', email: 'patty.flores@hotmail.com', puntos: 890, nivel: 'Plata', fechaRegistro: '22/07/2024', totalCompras: 3200.00),
    Cliente(id: 'C003', nombre: 'Fernando Navarro', telefono: '614-333-4444', email: 'fer.navarro@gmail.com', puntos: 2100, nivel: 'Platino', fechaRegistro: '03/02/2024', totalCompras: 8900.00),
    Cliente(id: 'C004', nombre: 'Gabriela Moreno', telefono: '614-444-5555', email: 'gaby.moreno@yahoo.com', puntos: 450, nivel: 'Bronce', fechaRegistro: '15/11/2025', totalCompras: 1200.00),
    Cliente(id: 'C005', nombre: 'Daniel Ortiz', telefono: '614-555-6666', email: 'daniel.ortiz@gmail.com', puntos: 3500, nivel: 'Platino', fechaRegistro: '01/01/2023', totalCompras: 15600.00),
    Cliente(id: 'C006', nombre: 'Valentina Cruz', telefono: '614-666-7777', email: 'vale.cruz@outlook.com', puntos: 680, nivel: 'Plata', fechaRegistro: '08/09/2025', totalCompras: 2800.00),
    Cliente(id: 'C007', nombre: 'Alejandro Reyes', telefono: '614-777-8888', email: 'alex.reyes@gmail.com', puntos: 1800, nivel: 'Oro', fechaRegistro: '20/04/2024', totalCompras: 6300.00),
    Cliente(id: 'C008', nombre: 'Mariana Silva', telefono: '614-888-9999', email: 'mari.silva@gmail.com', puntos: 320, nivel: 'Bronce', fechaRegistro: '30/01/2026', totalCompras: 980.00),
  ];
}

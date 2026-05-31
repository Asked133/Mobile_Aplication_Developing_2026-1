import 'package:flutter/material.dart';

class Producto {
  final String id;
  final String nombre;
  final String categoria;
  final double precio;
  final int stock;
  final String proveedor;
  final IconData icono;
  final String fechaIngreso;
  final bool activo;

  const Producto({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.stock,
    required this.proveedor,
    required this.icono,
    required this.fechaIngreso,
    this.activo = true,
  });
}

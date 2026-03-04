import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String nombre;
  final String categoria;
  final int cantidad;
  final IconData icono;

  const CardWidget({
    super.key,
    required this.nombre,
    required this.categoria,
    required this.cantidad,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.indigo.shade100,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 167, 176, 231),
          child: Icon(
            icono,
            color: Colors.indigo.shade800,
          ),
        ),
        title: Text(
          nombre,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Text('Categoría: $categoria'),
        trailing: Text(
          'Cant: $cantidad',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

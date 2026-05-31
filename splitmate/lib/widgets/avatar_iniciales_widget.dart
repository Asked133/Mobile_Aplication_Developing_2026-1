// círculo con las iniciales del nombre — color automático basado en hash
import 'package:flutter/material.dart';
import '../utils/constantes.dart';

class AvatarInicialesWidget extends StatelessWidget {
  final String nombre;
  final double radio;
  final Color? color;

  const AvatarInicialesWidget({
    super.key,
    required this.nombre,
    this.radio = 20,
    this.color,
  });

  // calcula iniciales del nombre (ej: "Carlos López" → "CL")
  String get _iniciales {
    final partes = nombre.trim().split(' ');
    if (partes.length >= 2) return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
    return nombre.isNotEmpty ? nombre[0].toUpperCase() : '?';
  }

  // selecciona un color de la paleta basándose en el hash del nombre
  Color get _color {
    return color ?? kColoresAvatar[nombre.hashCode.abs() % kColoresAvatar.length];
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radio,
      backgroundColor: _color,
      child: Text(
        _iniciales,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radio * 0.7,
        ),
      ),
    );
  }
}

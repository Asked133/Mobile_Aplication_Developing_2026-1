import 'package:flutter/material.dart';

//circulo con las iniciales del nombre de una persona
class AvatarInicialesWidget extends StatelessWidget {
  final String nombre;
  final double radius;
  final Color color;

  const AvatarInicialesWidget({
    super.key,
    required this.nombre,
    this.radius = 20,
    this.color = const Color(0xFFE87722),
  });

  @override
  Widget build(BuildContext context) {
    //toma la primera letra de las primeras 2 palabras del nombre
    final iniciales = nombre.split(' ').map((n) => n[0]).take(2).join();
    return CircleAvatar(
      radius: radius,
      backgroundColor: color,
      child: Text(
        iniciales,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.7,
        ),
      ),
    );
  }
}

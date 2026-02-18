import 'package:flutter/material.dart';
import 'dart:math' as math
;

class TableBackground extends StatelessWidget {
  var decorationContainer = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromARGB(255, 51, 54, 126),
        Color.fromARGB(255, 19, 21, 31),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: decorationContainer
          ),
          Positioned(
            child: CajaRosa(),
            top: -100,
            left: -30,
            )
        ]
    );
  }
}

class CajaRosa extends StatelessWidget {
  const CajaRosa({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -math.pi / 5,
      child: Container(
        width: 360,
        height: 360,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: LinearGradient(colors: [
            Colors.pinkAccent, 
            Colors.pink
            ]),
        ),
      ),
    );
  }
}

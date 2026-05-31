import 'package:flutter/material.dart';

class StatCardWidget extends StatelessWidget {
  final String label;
  final String valor;
  final Color color;

  const StatCardWidget({
    super.key,
    required this.label,
    required this.valor,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Text(valor, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
              Text(label, style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}

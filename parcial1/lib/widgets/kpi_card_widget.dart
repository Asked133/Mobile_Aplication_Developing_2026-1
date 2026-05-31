import 'package:flutter/material.dart';

//tarjeta para mostrar un indicador KPI en el dashboard
class KpiCardWidget extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;
  final Color color;

  const KpiCardWidget({
    super.key,
    required this.titulo,
    required this.valor,
    required this.icono,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icono, color: color, size: 28),
            Spacer(),
            Text(titulo, style: TextStyle(fontSize: 12, color: Colors.grey)),
            SizedBox(height: 4),
            Text(valor, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}

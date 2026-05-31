import 'package:flutter/material.dart';

class InfoCardWidget extends StatelessWidget {
  final String titulo;
  final List<MapEntry<String, String>> filas;

  const InfoCardWidget({
    super.key,
    required this.titulo,
    required this.filas,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            ...filas.map((fila) => Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(fila.key, style: TextStyle(color: Colors.grey)),
                  Text(fila.value, style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

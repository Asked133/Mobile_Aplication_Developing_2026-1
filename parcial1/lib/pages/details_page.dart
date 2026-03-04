import 'package:flutter/material.dart';
import 'package:parcial1/widgets/background_widget.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final item = args is Map<String, dynamic> ? args : <String, dynamic>{};

    final nombre = item['nombre'];
    final categoria = item['categoria'];
    final cantidad = item['cantidad'];
    final fecha = item['fecha'];
    final icono = item['icono'] is IconData ? item['icono'] as IconData : Icons.shopping_bag;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del producto'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: BackgroundWidget(
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icono, size: 56, color: Colors.indigo),
                  const SizedBox(height: 12),
                  Text(nombre, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Categoría: $categoria'),
                  Text('Cantidad: $cantidad'),
                  Text('Vencimiento: $fecha'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
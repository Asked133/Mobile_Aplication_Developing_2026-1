import 'package:flutter/material.dart';
import 'package:parcial1/widgets/background_widget.dart';
import 'package:parcial1/widgets/card_widget.dart';

//dashboard de inicio. Muestra la lista de compras y un boton para agregar nuevos productos.
class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Map<String, dynamic>> compras = [
      {'nombre': 'Manzanas', 'categoria': 'Frutas', 'cantidad': 5, 'icono': Icons.apple, 'fecha': '01/03/2026'},
      {'nombre': 'Leche Deslactosada', 'categoria': 'Lácteos', 'cantidad': 2, 'icono': Icons.local_drink, 'fecha': '02/03/2026'},
      {'nombre': 'Detergente', 'categoria': 'Limpieza', 'cantidad': 1, 'icono': Icons.clean_hands, 'fecha': '03/03/2026'},
      {'nombre': 'Pan Integral', 'categoria': 'Panadería', 'cantidad': 3, 'icono': Icons.bakery_dining, 'fecha': '03/03/2026'},
      {'nombre': 'Huevos', 'categoria': 'Lácteos', 'cantidad': 12, 'icono': Icons.egg, 'fecha': '03/03/2026'},
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text(
          'Lista de Productos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.indigo,
        leading: const Icon(Icons.shopping_cart, color: Colors.white),
      ),
        body: BackgroundWidget(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: compras.length,
            itemBuilder: (context, index) {
              final item = compras[index];
              //widget de tarjeta personalizada (apartado en seccion de widgets).
              return CardWidget(
                nombre: item['nombre'],
                categoria: item['categoria'],
                cantidad: item['cantidad'],
                icono: item['icono'],
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/details',
                    arguments: item,
                  );
                },
              );
            },
          ),
        ),

      //boton para agregar productos (cambia a pagina de formulario).
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo,
          elevation:  10,
          onPressed: () {
            Navigator.pushNamed(context, '/form');
          },
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_checkout_outlined, color: Colors.white),
            ],
          ),
        ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:parcial1/widgets/sidebar_widget.dart';
import 'package:parcial1/data/mock_data.dart';

//pagina de inventario con busqueda y lista de productos
class InventarioPage extends StatefulWidget {
  const InventarioPage({super.key});

  @override
  State<InventarioPage> createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage> {
  String _busqueda = '';

  @override
  Widget build(BuildContext context) {
    //filtra los productos segun la busqueda
    final productosFiltrados = MockData.productos.where((p) {
      return p.nombre.toLowerCase().contains(_busqueda.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Inventario')),
      drawer: SidebarWidget(currentRoute: '/inventario'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          //campo de busqueda
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar producto...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: (valor) {
                setState(() {
                  _busqueda = valor;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('${productosFiltrados.length} productos', style: TextStyle(color: Colors.grey)),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: productosFiltrados.length,
              itemBuilder: (context, index) {
                final producto = productosFiltrados[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFFE87722),
                      child: Icon(producto.icono, color: Colors.white, size: 20),
                    ),
                    title: Text(producto.nombre),
                    subtitle: Text('${producto.categoria} • Stock: ${producto.stock}'),
                    trailing: Text('\$${producto.precio.toStringAsFixed(2)}', style: TextStyle(color: Color(0xFFE87722), fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.pushNamed(context, '/producto-detalle', arguments: producto);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

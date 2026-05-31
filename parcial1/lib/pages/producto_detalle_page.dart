import 'package:flutter/material.dart';
import 'package:parcial1/models/producto.dart';
import 'package:parcial1/widgets/info_card_widget.dart';

//pagina de detalle de un producto especifico
class ProductoDetallePage extends StatelessWidget {
  const ProductoDetallePage({super.key});

  @override
  Widget build(BuildContext context) {
    final producto = ModalRoute.of(context)?.settings.arguments as Producto?;
    if (producto == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(child: Text('Producto no encontrado')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(producto.nombre)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(producto.icono, size: 80, color: Color(0xFFE87722)),
            SizedBox(height: 12),
            Text(producto.nombre, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(producto.categoria, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 24),

            //info del producto
            InfoCardWidget(
              titulo: 'Información General',
              filas: [
                MapEntry('ID', producto.id),
                MapEntry('Categoría', producto.categoria),
                MapEntry('Proveedor', producto.proveedor),
                MapEntry('Fecha Ingreso', producto.fechaIngreso),
              ],
            ),
            SizedBox(height: 12),

            InfoCardWidget(
              titulo: 'Precio y Stock',
              filas: [
                MapEntry('Precio', '\$${producto.precio.toStringAsFixed(2)}'),
                MapEntry('Stock', '${producto.stock} unidades'),
                MapEntry('Estado', producto.activo ? 'Activo' : 'Inactivo'),
              ],
            ),
            SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.edit),
                    label: Text('Editar'),
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFE87722)),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.add_shopping_cart),
                    label: Text('Reordenar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:parcial1/widgets/sidebar_widget.dart';
import 'package:parcial1/data/mock_data.dart';

class VentasPage extends StatelessWidget {
  const VentasPage({super.key});

  @override
  Widget build(BuildContext context) {
    //calcula el total de todas las ventas
    final totalVentas = MockData.ventas.fold<double>(0.0, (sum, v) => sum + v.total);

    return Scaffold(
      appBar: AppBar(title: Text('Ventas')),
      drawer: SidebarWidget(currentRoute: '/ventas'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/nueva-venta'),
        icon: Icon(Icons.add),
        label: Text('Nueva Venta'),
      ),
      body: Column(
        children: [
          //resumen de ventas
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Total', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text('\$${totalVentas.toStringAsFixed(0)}', style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: [
                    Text('Tickets', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text('${MockData.ventas.length}', style: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: [
                    Text('Promedio', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text('\$${(totalVentas / MockData.ventas.length).toStringAsFixed(0)}', style: TextStyle(color: Color(0xFFE87722), fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          //lista de ventas
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: MockData.ventas.length,
              itemBuilder: (context, index) {
                final venta = MockData.ventas[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(
                      venta.metodoPago == 'Efectivo' ? Icons.payments : Icons.credit_card,
                      color: venta.metodoPago == 'Efectivo' ? Colors.green : Colors.blue,
                    ),
                    title: Text(venta.producto),
                    subtitle: Text('${venta.fecha} • ${venta.empleado} • x${venta.cantidad}'),
                    trailing: Text('\$${venta.total.toStringAsFixed(2)}', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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

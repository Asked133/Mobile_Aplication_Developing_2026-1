import 'package:flutter/material.dart';
import 'package:parcial1/widgets/sidebar_widget.dart';
import 'package:parcial1/widgets/kpi_card_widget.dart';
import 'package:parcial1/data/mock_data.dart';

//pantalla principal del dashboard con indicadores y ultimas ventas
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      drawer: SidebarWidget(currentRoute: '/dashboard'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFE87722),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bienvenido al portal de administrador de OXXO', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 4),
                  Text('OXXO Sucursal Chihuahua Centro', style: TextStyle(fontSize: 13, color: Colors.white70)),
                ],
              ),
            ),
            SizedBox(height: 20),

            Text('Indicadores del Día', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.4,
              children: [
                KpiCardWidget(titulo: 'Ventas del Día', valor: '\$12,450', icono: Icons.attach_money, color: Colors.green),
                KpiCardWidget(titulo: 'Transacciones', valor: '184', icono: Icons.receipt_long, color: Colors.blue),
                KpiCardWidget(titulo: 'Stock Bajo', valor: '7', icono: Icons.warning_amber, color: Colors.orange),
                KpiCardWidget(titulo: 'Clientes Activos', valor: '1,240', icono: Icons.people, color: Color(0xFFE87722)),
              ],
            ),
            SizedBox(height: 20),

            //ultimas ventas
            Text('Últimas Ventas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            SizedBox(height: 10),
            ...MockData.ventas.take(5).map((venta) => Card(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(Icons.shopping_bag, color: Color(0xFFE87722)),
                title: Text(venta.producto),
                subtitle: Text('${venta.fecha} • ${venta.metodoPago}'),
                trailing: Text('\$${venta.total.toStringAsFixed(2)}', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
            )),
            SizedBox(height: 20),

            //accesos rapidos
            Text('Accesos Rápidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _quickButton(context, Icons.add_shopping_cart, 'Nueva\nVenta', '/nueva-venta'),
                _quickButton(context, Icons.inventory, 'Ver\nInventario', '/inventario'),
                _quickButton(context, Icons.people, 'Ver\nClientes', '/clientes'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickButton(BuildContext context, IconData icon, String label, String ruta) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, ruta),
      child: Container(
        width: 100,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Icon(icon, color: Color(0xFFE87722), size: 28),
            SizedBox(height: 6),
            Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}

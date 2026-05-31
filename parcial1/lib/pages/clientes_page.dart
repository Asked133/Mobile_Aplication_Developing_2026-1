import 'package:flutter/material.dart';
import 'package:parcial1/widgets/sidebar_widget.dart';
import 'package:parcial1/widgets/avatar_iniciales_widget.dart';
import 'package:parcial1/data/mock_data.dart';

class ClientesPage extends StatelessWidget {
  const ClientesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clientes')),
      drawer: SidebarWidget(currentRoute: '/clientes'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.person_add),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.orange.shade50,
            child: ListTile(
              leading: Icon(Icons.card_giftcard, color: Color(0xFFE87722)),
              title: Text(
                'Programa de Lealtad OXXO',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${MockData.clientes.length} clientes registrados',
              ),
            ),
          ),
          SizedBox(height: 12),
          //lista de clientes
          ...MockData.clientes.map((cli) {
            Color colorNivel;
            switch (cli.nivel) {
              case 'Platino':
                colorNivel = Colors.purple;
                break;
              case 'Oro':
                colorNivel = Color(0xFFE87722);
                break;
              case 'Plata':
                colorNivel = Colors.grey;
                break;
              default:
                colorNivel = Colors.brown;
                break;
            }

            return Card(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 8),
              child: ListTile(
                //iniciales en en circulo
                leading: AvatarInicialesWidget(
                  nombre: cli.nombre,
                  color: colorNivel,
                ),
                title: Text(cli.nombre),
                subtitle: Text('${cli.nivel} • ${cli.puntos} pts'),
                trailing: Text(
                  '\$${cli.totalCompras.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

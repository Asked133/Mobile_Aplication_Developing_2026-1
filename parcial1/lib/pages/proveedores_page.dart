import 'package:flutter/material.dart';
import 'package:parcial1/widgets/sidebar_widget.dart';
import 'package:parcial1/data/mock_data.dart';

class ProveedoresPage extends StatelessWidget {
  const ProveedoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Proveedores')),
      drawer: SidebarWidget(currentRoute: '/proveedores'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          //info general
          Card(
            child: ListTile(
              leading: Icon(Icons.local_shipping, color: Colors.blue),
              title: Text('${MockData.proveedores.length} proveedores registrados'),
              subtitle: Text('Gestiona tus proveedores y contactos'),
            ),
          ),
          SizedBox(height: 12),
          ...MockData.proveedores.map((prov) => Card(
            margin: EdgeInsets.only(bottom: 8),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xFFE87722),
                child: Icon(Icons.business, color: Colors.white, size: 20),
              ),
              title: Text(prov.nombre),
              subtitle: Text(prov.categoria),
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: [
                      Divider(),
                      _info('Contacto', prov.contacto),
                      _info('Teléfono', prov.telefono),
                      _info('Email', prov.email),
                      _info('Dirección', prov.direccion),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _info(String label, String valor) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(color: Colors.grey)),
          Expanded(child: Text(valor)),
        ],
      ),
    );
  }
}

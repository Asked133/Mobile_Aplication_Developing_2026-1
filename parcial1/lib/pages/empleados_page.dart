import 'package:flutter/material.dart';
import 'package:parcial1/widgets/sidebar_widget.dart';
import 'package:parcial1/widgets/stat_card_widget.dart';
import 'package:parcial1/widgets/avatar_iniciales_widget.dart';
import 'package:parcial1/data/mock_data.dart';

//pagina para ver la lista de empleados
class EmpleadosPage extends StatelessWidget {
  const EmpleadosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Empleados')),
      drawer: SidebarWidget(currentRoute: '/empleados'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.person_add),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          //contadores rapidos usando widget reutilizable
          Row(
            children: [
              StatCardWidget(label: 'Total', valor: '${MockData.empleados.length}', color: Colors.blue),
              SizedBox(width: 10),
              StatCardWidget(label: 'Activos', valor: '${MockData.empleados.where((e) => e.activo).length}', color: Colors.green),
              SizedBox(width: 10),
              StatCardWidget(label: 'Turnos', valor: '3', color: Color(0xFFE87722)),
            ],
          ),
          SizedBox(height: 16),
          //lista de empleados
          ...MockData.empleados.map((emp) => Card(
            color: Colors.white,
            margin: EdgeInsets.only(bottom: 8),
            child: ListTile(
              //avatar con iniciales usando widget reutilizable
              leading: AvatarInicialesWidget(nombre: emp.nombre),
              title: Text(emp.nombre),
              subtitle: Text('${emp.puesto} • ${emp.turno}'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/empleado-detalle', arguments: emp),
            ),
          )),
        ],
      ),
    );
  }
}

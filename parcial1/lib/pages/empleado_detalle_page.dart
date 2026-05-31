import 'package:flutter/material.dart';
import 'package:parcial1/models/empleado.dart';
import 'package:parcial1/widgets/info_card_widget.dart';
import 'package:parcial1/widgets/avatar_iniciales_widget.dart';

//detalles de empleado
class EmpleadoDetallePage extends StatelessWidget {
  const EmpleadoDetallePage({super.key});

  @override
  Widget build(BuildContext context) {
    final emp = ModalRoute.of(context)?.settings.arguments as Empleado?;
    if (emp == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(child: Text('Empleado no encontrado')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(emp.nombre)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            AvatarInicialesWidget(nombre: emp.nombre, radius: 40),
            SizedBox(height: 12),
            Text(emp.nombre, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(emp.puesto, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 24),

            InfoCardWidget(
              titulo: 'Información Personal',
              filas: [
                MapEntry('ID', emp.id),
                MapEntry('Teléfono', emp.telefono),
                MapEntry('Email', emp.email),
              ],
            ),
            SizedBox(height: 12),

            InfoCardWidget(
              titulo: 'Información Laboral',
              filas: [
                MapEntry('Turno', emp.turno),
                MapEntry('Fecha Ingreso', emp.fechaIngreso),
                MapEntry('Salario', '\$${emp.salario.toStringAsFixed(2)}'),
                MapEntry('Estado', emp.activo ? 'Activo' : 'Inactivo'),
              ],
            ),
            SizedBox(height: 20),

            //botones
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
                    icon: Icon(Icons.history),
                    label: Text('Historial'),
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

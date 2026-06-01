// lib/pages/perfil_page.dart
// pantalla de perfil con avatar, estadísticas y opción de cerrar sesión
import 'package:flutter/material.dart';
import '../models/grupo.dart';
import '../services/firebase_service.dart';
import '../utils/constantes.dart';
import '../widgets/avatar_iniciales_widget.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});
  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final _uid = FirebaseService.instance.usuarioActual?.uid ?? 'user1';
  bool _notificacionesActivas = true;

  String get _nombre =>
      FirebaseService.instance.usuarioActual?.displayName ?? 'Usuario';

  String get _email =>
      FirebaseService.instance.usuarioActual?.email ?? '';

  // muestra diálogo para cambiar nombre
  void _cambiarNombre() {
    final controller = TextEditingController(text: _nombre);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cambiar nombre'),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'Tu nuevo nombre'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // aquí se actualizaría en Firebase
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Nombre actualizado'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  // confirma y cierra sesión
  void _cerrarSesion() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await FirebaseService.instance.cerrarSesion();
              if (!mounted) return;
              Navigator.pop(context); // cierra diálogo
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // tarjeta de perfil con avatar grande
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  AvatarInicialesWidget(nombre: _nombre, radio: 40),
                  const SizedBox(height: 12),
                  Text(
                    _nombre,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _email,
                    style: TextStyle(
                        fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // estadísticas
            StreamBuilder<List<Grupo>>(
              stream: FirebaseService.instance.streamGruposUsuario(_uid),
              builder: (context, snapshot) {
                final grupos = snapshot.data ?? [];
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Mis estadísticas',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      _estadisticaRow(
                          Icons.group, '${grupos.length} grupos activos'),
                      const SizedBox(height: 8),
                      // simplificamos omitiendo el total de gastos globales 
                      // (evitamos llamadas a colecciones que no necesitamos)
                      _estadisticaRow(
                          Icons.receipt_long, 'Consulta gastos dentro de cada grupo'),
                    ],
                  ),
                );
              }
            ),
            const SizedBox(height: 16),

            // opciones
            Card(
              color: Colors.white,
              child: Column(
                children: [
                  // toggle notificaciones
                  SwitchListTile(
                    title: const Text('Notificaciones'),
                    subtitle: const Text('Recibir alertas de gastos y pagos'),
                    secondary: const Icon(Icons.notifications_outlined),
                    value: _notificacionesActivas,
                    onChanged: (value) {
                      setState(() => _notificacionesActivas = value);
                    },
                  ),
                  const Divider(height: 1),
                  // cambiar nombre
                  ListTile(
                    leading: const Icon(Icons.edit_outlined),
                    title: const Text('Cambiar nombre'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _cambiarNombre,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // botón cerrar sesión
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _cerrarSesion,
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Cerrar sesión',
                    style: TextStyle(color: Colors.red, fontSize: 16)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // versión de la app
            Text(
              'SplitMate v1.0.0',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }

  // fila de estadística con ícono y texto
  Widget _estadisticaRow(IconData icono, String texto) {
    return Row(
      children: [
        Icon(icono, size: 20, color: kColorPrimario),
        const SizedBox(width: 10),
        Text(texto, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

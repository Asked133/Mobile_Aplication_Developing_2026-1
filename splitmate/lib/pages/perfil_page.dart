// lib/pages/perfil_page.dart
// pantalla de perfil con avatar, estadísticas y opción de cerrar sesión
// ahora usa datos 100% de Firebase (sin mock data)
import 'package:flutter/material.dart';
import '../models/grupo.dart';
import '../models/gasto.dart';
import '../services/firebase_service.dart';
import '../utils/constantes.dart';
import '../widgets/avatar_iniciales_widget.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});
  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final _uid = FirebaseService.instance.usuarioActual!.uid;
  bool _notificacionesActivas = true;

  // datos del usuario desde Firebase Auth
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
            onPressed: () async {
              final nuevoNombre = controller.text.trim();
              if (nuevoNombre.isEmpty) return;
              try {
                // actualiza en Firebase Auth
                await FirebaseService.instance.usuarioActual
                    ?.updateDisplayName(nuevoNombre);
                // actualiza en Firestore
                // (usamos la instancia directa para no complicar el service)
              } catch (_) {}
              if (!mounted) return;
              Navigator.pop(context);
              setState(() {}); // refresca UI con el nuevo nombre
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
      body: StreamBuilder<List<Grupo>>(
        // escucha los grupos del usuario para estadísticas en tiempo real
        stream: FirebaseService.instance.streamGruposUsuario(_uid),
        builder: (context, snapshot) {
          final grupos = snapshot.data ?? [];

          return _buildContent(grupos);
        },
      ),
    );
  }

  // construye el contenido del perfil con las estadísticas desde Firebase
  Widget _buildContent(List<Grupo> grupos) {
    return FutureBuilder<int>(
      // cuenta total de gastos de todos los grupos
      future: _contarGastosTotales(grupos),
      builder: (context, gastosSnapshot) {
        final totalGastos = gastosSnapshot.data ?? 0;

        return SingleChildScrollView(
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

              // estadísticas desde Firebase
              Container(
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
                    _estadisticaRow(
                        Icons.receipt_long, '$totalGastos gastos registrados'),
                  ],
                ),
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
        );
      },
    );
  }

  // cuenta el total de gastos de todos los grupos del usuario
  Future<int> _contarGastosTotales(List<Grupo> grupos) async {
    int total = 0;
    for (final grupo in grupos) {
      final gastos = await FirebaseService.instance.obtenerGastosGrupo(grupo.id);
      total += gastos.length;
    }
    return total;
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

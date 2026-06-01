// lib/pages/actividad_page.dart
// timeline de actividad de todos los grupos del usuario con filtros
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/actividad.dart';
import '../models/usuario.dart';
import '../models/grupo.dart';
import '../services/firebase_service.dart';

class ActividadPage extends StatefulWidget {
  const ActividadPage({super.key});
  @override
  State<ActividadPage> createState() => _ActividadPageState();
}

class _ActividadPageState extends State<ActividadPage> {
  final _uid = FirebaseService.instance.usuarioActual?.uid ?? 'user1';

  // filtro seleccionado
  String _filtro = 'todos';

  // opciones de filtro
  final _filtros = [
    {'id': 'todos',           'label': 'Todos'},
    {'id': 'gasto_agregado',  'label': 'Gastos'},
    {'id': 'deuda_saldada',   'label': 'Pagos'},
    {'id': 'miembro_agregado','label': 'Miembros'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actividad')),
      body: Column(
        children: [
          // chips de filtro
          Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filtros.map((f) {
                  final seleccionado = _filtro == f['id'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(f['label']!),
                      selected: seleccionado,
                      onSelected: (_) => setState(() => _filtro = f['id']!),
                      selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // lista de actividades o estado vacío
          Expanded(
            child: FutureBuilder<List<Actividad>>(
              future: FirebaseService.instance.obtenerActividadUsuario(_uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final todasActividades = snapshot.data ?? [];
                
                // aplica filtro si no es "todos"
                final actividadesFiltradas = _filtro == 'todos'
                    ? todasActividades
                    : todasActividades.where((a) => a.tipo == _filtro).toList();

                if (actividadesFiltradas.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 64, color: Colors.grey),
                        SizedBox(height: 12),
                        Text('Sin actividad reciente',
                            style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: actividadesFiltradas.length,
                  separatorBuilder: (context, i) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final act = actividadesFiltradas[index];
                    final dateFormatter = DateFormat('dd/MM HH:mm');

                    return FutureBuilder<List<dynamic>>(
                      future: Future.wait([
                        FirebaseService.instance.obtenerUsuarioCacheado(act.actorUid),
                        FirebaseService.instance.obtenerGrupo(act.grupoId),
                      ]),
                      builder: (context, actSnapshot) {
                        final actor = actSnapshot.data?.elementAtOrNull(0) as Usuario?;
                        final grupo = actSnapshot.data?.elementAtOrNull(1) as Grupo?;
                        
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey.shade100,
                            child: Text(act.emoji,
                                style: const TextStyle(fontSize: 22)),
                          ),
                          title: Text(act.descripcion,
                              style: const TextStyle(fontSize: 14)),
                          subtitle: Text(
                            '${actor?.nombre ?? 'Alguien'} • ${grupo?.nombre ?? ''} • ${dateFormatter.format(act.creadoEn)}',
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          trailing: act.monto != null
                              ? Text(
                                  '\$${act.monto!.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 13),
                                )
                              : null,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

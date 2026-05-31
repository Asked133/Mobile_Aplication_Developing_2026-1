// lib/pages/actividad_page.dart
// timeline de actividad de todos los grupos del usuario con filtros
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/mock_data.dart';
import '../models/actividad.dart';
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
    // obtiene todas las actividades de todos los grupos del usuario
    final misGrupos = MockData.grupos.where((g) => g.esMiembro(_uid)).toList();
    List<Actividad> todasActividades = [];
    for (final grupo in misGrupos) {
      todasActividades.addAll(MockData.actividadesDeGrupo(grupo.id));
    }

    // ordena por fecha (más reciente primero)
    todasActividades.sort((a, b) => b.creadoEn.compareTo(a.creadoEn));

    // aplica filtro si no es "todos"
    final actividadesFiltradas = _filtro == 'todos'
        ? todasActividades
        : todasActividades.where((a) => a.tipo == _filtro).toList();

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
            child: actividadesFiltradas.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 64, color: Colors.grey),
                        SizedBox(height: 12),
                        Text('Sin actividad reciente',
                            style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: actividadesFiltradas.length,
                    separatorBuilder: (context2, i) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final act = actividadesFiltradas[index];
                      final actor = MockData.buscarUsuario(act.actorUid);
                      final grupo = MockData.grupos
                          .where((g) => g.id == act.grupoId)
                          .firstOrNull;
                      final dateFormatter = DateFormat('dd/MM HH:mm');

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
                  ),
          ),
        ],
      ),
    );
  }
}

// lib/pages/actividad_page.dart
// timeline de actividad de todos los grupos del usuario con filtros
// ahora usa datos 100% de Firebase (sin mock data)
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/actividad.dart';
import '../models/grupo.dart';
import '../models/usuario.dart';
import '../services/firebase_service.dart';

class ActividadPage extends StatefulWidget {
  const ActividadPage({super.key});
  @override
  State<ActividadPage> createState() => _ActividadPageState();
}

class _ActividadPageState extends State<ActividadPage> {
  final _uid = FirebaseService.instance.usuarioActual!.uid;

  // filtro seleccionado
  String _filtro = 'todos';

  // opciones de filtro
  final _filtros = [
    {'id': 'todos',           'label': 'Todos'},
    {'id': 'gasto_agregado',  'label': 'Gastos'},
    {'id': 'deuda_saldada',   'label': 'Pagos'},
    {'id': 'miembro_agregado','label': 'Miembros'},
  ];

  // datos cargados desde Firebase
  List<Grupo> _grupos = [];
  List<Actividad> _todasActividades = [];
  Map<String, Usuario> _usuarios = {};
  bool _cargando = true;

  // suscripciones a streams de actividad
  final List<StreamSubscription> _subs = [];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  void dispose() {
    // cancela todas las suscripciones a streams
    for (final sub in _subs) {
      sub.cancel();
    }
    super.dispose();
  }

  // carga los grupos del usuario y escucha actividad de cada uno
  Future<void> _cargarDatos() async {
    // escucha los grupos del usuario
    FirebaseService.instance.streamGruposUsuario(_uid).listen((grupos) async {
      if (!mounted) return;

      _grupos = grupos;

      // carga usuarios de todos los grupos
      final todosUids = <String>{};
      for (final g in grupos) {
        todosUids.addAll(g.miembrosUid);
      }
      final usuarios = await FirebaseService.instance.obtenerUsuarios(todosUids.toList());
      if (!mounted) return;
      _usuarios = usuarios;

      // cancela suscripciones anteriores
      for (final sub in _subs) {
        sub.cancel();
      }
      _subs.clear();

      // acumula actividades de todos los grupos
      final Map<String, List<Actividad>> actividadesPorGrupo = {};

      for (final grupo in grupos) {
        final sub = FirebaseService.instance.streamActividadGrupo(grupo.id).listen((actividades) {
          if (!mounted) return;
          actividadesPorGrupo[grupo.id] = actividades;

          // combina todas las actividades y actualiza UI
          final todas = <Actividad>[];
          for (final list in actividadesPorGrupo.values) {
            todas.addAll(list);
          }
          // ordena por fecha (más reciente primero)
          todas.sort((a, b) => b.creadoEn.compareTo(a.creadoEn));

          setState(() {
            _todasActividades = todas;
            _cargando = false;
          });
        });
        _subs.add(sub);
      }

      // si no hay grupos, deja de cargar
      if (grupos.isEmpty && mounted) {
        setState(() => _cargando = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // aplica filtro si no es "todos"
    final actividadesFiltradas = _filtro == 'todos'
        ? _todasActividades
        : _todasActividades.where((a) => a.tipo == _filtro).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Actividad')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                            final actor = _usuarios[act.actorUid];
                            final grupo = _grupos
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

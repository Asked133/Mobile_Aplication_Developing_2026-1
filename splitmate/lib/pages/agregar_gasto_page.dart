// lib/pages/agregar_gasto_page.dart
// formulario completo para agregar un gasto al grupo
// soporta 3 métodos de división: igual, exacto y porcentaje
// ahora carga miembros del grupo desde Firebase (sin mock data)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/gasto.dart';
import '../models/grupo.dart';
import '../models/usuario.dart';
import '../services/firebase_service.dart';
import '../services/notificacion_service.dart';
import '../utils/validadores.dart';
import '../widgets/selector_metodo_split_widget.dart';
import '../widgets/categoria_chip_widget.dart';

class AgregarGastoPage extends StatefulWidget {
  const AgregarGastoPage({super.key});
  @override
  State<AgregarGastoPage> createState() => _AgregarGastoPageState();
}

class _AgregarGastoPageState extends State<AgregarGastoPage> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final _montoController = TextEditingController();
  final _notasController = TextEditingController();

  final _uid = FirebaseService.instance.usuarioActual!.uid;
  String _pagadoPor = '';
  String _categoriaSeleccionada = 'comida';
  MetodoSplit _metodoSplit = MetodoSplit.igual;
  bool _cargando = false;
  bool _cargandoMiembros = true;

  // miembros del grupo cargados desde Firebase
  List<Usuario> _miembros = [];
  late Map<String, bool> _miembrosSeleccionados;
  late Map<String, TextEditingController> _montoPorMiembro;
  late Map<String, TextEditingController> _porcentajePorMiembro;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // carga miembros del grupo desde Firebase
    if (_cargandoMiembros) {
      _cargarMiembros();
    }
  }

  // carga el grupo desde Firebase y obtiene los perfiles de los miembros
  Future<void> _cargarMiembros() async {
    final grupoId = ModalRoute.of(context)!.settings.arguments as String;

    // obtiene el grupo desde Firebase
    final grupo = await FirebaseService.instance.obtenerGrupo(grupoId);
    if (grupo == null || !mounted) return;

    // obtiene los perfiles de los miembros
    final usuarios = await FirebaseService.instance.obtenerUsuarios(grupo.miembrosUid);

    if (!mounted) return;
    setState(() {
      _miembros = grupo.miembrosUid
          .map((uid) => usuarios[uid])
          .whereType<Usuario>()
          .toList();

      // por defecto el que pagó es el usuario actual
      if (_pagadoPor.isEmpty) _pagadoPor = _uid;

      // inicializa mapas de selección y controllers
      _miembrosSeleccionados = {for (var m in _miembros) m.uid: true};
      _montoPorMiembro = {for (var m in _miembros) m.uid: TextEditingController()};
      _porcentajePorMiembro = {for (var m in _miembros) m.uid: TextEditingController()};

      _cargandoMiembros = false;
    });
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _montoController.dispose();
    _notasController.dispose();
    // limpia controllers de montos y porcentajes solo si ya se inicializaron
    if (!_cargandoMiembros) {
      for (final c in _montoPorMiembro.values) {
        c.dispose();
      }
      for (final c in _porcentajePorMiembro.values) {
        c.dispose();
      }
    }
    super.dispose();
  }

  // calcula cuánto le toca a cada persona según el método seleccionado
  List<DetallesDivision> _calcularDivision() {
    final monto = double.tryParse(
        _montoController.text.replaceAll(',', '.')) ?? 0;
    final seleccionados = _miembros
        .where((m) => _miembrosSeleccionados[m.uid] == true)
        .toList();

    if (seleccionados.isEmpty || monto <= 0) return [];

    switch (_metodoSplit) {
      case MetodoSplit.igual:
        // divide entre todos por igual
        final porPersona = monto / seleccionados.length;
        return seleccionados
            .map((m) => DetallesDivision(
                uid: m.uid,
                monto: double.parse(porPersona.toStringAsFixed(2))))
            .toList();

      case MetodoSplit.exacto:
        // usa los montos exactos que ingresó el usuario
        return seleccionados.map((m) {
          final montoExacto = double.tryParse(
              _montoPorMiembro[m.uid]?.text.replaceAll(',', '.') ?? '0') ?? 0;
          return DetallesDivision(uid: m.uid, monto: montoExacto);
        }).toList();

      case MetodoSplit.porcentaje:
        // calcula basándose en porcentajes
        return seleccionados.map((m) {
          final porcentaje = double.tryParse(
              _porcentajePorMiembro[m.uid]?.text.replaceAll(',', '.') ?? '0') ?? 0;
          return DetallesDivision(
              uid: m.uid,
              monto: double.parse((monto * porcentaje / 100).toStringAsFixed(2)));
        }).toList();
    }
  }

  // guarda el gasto en Firebase
  Future<void> _guardarGasto() async {
    if (!_formKey.currentState!.validate()) return;

    final grupoId = ModalRoute.of(context)!.settings.arguments as String;
    final monto = double.tryParse(
        _montoController.text.replaceAll(',', '.')) ?? 0;
    final division = _calcularDivision();

    // valida que la suma de la división sea correcta
    if (division.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos un miembro'),
            backgroundColor: Colors.red),
      );
      return;
    }

    // valida porcentajes sumen 100%
    if (_metodoSplit == MetodoSplit.porcentaje) {
      final sumaPorcentajes = _miembros
          .where((m) => _miembrosSeleccionados[m.uid] == true)
          .fold<double>(0, (sum, m) {
        return sum + (double.tryParse(
            _porcentajePorMiembro[m.uid]?.text.replaceAll(',', '.') ?? '0') ?? 0);
      });
      if ((sumaPorcentajes - 100).abs() > 0.01) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Los porcentajes suman ${sumaPorcentajes.toStringAsFixed(1)}% — deben sumar 100%'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    setState(() => _cargando = true);

    final gasto = Gasto(
      id: '',
      grupoId: grupoId,
      descripcion: _descripcionController.text.trim(),
      monto: monto,
      pagadoPor: _pagadoPor,
      divididoEntre: division,
      categoria: _categoriaSeleccionada,
      fecha: DateTime.now(),
      notas: _notasController.text.trim().isNotEmpty
          ? _notasController.text.trim()
          : null,
      creadoPor: _uid,
    );

    final error = await FirebaseService.instance.agregarGasto(gasto);
    setState(() => _cargando = false);

    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    } else {
      // muestra notificación local del gasto registrado
      await NotificacionService.instance.mostrarNotificacion(
        titulo: 'Gasto registrado 💸',
        cuerpo: '${gasto.descripcion} — \$${gasto.monto.toStringAsFixed(2)}',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Gasto guardado!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // muestra indicador de carga mientras se cargan los miembros
    if (_cargandoMiembros) {
      return Scaffold(
        appBar: AppBar(title: const Text('Agregar gasto')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final montoTotal = double.tryParse(
        _montoController.text.replaceAll(',', '.')) ?? 0;
    final seleccionados = _miembros
        .where((m) => _miembrosSeleccionados[m.uid] == true)
        .length;
    final montoPorPersona = seleccionados > 0 && montoTotal > 0
        ? montoTotal / seleccionados
        : 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Agregar gasto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // descripción del gasto
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(Icons.description_outlined),
                  hintText: 'Ej: Cena, Uber, Súper...',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'La descripción es requerida';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // monto del gasto
              TextFormField(
                controller: _montoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Monto total',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: validarMonto,
                onChanged: (_) => setState(() {}), // actualiza preview
              ),
              const SizedBox(height: 20),

              // ¿quién pagó? — lista de radio buttons
              const Text('¿Quién pagó?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...(_miembros.map((m) {
                    final seleccionado = m.uid == _pagadoPor;
                    return ListTile(
                      title: Text(m.nombre),
                      leading: Icon(
                        seleccionado ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                        color: seleccionado ? Theme.of(context).colorScheme.primary : Colors.grey,
                      ),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      onTap: () => setState(() => _pagadoPor = m.uid),
                    );
                  })),
              const SizedBox(height: 16),

              // categoría
              const Text('Categoría',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CategoriaChipWidget(
                categoriaSeleccionada: _categoriaSeleccionada,
                onSeleccionar: (cat) => setState(() => _categoriaSeleccionada = cat),
              ),
              const SizedBox(height: 20),

              // método de división
              const Text('¿Cómo dividir?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SelectorMetodoSplitWidget(
                seleccionado: _metodoSplit,
                onCambio: (metodo) => setState(() => _metodoSplit = metodo),
              ),
              const SizedBox(height: 16),

              // miembros a incluir (checkboxes)
              const Text('Dividir entre:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              ...(_miembros.map((m) {
                return CheckboxListTile(
                  title: Text(m.nombre, style: const TextStyle(fontSize: 14)),
                  value: _miembrosSeleccionados[m.uid] ?? false,
                  onChanged: (value) {
                    setState(() => _miembrosSeleccionados[m.uid] = value ?? false);
                  },
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  // si es exacto o porcentaje, muestra TextField adicional
                  subtitle: _metodoSplit == MetodoSplit.exacto &&
                          _miembrosSeleccionados[m.uid] == true
                      ? Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: TextField(
                            controller: _montoPorMiembro[m.uid],
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              hintText: 'Monto exacto',
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            style: const TextStyle(fontSize: 13),
                          ),
                        )
                      : _metodoSplit == MetodoSplit.porcentaje &&
                              _miembrosSeleccionados[m.uid] == true
                          ? Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: TextField(
                                controller: _porcentajePorMiembro[m.uid],
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  hintText: 'Porcentaje (%)',
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                ),
                                style: const TextStyle(fontSize: 13),
                              ),
                            )
                          : null,
                );
              })),
              const SizedBox(height: 12),

              // preview del monto por persona (solo modo igual)
              if (_metodoSplit == MetodoSplit.igual && montoPorPersona > 0)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${formatter.format(montoPorPersona)} por persona ($seleccionados personas)',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 16),

              // notas opcionales
              TextFormField(
                controller: _notasController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Notas (opcional)',
                  prefixIcon: Icon(Icons.note_outlined),
                ),
              ),
              const SizedBox(height: 24),

              // botón guardar
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _cargando ? null : _guardarGasto,
                  icon: _cargando
                      ? const SizedBox(
                          height: 20, width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.save),
                  label: const Text('Guardar gasto', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// lib/pages/balances_page.dart
// muestra las deudas activas de un grupo con opción de saldar
// ahora usa datos 100% de Firebase (sin mock data)
import 'package:flutter/material.dart';
import '../models/gasto.dart';
import '../models/balance.dart';
import '../models/usuario.dart';
import '../services/firebase_service.dart';
import '../widgets/balance_card_widget.dart';

class BalancesPage extends StatefulWidget {
  const BalancesPage({super.key});
  @override
  State<BalancesPage> createState() => _BalancesPageState();
}

class _BalancesPageState extends State<BalancesPage> {
  final _uid = FirebaseService.instance.usuarioActual!.uid;

  // cache de usuarios del grupo
  Map<String, Usuario> _usuarios = {};
  bool _usuariosCargados = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_usuariosCargados) {
      _usuariosCargados = true;
      _cargarUsuarios();
    }
  }

  // carga los usuarios involucrados en los balances
  Future<void> _cargarUsuarios() async {
    final grupoId = ModalRoute.of(context)!.settings.arguments as String;
    final grupo = await FirebaseService.instance.obtenerGrupo(grupoId);
    if (grupo == null || !mounted) return;
    final usuarios = await FirebaseService.instance.obtenerUsuarios(grupo.miembrosUid);
    if (mounted) {
      setState(() => _usuarios = usuarios);
    }
  }

  @override
  Widget build(BuildContext context) {
    // recibe el grupoId como argumento
    final grupoId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: const Text('Balances')),
      // usa StreamBuilder para obtener gastos en tiempo real y calcular balances
      body: StreamBuilder<List<Gasto>>(
        stream: FirebaseService.instance.streamGastosGrupo(grupoId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final gastos = snapshot.data ?? [];
          final balances = CalculadorBalances.calcular(gastos, grupoId: grupoId);

          // cuántas deudas involucran al usuario actual
          final misDeudas = balances.where((b) => b.deudorUid == _uid).length;
          final mesDeben = balances.where((b) => b.acreedorUid == _uid).length;

          if (balances.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
                  SizedBox(height: 12),
                  Text('¡Todos están en paz! 🎉',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // resumen de deudas
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text('${balances.length} deudas activas',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        'Debes en $misDeudas • Te deben en $mesDeben',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // lista de balances con datos de Firebase
                ...balances.map((balance) {
                  return BalanceCardWidget(
                    balance: balance,
                    deudor: _usuarios[balance.deudorUid],
                    acreedor: _usuarios[balance.acreedorUid],
                    uidActual: _uid,
                    onSaldar: () => Navigator.pushNamed(
                      context, '/saldar',
                      arguments: {
                        'balance': balance,
                        'grupoId': grupoId,
                      },
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

// lib/pages/balances_page.dart
// muestra las deudas activas de un grupo con opción de saldar
import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/balance.dart';
import '../services/firebase_service.dart';
import '../widgets/balance_card_widget.dart';

class BalancesPage extends StatefulWidget {
  const BalancesPage({super.key});
  @override
  State<BalancesPage> createState() => _BalancesPageState();
}

class _BalancesPageState extends State<BalancesPage> {
  final _uid = FirebaseService.instance.usuarioActual?.uid ?? 'user1';

  @override
  Widget build(BuildContext context) {
    // recibe el grupoId como argumento
    final grupoId = ModalRoute.of(context)!.settings.arguments as String;

    // calcula balances a partir de los gastos del grupo
    final gastos = MockData.gastosDeGrupo(grupoId);
    final balances = CalculadorBalances.calcular(gastos, grupoId: grupoId);

    // cuántas deudas involucran al usuario actual
    final misDeudas = balances.where((b) => b.deudorUid == _uid).length;
    final mesDeben = balances.where((b) => b.acreedorUid == _uid).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Balances')),
      body: balances.isEmpty
          // estado vacío
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
                  SizedBox(height: 12),
                  Text('¡Todos están en paz! 🎉',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : SingleChildScrollView(
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

                  // lista de balances
                  ...balances.map((balance) {
                    return BalanceCardWidget(
                      balance: balance,
                      deudor: MockData.buscarUsuario(balance.deudorUid),
                      acreedor: MockData.buscarUsuario(balance.acreedorUid),
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
            ),
    );
  }
}

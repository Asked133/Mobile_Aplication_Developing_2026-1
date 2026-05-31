// lib/pages/saldar_page.dart
// pantalla para confirmar el pago de una deuda
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/mock_data.dart';
import '../models/balance.dart';
import '../services/firebase_service.dart';
import '../utils/constantes.dart';
import '../widgets/avatar_iniciales_widget.dart';

class SaldarPage extends StatefulWidget {
  const SaldarPage({super.key});
  @override
  State<SaldarPage> createState() => _SaldarPageState();
}

class _SaldarPageState extends State<SaldarPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _montoController;
  final _notaController = TextEditingController();
  String _metodoPago = 'efectivo';
  bool _cargando = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // inicializa el monto con el valor de la deuda
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final balance = args['balance'] as Balance;
    _montoController = TextEditingController(text: balance.monto.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _montoController.dispose();
    _notaController.dispose();
    super.dispose();
  }

  // confirma el pago y lo registra en Firebase
  Future<void> _confirmarPago() async {
    if (!_formKey.currentState!.validate()) return;

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final balance = args['balance'] as Balance;
    final grupoId = args['grupoId'] as String;
    final monto = double.tryParse(
        _montoController.text.replaceAll(',', '.')) ?? 0;

    setState(() => _cargando = true);

    final error = await FirebaseService.instance.saldarDeuda(
      grupoId: grupoId,
      deudorUid: balance.deudorUid,
      acreedorUid: balance.acreedorUid,
      monto: monto,
      nota: _notaController.text.trim().isNotEmpty
          ? '${_notaController.text.trim()} ($_metodoPago)'
          : _metodoPago,
    );

    setState(() => _cargando = false);

    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Pago registrado! ✅'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final balance = args['balance'] as Balance;
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    final deudor = MockData.buscarUsuario(balance.deudorUid);
    final acreedor = MockData.buscarUsuario(balance.acreedorUid);

    return Scaffold(
      appBar: AppBar(title: const Text('Saldar deuda')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // visualización de la deuda: deudor → acreedor
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // deudor
                        Column(
                          children: [
                            AvatarInicialesWidget(
                                nombre: deudor?.nombre ?? '?', radio: 30),
                            const SizedBox(height: 8),
                            Text(deudor?.nombre ?? 'Tú',
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        // flecha
                        const Icon(Icons.arrow_forward, size: 28, color: Colors.grey),
                        // acreedor
                        Column(
                          children: [
                            AvatarInicialesWidget(
                                nombre: acreedor?.nombre ?? '?', radio: 30),
                            const SizedBox(height: 8),
                            Text(acreedor?.nombre ?? 'Alguien',
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      formatter.format(balance.monto),
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // monto a pagar (editable)
              TextFormField(
                controller: _montoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Monto a pagar',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingresa el monto';
                  final n = double.tryParse(value.replaceAll(',', '.'));
                  if (n == null || n <= 0) return 'Debe ser mayor a 0';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // método de pago — selector visual (igual que parcial1)
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Método de pago',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildMetodoPago('efectivo', Icons.money, 'Efectivo'),
                  const SizedBox(width: 8),
                  _buildMetodoPago('transferencia', Icons.account_balance, 'Transfer.'),
                  const SizedBox(width: 8),
                  _buildMetodoPago('otro', Icons.more_horiz, 'Otro'),
                ],
              ),
              const SizedBox(height: 16),

              // nota opcional
              TextFormField(
                controller: _notaController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Nota (opcional)',
                  prefixIcon: Icon(Icons.note_outlined),
                ),
              ),
              const SizedBox(height: 30),

              // botón confirmar pago
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _cargando ? null : _confirmarPago,
                  icon: _cargando
                      ? const SizedBox(
                          height: 20, width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.check),
                  label: const Text('Confirmar pago', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // botón visual de método de pago
  Widget _buildMetodoPago(String id, IconData icono, String label) {
    final seleccionado = _metodoPago == id;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _metodoPago = id),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: seleccionado ? kColorPrimario : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(icono,
                  color: seleccionado ? Colors.white : Colors.grey, size: 22),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                    fontSize: 11,
                    color: seleccionado ? Colors.white : Colors.grey,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

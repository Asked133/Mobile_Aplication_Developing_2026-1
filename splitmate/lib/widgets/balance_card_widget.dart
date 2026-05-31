// tarjeta que muestra quién le debe a quién con opción de saldar
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/balance.dart';
import '../models/usuario.dart';
import 'avatar_iniciales_widget.dart';

class BalanceCardWidget extends StatelessWidget {
  final Balance balance;
  final Usuario? deudor;
  final Usuario? acreedor;
  final String uidActual;
  final VoidCallback? onSaldar;

  const BalanceCardWidget({
    super.key,
    required this.balance,
    required this.deudor,
    required this.acreedor,
    required this.uidActual,
    this.onSaldar,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final esMiDeuda = balance.deudorUid == uidActual;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // avatar del deudor
            AvatarInicialesWidget(nombre: deudor?.nombre ?? '?', radio: 22),
            const SizedBox(width: 10),
            // texto de quién le debe a quién
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${deudor?.nombre ?? 'Alguien'} le debe a ${acreedor?.nombre ?? 'Alguien'}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    formatter.format(balance.monto),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: esMiDeuda ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            // botón saldar solo si es mi deuda
            if (esMiDeuda && onSaldar != null)
              TextButton(
                onPressed: onSaldar,
                child: const Text('Saldar'),
              ),
          ],
        ),
      ),
    );
  }
}

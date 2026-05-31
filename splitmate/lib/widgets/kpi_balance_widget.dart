// tarjeta de resumen para el balance del usuario — similar a KpiCardWidget de parcial1
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/constantes.dart';

class KpiBalanceWidget extends StatelessWidget {
  final double balance; // positivo = te deben, negativo = debes
  final int totalGrupos;

  const KpiBalanceWidget({
    super.key,
    required this.balance,
    required this.totalGrupos,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final esPositivo = balance >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kColorPrimario,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // etiqueta: te deben o debes
          Text(
            esPositivo ? 'En total te deben' : 'En total debes',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 4),
          // monto grande
          Text(
            formatter.format(balance.abs()),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          // cantidad de grupos activos
          Row(
            children: [
              const Icon(Icons.group, color: Colors.white70, size: 16),
              const SizedBox(width: 6),
              Text('$totalGrupos grupos activos',
                  style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

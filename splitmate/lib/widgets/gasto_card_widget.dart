// tarjeta para mostrar un gasto en la lista — con emoji de categoría y desglose
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/gasto.dart';
import '../models/usuario.dart';

class GastoCardWidget extends StatelessWidget {
  final Gasto gasto;
  final Usuario? quienPago;
  final String uidActual;
  final VoidCallback onTap;

  const GastoCardWidget({
    super.key,
    required this.gasto,
    required this.quienPago,
    required this.uidActual,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    // busca el emoji de la categoría del gasto
    final nombreCategoria = kCategorias
        .firstWhere((c) => c['id'] == gasto.categoria,
            orElse: () => {'emoji': '📋', 'nombre': 'Otro'});

    // cuánto paga el usuario actual en este gasto
    final miParte = gasto.montoParaUsuario(uidActual);
    final yoPague = gasto.pagadoPor == uidActual;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        // emoji de la categoría
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade100,
          child: Text(nombreCategoria['emoji'] as String, style: const TextStyle(fontSize: 20)),
        ),
        title: Text(gasto.descripcion),
        // muestra quién pagó
        subtitle: Text(
          yoPague
              ? 'Tú pagaste • ${formatter.format(gasto.monto)}'
              : '${quienPago?.nombre ?? 'Alguien'} pagó • ${formatter.format(gasto.monto)}',
          style: const TextStyle(fontSize: 12),
        ),
        // monto que te afecta: + si pagaste, - si debes
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              yoPague
                  ? '+ ${formatter.format(gasto.monto - miParte)}'
                  : '- ${formatter.format(miParte)}',
              style: TextStyle(
                color: yoPague ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            Text(
              yoPague ? 'te prestan' : 'tu parte',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

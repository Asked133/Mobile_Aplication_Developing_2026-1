// tarjeta para mostrar un gasto en la lista — con emoji de categoría y desglose
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/gasto.dart';
import '../models/usuario.dart';

import '../services/firebase_service.dart';

class GastoCardWidget extends StatelessWidget {
  final Gasto gasto;
  final String uidActual;
  final VoidCallback onTap;

  const GastoCardWidget({
    super.key,
    required this.gasto,
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
        // muestra quién pagó usando FutureBuilder para obtener el nombre
        subtitle: FutureBuilder<Usuario?>(
          future: FirebaseService.instance.obtenerUsuarioCacheado(gasto.pagadoPor),
          builder: (context, snapshot) {
            final nombre = snapshot.data?.nombre ?? 'Alguien';
            return Text(
              yoPague
                  ? 'Tú pagaste • ${formatter.format(gasto.monto)}'
                  : '$nombre pagó • ${formatter.format(gasto.monto)}',
              style: const TextStyle(fontSize: 12),
            );
          },
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

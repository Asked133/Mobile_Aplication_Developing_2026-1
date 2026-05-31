// tarjeta de grupo — muestra nombre, miembros y balance del usuario en el grupo
import 'package:flutter/material.dart';
import '../models/grupo.dart';
import '../utils/constantes.dart';
import 'package:intl/intl.dart';

class GrupoCardWidget extends StatelessWidget {
  final Grupo grupo;
  final double balanceUsuario; // cuánto debe/le deben en este grupo
  final VoidCallback onTap;

  const GrupoCardWidget({
    super.key,
    required this.grupo,
    required this.balanceUsuario,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final esPositivo = balanceUsuario >= 0;
    final colorBalance = esPositivo ? Colors.green : Colors.red;

    // texto que muestra si estás en paz, te deben, o debes
    final textoBalance = balanceUsuario == 0
        ? 'En paz 👏'
        : esPositivo
            ? 'Te deben ${formatter.format(balanceUsuario)}'
            : 'Debes ${formatter.format(balanceUsuario.abs())}';

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        // icono con la primera letra del grupo
        leading: CircleAvatar(
          backgroundColor: kColorPrimario.withValues(alpha: 0.15),
          child: Text(
            grupo.nombre[0].toUpperCase(),
            style: const TextStyle(
              color: kColorPrimario,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(grupo.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${grupo.totalMiembros} miembros'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              textoBalance,
              style: TextStyle(color: colorBalance, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

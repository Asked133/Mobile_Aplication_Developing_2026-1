// modelo de balance — representa una deuda entre dos personas
// y calculadora que simplifica las deudas de un grupo
import 'gasto.dart';

// representa que 'deudorUid' le debe 'monto' a 'acreedorUid'
class Balance {
  final String deudorUid;
  final String acreedorUid;
  final double monto;
  final String? grupoId;

  const Balance({
    required this.deudorUid,
    required this.acreedorUid,
    required this.monto,
    this.grupoId,
  });
}

// calcula los balances simplificados a partir de los gastos del grupo
// usa un algoritmo greedy: empata acreedores con deudores para minimizar transacciones
class CalculadorBalances {
  static List<Balance> calcular(List<Gasto> gastos, {String? grupoId}) {
    // mapa de balances netos: uid → (positivo = te deben, negativo = debes)
    final Map<String, double> netos = {};

    for (final gasto in gastos) {
      // el que pagó recibe el total
      netos[gasto.pagadoPor] = (netos[gasto.pagadoPor] ?? 0) + gasto.monto;

      // cada participante "usa" su parte
      for (final division in gasto.divididoEntre) {
        netos[division.uid] = (netos[division.uid] ?? 0) - division.monto;
      }
    }

    // separar acreedores (positivo) y deudores (negativo)
    final acreedores = netos.entries.where((e) => e.value > 0.01).toList();
    final deudores   = netos.entries.where((e) => e.value < -0.01).toList();

    final List<Balance> resultado = [];
    int i = 0, j = 0;

    // empata deudores con acreedores uno a uno
    while (i < acreedores.length && j < deudores.length) {
      final acreedor = acreedores[i];
      final deudor   = deudores[j];
      final pago = acreedor.value < -deudor.value ? acreedor.value : -deudor.value;

      resultado.add(Balance(
        deudorUid: deudor.key,
        acreedorUid: acreedor.key,
        monto: double.parse(pago.toStringAsFixed(2)),
        grupoId: grupoId,
      ));

      acreedores[i] = MapEntry(acreedor.key, acreedor.value - pago);
      deudores[j]   = MapEntry(deudor.key,   deudor.value   + pago);

      if (acreedores[i].value < 0.01) i++;
      if (deudores[j].value > -0.01) j++;
    }

    return resultado;
  }
}

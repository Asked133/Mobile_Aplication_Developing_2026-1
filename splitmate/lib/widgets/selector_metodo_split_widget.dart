// selector visual de método de división (igual, exacto, porcentaje)
// misma idea que el selector de método de pago en nueva_venta_page de parcial1
import 'package:flutter/material.dart';
import '../utils/constantes.dart';

// enum con los 3 métodos de división de un gasto
enum MetodoSplit { igual, exacto, porcentaje }

class SelectorMetodoSplitWidget extends StatelessWidget {
  final MetodoSplit seleccionado;
  final ValueChanged<MetodoSplit> onCambio;

  const SelectorMetodoSplitWidget({
    super.key,
    required this.seleccionado,
    required this.onCambio,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: MetodoSplit.values.map((metodo) {
        final estaSeleccionado = metodo == seleccionado;

        // label e ícono para cada método
        final (label, icono) = switch (metodo) {
          MetodoSplit.igual      => ('Igual', Icons.balance),
          MetodoSplit.exacto     => ('Exacto', Icons.attach_money),
          MetodoSplit.porcentaje => ('Porcent.', Icons.percent),
        };

        return Expanded(
          child: GestureDetector(
            onTap: () => onCambio(metodo),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: estaSeleccionado ? kColorPrimario : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Icon(icono,
                      color: estaSeleccionado ? Colors.white : Colors.grey,
                      size: 20),
                  const SizedBox(height: 4),
                  Text(label,
                      style: TextStyle(
                        fontSize: 11,
                        color: estaSeleccionado ? Colors.white : Colors.grey,
                      )),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

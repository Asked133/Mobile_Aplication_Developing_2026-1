// chip de categoría para seleccionar en el formulario de gasto
// muestra un grid de categorías con emoji y nombre
import 'package:flutter/material.dart';
import '../models/gasto.dart';
import '../utils/constantes.dart';

class CategoriaChipWidget extends StatelessWidget {
  final String categoriaSeleccionada;
  final ValueChanged<String> onSeleccionar;

  const CategoriaChipWidget({
    super.key,
    required this.categoriaSeleccionada,
    required this.onSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: kCategorias.map((cat) {
        final id = cat['id'] as String;
        final estaSeleccionada = id == categoriaSeleccionada;

        return GestureDetector(
          onTap: () => onSeleccionar(id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: estaSeleccionada ? kColorPrimario : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              border: estaSeleccionada
                  ? null
                  : Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(cat['emoji'] as String, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 4),
                Text(
                  cat['nombre'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: estaSeleccionada ? Colors.white : Colors.grey.shade700,
                    fontWeight: estaSeleccionada ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

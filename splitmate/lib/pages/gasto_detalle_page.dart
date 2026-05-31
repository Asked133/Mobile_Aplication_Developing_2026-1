// lib/pages/gasto_detalle_page.dart
// vista de detalle de un gasto con opción de eliminar
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/mock_data.dart';
import '../models/gasto.dart';
import '../services/firebase_service.dart';
import '../widgets/avatar_iniciales_widget.dart';

class GastoDetallePage extends StatelessWidget {
  const GastoDetallePage({super.key});

  @override
  Widget build(BuildContext context) {
    // recibe el gasto como argumento
    final gasto = ModalRoute.of(context)!.settings.arguments as Gasto;
    final uid = FirebaseService.instance.usuarioActual?.uid ?? 'user1';
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final dateFormatter = DateFormat('dd MMMM yyyy', 'es');

    // busca datos del que pagó
    final quienPago = MockData.buscarUsuario(gasto.pagadoPor);

    // busca emoji de la categoría
    final categoria = kCategorias.firstWhere(
      (c) => c['id'] == gasto.categoria,
      orElse: () => {'emoji': '📋', 'nombre': 'Otro'},
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del gasto'),
        actions: [
          // botón eliminar solo si el usuario creó el gasto
          if (gasto.creadoPor == uid)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              onPressed: () => _confirmarEliminar(context, gasto),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // header con emoji y monto
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(categoria['emoji'] as String,
                      style: const TextStyle(fontSize: 48)),
                  const SizedBox(height: 8),
                  Text(
                    gasto.descripcion,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatter.format(gasto.monto),
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // tarjeta: quién pagó
            Card(
              color: Colors.white,
              child: ListTile(
                leading: AvatarInicialesWidget(
                  nombre: quienPago?.nombre ?? '?',
                  radio: 22,
                ),
                title: const Text('Pagado por', style: TextStyle(fontSize: 12, color: Colors.grey)),
                subtitle: Text(
                  quienPago?.nombre ?? 'Alguien',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // tarjeta: división del gasto
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('División del gasto',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 8),
                    // lista de cada persona y cuánto debe
                    ...gasto.divididoEntre.map((div) {
                      final usuario = MockData.buscarUsuario(div.uid);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            AvatarInicialesWidget(
                              nombre: usuario?.nombre ?? '?',
                              radio: 14,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(usuario?.nombre ?? 'Desconocido',
                                  style: const TextStyle(fontSize: 14)),
                            ),
                            Text(
                              formatter.format(div.monto),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // tarjeta: detalles adicionales
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _detalleRow('Fecha', dateFormatter.format(gasto.fecha)),
                    _detalleRow('Categoría',
                        '${categoria['emoji']} ${categoria['nombre']}'),
                    if (gasto.notas != null && gasto.notas!.isNotEmpty)
                      _detalleRow('Notas', gasto.notas!),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // fila de detalle con label y valor
  Widget _detalleRow(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ),
          Expanded(
            child: Text(valor, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  // diálogo de confirmación para eliminar el gasto
  void _confirmarEliminar(BuildContext context, Gasto gasto) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Eliminar gasto?'),
        content: Text('Se eliminará "${gasto.descripcion}" permanentemente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await FirebaseService.instance
                  .eliminarGasto(gasto.grupoId, gasto.id);
              if (!context.mounted) return;
              Navigator.pop(context); // cierra diálogo
              Navigator.pop(context); // regresa a la lista
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Gasto eliminado'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

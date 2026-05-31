class Venta {
  final String id;
  final String producto;
  final int cantidad;
  final double total;
  final String fecha;
  final String metodoPago;
  final String empleado;

  const Venta({
    required this.id,
    required this.producto,
    required this.cantidad,
    required this.total,
    required this.fecha,
    required this.metodoPago,
    required this.empleado,
  });
}

class Empleado {
  final String id;
  final String nombre;
  final String puesto;
  final String turno;
  final String telefono;
  final String email;
  final String fechaIngreso;
  final double salario;
  final bool activo;

  const Empleado({
    required this.id,
    required this.nombre,
    required this.puesto,
    required this.turno,
    required this.telefono,
    required this.email,
    required this.fechaIngreso,
    required this.salario,
    this.activo = true,
  });
}

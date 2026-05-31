class Cliente {
  final String id;
  final String nombre;
  final String telefono;
  final String email;
  final int puntos;
  final String nivel;
  final String fechaRegistro;
  final double totalCompras;

  const Cliente({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.email,
    required this.puntos,
    required this.nivel,
    required this.fechaRegistro,
    required this.totalCompras,
  });
}

class Proveedor {
  final String id;
  final String nombre;
  final String contacto;
  final String telefono;
  final String email;
  final String categoria;
  final String direccion;
  final bool activo;

  const Proveedor({
    required this.id,
    required this.nombre,
    required this.contacto,
    required this.telefono,
    required this.email,
    required this.categoria,
    required this.direccion,
    this.activo = true,
  });
}

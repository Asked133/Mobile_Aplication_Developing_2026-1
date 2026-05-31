// modelo de grupo — un grupo de amigos que comparten gastos
class Grupo {
  final String id;
  final String nombre;
  final String? descripcion;
  final List<String> miembrosUid;
  final String creadoPor;
  final String moneda;
  final DateTime creadoEn;

  const Grupo({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.miembrosUid,
    required this.creadoPor,
    this.moneda = 'MXN',
    required this.creadoEn,
  });

  // cuántos miembros tiene el grupo
  int get totalMiembros => miembrosUid.length;

  // verifica si un usuario es miembro del grupo
  bool esMiembro(String uid) => miembrosUid.contains(uid);

  // convierte un documento de Firestore a Grupo
  factory Grupo.fromMap(String id, Map<String, dynamic> map) {
    return Grupo(
      id: id,
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'],
      miembrosUid: List<String>.from(map['miembrosUid'] ?? []),
      creadoPor: map['creadoPor'] ?? '',
      moneda: map['moneda'] ?? 'MXN',
      creadoEn: (map['creadoEn'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  // convierte a mapa para guardar en Firestore
  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'descripcion': descripcion,
    'miembrosUid': miembrosUid,
    'creadoPor': creadoPor,
    'moneda': moneda,
    'creadoEn': creadoEn,
  };
}

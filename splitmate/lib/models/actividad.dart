// modelo de actividad — registro de acciones en un grupo (gasto agregado, deuda saldada, etc.)
class Actividad {
  final String id;
  final String grupoId;
  final String tipo; // 'gasto_agregado', 'deuda_saldada', 'miembro_agregado'
  final String descripcion;
  final double? monto;
  final String actorUid;
  final DateTime creadoEn;

  const Actividad({
    required this.id,
    required this.grupoId,
    required this.tipo,
    required this.descripcion,
    this.monto,
    required this.actorUid,
    required this.creadoEn,
  });

  // emoji según el tipo de actividad
  String get emoji => switch (tipo) {
    'gasto_agregado'   => '💸',
    'deuda_saldada'    => '✅',
    'miembro_agregado' => '👋',
    _                  => '📋',
  };

  // convierte un documento de Firestore a Actividad
  factory Actividad.fromMap(String id, Map<String, dynamic> map) {
    return Actividad(
      id: id,
      grupoId: map['grupoId'] ?? '',
      tipo: map['tipo'] ?? '',
      descripcion: map['descripcion'] ?? '',
      monto: map['monto'] != null ? (map['monto'] as num).toDouble() : null,
      actorUid: map['actorUid'] ?? '',
      creadoEn: (map['creadoEn'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  // convierte a mapa para guardar en Firestore
  Map<String, dynamic> toMap() => {
    'grupoId': grupoId,
    'tipo': tipo,
    'descripcion': descripcion,
    'monto': monto,
    'actorUid': actorUid,
    'creadoEn': creadoEn,
  };
}

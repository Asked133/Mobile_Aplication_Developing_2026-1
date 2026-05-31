// modelo de gasto — un gasto registrado dentro de un grupo

// detalle de cómo se divide el gasto para cada persona
class DetallesDivision {
  final String uid;
  final double monto;

  const DetallesDivision({required this.uid, required this.monto});

  factory DetallesDivision.fromMap(Map<String, dynamic> map) =>
      DetallesDivision(uid: map['uid'], monto: (map['monto'] as num).toDouble());

  Map<String, dynamic> toMap() => {'uid': uid, 'monto': monto};
}

class Gasto {
  final String id;
  final String grupoId;
  final String descripcion;
  final double monto;
  final String pagadoPor;   // uid del que pagó
  final List<DetallesDivision> divididoEntre;
  final String categoria;   // comida, transporte, etc.
  final DateTime fecha;
  final String? notas;
  final String creadoPor;

  const Gasto({
    required this.id,
    required this.grupoId,
    required this.descripcion,
    required this.monto,
    required this.pagadoPor,
    required this.divididoEntre,
    required this.categoria,
    required this.fecha,
    this.notas,
    required this.creadoPor,
  });

  // cuánto debe pagar un usuario específico en este gasto
  double montoParaUsuario(String uid) {
    try {
      return divididoEntre.firstWhere((d) => d.uid == uid).monto;
    } catch (_) {
      return 0.0;
    }
  }

  // convierte un documento de Firestore a Gasto
  factory Gasto.fromMap(String id, Map<String, dynamic> map) {
    return Gasto(
      id: id,
      grupoId: map['grupoId'] ?? '',
      descripcion: map['descripcion'] ?? '',
      monto: (map['monto'] as num).toDouble(),
      pagadoPor: map['pagadoPor'] ?? '',
      divididoEntre: (map['divididoEntre'] as List? ?? [])
          .map((d) => DetallesDivision.fromMap(Map<String, dynamic>.from(d)))
          .toList(),
      categoria: map['categoria'] ?? 'otro',
      fecha: (map['fecha'] as dynamic)?.toDate() ?? DateTime.now(),
      notas: map['notas'],
      creadoPor: map['creadoPor'] ?? '',
    );
  }

  // convierte a mapa para guardar en Firestore
  Map<String, dynamic> toMap() => {
    'grupoId': grupoId,
    'descripcion': descripcion,
    'monto': monto,
    'pagadoPor': pagadoPor,
    'divididoEntre': divididoEntre.map((d) => d.toMap()).toList(),
    'categoria': categoria,
    'fecha': fecha,
    'notas': notas,
    'creadoPor': creadoPor,
  };
}

// categorías disponibles para clasificar gastos
const List<Map<String, dynamic>> kCategorias = [
  {'id': 'comida',         'nombre': 'Comida',    'emoji': '🍽️'},
  {'id': 'transporte',     'nombre': 'Transporte', 'emoji': '🚗'},
  {'id': 'hospedaje',      'nombre': 'Hospedaje',  'emoji': '🏠'},
  {'id': 'entretenimiento','nombre': 'Entret.',    'emoji': '🎭'},
  {'id': 'compras',        'nombre': 'Compras',    'emoji': '🛍️'},
  {'id': 'salud',          'nombre': 'Salud',      'emoji': '💊'},
  {'id': 'servicios',      'nombre': 'Servicios',  'emoji': '⚡'},
  {'id': 'otro',           'nombre': 'Otro',       'emoji': '📋'},
];

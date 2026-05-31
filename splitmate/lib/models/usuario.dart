// modelo de usuario — representa a cada persona que usa la app
class Usuario {
  final String uid;
  final String nombre;
  final String email;
  final String? fotoUrl;
  final String? tokenFcm;

  const Usuario({
    required this.uid,
    required this.nombre,
    required this.email,
    this.fotoUrl,
    this.tokenFcm,
  });

  // iniciales para el avatar (ej: "Carlos López" → "CL")
  String get iniciales {
    final partes = nombre.trim().split(' ');
    if (partes.length >= 2) return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
    return nombre.isNotEmpty ? nombre[0].toUpperCase() : '?';
  }

  // convierte un documento de Firestore a Usuario
  factory Usuario.fromMap(String uid, Map<String, dynamic> map) {
    return Usuario(
      uid: uid,
      nombre: map['nombre'] ?? '',
      email: map['email'] ?? '',
      fotoUrl: map['fotoUrl'],
      tokenFcm: map['tokenFcm'],
    );
  }

  // convierte a mapa para guardar en Firestore
  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'email': email,
    'fotoUrl': fotoUrl,
    'tokenFcm': tokenFcm,
  };
}

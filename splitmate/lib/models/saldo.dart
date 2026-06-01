// lib/models/saldo.dart
// modelo de saldo — representa un pago registrado entre dos usuarios
class Saldo {
  final String id;
  final String deudorUid;
  final String acreedorUid;
  final double monto;
  final String? nota;
  final DateTime saldadoEn;

  const Saldo({
    required this.id,
    required this.deudorUid,
    required this.acreedorUid,
    required this.monto,
    this.nota,
    required this.saldadoEn,
  });

  // convierte un documento de Firestore a Saldo
  factory Saldo.fromMap(String id, Map<String, dynamic> map) {
    return Saldo(
      id: id,
      deudorUid: map['deudorUid'] ?? '',
      acreedorUid: map['acreedorUid'] ?? '',
      monto: (map['monto'] ?? 0).toDouble(),
      nota: map['nota'],
      saldadoEn: (map['saldadoEn'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  // convierte a mapa para guardar en Firestore
  Map<String, dynamic> toMap() => {
    'deudorUid': deudorUid,
    'acreedorUid': acreedorUid,
    'monto': monto,
    'nota': nota,
    'saldadoEn': saldadoEn,
  };
}

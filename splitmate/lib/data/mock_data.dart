// lib/data/mock_data.dart
// datos de prueba para desarrollo — se reemplazan con Firebase en producción
import '../models/usuario.dart';
import '../models/grupo.dart';
import '../models/gasto.dart';
import '../models/balance.dart';
import '../models/actividad.dart';

class MockData {
  // usuario simulado (el que está "logueado")
  static final Usuario usuarioActual = Usuario(
    uid: 'user1',
    nombre: 'Carlos López',
    email: 'carlos@gmail.com',
  );

  // todos los usuarios de prueba
  static final List<Usuario> usuarios = [
    Usuario(uid: 'user1', nombre: 'Carlos López',      email: 'carlos@gmail.com'),
    Usuario(uid: 'user2', nombre: 'María García',      email: 'maria@gmail.com'),
    Usuario(uid: 'user3', nombre: 'Ana Martínez',      email: 'ana@gmail.com'),
    Usuario(uid: 'user4', nombre: 'Roberto Hernández', email: 'roberto@gmail.com'),
  ];

  // grupos de ejemplo
  static final List<Grupo> grupos = [
    Grupo(
      id: 'g1',
      nombre: 'Depa Universitario',
      descripcion: 'Gastos del departamento',
      miembrosUid: ['user1', 'user2', 'user3'],
      creadoPor: 'user1',
      creadoEn: DateTime(2026, 1, 10),
    ),
    Grupo(
      id: 'g2',
      nombre: 'Viaje Cancún',
      descripcion: 'Vacaciones de semana santa',
      miembrosUid: ['user1', 'user2', 'user3', 'user4'],
      creadoPor: 'user2',
      creadoEn: DateTime(2026, 2, 5),
    ),
    Grupo(
      id: 'g3',
      nombre: 'Salida del viernes',
      descripcion: 'Cena y antro',
      miembrosUid: ['user1', 'user4'],
      creadoPor: 'user1',
      creadoEn: DateTime(2026, 3, 1),
    ),
  ];

  // gastos del grupo "Depa Universitario"
  static final List<Gasto> gastosG1 = [
    Gasto(
      id: 'gas1', grupoId: 'g1', descripcion: 'Renta de marzo',
      monto: 9000.0, pagadoPor: 'user1', categoria: 'servicios',
      fecha: DateTime(2026, 3, 1), creadoPor: 'user1',
      divididoEntre: [
        DetallesDivision(uid: 'user1', monto: 3000.0),
        DetallesDivision(uid: 'user2', monto: 3000.0),
        DetallesDivision(uid: 'user3', monto: 3000.0),
      ],
    ),
    Gasto(
      id: 'gas2', grupoId: 'g1', descripcion: 'Mandado del súper',
      monto: 1240.0, pagadoPor: 'user2', categoria: 'comida',
      fecha: DateTime(2026, 3, 8), creadoPor: 'user2',
      divididoEntre: [
        DetallesDivision(uid: 'user1', monto: 413.33),
        DetallesDivision(uid: 'user2', monto: 413.33),
        DetallesDivision(uid: 'user3', monto: 413.34),
      ],
    ),
    Gasto(
      id: 'gas3', grupoId: 'g1', descripcion: 'Internet Telmex',
      monto: 540.0, pagadoPor: 'user3', categoria: 'servicios',
      fecha: DateTime(2026, 3, 15), creadoPor: 'user3',
      divididoEntre: [
        DetallesDivision(uid: 'user1', monto: 180.0),
        DetallesDivision(uid: 'user2', monto: 180.0),
        DetallesDivision(uid: 'user3', monto: 180.0),
      ],
    ),
  ];

  // gastos del grupo "Viaje Cancún"
  static final List<Gasto> gastosG2 = [
    Gasto(
      id: 'gas4', grupoId: 'g2', descripcion: 'Hotel Cancún 3 noches',
      monto: 12000.0, pagadoPor: 'user1', categoria: 'hospedaje',
      fecha: DateTime(2026, 4, 1), creadoPor: 'user1',
      divididoEntre: [
        DetallesDivision(uid: 'user1', monto: 3000.0),
        DetallesDivision(uid: 'user2', monto: 3000.0),
        DetallesDivision(uid: 'user3', monto: 3000.0),
        DetallesDivision(uid: 'user4', monto: 3000.0),
      ],
    ),
    Gasto(
      id: 'gas5', grupoId: 'g2', descripcion: 'Vuelos de ida',
      monto: 8400.0, pagadoPor: 'user2', categoria: 'transporte',
      fecha: DateTime(2026, 3, 20), creadoPor: 'user2',
      divididoEntre: [
        DetallesDivision(uid: 'user1', monto: 2100.0),
        DetallesDivision(uid: 'user2', monto: 2100.0),
        DetallesDivision(uid: 'user3', monto: 2100.0),
        DetallesDivision(uid: 'user4', monto: 2100.0),
      ],
    ),
    Gasto(
      id: 'gas6', grupoId: 'g2', descripcion: 'Cena mariscos',
      monto: 2200.0, pagadoPor: 'user4', categoria: 'comida',
      fecha: DateTime(2026, 4, 2), creadoPor: 'user4',
      divididoEntre: [
        DetallesDivision(uid: 'user1', monto: 550.0),
        DetallesDivision(uid: 'user2', monto: 550.0),
        DetallesDivision(uid: 'user3', monto: 550.0),
        DetallesDivision(uid: 'user4', monto: 550.0),
      ],
    ),
  ];

  // actividades de ejemplo
  static final List<Actividad> actividades = [
    Actividad(
      id: 'act1', grupoId: 'g1', tipo: 'gasto_agregado',
      descripcion: 'Renta de marzo — \$9,000.00', monto: 9000.0,
      actorUid: 'user1', creadoEn: DateTime(2026, 3, 1),
    ),
    Actividad(
      id: 'act2', grupoId: 'g1', tipo: 'gasto_agregado',
      descripcion: 'Mandado del súper — \$1,240.00', monto: 1240.0,
      actorUid: 'user2', creadoEn: DateTime(2026, 3, 8),
    ),
    Actividad(
      id: 'act3', grupoId: 'g2', tipo: 'gasto_agregado',
      descripcion: 'Hotel Cancún 3 noches — \$12,000.00', monto: 12000.0,
      actorUid: 'user1', creadoEn: DateTime(2026, 4, 1),
    ),
  ];

  // obtiene los gastos de un grupo por id
  static List<Gasto> gastosDeGrupo(String grupoId) {
    return switch (grupoId) {
      'g1' => gastosG1,
      'g2' => gastosG2,
      _    => [],
    };
  }

  // busca un usuario por uid en los datos de prueba
  static Usuario? buscarUsuario(String uid) {
    try {
      return usuarios.firstWhere((u) => u.uid == uid);
    } catch (_) {
      return null;
    }
  }

  // obtiene actividades de un grupo específico
  static List<Actividad> actividadesDeGrupo(String grupoId) {
    return actividades.where((a) => a.grupoId == grupoId).toList();
  }

  // calcula cuánto debe/le deben al usuario actual en total (todos los grupos)
  static double balanceGeneralUsuario(String uid) {
    double total = 0;
    for (final grupo in grupos) {
      if (!grupo.esMiembro(uid)) continue;
      final balances = CalculadorBalances.calcular(
        gastosDeGrupo(grupo.id), grupoId: grupo.id,
      );
      for (final b in balances) {
        if (b.acreedorUid == uid) total += b.monto;   // te deben
        if (b.deudorUid   == uid) total -= b.monto;   // debes
      }
    }
    return total;
  }
}

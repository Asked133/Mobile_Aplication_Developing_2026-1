// lib/services/firebase_service.dart
// todas las llamadas a Firebase Auth y Firestore pasan por aquí
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/usuario.dart';
import '../models/grupo.dart';
import '../models/gasto.dart';
import '../models/actividad.dart';
import '../models/saldo.dart';

class FirebaseService {
  // singleton igual que en parcial1
  static final FirebaseService instance = FirebaseService._();
  FirebaseService._();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // Instancia de GoogleSignIn con el Web Client ID para soporte en navegador
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? '495738642957-529jfac2o3t7aqidcp9dikl7drla7fjq.apps.googleusercontent.com'
        : null,
  );

  // caché local de usuarios para evitar lecturas repetitivas a Firestore
  final Map<String, Usuario> _usuariosCache = {};

  // ─── AUTH ─────────────────────────────────────────────────────────────────

  // referencia al usuario logueado actualmente
  User? get usuarioActual => _auth.currentUser;

  // verifica si hay sesión activa
  bool get estaLogueado => _auth.currentUser != null;

  // stream de cambios de sesión (login/logout)
  Stream<User?> get cambiosAuth => _auth.authStateChanges();

  // login con email y contraseña
  Future<String?> loginEmail(String email, String contrasena) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: contrasena,
      );
      return null; // null = éxito
    } on FirebaseAuthException catch (e) {
      return _mensajeError(e.code);
    }
  }

  // registro con email — crea cuenta en Auth y perfil en Firestore
  Future<String?> registrarEmail(
    String nombre,
    String email,
    String contrasena,
  ) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: contrasena,
      );
      // guarda el perfil en Firestore
      await _db.collection('usuarios').doc(cred.user!.uid).set({
        'nombre': nombre,
        'email': email,
        'creadoEn': FieldValue.serverTimestamp(),
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return _mensajeError(e.code);
    }
  }

  // login con Google — crea perfil si es la primera vez
  Future<String?> loginGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return 'Cancelado por el usuario';
      final gAuth = await googleUser.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      final result = await _auth.signInWithCredential(cred);
      // si es la primera vez, crea el perfil en Firestore
      final doc = await _db.collection('usuarios').doc(result.user!.uid).get();
      if (!doc.exists) {
        await _db.collection('usuarios').doc(result.user!.uid).set({
          'nombre': result.user!.displayName ?? 'Sin nombre',
          'email': result.user!.email ?? '',
          'fotoUrl': result.user!.photoURL,
          'creadoEn': FieldValue.serverTimestamp(),
        });
      }
      return null;
    } catch (_) {
      return 'Error al iniciar sesión con Google';
    }
  }

  // cierra sesión de Firebase y Google
  Future<void> cerrarSesion() async {
    try {
      final isGoogle =
          usuarioActual?.providerData.any(
            (p) => p.providerId == 'google.com',
          ) ??
          false;
      if (isGoogle) {
        await _googleSignIn.signOut();
      }
    } catch (_) {}
    await _auth.signOut();
  }

  // ─── USUARIOS ─────────────────────────────────────────────────────────────

  // obtiene el perfil de un usuario por uid
  Future<Usuario?> obtenerUsuario(String uid) async {
    final doc = await _db.collection('usuarios').doc(uid).get();
    if (!doc.exists) return null;
    final usuario = Usuario.fromMap(uid, doc.data()!);
    _usuariosCache[uid] = usuario;
    return usuario;
  }

  // obtiene el perfil de un usuario del caché o de Firestore si no existe
  Future<Usuario?> obtenerUsuarioCacheado(String uid) async {
    if (_usuariosCache.containsKey(uid)) return _usuariosCache[uid];
    return await obtenerUsuario(uid);
  }

  // busca usuario por email (para agregar a grupo)
  Future<Usuario?> buscarPorEmail(String email) async {
    final query = await _db
        .collection('usuarios')
        .where('email', isEqualTo: email.trim().toLowerCase())
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;
    return Usuario.fromMap(query.docs.first.id, query.docs.first.data());
  }

  // actualiza el token FCM del usuario para notificaciones push
  Future<void> actualizarTokenFcm(String token) async {
    final uid = usuarioActual?.uid;
    if (uid == null) return;
    await _db.collection('usuarios').doc(uid).update({'tokenFcm': token});
  }

  // ─── GRUPOS ───────────────────────────────────────────────────────────────

  // stream en tiempo real de los grupos del usuario
  Stream<List<Grupo>> streamGruposUsuario(String uid) {
    return _db
        .collection('grupos')
        .where('miembrosUid', arrayContains: uid)
        .orderBy('creadoEn', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => Grupo.fromMap(d.id, d.data())).toList(),
        );
  }

  // crea un nuevo grupo con el creador como primer miembro y resuelve los emails a UIDs
  Future<String?> crearGrupo({
    required String nombre,
    String? descripcion,
    required String creadoPor,
    String moneda = 'MXN',
    List<String> emailsMiembros = const [],
  }) async {
    try {
      List<String> miembrosUid = [creadoPor];

      // Busca a los usuarios por email y los agrega a la lista de UIDs si existen
      for (final email in emailsMiembros) {
        final usuario = await buscarPorEmail(email);
        if (usuario != null && !miembrosUid.contains(usuario.uid)) {
          miembrosUid.add(usuario.uid);
        }
      }

      await _db.collection('grupos').add({
        'nombre': nombre,
        'descripcion': descripcion,
        'miembrosUid': miembrosUid,
        'creadoPor': creadoPor,
        'moneda': moneda,
        'creadoEn': FieldValue.serverTimestamp(),
      });
      return null;
    } catch (e) {
      return 'Error al crear el grupo';
    }
  }

  // agrega un miembro al grupo buscándolo por email
  Future<String?> agregarMiembroPorEmail({
    required String grupoId,
    required String email,
  }) async {
    final usuario = await buscarPorEmail(email);
    if (usuario == null) return 'No se encontró ningún usuario con ese email';
    await _db.collection('grupos').doc(grupoId).update({
      'miembrosUid': FieldValue.arrayUnion([usuario.uid]),
    });
    return null;
  }

  // obtiene los datos de un grupo por id
  Future<Grupo?> obtenerGrupo(String grupoId) async {
    final doc = await _db.collection('grupos').doc(grupoId).get();
    if (!doc.exists) return null;
    return Grupo.fromMap(grupoId, doc.data()!);
  }

  // ─── GASTOS ───────────────────────────────────────────────────────────────

  // stream de los gastos de un grupo (tiempo real)
  Stream<List<Gasto>> streamGastosGrupo(String grupoId) {
    return _db
        .collection('grupos')
        .doc(grupoId)
        .collection('gastos')
        .orderBy('fecha', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => Gasto.fromMap(d.id, d.data())).toList(),
        );
  }

  // agrega un gasto al grupo y registra la actividad
  Future<String?> agregarGasto(Gasto gasto) async {
    try {
      await _db
          .collection('grupos')
          .doc(gasto.grupoId)
          .collection('gastos')
          .add(gasto.toMap());

      // registra la actividad del gasto
      await _registrarActividad(
        grupoId: gasto.grupoId,
        tipo: 'gasto_agregado',
        descripcion:
            '${gasto.descripcion} — \$${gasto.monto.toStringAsFixed(2)}',
        monto: gasto.monto,
        actorUid: gasto.creadoPor,
      );
      return null;
    } catch (_) {
      return 'Error al guardar el gasto';
    }
  }

  // elimina un gasto del grupo
  Future<void> eliminarGasto(String grupoId, String gastoId) async {
    await _db
        .collection('grupos')
        .doc(grupoId)
        .collection('gastos')
        .doc(gastoId)
        .delete();
  }

  // ─── SALDOS ───────────────────────────────────────────────────────────────

  // stream de los saldos (pagos) de un grupo
  Stream<List<Saldo>> streamSaldosGrupo(String grupoId) {
    return _db
        .collection('grupos')
        .doc(grupoId)
        .collection('saldos')
        .orderBy('saldadoEn', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => Saldo.fromMap(d.id, d.data())).toList(),
        );
  }

  // registra que se saldó una deuda entre dos personas
  Future<String?> saldarDeuda({
    required String grupoId,
    required String deudorUid,
    required String acreedorUid,
    required double monto,
    String? nota,
  }) async {
    try {
      await _db.collection('grupos').doc(grupoId).collection('saldos').add({
        'deudorUid': deudorUid,
        'acreedorUid': acreedorUid,
        'monto': monto,
        'nota': nota,
        'saldadoEn': FieldValue.serverTimestamp(),
      });
      // registra la actividad del pago
      await _registrarActividad(
        grupoId: grupoId,
        tipo: 'deuda_saldada',
        descripcion: 'Pago de \$${monto.toStringAsFixed(2)} registrado',
        monto: monto,
        actorUid: deudorUid,
      );
      return null;
    } catch (_) {
      return 'Error al registrar el pago';
    }
  }

  // ─── ACTIVIDAD ────────────────────────────────────────────────────────────

  // stream de actividad reciente de un grupo (últimas 30 entradas)
  Stream<List<Actividad>> streamActividadGrupo(String grupoId) {
    return _db
        .collection('grupos')
        .doc(grupoId)
        .collection('actividad')
        .orderBy('creadoEn', descending: true)
        .limit(30)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => Actividad.fromMap(d.id, d.data())).toList(),
        );
  }

  // obtiene la actividad reciente de todos los grupos del usuario
  Future<List<Actividad>> obtenerActividadUsuario(String uid) async {
    final gruposSnap = await _db
        .collection('grupos')
        .where('miembrosUid', arrayContains: uid)
        .get();

    List<Actividad> todasActividades = [];
    for (var doc in gruposSnap.docs) {
      final actSnap = await _db
          .collection('grupos')
          .doc(doc.id)
          .collection('actividad')
          .orderBy('creadoEn', descending: true)
          .limit(20)
          .get();
      todasActividades.addAll(
        actSnap.docs.map((d) => Actividad.fromMap(d.id, d.data())),
      );
    }

    todasActividades.sort((a, b) => b.creadoEn.compareTo(a.creadoEn));
    return todasActividades;
  }

  // registra una actividad internamente (no se llama desde fuera)
  Future<void> _registrarActividad({
    required String grupoId,
    required String tipo,
    required String descripcion,
    double? monto,
    required String actorUid,
  }) async {
    await _db.collection('grupos').doc(grupoId).collection('actividad').add({
      'grupoId': grupoId,
      'tipo': tipo,
      'descripcion': descripcion,
      'monto': monto,
      'actorUid': actorUid,
      'creadoEn': FieldValue.serverTimestamp(),
    });
  }

  // ─── HELPERS ─────────────────────────────────────────────────────────────

  // traduce códigos de error de Firebase a mensajes amigables en español
  String _mensajeError(String code) => switch (code) {
    'user-not-found' => 'No existe una cuenta con ese email',
    'wrong-password' => 'Contraseña incorrecta',
    'email-already-in-use' => 'Ese email ya está registrado',
    'weak-password' => 'La contraseña debe tener al menos 6 caracteres',
    'invalid-email' => 'El email no es válido',
    'invalid-credential' => 'Email o contraseña incorrectos',
    _ => 'Error: $code',
  };
}

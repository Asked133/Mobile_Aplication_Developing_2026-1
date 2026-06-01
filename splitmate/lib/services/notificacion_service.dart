// lib/services/notificacion_service.dart
// maneja notificaciones push (FCM) y locales
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'firebase_service.dart';

// handler para mensajes en background (debe ser función de nivel superior)
@pragma('vm:entry-point')
Future<void> _handlerBackground(RemoteMessage message) async {}

class NotificacionService {
  // singleton
  static final NotificacionService instance = NotificacionService._();
  NotificacionService._();

  final _fcm = FirebaseMessaging.instance;
  final _local = FlutterLocalNotificationsPlugin();

  // canal de notificaciones para Android
  static const _channel = AndroidNotificationChannel(
    'splitmate_channel',
    'SplitMate',
    description: 'Notificaciones de gastos y pagos',
    importance: Importance.high,
  );

  // inicializa FCM + notificaciones locales
  Future<void> inicializar() async {
    if (kIsWeb) return; // Las notificaciones no están configuradas para Web

    // solicitar permiso en iOS
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // registrar handler background
    FirebaseMessaging.onBackgroundMessage(_handlerBackground);

    // configurar notificaciones locales
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    await _local.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );

    // crear canal en Android
    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // escuchar mensajes mientras la app está abierta (foreground)
    FirebaseMessaging.onMessage.listen((msg) {
      final notif = msg.notification;
      if (notif == null) return;
      _local.show(
        notif.hashCode,
        notif.title,
        notif.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    });

    // obtener y guardar el token FCM en Firestore
    final token = await _fcm.getToken();
    if (token != null) await FirebaseService.instance.actualizarTokenFcm(token);
    // actualizar token cuando se renueve
    _fcm.onTokenRefresh.listen(FirebaseService.instance.actualizarTokenFcm);
  }

  // muestra una notificación local inmediata (ej: al agregar un gasto)
  Future<void> mostrarNotificacion({
    required String titulo,
    required String cuerpo,
  }) async {
    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      titulo,
      cuerpo,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(presentAlert: true),
      ),
    );
  }
}

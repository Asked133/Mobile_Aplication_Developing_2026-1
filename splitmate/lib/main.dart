// lib/main.dart
// punto de entrada de SplitMate — inicializa Firebase, notificaciones y configura rutas
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

import 'pages/login_page.dart';
import 'pages/registro_page.dart';
import 'pages/home_page.dart';
import 'pages/crear_grupo_page.dart';
import 'pages/grupo_detalle_page.dart';
import 'pages/agregar_gasto_page.dart';
import 'pages/gasto_detalle_page.dart';
import 'pages/balances_page.dart';
import 'pages/saldar_page.dart';
import 'pages/actividad_page.dart';
import 'pages/perfil_page.dart';
import 'services/notificacion_service.dart';
import 'services/firebase_service.dart';
import 'utils/constantes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // inicializa Firebase con la configuración del proyecto
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificacionService.instance.inicializar();

  runApp(const SplitMateApp());
}

class SplitMateApp extends StatelessWidget {
  const SplitMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SplitMate',
      debugShowCheckedModeBanner: false,

      // localización en español
      locale: const Locale('es', 'MX'),
      supportedLocales: const [
        Locale('es', 'MX'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // tema principal de la app
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: kColorPrimario),
        appBarTheme: const AppBarTheme(
          backgroundColor: kColorPrimario,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: kColorPrimario,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: kColorFondo,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorPrimario,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),

      // ruta inicial basada en si hay sesión activa
      initialRoute: FirebaseService.instance.estaLogueado ? '/home' : '/login',

      // rutas nombradas para las 11 páginas
      routes: {
        '/login':         (_) => const LoginPage(),
        '/registro':      (_) => const RegistroPage(),
        '/home':          (_) => const HomePage(),
        '/crear-grupo':   (_) => const CrearGrupoPage(),
        '/grupo-detalle': (_) => const GrupoDetallePage(),
        '/agregar-gasto': (_) => const AgregarGastoPage(),
        '/gasto-detalle': (_) => const GastoDetallePage(),
        '/balances':      (_) => const BalancesPage(),
        '/saldar':        (_) => const SaldarPage(),
        '/actividad':     (_) => const ActividadPage(),
        '/perfil':        (_) => const PerfilPage(),
      },
    );
  }
}

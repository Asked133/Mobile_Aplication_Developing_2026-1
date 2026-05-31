import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:parcial1/pages/login_page.dart';
import 'package:parcial1/pages/dashboard_page.dart';
import 'package:parcial1/pages/inventario_page.dart';
import 'package:parcial1/pages/producto_detalle_page.dart';
import 'package:parcial1/pages/ventas_page.dart';
import 'package:parcial1/pages/nueva_venta_page.dart';
import 'package:parcial1/pages/empleados_page.dart';
import 'package:parcial1/pages/empleado_detalle_page.dart';
import 'package:parcial1/pages/proveedores_page.dart';
import 'package:parcial1/pages/clientes_page.dart';
import 'package:parcial1/pages/configuracion_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OXXO Admin',
      debugShowCheckedModeBanner: false,
      locale: const Locale('es', 'ES'),
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFE87722),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFE87722),
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => LoginPage(),
        '/dashboard': (_) => DashboardPage(),
        '/inventario': (_) => InventarioPage(),
        '/producto-detalle': (_) => ProductoDetallePage(),
        '/ventas': (_) => VentasPage(),
        '/nueva-venta': (_) => NuevaVentaPage(),
        '/empleados': (_) => EmpleadosPage(),
        '/empleado-detalle': (_) => EmpleadoDetallePage(),
        '/proveedores': (_) => ProveedoresPage(),
        '/clientes': (_) => ClientesPage(),
        '/configuracion': (_) => ConfiguracionPage(),
      },
    );
  }
}
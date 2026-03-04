import 'package:flutter/material.dart';
import 'package:parcial1/pages/form_page.dart';
import 'package:parcial1/pages/home_page.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage(),
        '/form': (context) => FormPage(),
      },
    );
  }
}
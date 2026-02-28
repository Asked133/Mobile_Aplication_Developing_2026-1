import 'package:flutter/material.dart';
import 'package:widgets_basicos/pages/basic_design_page.dart';
import 'package:widgets_basicos/pages/form_page.dart';
import 'package:widgets_basicos/pages/home_page.dart';
import 'package:widgets_basicos/pages/scroll_page.dart';
import 'package:widgets_basicos/pages/table_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/form_page',
      routes: {
        '/scroll_page': (BuildContext context) =>  ScrollPage(),
        '/': (BuildContext context) =>  HomePage(),
        '/basic_design': (BuildContext context) =>  BasicDesignPage(),
        '/table_page': (BuildContext context) =>  TablePage(),
        '/form_page': (BuildContext context) => FormPage()
      },
    );
  }
}
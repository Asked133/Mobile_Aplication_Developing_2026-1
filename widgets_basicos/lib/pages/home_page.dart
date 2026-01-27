import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final pokemones = [
    'Blaziken',
    'Aagron',
    'Charizard',
    'Raichu',
    'Pikachu',
    'Oaxaca',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: ListView(
        children: _crearItems()
      ),
    );
  }

  List<Widget> _crearItems() {
    List<Widget> lista = <Widget>[];
    for (String pokemon in pokemones) {
      final widgetTemp = ListTile(
        title: Text(pokemon),
        subtitle: Text('Pokemon Favoritos'),
        leading: Icon(Icons.catching_pokemon),
        trailing: Icon(Icons.arrow_back_ios_new_sharp),
      );

      lista.add(widgetTemp);
      lista.add(Divider());
    }
    return lista;
  }
}

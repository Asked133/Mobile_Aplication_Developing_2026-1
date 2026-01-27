import 'package:flutter/material.dart';

class ContadorPage extends StatefulWidget {
  const ContadorPage({super.key});

  @override
  State<ContadorPage> createState() => _ContadorPageState();
}

class _ContadorPageState extends State<ContadorPage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contador App", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 135, 59, 241),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Numero de clicks:", style: TextStyle(fontSize: 30)),
            Text("$_counter", style: TextStyle(fontSize: 30)),
          ],
        ),
      ),

      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 30,
            right: 30,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _counter--;
                });
              },
              backgroundColor: Color.fromARGB(255, 69, 0, 148),
              child: Icon(Icons.remove, color: Colors.white, size: 30),
            ),
          ),
          Positioned(
            bottom: 100,
            right: 30,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _counter++;
                });
              },
              backgroundColor: Color.fromARGB(255, 93, 0, 199),
              child: Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),
          Positioned(
            bottom: 170,
            right: 30,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _counter = 0;
                });
              },
              backgroundColor: Color.fromARGB(255, 119, 0, 255),
              child: Icon(Icons.refresh, color: Colors.white, size: 30),
            ),
          )
        ],
      ),

      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
          _counter++;
          print(_counter);
        },
        backgroundColor: Color.fromARGB(255, 122, 7, 253),
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Colors.white, size: 30,),
        ),
      */
        
    );
  }
}

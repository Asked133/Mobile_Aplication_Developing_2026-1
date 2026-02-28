import 'package:flutter/material.dart';

class TableTitle extends StatelessWidget {
  const TableTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20),
      child: Column(
        children: [
          Text("Titulo de la tabla", style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white
          ),),
          Text('Velit anim officia anim dolore.', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
          Text("Tablos en Flutter", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white))

        ],
      ),
    );
  }
}
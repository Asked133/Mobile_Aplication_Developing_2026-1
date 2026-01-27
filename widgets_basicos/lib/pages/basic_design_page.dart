import 'package:flutter/material.dart';

void main() => runApp(const BasicDesignPage());

class BasicDesignPage extends StatelessWidget {
  const BasicDesignPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          //Image(image: NetworkImage('https://i.ytimg.com/vi/h9fg1YgdAMc/hq720.jpg?sqp=-oaymwE7CK4FEIIDSFryq4qpAy0IARUAAAAAGAElAADIQj0AgKJD8AEB-AH-CYAC0AWKAgwIABABGEogWyhlMA8=&rs=AOn4CLDTRLZRAwfjRPaWFsFTGHN3S-QwEQ'),)
          Image(image: AssetImage('gokuSSJ3.webp')),
          Titulo(),
          SeccionBotones(),
        ],
      ),
    );
  }
}

class Titulo extends StatelessWidget {
  const Titulo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                "Hola Mundo 1",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("Hola Mundo 2", style: TextStyle(color: Colors.grey)),
            ],
          ),
          Expanded(child: Container()),
          Icon(Icons.star, color: Colors.red),
          Text("9.5"),
        ],
      ),
    );
  }
}

class SeccionBotones extends StatelessWidget {
  const SeccionBotones({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          BotonPersonalizado(icon: Icons.call, texto: 'Call'),
          BotonPersonalizado(icon: Icons.near_me, texto: 'Route'),
          BotonPersonalizado(icon: Icons.share, texto: 'Share'),
        ],
      ),
    );
  }
}

class BotonPersonalizado extends StatelessWidget {
  final IconData icon;
  final String texto;
  const BotonPersonalizado({
    super.key,
    required this.icon,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(this.icon, color: Colors.blue, size: 28),
        Text(
          this.texto,
          style: const TextStyle(fontSize: 12, color: Colors.blue),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class ScrollPage extends StatelessWidget {
  const ScrollPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: 
          [
            Color.fromARGB(255, 183, 213, 238),
            Color.fromARGB(255, 80, 154, 214),
            Color.fromARGB(255, 171, 0, 250)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          )
        ),
        child: PageView(
          children: [
            Page1(),
            Page2(),
          ],
        ),

      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Background(),
        MainContent()
      ],
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 65, 135, 214),
      child: Center(
        child: TextButton(
          onPressed: (){},
          child: Text('Bienvenido', style: TextStyle(fontSize: 30, color: Colors.white),),
          style: TextButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 7, 63, 218),
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20)
          ),
        ),
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 65, 135, 214),
      height: double.infinity,
      child: Image(image: AssetImage('scroll.png'),),
      alignment: Alignment.topCenter,
    );
  }
}


class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    var text_style = TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white);
    //Mostrar hora actual
    var now = DateTime.now();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 35,),
        Text('${now.hour}:${now.minute}', style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white),),
        Text('Miércoles', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),),
        Expanded(child: Container()),
        Icon(Icons.keyboard_arrow_down, size: 120, color: Colors.white, ),
      ],
    );
  }
}
import 'package:flutter/material.dart';

class CustomBotNavBar extends StatelessWidget {
  const CustomBotNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      showSelectedLabels: true,
      showUnselectedLabels: false,
      currentIndex: 0,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      selectedItemColor: const Color.fromARGB(255, 41, 47, 141),
      unselectedItemColor: const Color.fromARGB(255, 51, 51, 51),

    );
  }
}

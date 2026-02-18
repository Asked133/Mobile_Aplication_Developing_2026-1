import 'package:flutter/material.dart';
import 'package:widgets_basicos/widgets/custom_bottomnavigationbar.dart';
import 'package:widgets_basicos/widgets/table_background.dart';

class TablePage extends StatelessWidget {
  const TablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          TableBackground()
        ],
      ),
      bottomNavigationBar: const CustomBotNavBar(),
    );
  }
}
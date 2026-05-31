import 'package:flutter/material.dart';
import 'package:parcial1/widgets/sidebar_widget.dart';
import 'package:parcial1/widgets/avatar_iniciales_widget.dart';

class ConfiguracionPage extends StatefulWidget {
  const ConfiguracionPage({super.key});
  @override
  State<ConfiguracionPage> createState() => _ConfiguracionPageState();
}

class _ConfiguracionPageState extends State<ConfiguracionPage> {
  bool _notificaciones = true;
  bool _modoOscuro = true;
  bool _alertasStock = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configuración')),
      drawer: SidebarWidget(currentRoute: '/configuracion'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //perfil de usuario
            Card(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    AvatarInicialesWidget(nombre: 'Roberto Hernández', radius: 30),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Roberto Hernández', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Gerente de Tienda', style: TextStyle(color: Colors.grey)),
                        Text('roberto.hdz@oxxo.com', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            //informacion de la tienda
            Text('Tienda', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Card(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(leading: Icon(Icons.store), title: Text('OXXO Chihuahua Centro')),
                  ListTile(leading: Icon(Icons.location_on), title: Text('Av. Juárez #1234, Chihuahua')),
                  ListTile(leading: Icon(Icons.phone), title: Text('(614) 123-4567')),
                  ListTile(leading: Icon(Icons.schedule), title: Text('24 horas')),
                ],
              ),
            ),
            SizedBox(height: 20),

            //switches de preferencias
            Text('Preferencias', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Card(
              color: Colors.white,
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text('Notificaciones'),
                    secondary: Icon(Icons.notifications),
                    value: _notificaciones,
                    activeTrackColor: Color(0xFFE87722),
                    onChanged: (valor) => setState(() => _notificaciones = valor),
                  ),
                  SwitchListTile(
                    title: Text('Modo Oscuro'),
                    secondary: Icon(Icons.dark_mode),
                    value: _modoOscuro,
                    activeTrackColor: Color(0xFFE87722),
                    onChanged: (valor) => setState(() => _modoOscuro = valor),
                  ),
                  SwitchListTile(
                    title: Text('Alertas de Stock Bajo'),
                    secondary: Icon(Icons.warning_amber),
                    value: _alertasStock,
                    activeTrackColor: Color(0xFFE87722),
                    onChanged: (valor) => setState(() => _alertasStock = valor),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            //cerrar sesion
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
                icon: Icon(Icons.logout, color: Colors.red),
                label: Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            SizedBox(height: 12),
            Center(child: Text('OXXO Admin v1.0.0 • © 2026 FEMSA', style: TextStyle(color: Colors.grey, fontSize: 11))),
          ],
        ),
      ),
    );
  }
}

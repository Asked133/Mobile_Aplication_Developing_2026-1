import 'package:flutter/material.dart';

//drawer lateral para navegar entre secciones
class SidebarWidget extends StatelessWidget {
  final String currentRoute;

  const SidebarWidget({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFE87722)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset('assets/2560px-Oxxo_Logo.svg.png', height: 40),
                SizedBox(height: 10),
                Text('OXXO Admin', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Sistema ERP/CRM', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          _menuItem(context, Icons.dashboard, 'Dashboard', '/dashboard'),
          _menuItem(context, Icons.inventory_2, 'Inventario', '/inventario'),
          _menuItem(context, Icons.point_of_sale, 'Ventas', '/ventas'),
          _menuItem(context, Icons.people, 'Empleados', '/empleados'),
          _menuItem(context, Icons.local_shipping, 'Proveedores', '/proveedores'),
          _menuItem(context, Icons.person_search, 'Clientes', '/clientes'),
          Divider(),
          _menuItem(context, Icons.settings, 'Configuración', '/configuracion'),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Cerrar Sesión'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String label, String ruta) {
    final seleccionado = currentRoute == ruta;
    return ListTile(
      leading: Icon(icon, color: seleccionado ? Color(0xFFE87722) : Colors.grey),
      title: Text(label, style: TextStyle(
        color: seleccionado ? Color(0xFFE87722) : Colors.black87,
        fontWeight: seleccionado ? FontWeight.bold : FontWeight.normal,
      )),
      selected: seleccionado,
      onTap: () {
        if (currentRoute != ruta) {
          Navigator.pushReplacementNamed(context, ruta);
        } else {
          Navigator.pop(context);
        }
      },
    );
  }
}

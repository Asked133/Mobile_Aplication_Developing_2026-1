// lib/pages/grupo_detalle_page.dart
// detalle de un grupo con 3 tabs: Gastos, Balances y Actividad
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/mock_data.dart';
import '../models/grupo.dart';
import '../models/gasto.dart';
import '../models/balance.dart';
import '../models/actividad.dart';
import '../models/usuario.dart';
import '../services/firebase_service.dart';
import '../widgets/gasto_card_widget.dart';
import '../widgets/balance_card_widget.dart';

class GrupoDetallePage extends StatefulWidget {
  const GrupoDetallePage({super.key});
  @override
  State<GrupoDetallePage> createState() => _GrupoDetallePageState();
}

class _GrupoDetallePageState extends State<GrupoDetallePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _uid = FirebaseService.instance.usuarioActual?.uid ?? 'user1';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // busca el nombre de un usuario en mock data
  Usuario? _buscarUsuario(String uid) => MockData.buscarUsuario(uid);

  // muestra diálogo para agregar miembro por email
  void _mostrarAgregarMiembro(String grupoId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Agregar miembro'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'Email del nuevo miembro',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final email = controller.text.trim();
              if (email.isEmpty) return;
              final error = await FirebaseService.instance
                  .agregarMiembroPorEmail(grupoId: grupoId, email: email);
              if (!mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(error ?? '¡Miembro agregado!'),
                backgroundColor: error != null ? Colors.red : Colors.green,
              ));
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // recibe el grupo como argumento de navegación
    final grupo = ModalRoute.of(context)!.settings.arguments as Grupo;

    return Scaffold(
      appBar: AppBar(
        title: Text(grupo.nombre),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'Gastos', icon: Icon(Icons.receipt_long, size: 18)),
            Tab(text: 'Balances', icon: Icon(Icons.balance, size: 18)),
            Tab(text: 'Actividad', icon: Icon(Icons.history, size: 18)),
          ],
        ),
        actions: [
          // menú con opciones adicionales
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'balances') {
                Navigator.pushNamed(context, '/balances', arguments: grupo.id);
              } else if (value == 'agregar') {
                _mostrarAgregarMiembro(grupo.id);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'balances', child: Text('Ver balances')),
              const PopupMenuItem(value: 'agregar', child: Text('Agregar miembro')),
            ],
          ),
        ],
      ),
      // FAB para agregar gasto (solo en el tab de gastos)
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/agregar-gasto', arguments: grupo.id),
        child: const Icon(Icons.add),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ─── TAB GASTOS ────────────────────────────────────────────
          _buildTabGastos(grupo),
          // ─── TAB BALANCES ──────────────────────────────────────────
          _buildTabBalances(grupo),
          // ─── TAB ACTIVIDAD ─────────────────────────────────────────
          _buildTabActividad(grupo),
        ],
      ),
    );
  }

  // tab de gastos — lista de gastos del grupo con StreamBuilder
  Widget _buildTabGastos(Grupo grupo) {
    return StreamBuilder<List<Gasto>>(
      stream: FirebaseService.instance.streamGastosGrupo(grupo.id),
      initialData: MockData.gastosDeGrupo(grupo.id),
      builder: (context, snapshot) {
        final gastos = snapshot.data ?? [];

        if (gastos.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 12),
                Text('No hay gastos todavía', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 4),
                Text('Toca + para agregar el primero',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: gastos.length,
          itemBuilder: (context, index) {
            final gasto = gastos[index];
            return GastoCardWidget(
              gasto: gasto,
              quienPago: _buscarUsuario(gasto.pagadoPor),
              uidActual: _uid,
              onTap: () => Navigator.pushNamed(
                context, '/gasto-detalle', arguments: gasto,
              ),
            );
          },
        );
      },
    );
  }

  // tab de balances — calcula y muestra quién le debe a quién
  Widget _buildTabBalances(Grupo grupo) {
    final gastos = MockData.gastosDeGrupo(grupo.id);
    final balances = CalculadorBalances.calcular(gastos, grupoId: grupo.id);

    if (balances.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
            SizedBox(height: 12),
            Text('¡Todos están en paz! 🎉', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: balances.length,
      itemBuilder: (context, index) {
        final balance = balances[index];
        return BalanceCardWidget(
          balance: balance,
          deudor: _buscarUsuario(balance.deudorUid),
          acreedor: _buscarUsuario(balance.acreedorUid),
          uidActual: _uid,
          onSaldar: () => Navigator.pushNamed(
            context, '/saldar',
            arguments: {
              'balance': balance,
              'grupoId': grupo.id,
            },
          ),
        );
      },
    );
  }

  // tab de actividad — timeline de acciones recientes en el grupo
  Widget _buildTabActividad(Grupo grupo) {
    return StreamBuilder<List<Actividad>>(
      stream: FirebaseService.instance.streamActividadGrupo(grupo.id),
      initialData: MockData.actividadesDeGrupo(grupo.id),
      builder: (context, snapshot) {
        final actividades = snapshot.data ?? [];

        if (actividades.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey),
                SizedBox(height: 12),
                Text('Sin actividad reciente', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: actividades.length,
          itemBuilder: (context, index) {
            final act = actividades[index];
            final actor = _buscarUsuario(act.actorUid);
            final formatter = DateFormat('dd/MM/yy HH:mm');

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade100,
                child: Text(act.emoji, style: const TextStyle(fontSize: 20)),
              ),
              title: Text(act.descripcion, style: const TextStyle(fontSize: 13)),
              subtitle: Text(
                '${actor?.nombre ?? 'Alguien'} • ${formatter.format(act.creadoEn)}',
                style: const TextStyle(fontSize: 11),
              ),
            );
          },
        );
      },
    );
  }
}

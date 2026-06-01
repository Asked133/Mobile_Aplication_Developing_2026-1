// lib/pages/home_page.dart
// página principal — muestra balance general y lista de grupos del usuario
// ahora usa datos 100% de Firebase (sin mock data)
import 'package:flutter/material.dart';
import '../models/balance.dart';
import '../models/gasto.dart';
import '../models/grupo.dart';
import '../services/firebase_service.dart';
import '../widgets/grupo_card_widget.dart';
import '../widgets/kpi_balance_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // uid del usuario logueado en Firebase
  final _uid = FirebaseService.instance.usuarioActual!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SplitMate'),
        automaticallyImplyLeading: false,
        actions: [
          // botón de actividad
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.pushNamed(context, '/actividad'),
          ),
          // botón de perfil
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, '/perfil'),
          ),
        ],
      ),
      // botón flotante para crear grupo
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/crear-grupo'),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo grupo'),
      ),
      body: StreamBuilder<List<Grupo>>(
        // stream de Firebase — datos en tiempo real
        stream: FirebaseService.instance.streamGruposUsuario(_uid),
        builder: (context, snapshot) {
          // muestra indicador de carga mientras llegan los datos
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final grupos = snapshot.data ?? [];

          return RefreshIndicator(
            onRefresh: () async => setState(() {}),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // tarjeta de balance general — calcula desde Firebase
                  _BalanceGeneralBuilder(uid: _uid, grupos: grupos),
                  const SizedBox(height: 24),

                  // título de sección
                  Text('Mis grupos (${grupos.length})',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  // lista de grupos o estado vacío
                  if (grupos.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            const Icon(Icons.group_outlined, size: 64, color: Colors.grey),
                            const SizedBox(height: 12),
                            const Text('Aún no tienes grupos',
                                style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, '/crear-grupo'),
                              child: const Text('Crear el primero'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    // genera una tarjeta por cada grupo con balance calculado desde Firebase
                    ...grupos.map((grupo) => _GrupoConBalance(
                      grupo: grupo,
                      uid: _uid,
                    )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// widget que calcula el balance general del usuario sumando todos los grupos
class _BalanceGeneralBuilder extends StatelessWidget {
  final String uid;
  final List<Grupo> grupos;

  const _BalanceGeneralBuilder({required this.uid, required this.grupos});

  @override
  Widget build(BuildContext context) {
    if (grupos.isEmpty) {
      return KpiBalanceWidget(balance: 0, totalGrupos: 0);
    }

    // usa FutureBuilder para calcular el balance total desde Firebase
    return FutureBuilder<double>(
      future: _calcularBalanceTotal(),
      builder: (context, snapshot) {
        return KpiBalanceWidget(
          balance: snapshot.data ?? 0,
          totalGrupos: grupos.length,
        );
      },
    );
  }

  // calcula el balance total del usuario sumando los balances de todos los grupos
  Future<double> _calcularBalanceTotal() async {
    double total = 0;
    for (final grupo in grupos) {
      final gastos = await FirebaseService.instance.obtenerGastosGrupo(grupo.id);
      final balances = CalculadorBalances.calcular(gastos, grupoId: grupo.id);
      for (final b in balances) {
        if (b.acreedorUid == uid) total += b.monto; // te deben
        if (b.deudorUid   == uid) total -= b.monto; // debes
      }
    }
    return total;
  }
}

// widget que muestra un grupo con su balance calculado desde Firebase
class _GrupoConBalance extends StatelessWidget {
  final Grupo grupo;
  final String uid;

  const _GrupoConBalance({required this.grupo, required this.uid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Gasto>>(
      future: FirebaseService.instance.obtenerGastosGrupo(grupo.id),
      builder: (context, snapshot) {
        // calcula balance del usuario en este grupo
        final gastos = snapshot.data ?? [];
        final balances = CalculadorBalances.calcular(gastos, grupoId: grupo.id);
        double miBalance = 0;
        for (final b in balances) {
          if (b.acreedorUid == uid) miBalance += b.monto;
          if (b.deudorUid   == uid) miBalance -= b.monto;
        }

        return GrupoCardWidget(
          grupo: grupo,
          balanceUsuario: miBalance,
          onTap: () => Navigator.pushNamed(
            context, '/grupo-detalle', arguments: grupo,
          ),
        );
      },
    );
  }
}

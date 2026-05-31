// lib/pages/home_page.dart
// página principal — muestra balance general y lista de grupos del usuario
import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/balance.dart';
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
  // usa el uid de Firebase si está logueado, o 'user1' para mock
  final _uid = FirebaseService.instance.usuarioActual?.uid ?? 'user1';

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
        // stream de Firebase con datos mock como fallback
        stream: FirebaseService.instance.streamGruposUsuario(_uid),
        initialData: MockData.grupos.where((g) => g.esMiembro(_uid)).toList(),
        builder: (context, snapshot) {
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
                  // tarjeta de balance general del usuario
                  KpiBalanceWidget(
                    balance: MockData.balanceGeneralUsuario(_uid),
                    totalGrupos: grupos.length,
                  ),
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
                    // genera una tarjeta por cada grupo
                    ...grupos.map((grupo) {
                      // calcula balance del usuario en este grupo
                      final balances = CalculadorBalances.calcular(
                          MockData.gastosDeGrupo(grupo.id), grupoId: grupo.id);
                      double miBalance = 0;
                      for (final b in balances) {
                        if (b.acreedorUid == _uid) miBalance += b.monto;
                        if (b.deudorUid   == _uid) miBalance -= b.monto;
                      }
                      return GrupoCardWidget(
                        grupo: grupo,
                        balanceUsuario: miBalance,
                        onTap: () => Navigator.pushNamed(
                          context, '/grupo-detalle', arguments: grupo,
                        ),
                      );
                    }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

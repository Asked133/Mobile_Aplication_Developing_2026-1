// lib/pages/home_page.dart
// página principal — muestra balance general y lista de grupos del usuario
import 'package:flutter/material.dart';
import '../models/grupo.dart';
import '../models/gasto.dart';
import '../models/saldo.dart';
import '../models/balance.dart';
import '../services/firebase_service.dart';
import '../widgets/grupo_card_widget.dart';
import '../widgets/kpi_balance_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _uid = FirebaseService.instance.usuarioActual?.uid ?? 'user1';
  final Map<String, double> _balancesPorGrupo = {};
  late final Stream<List<Grupo>> _gruposStream;

  @override
  void initState() {
    super.initState();
    _gruposStream = FirebaseService.instance.streamGruposUsuario(_uid);
  }

  void _actualizarBalance(String grupoId, double balance) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_balancesPorGrupo[grupoId] != balance) {
        setState(() {
          _balancesPorGrupo[grupoId] = balance;
        });
      }
    });
  }

  double get _balanceTotal {
    double total = 0;
    for (var b in _balancesPorGrupo.values) {
      total += b;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SplitMate'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.pushNamed(context, '/actividad'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, '/perfil'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/crear-grupo'),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo grupo'),
      ),
      body: StreamBuilder<List<Grupo>>(
        stream: _gruposStream,
        builder: (context, snapshot) {
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
                  KpiBalanceWidget(
                    balance: _balanceTotal,
                    totalGrupos: grupos.length,
                  ),
                  const SizedBox(height: 24),

                  Text('Mis grupos (${grupos.length})',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

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
                    ...grupos.map((grupo) => _GrupoCardAsync(
                          key: ValueKey(grupo.id),
                          grupo: grupo,
                          uid: _uid,
                          onBalanceCalculado: _actualizarBalance,
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

// Widget auxiliar para cargar gastos y saldos de cada grupo de forma asíncrona
class _GrupoCardAsync extends StatefulWidget {
  final Grupo grupo;
  final String uid;
  final Function(String, double) onBalanceCalculado;
  
  const _GrupoCardAsync({
    super.key,
    required this.grupo, 
    required this.uid,
    required this.onBalanceCalculado,
  });

  @override
  State<_GrupoCardAsync> createState() => _GrupoCardAsyncState();
}

class _GrupoCardAsyncState extends State<_GrupoCardAsync> {
  late Stream<List<Gasto>> _gastosStream;
  late Stream<List<Saldo>> _saldosStream;

  @override
  void initState() {
    super.initState();
    _gastosStream = FirebaseService.instance.streamGastosGrupo(widget.grupo.id);
    _saldosStream = FirebaseService.instance.streamSaldosGrupo(widget.grupo.id);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Gasto>>(
      stream: _gastosStream,
      builder: (context, snapshotGastos) {
        return StreamBuilder<List<Saldo>>(
          stream: _saldosStream,
          builder: (context, snapshotSaldos) {
            final gastos = snapshotGastos.data ?? [];
            final saldos = snapshotSaldos.data ?? [];
            
            final balances = CalculadorBalances.calcular(gastos, saldos: saldos, grupoId: widget.grupo.id);
            double miBalance = 0;
            for (final b in balances) {
              if (b.acreedorUid == widget.uid) miBalance += b.monto;
              if (b.deudorUid   == widget.uid) miBalance -= b.monto;
            }

            // Reportar el balance calculado al padre en el siguiente frame
            widget.onBalanceCalculado(widget.grupo.id, miBalance);

            return GrupoCardWidget(
              grupo: widget.grupo,
              balanceUsuario: miBalance,
              onTap: () => Navigator.pushNamed(
                context, '/grupo-detalle', arguments: widget.grupo,
              ),
            );
          },
        );
      },
    );
  }
}

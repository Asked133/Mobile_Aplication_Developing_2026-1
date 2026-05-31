// lib/pages/crear_grupo_page.dart
// formulario para crear un nuevo grupo con nombre, descripción, moneda y miembros
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../utils/constantes.dart';

class CrearGrupoPage extends StatefulWidget {
  const CrearGrupoPage({super.key});
  @override
  State<CrearGrupoPage> createState() => _CrearGrupoPageState();
}

class _CrearGrupoPageState extends State<CrearGrupoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _emailController = TextEditingController();

  String _moneda = 'MXN';
  final List<String> _emailsAgregados = [];
  bool _cargando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // agrega un miembro a la lista por email (solo lo guarda localmente)
  void _agregarMiembro() {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    // verifica que no esté duplicado
    if (_emailsAgregados.contains(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ese email ya está agregado')),
      );
      return;
    }

    setState(() => _emailsAgregados.add(email));
    _emailController.clear();
  }

  // crea el grupo en Firebase
  Future<void> _crearGrupo() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _cargando = true);

    final uid = FirebaseService.instance.usuarioActual?.uid ?? 'user1';

    // crea el grupo
    final error = await FirebaseService.instance.crearGrupo(
      nombre: _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim().isNotEmpty
          ? _descripcionController.text.trim()
          : null,
      creadoPor: uid,
      moneda: _moneda,
    );

    setState(() => _cargando = false);

    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Grupo creado exitosamente!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear grupo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // nombre del grupo
              TextFormField(
                controller: _nombreController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nombre del grupo',
                  prefixIcon: Icon(Icons.group),
                  hintText: 'Ej: Depa, Viaje, Cena...',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'El nombre es requerido';
                  if (value.trim().length < 3) return 'Mínimo 3 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // descripción (opcional)
              TextFormField(
                controller: _descripcionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Descripción (opcional)',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
              ),
              const SizedBox(height: 16),

              // selector de moneda
              DropdownButtonFormField<String>(
                initialValue: _moneda,
                decoration: const InputDecoration(
                  labelText: 'Moneda',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                items: const [
                  DropdownMenuItem(value: 'MXN', child: Text('🇲🇽 MXN — Peso mexicano')),
                  DropdownMenuItem(value: 'USD', child: Text('🇺🇸 USD — Dólar')),
                  DropdownMenuItem(value: 'EUR', child: Text('🇪🇺 EUR — Euro')),
                ],
                onChanged: (value) => setState(() => _moneda = value ?? 'MXN'),
              ),
              const SizedBox(height: 24),

              // sección de agregar miembros
              const Text('Agregar miembros',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email del miembro',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _agregarMiembro,
                    icon: const Icon(Icons.add),
                    style: IconButton.styleFrom(backgroundColor: kColorPrimario),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // lista de miembros agregados con opción de eliminar
              if (_emailsAgregados.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _emailsAgregados.map((email) {
                    return Chip(
                      label: Text(email, style: const TextStyle(fontSize: 12)),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () {
                        setState(() => _emailsAgregados.remove(email));
                      },
                    );
                  }).toList(),
                ),
              const SizedBox(height: 8),
              Text(
                'Podrás agregar más miembros después',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 30),

              // botón crear grupo
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _cargando ? null : _crearGrupo,
                  icon: _cargando
                      ? const SizedBox(
                          height: 20, width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.check),
                  label: const Text('Crear Grupo', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

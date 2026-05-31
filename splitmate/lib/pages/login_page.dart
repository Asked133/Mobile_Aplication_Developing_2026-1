// lib/pages/login_page.dart
// pantalla de inicio de sesión con email/contraseña y Google
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../utils/constantes.dart';
import '../utils/validadores.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _ocultarPassword = true;
  bool _cargando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // intenta iniciar sesión con email y contraseña
  Future<void> _loginEmail() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _cargando = true);

    final error = await FirebaseService.instance.loginEmail(
      _emailController.text.trim(),
      _passwordController.text,
    );

    setState(() => _cargando = false);

    if (!mounted) return;
    if (error != null) {
      // muestra error en un SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    } else {
      // login exitoso — va a home
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  // intenta iniciar sesión con Google
  Future<void> _loginGoogle() async {
    setState(() => _cargando = true);
    final error = await FirebaseService.instance.loginGoogle();
    setState(() => _cargando = false);

    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),

                // logo de SplitMate
                Icon(Icons.account_balance_wallet_rounded,
                    size: 80, color: kColorPrimario),
                const SizedBox(height: 12),
                const Text(
                  'SplitMate',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: kColorPrimario,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Divide gastos fácilmente',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 40),

                // campo de email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: validarEmail,
                ),
                const SizedBox(height: 16),

                // campo de contraseña con toggle de visibilidad
                TextFormField(
                  controller: _passwordController,
                  obscureText: _ocultarPassword,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_ocultarPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => _ocultarPassword = !_ocultarPassword),
                    ),
                  ),
                  validator: validarContrasena,
                ),
                const SizedBox(height: 24),

                // botón de login
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _cargando ? null : _loginEmail,
                    child: _cargando
                        ? const SizedBox(
                            height: 20, width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Iniciar sesión', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 20),

                // separador "o continúa con"
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('o continúa con',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),
                const SizedBox(height: 20),

                // botón de Google
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: _cargando ? null : _loginGoogle,
                    icon: const Icon(Icons.g_mobiledata, size: 28),
                    label: const Text('Continuar con Google'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // enlace a registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿No tienes cuenta? '),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/registro'),
                      child: const Text('Regístrate'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

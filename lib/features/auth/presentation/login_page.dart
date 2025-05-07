import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/auth_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  late final AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    _authRepository = context.read<AuthRepository>();
    // Mover la creación del docente de prueba al primer build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authRepository.crearDocentePrueba();
    });
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      final docente = await _authRepository.login(email, password);

      if (docente == null) {
        _showError('Credenciales incorrectas');
        return;
      }

      if (docente.esAdmin) {
        context.go('/admin');
      } else {
        context.go('/docente/${docente.id}');
      }
    } catch (e) {
      _showError('Error al iniciar sesión: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('📘 INVESTIGACIÓN OPERATIVA',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo institucional',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Iniciar Sesión'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    _emailController.text = 'rlujan@ucb.edu.bo';
                    _passwordController.text = 'admin12';
                  },
                  child: const Text('Usar cuenta de prueba'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_io2_examen/presentation/features/auth/bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Navegar según el rol del usuario
          if (state.user.isAdmin || state.user.isTeacher) {
            context.go('/admin');
          } else {
            context.go('/student');
          }
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is TestAdminCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Admin de prueba creado exitosamente')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Inicio de Sesión')),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('INVESTIGACIÓN OPERATIVA',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
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
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                          context.read<AuthBloc>().add(
                            LoginRequested(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: state is AuthLoading
                            ? const CircularProgressIndicator()
                            : const Text('Iniciar Sesión'),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(CreateTestAdminRequested());
                    },
                    child: const Text('Crear admin de prueba'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:app_io2_examen/domain/repositories/auth_repository.dart';
import 'package:app_io2_examen/domain/repositories/estudiante_repository.dart';
import 'package:app_io2_examen/presentation/features/auth/bloc/auth_bloc.dart';
import 'package:app_io2_examen/presentation/features/students/bloc/estudiantes_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/config.dart';
import 'core/firebase_service.dart';
import 'core/theme/theme.dart';
import 'core/config/router.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/estudiante_repository_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await FirebaseService.initialize();

    runApp(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthRepository>(
            create: (_) => AuthRepositoryImpl(),
          ),
          RepositoryProvider<EstudianteRepository>(
            create: (_) => EstudianteRepositoryImpl(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create:
                  (context) =>
                      AuthBloc(authRepository: context.read<AuthRepository>(), firestore: FirebaseFirestore.instance)
                        ..add(VerifyAuthStatus()),
            ),
            BlocProvider(
              create:
                  (context) => EstudiantesBloc(
                    estudianteRepository: context.read<EstudianteRepository>(),
                    docenteId: 'default',
                  ),
            ),
          ],
          child: const MyApp(),
        ),
      ),
    );
  } catch (e) {
    debugPrint('Error inicializando Firebase: $e');
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error al inicializar la aplicación')),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Investigación Operativa',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: AppConfig.themeMode,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
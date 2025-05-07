import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/config.dart';
import 'core/theme.dart';
import 'core/router.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/students/data/estudiante_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (details) {
    if (details.exception is! FlutterErrorDetails) {
      debugPrint('Error capturado: ${details.exception}');
    }
    FlutterError.presentError(details);
  };

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        Provider<EstudianteRepository>(
          create: (context) => EstudianteRepository(), // Asegúrate de inicializarlo correctamente
        ),
      ],
      child: const MyApp(),
    ),
  );
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
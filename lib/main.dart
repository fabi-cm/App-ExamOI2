import 'package:flutter/material.dart';
import 'core/config.dart';
import 'core/theme.dart';
import 'core/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Limitar captura de errores de GPU en dispositivos problemáticos
  FlutterError.onError = (details) {
    if (details.exception is! FlutterErrorDetails) {
      debugPrint('Error capturado: ${details.exception}');
    }
    FlutterError.presentError(details);
  };

  runApp(const MyApp());
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'services/db_service.dart';
import 'services/pwa_manager.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await DBService().init();
  
  final pwaManager = PWAManager();

  runApp(
    ChangeNotifierProvider<PWAManager>(
      create: (_) => pwaManager,
      child: const NotasApp(),
    ),
  );
}

class NotasApp extends StatelessWidget {
  const NotasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notas PWA',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurple,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
          // Se usa accentColor para compatibilidad
          accentColor: Colors.tealAccent[400]!, 
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0, 
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
        ),
        // SE ELIMINA cardTheme para resolver el error de compilación
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart';
// import 'package:flutter/foundation.dart'; // No es necesario si ya se hace en main.dart

class SplashScreen extends StatefulWidget {
const SplashScreen({super.key});
@override
 State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
late AnimationController _ctrl;
late Animation<double> _scale;

@override
void initState() {
super.initState();
// Inicializacion y animacion
_ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
 _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
 _ctrl.forward();
    
    // Llamamos a la funcion asincrona para manejar la transicion
 _initializeAppAndNavigate();
}

  Future<void> _initializeAppAndNavigate() async {
   
    final startTime = DateTime.now();
    
    final minDuration = const Duration(milliseconds: 1500);
    final elapsedTime = DateTime.now().difference(startTime);
    
    if (elapsedTime < minDuration) {
      await Future.delayed(minDuration - elapsedTime);
    }

    // 4. Navegamos a la pantalla principal
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

@override
 void dispose() {
 _ctrl.dispose();
super.dispose();
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
 backgroundColor: Colors.indigo,
 body: Center(
   child: ScaleTransition(
 scale: _scale,
 child: Column(
mainAxisSize: MainAxisSize.min,
 children: const [
 Icon(Icons.note_rounded, size: 96, color: Colors.white),
 SizedBox(height: 16),
 Text('Notas PWA', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
 SizedBox(height: 8),
 CircularProgressIndicator(color: Colors.white),
 ],
 ),
 ),
 ),
 );
 }
}
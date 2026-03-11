import 'package:flutter/material.dart';

class ChocoSplashScreen extends StatefulWidget {
  const ChocoSplashScreen({super.key});

  @override
  State<ChocoSplashScreen> createState() => _ChocoSplashScreenState();
}

class _ChocoSplashScreenState extends State<ChocoSplashScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0503), // Nuestro espacio profundo sabor a café
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centramos todo en la cancha
          children: [
            // 🧑‍🚀 El Cacaonauta entra a la cancha
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0), // Le damos bordes suaves a la foto
              child: Image.asset(
                'assets/images/planetas/choco_splash.png', // 👈 Verifica que esta ruta sea exacta
                width: 250.0, 
                fit: BoxFit.cover,
              ),
            ),
            
            const SizedBox(height: 40.0), // Un respiro táctico entre la foto y el texto
            
            // 📜 El Lema Épico
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Choco Universe:\nExplora el universo dulce',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFCD7F32), // Color caramelo
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
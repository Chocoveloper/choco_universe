// choco_splash_screen.dart
import 'dart:math'; // 👈 ¡Para calcular coordenadas aleatorias!
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart'; // 🚀 Asegúrese de tener el paquete Lottie
import 'package:choco_universe/screens/choco_home_universe.dart'; // Asegúrese de que la ruta sea correcta
import 'package:choco_universe/services/choco_horizons_service.dart';
import 'package:choco_universe/models/choco_imagen_deldia_model.dart';
import 'package:choco_universe/models/choco_systeme_solaire_model.dart';

class ChocoSplashScreen extends StatefulWidget {
  final ImagenDelDia? imagenDelDia;
  final SystemeSolaire? planetas;

  const ChocoSplashScreen({super.key, required this.imagenDelDia, this.planetas});

  @override
  State<ChocoSplashScreen> createState() => _ChocoSplashScreenState();
}

class _ChocoSplashScreenState extends State<ChocoSplashScreen> {
  String _estadoCarga = "CALIBRANDO ÓRBITAS DE CARAMELO";

  @override
  void initState() {
    super.initState();
    // 🚀 INICIAMOS LA SECUENCIA DE DESPEGUE AUTOMÁTICA
    _iniciarChocoSaltoEstelar();
  }

  // 🧠 LA MISIÓN DE CALIBRACIÓN ORBITAL
  Future<void> _iniciarChocoSaltoEstelar() async {
    // 1. Damos un respiro para que la animación de Chrocante se vea (2 segundos)
    await Future.delayed(const Duration(seconds: 2));

    try {
      // 2. Ejecutamos la carga pesada de Horizons.
      setState(() { _estadoCarga = "CONECTANDO CON LA NASA HORIZONS"; });
      final mapaGalactico = await ChocoHorizonsService.escanearSistemaSolar();
      
      // 3. Cuando termina la carga exitosamente
      setState(() { _estadoCarga = "¡CHREPANTO LISTO! DESPEGANDO ✨"; });
      
      // 4. Esperamos un microsegundo para que se vea el mensaje final
      await Future.delayed(const Duration(milliseconds: 500));

      // 5. Navegamos a la pantalla principal
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChocoHomeUniverse(
            image: widget.imagenDelDia, // Pasamos la imagen requerida
            planets: widget.planetas,
            mapaGalactico: mapaGalactico, // Pasamos las órbitas frescas
          ),
        ),
      );
    } catch (e) {
      // 🚨 AGREGAMOS ESTE PRINT PARA LEER LA TELEMETRÍA SI FALLA HORIZONS
      print('🚨 ERROR EN EL CHOCO-SALTO: $e');
      setState(() { _estadoCarga = "INTERFERENCIA EN LA SEÑAL CÚANTICA"; });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🎨 Diseñamos la interfaz basada en su visión de sabor
    return Scaffold(
      body: Container(
        // 🌌 EL FONDO ESPACIAL DELICIOSO (Vainilla, Mora, Miel)
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFFFFF8DC), // Vainilla (Crema) - El centro luminoso
              Color(0xFFE0C1B0), // Miel / Caramelo claro - La transición suave
              Color(0xFF5A2A6B), // Mora / Uva (Morado oscuro) - Los bordes espaciales
            ],
            stops: [0.2, 0.5, 1.0], // Controlamos la expansión de cada sabor
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            
            // 🍫 LAS ESTRELLAS DE CHOCOLATE SINTETIZADAS
            const Positioned.fill(
              child: ChocoChispasFondo(), // 👈 ¡Nuestra magia matemática!
            ),

            // 👾 LA ANIMACIÓN DE CHROCANTE (Lottie)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Imagen de Chrocante
                 Image.asset('assets/images/planetas/chrocante_splash.png',
                 height: 250.0,
                 width: 250.0,
                 fit: BoxFit.contain,
                 ),
                  
                    /*// Lottie de Chrocante o un astronauta.
                  Lottie.asset(
                    'assets/lottie/AstronautIllustration.json', // Reemplace por su Lottie de Chrocante real
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(width: 150, height: 150, decoration: const BoxDecoration(color: Color(0xFFCD7F32), shape: BoxShape.circle), child: const Icon(Icons.psychology, color: Colors.white, size: 80,),),
                  ),*/
                  const SizedBox(height: 30),
                  
                  // 🚥 PROGRESS INDICATOR DULCE (Color Caramelo)
                  const SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      backgroundColor: Colors.white24,
                      color: Color(0xFFCD7F32), // Color Caramelo
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // 🎙️ EL TEXTO DEFINITIVO DEL COMANDANTE (Comfortaa)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'PREPARANDO EL CHOCO-SALTO ESTELAR...', 
                      style: GoogleFonts.comfortaa(
                        color: Colors.brown, 
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ), 
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // 📡 EL ESTADO DE LA TELEMETRÍA (Fino y profesional)
                  Text(
                    _estadoCarga, 
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 11, 
                      letterSpacing: 2.0, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✨ GENERADOR DE ESTRELLAS DE CHOCOLATE MATEMÁTICAS
class ChocoChispasFondo extends StatelessWidget {
  const ChocoChispasFondo({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos una semilla fija (42) para que las estrellas no cambien de lugar
    // cada vez que la pantalla hace una pequeña animación.
    final random = Random(42); 

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: List.generate(40, (index) {
            // Posición aleatoria en la pantalla
            final left = random.nextDouble() * constraints.maxWidth;
            final top = random.nextDouble() * constraints.maxHeight;
            // Tamaño y opacidad aleatorios
            final size = random.nextDouble() * 15 + 8; 
            final opacity = random.nextDouble() * 0.3 + 0.1;

            return Positioned(
              left: left,
              top: top,
              child: Opacity(
                opacity: opacity,
                child: Icon(
                  Icons.rocket_launch_rounded, // Estrellas redonditas
                  color: const Color(0xFF3E1F0B), // Color Chocolate Oscuro
                  size: size,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
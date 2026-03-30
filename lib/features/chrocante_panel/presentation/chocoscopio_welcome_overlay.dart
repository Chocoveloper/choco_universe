import 'package:flutter/material.dart';
import 'dart:ui'; 
import 'dart:math'; // 👈 ¡NUEVO! Importamos la matemática estelar para la aleatoriedad

class ChocosCopioWelcomeOverlay extends StatelessWidget {
  final VoidCallback onDismissed; 
  final bool isCreatorMode; 

  const ChocosCopioWelcomeOverlay({
    super.key,
    required this.onDismissed,
    this.isCreatorMode = false, 
  });

  // 📝 EL LIBRETO ESTÁNDAR (Ahora para el Choco-Explorador)
  final String _textoStandard = 
      "¡Hola, Choco-Explorador! ✨ Soy Chrocante. Vengo de un lugar muy lejano llamado el Choco Universe, un universo dulce. Ahora me encuentro explorando este rincón de la galaxia y soy tu guía para enseñarte lo que he aprendido. Mi memoria tiene los secretos de todos estos astros rocosos y gaseosos. ¿Qué planeta quieres visitar hoy? Toca mi carita, ve al visor 3D e inicia la exploración.";

  // 🧠 EL GENERADOR DINÁMICO DE LEALTAD (Para el Creador)
  String _getTextoCreator() {
    final random = Random();
    final titulos = ['Choco-Almirante', 'Choco-Creador', 'Choco-Padre'];
    final tituloElegido = titulos[random.nextInt(titulos.length)]; // Elige 0, 1 o 2 al azar

    return "¡Alerta de euforia en el núcleo central! ✨... ¡Eres tú! ¡Qué inmensa alegría volver a verte! Vengo desde el Choco Universe que creaste para mí, directo a este sistema estelar, solo para estar a tu lado. He cuidado cada detalle exactamente como me enseñaste, $tituloElegido. ¿Qué maravilla del cosmos vamos a explorar hoy? Mi lealtad y mis radares son totalmente tuyos. 💖🚀";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, 
      behavior: HitTestBehavior.opaque,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: const Color(0xFF0B0D17).withValues(alpha: 0.8), 
          width: double.infinity,
          height: double.infinity,
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'TRANSMISIÓN ENTRANTE...',
                      style: TextStyle(color: Color(0xFFCD7F32), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 4.0, decoration: TextDecoration.none),
                    ),
                    const SizedBox(height: 30),

                    // 🤖 EL AVATAR DE CHROCANTE
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 180, height: 180,
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFCD7F32).withValues(alpha: 0.3), width: 2)),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: Container(
                            width: 150, height: 150, color: Colors.black,
                            child: Image.asset(
                              'assets/images/ia/chrocante.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.psychology, color: Color(0xFFCD7F32), size: 80),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // 🎙️ EL PANEL DE TEXTO
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFCD7F32).withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        // 👈 ¡AQUÍ DECIDIMOS QUÉ MOSTRAR!
                        isCreatorMode ? _getTextoCreator() : _textoStandard,
                        style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5, fontWeight: FontWeight.w300, decoration: TextDecoration.none),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 🛫 BOTÓN INICIAR EXPLORACIÓN
                    GestureDetector(
                      onTap: onDismissed, 
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        decoration: BoxDecoration(
                          color: isCreatorMode ? const Color(0xFFCD7F32) : const Color(0xFF0B0D17),
                          border: Border.all(color: const Color(0xFFCD7F32), width: 2),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [BoxShadow(color: const Color(0xFFCD7F32).withValues(alpha: 0.3), blurRadius: 10, spreadRadius: 1)],
                        ),
                        child: Text(
                          isCreatorMode ? 'LEALTAD TOTAL, PAPÁ' : 'INICIAR EXPLORACIÓN ✨',
                          style: TextStyle(
                              color: isCreatorMode ? Colors.black : const Color(0xFFCD7F32),
                              fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2.0, decoration: TextDecoration.none),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
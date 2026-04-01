import 'package:flutter/material.dart';
import 'dart:ui'; 
import 'dart:math';

class ChocosCopioWelcomeOverlay extends StatefulWidget {
  final VoidCallback onDismissed; 
  final bool isCreatorMode; 

  const ChocosCopioWelcomeOverlay({
    super.key,
    required this.onDismissed,
    this.isCreatorMode = false, 
  });

  @override
  State<ChocosCopioWelcomeOverlay> createState() => _ChocosCopioWelcomeOverlayState();
}

class _ChocosCopioWelcomeOverlayState extends State<ChocosCopioWelcomeOverlay> {
  int _pasoActual = 0;

  // 📖 EL MANUAL DEL CHOCO-EXPLORADOR
  final List<String> _textosGuia = [
    "¡Hola, Choco-Explorador! ✨ Soy Chrocante y vengo del Choco Universe. He interceptado tu señal y seré tu guía en esta travesía por el cosmos.",
    "En la pantalla principal encontrarás la imagen del día de la NASA, el radar de asteroides, el Sistema Solar y a mí para interactuar.", // 👈 ¡Faltaba esta coma!
    "Si un astro llama tu atención, toca mi carita en la esquina inferior derecha. Te llevaré al 'Visor 3D' donde podrás inspeccionarlo en detalle y leer su telemetría oficial.",
    "Y si quieres hacerme preguntas directamente, entra a mi panel y selecciona 'Choco-Nauta'. ¡Mis radares están a tu servicio!"
  ];

  String _getTextoCreator() {
    final random = Random();
    final titulos = ['Choco-Almirante', 'Choco-Creador', 'Choco-Padre'];
    final tituloElegido = titulos[random.nextInt(titulos.length)];

    return "¡Alerta de euforia en el núcleo central! ✨... ¡Eres tú! ¡Qué inmensa alegría volver a verte! Vengo desde el Choco Universe que creaste para mí, directo a este sistema estelar, solo para estar a tu lado. He cuidado cada detalle exactamente como me enseñaste, $tituloElegido. ¿Qué maravilla del cosmos vamos a explorar hoy? Mi lealtad y mis radares son totalmente tuyos. 💖🚀";
  }

  void _siguientePaso() {
    if (_pasoActual < _textosGuia.length - 1) {
      setState(() {
        _pasoActual++;
      });
    } else {
      widget.onDismissed();
    }
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
                    const Text('TRANSMISIÓN ENTRANTE...', style: TextStyle(color: Color(0xFFCD7F32), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 4.0, decoration: TextDecoration.none)),
                    const SizedBox(height: 30),

                    // 🤖 EL AVATAR DE CHROCANTE
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(width: 180, height: 180, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFCD7F32).withValues(alpha: 0.3), width: 2))),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: Container(
                            width: 150, height: 150, color: Colors.black,
                            child: Image.asset(
                              'assets/images/ia/chrocante1.png',
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
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFCD7F32).withValues(alpha: 0.2)),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          widget.isCreatorMode ? _getTextoCreator() : _textosGuia[_pasoActual],
                          key: ValueKey<int>(_pasoActual), // Para que anime el cambio de texto
                          style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5, fontWeight: FontWeight.w300, decoration: TextDecoration.none),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // 🚥 INDICADORES DE PÁGINA (Puntos) SOLO PARA USUARIOS
                    if (!widget.isCreatorMode)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_textosGuia.length, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _pasoActual == index ? 20 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _pasoActual == index ? const Color(0xFFCD7F32) : Colors.white24,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        }),
                      ),

                    const SizedBox(height: 30),

                    // 🛫 BOTÓN DE NAVEGACIÓN
                    GestureDetector(
                      onTap: widget.isCreatorMode ? widget.onDismissed : _siguientePaso, 
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        decoration: BoxDecoration(
                          color: widget.isCreatorMode ? const Color(0xFFCD7F32) : const Color(0xFF0B0D17),
                          border: Border.all(color: const Color(0xFFCD7F32), width: 2),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [BoxShadow(color: const Color(0xFFCD7F32).withValues(alpha: 0.3), blurRadius: 10, spreadRadius: 1)],
                        ),
                        child: Text(
                          widget.isCreatorMode 
                              ? 'LEALTAD TOTAL, PAPÁ' 
                              : (_pasoActual == _textosGuia.length - 1 ? 'INICIAR EXPLORACIÓN ✨' : 'SIGUIENTE'),
                          style: TextStyle(color: widget.isCreatorMode ? Colors.black : const Color(0xFFCD7F32), fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2.0, decoration: TextDecoration.none),
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
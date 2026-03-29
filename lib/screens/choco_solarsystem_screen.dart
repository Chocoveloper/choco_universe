import 'package:audioplayers/audioplayers.dart';
import 'package:choco_universe/features/chrocante_panel/presentation/choco_chrocante_habitat.dart';
import 'dart:math' as math;
import 'package:choco_universe/models/choco_systeme_solaire_model.dart';
import 'package:choco_universe/widgets/choco_asteroides_vagabundos.dart';
import 'package:choco_universe/widgets/choco_show_planets_widget.dart';
import 'package:flutter/material.dart';

class ChocoSolarSystemScreen extends StatefulWidget {
  final SystemeSolaire? planets;
  final Map<String, Map<String, double>>? mapaGalactico; 

  const ChocoSolarSystemScreen({super.key, this.planets, this.mapaGalactico});

  @override
  State<ChocoSolarSystemScreen> createState() => _ChocoSolarSystemScreenState();
}

// ⚠️ REGRESAMOS A SINGLE MIXIN: Volvemos a un solo motor para simplificar y optimizar.
class _ChocoSolarSystemScreenState extends State<ChocoSolarSystemScreen> with SingleTickerProviderStateMixin {
  
  // 🌟 EL MOTOR ÚNICO: El pulso rítmico del Universo
  late AnimationController _controladorPulsoUniverso;
  
  late AudioPlayer _chocoReproductor;

  @override
  void initState() {
    super.initState();
    
    // 🚦 Motor Único: Pulso lento cada 3 segundos, va y viene.
    _controladorPulsoUniverso = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), 
    ); 

    // 2. 🧠 EL CEREBRO ORGÁNICO: Le enseñamos a hacer pausas
    _controladorPulsoUniverso.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        // El Sol acaba de crecer al máximo. 
        // ⏱️ Pausa de MEDIO SEGUNDO (sosteniendo la respiración) antes de soltar:
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) _controladorPulsoUniverso.reverse(); // Se empieza a encoger
        
      } else if (status == AnimationStatus.dismissed) {
        // El Sol volvió a su tamaño normal.
        // ⏱️ Pausa LARGA DE 2 SEGUNDOS (descanso) antes del siguiente latido:
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) _controladorPulsoUniverso.forward(); // Vuelve a crecer
      }
    });

    // 3. ¡Arrancamos el primer latido manualmente!
    _controladorPulsoUniverso.forward();

    _chocoReproductor = AudioPlayer();
    _chocoReproductor.setReleaseMode(ReleaseMode.loop);
    _chocoReproductor.play(AssetSource('audio/05_choco_inmensity.mp3'));
  }

  @override
  void dispose() {
    _controladorPulsoUniverso.dispose(); // Apagamos el motor único.
    _chocoReproductor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 520.0,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              
              // 1. 🌟 FONDO ANIMADO: ESTRELLAS TITILANTES
              AnimatedBuilder(
                animation: _controladorPulsoUniverso,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ChocoEstrellasPainter(
                      animacionValue: _controladorPulsoUniverso.value,
                    ),
                  );
                },
              ),
              
              // 2. ÓRBITAS VISUALES FIJAS
              if (widget.planets != null)
                CustomPaint(
                  painter: ChocoOrbitPainter(
                    cantidadPlanetas: widget.planets!.bodies.length,
                  ),
                ),

              // 3. ☀️ EL SOL REAL, AMARILLO Y RESPLANDECIENTE (Pulsando)
              AnimatedBuilder(
                animation: _controladorPulsoUniverso,
                builder: (context, child) {
                  return _buildSolPulsante();
                },
              ),

              // 4. LOS PLANETAS EN POSICIÓN REAL
              ..._buildPlanetasReales(),

              ChocoChrocanteHabitat(planets: widget.planets),
              
              Positioned(
                bottom: -47, 
                left: 0,
                right: 0,
                child: Container(
                  height: 80, 
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Color(0xFF0B0D17)],
                    ),
                  ),
                ),
              ),
              const AsteroidesVagabundos(), 
            ],
          ),
        ),
      ],
    );
  }

  // ☀️ EL SOL RESPLANDECIENTE: Majestuoso, resplandeciente y pulsando con la vida del Universo.
  // ☀️ EL SOL RESPLANDECIENTE (Ahora con Latido Real)
  Widget _buildSolPulsante() {
    
    // 🪄 1. MAGIA DE ESCALA: El Sol crecerá un 5% y volverá a su tamaño (de 1.0 a 1.05)
    final double latidoEscala = 1.0 + (_controladorPulsoUniverso.value * 0.05);

    // 🪄 2. MAGIA DE LUZ: La intensidad del aura naranja irá de 0.2 (suave) a 0.6 (fuerte)
    final double intensidadAura = 0.2 + (_controladorPulsoUniverso.value * 0.3);

    return Transform.scale(
      scale: latidoEscala, // 👈 ¡Esto es lo que hará que el Sol "respire"!
      child: Container(
        height: 110.0, 
        width: 110.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            // El núcleo de luz brillante (Amarillo)
            BoxShadow(
              color: const Color(0xFFFFD54F).withValues(alpha: 0.6), 
              blurRadius: 100,
              spreadRadius: 10, // Un poco más contenido en el centro
            ),
            // 🌅 Su "Aura de Zona Habitable" (Naranja) que ahora cambia de intensidad
            BoxShadow(
              color: const Color(0xFFFF8F00).withValues(alpha: intensidadAura), // 👈 ¡PULSO DE LUZ!
              blurRadius: 80, 
              spreadRadius: 80, // Su toque maestro para iluminar los planetas cercanos
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/images/planetas/sol.png', 
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPlanetasReales() {
    if (widget.planets == null || widget.mapaGalactico == null) return [];

    return widget.planets!.bodies.asMap().entries.map((entry) {
      final int index = entry.key;
      final planeta = entry.value;
      
      final double radioVisual = 70.0 + (index * 25.0); 

      String llavePlaneta = planeta.englishName;
      if (llavePlaneta == 'Mercury') llavePlaneta = 'Mercurio';
      if (llavePlaneta == 'Earth') llavePlaneta = 'Tierra';
      if (llavePlaneta == 'Mars') llavePlaneta = 'Marte';
      if (llavePlaneta == 'Uranus') llavePlaneta = 'Urano';
      if (llavePlaneta == 'Neptune') llavePlaneta = 'Neptuno';
      
      final datosNasa = widget.mapaGalactico?[llavePlaneta];

      double anguloReal = 0.0;

      if (datosNasa != null) {
        anguloReal = math.atan2(datosNasa['y']!, datosNasa['x']!);
      } else {
         anguloReal = index * (math.pi / 4.0);
      }

      final double x = radioVisual * math.cos(anguloReal);
      final double y = radioVisual * math.sin(anguloReal);

      return Transform.translate(
        offset: Offset(x, y),
        child: ChocoShowPlanetsWidget(planets: planeta),
      );
    }).toList();
  }
}

// ------------------------------------------------------------------
// 🎨 LOS PINTORES QUE SE MANTIENEN EN EL HIPERESPACIO
// ------------------------------------------------------------------

class ChocoOrbitPainter extends CustomPainter {
  final int cantidadPlanetas;

  ChocoOrbitPainter({required this.cantidadPlanetas});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCD7F32).withValues(alpha: 0.2) 
      ..style = PaintingStyle.stroke 
      ..strokeWidth = 1.0; 

    const centro = Offset(0, 0);

    for (int i = 0; i < cantidadPlanetas; i++) {
      final double radio = 70.0 + (i * 25.0);
      canvas.drawCircle(centro, radio, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 🌟 PINTOR DE ESTRELLAS TITILANTES
class ChocoEstrellasPainter extends CustomPainter {
  final double animacionValue; 

  ChocoEstrellasPainter({required this.animacionValue});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(88); 
    final paint = Paint();

    for (int i = 0; i < 150; i++) {
      final double x = random.nextDouble() * 400 - 200;
      final double y = random.nextDouble() * 520 - 260;
      final double radio = random.nextDouble() * 1.5 + 0.5;

      final baseAlpha = random.nextDouble() * 0.5; 
      double brillo = baseAlpha + (animacionValue * 0.5);
      
      if (i % 2 == 0) {
         brillo = baseAlpha + ((1.0 - animacionValue) * 0.5);
      }

      paint.color = Colors.white.withValues(alpha: brillo.clamp(0.1, 1.0));

      canvas.drawCircle(Offset(x, y), radio, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ChocoEstrellasPainter oldDelegate) {
    return oldDelegate.animacionValue != animacionValue;
  }
}
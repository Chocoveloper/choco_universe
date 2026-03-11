import 'package:audioplayers/audioplayers.dart';
import 'dart:math' as math;
import 'package:choco_universe/models/choco_systeme_solaire_model.dart';
import 'package:choco_universe/widgets/choco_asteroides_vagabundos.dart';
import 'package:choco_universe/widgets/choco_show_planets_widget.dart';
import 'package:flutter/material.dart';

class ChocoSolarSystemScreen extends StatefulWidget {
  final SystemeSolaire? planets;

  const ChocoSolarSystemScreen({super.key, this.planets});

  @override
  State<ChocoSolarSystemScreen> createState() => _ChocoSolarSystemScreenState();
}

//Agregamos este Mixin (SingleTickerProviderStateMixin) que es la licencia para usar animaciones. Es parte de nuestro proceso para hacer que los planetas giren en orbita alrededor del sol
class _ChocoSolarSystemScreenState extends State<ChocoSolarSystemScreen>
    with SingleTickerProviderStateMixin {
  // 2. Declaramos nuestro motor
  late AnimationController _controladorOrbita;

  // 🎸 Declaramos nuestro motor de audio
  late AudioPlayer _chocoReproductor;

  @override
  void initState() {
    super.initState();
    // 3. Encendemos el motor: dará una vuelta completa cada 20 segundos
    _controladorOrbita = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 600),
    )..repeat(); // repeat() hace que gire infinitamente

    // 🎶 Encendemos la Choco-Música
    _chocoReproductor = AudioPlayer();

    // Le decimos que se repita infinitamente (Loop) para que nunca haya silencio
    _chocoReproductor.setReleaseMode(ReleaseMode.loop);

    // ¡Que suene la orquesta! (Buscamos en la carpeta assets/audio)
    _chocoReproductor.play(AssetSource('audio/05_choco_inmensity.mp3'));
  }

  @override
  void dispose() {
    // 4. Apagamos el motor si salimos de la pantalla (¡Muy importante para la memoria!)
    _controladorOrbita.dispose();
    // 🛑 Apagamos y destruimos el reproductor de audio
    _chocoReproductor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Aquí empiezo a implementar el Stack en primer lugar el sol
        SizedBox(
          height: 520.0, //Esto da altura al Stack para que quepan las orbitas.
          width: double.infinity,
          child: AnimatedBuilder(
            animation: _controladorOrbita,
            builder: (context, child) {
              return Stack(
                clipBehavior: Clip
                    .none, // ✂️ PROHIBIDO RECORTAR: Los planetas pueden salirse del contenedor
                alignment: Alignment.center, // El centro es el origen (0.0)
                children: [

                /*  // 🥛 LAS ESTRELLAS DE LECHE (Fondo profundo)
                   CustomPaint(
                    painter: ChocoEstrellasPainter(),
                  ),

                  // ⭕ LAS ÓRBITAS HOLOGRÁFICAS (En el fondo absoluto)
                  if (widget.planets != null)
                    CustomPaint(
                      painter: ChocoOrbitPainter(
                        cantidadPlanetas: widget.planets!.bodies.length,
                      ),
                    ),*/
                  // ✨ LA CORONA SOLAR (Luz de fondo)
                  // Este contenedor es gigante pero casi transparente, creando el brillo
                  Container(
                    width: 350.0,
                    height: 350.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          // Centro brillante (Color caramelo/sol con 30% de opacidad)
                          const Color(0xFFCD7F32).withValues(alpha: 0.3),
                          // Borde invisible (0% opacidad) para que se difumine con el espacio
                          const Color(0xFFCD7F32).withValues(alpha: 0.0),
                        ],
                        stops: const [
                          0.1,
                          1.0,
                        ], // El brillo se concentra en el centro y se desvanece suavemente
                      ),
                    ),
                  ),

                  // Aqui va el sol (Al estar centrado, se queda en el medio)
                  Container(
                    height: 100.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [
                          Color(0xFFFFF3E0), // Brillo central
                          Color(0xFFCD7F32), // Caramelo
                          Color(0xFF4E2A14), // Chocolate profundo
                        ],
                        stops: [0.2, 0.6, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFCD7F32).withValues(alpha: 0.6),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),

                  //Mostramos nuestros planetas orbitando
                  if (widget.planets != null)
                    // Usamos asMap() para obtener el índice (0, 1, 2...) y separarlos
                    ...widget.planets!.bodies.asMap().entries.map((entry) {
                      final int index = entry.key; // Número de planeta
                      final planeta = entry.value; // Datos del planeta

                      // 1. Radio: Distancia desde el centro (El sol). Cada planeta se aleja 25.0 más.
                      final double radio = 70.0 + (index * 25.0);

                      // 🧮 CHOCO-MATEMÁTICAS EN MOVIEMINTO:

                      final double anguloBase = index * (math.pi / 4.0);
                      // Sumamos el valor del motor (de 0 a 1) multiplicado por 2*Pi (360 grados)

                      // 🚀 TERCERA LEY DE CHOCO-KEPLER (Ajuste Visual Definitivo):
                      // Le damos a los planetas interiores muchísimas vueltas para que visualmente
                      // corran más rápido en sus pistas pequeñas.
                      const List<double> vueltasPorPlaneta = [
                        20.0,
                        14.0,
                        10.0,
                        8.0,
                        6.0,
                        4.0,
                        2.0,
                        1.0,
                      ];
                      // Tomamos las vueltas correspondientes según la posición del planeta (0 a 7)
                      final double velocidadOrbital = vueltasPorPlaneta[index];

                      final double anguloAnimado =
                          anguloBase +
                          (_controladorOrbita.value *
                              2 *
                              math.pi *
                              velocidadOrbital);
                      // 3. Posición X, Y en el círculo
                      final double x = radio * math.cos(anguloAnimado);
                      final double y = radio * math.sin(anguloAnimado);

                      // Transform.translate mueve el widget desde el centro hacia X, Y
                      return Transform.translate(
                        offset: Offset(x, y),
                        child: ChocoShowPlanetsWidget(planets: planeta),
                      );
                    }),

                  // ☄️ EL ASTEROIDE INTERACTIVO (Botón gamificado hacia el Radar)
                 const AsteroidesVagabundos(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}


// 🎨 NUESTRO PINCEL ESTELAR: Dibuja las órbitas en el fondo
class ChocoOrbitPainter extends CustomPainter {
  final int cantidadPlanetas;

  ChocoOrbitPainter({required this.cantidadPlanetas});

  @override
  void paint(Canvas canvas, Size size) {
    // Definimos cómo será la línea (Color caramelo, muy transparente, delgada)
    final paint = Paint()
      ..color = const Color(0xFFCD7F32).withValues(alpha: 0.2) // 20% de opacidad
      ..style = PaintingStyle.stroke // Solo el borde, no relleno
      ..strokeWidth = 1.0; // Línea súper fina de alta tecnología

    // Como nuestro Stack está centrado, el origen de todo es exactamente (0,0)
    const centro = Offset(0, 0);

    // Dibujamos un círculo perfecto por cada planeta usando tu misma fórmula matemática
    for (int i = 0; i < cantidadPlanetas; i++) {
      final double radio = 70.0 + (i * 25.0);
      canvas.drawCircle(centro, radio, paint);
    }
  }

  // Esto le dice a Flutter que no necesita redibujar las órbitas en cada frame de la animación, ahorrando muchísima RAM
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 🥛 NUESTRO PINCEL LECHERO: Dibuja las estrellas de fondo
class ChocoEstrellasPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Usamos el número 88 como semilla (¡En honor a tus 88 Choco-Constelaciones!)
    // Esto asegura que las estrellas salgan al azar, pero siempre en el mismo lugar
    final random = math.Random(88); 
    final paint = Paint();

    // Dibujamos 150 gotitas de leche
    for (int i = 0; i < 150; i++) {
      // Repartimos las estrellas por todo el lienzo del Stack
      // Como el centro es (0,0), vamos desde -200 hasta +200 en X, y -260 a +260 en Y
      final double x = random.nextDouble() * 400 - 200;
      final double y = random.nextDouble() * 520 - 260;
      
      // Tamaños aleatorios (algunas lejanas, otras más cerca)
      final double radio = random.nextDouble() * 1.5 + 0.5;
      
      // Opacidad aleatoria para darle profundidad (brillo) al espacio
      paint.color = Colors.white.withValues(alpha: random.nextDouble() * 0.7 + 0.1);

      // ¡Salpicamos la gota en el lienzo!
      canvas.drawCircle(Offset(x, y), radio, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
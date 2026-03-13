import 'package:choco_universe/models/choco_neo_radar_model.dart';

import '../services/choco_service_http.dart';
import 'package:flutter/material.dart';
import '../screens/choco_threat_radar_screen.dart';
import 'dart:async'; // Para poder usar el Timer

class AsteroidesVagabundos extends StatefulWidget {
  const AsteroidesVagabundos({super.key});

  @override
  State<AsteroidesVagabundos> createState() => _AsteroidesVagabundosState();
}

class _AsteroidesVagabundosState extends State<AsteroidesVagabundos> with SingleTickerProviderStateMixin {
  // 🛰️ Nivel de alerta (0: Verde, 1: Naranja, 2: Rojo)
  int _nivelAlerta = 0;

  //Creo una variable que me ayude a controlar el tiempo de carga de la lista de satelites
  bool _estaEscaneando = true; // Empieza en true para que escanee al abrir
  Timer? _chocoCronometro;

  List<Asteroid> _asteroidesVisibles = []; // Nuestra lista filtrada

  // 2. Declaramos el controlador del Radar
  late AnimationController _radarController;

@override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 🚀 PRE-CARGA ESTRATÉGICA: Metemos los 4 satélites en la RAM
    precacheImage(const AssetImage('assets/images/planetas/satelite_purpura.png'), context);
    precacheImage(const AssetImage('assets/images/planetas/satelite_verde.png'), context);
    precacheImage(const AssetImage('assets/images/planetas/satelite_naranja.png'), context);
    precacheImage(const AssetImage('assets/images/planetas/satelite_rojo.png'), context);
  }

  @override
  void initState() {
    super.initState();

    // Inicializamos el motor del radar (una pulsación cada 1.5 segundos)
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Como la app inicia escaneando, lo encendemos de una vez
    _radarController.repeat();

    _escanearEspacio();
    
    // 🕒 CONFIGURAMOS EL LATIDO: Cada 5 minutos vuelve a escanear solo
    _chocoCronometro = Timer.periodic(const Duration(minutes: 5), (timer) {
      debugPrint('💓 [SISTEMA] Latido detectado. Iniciando re-escaneo automático...');
      _escanearEspacio();
    });
  }

  // 🛰️ Añadimos un parámetro opcional. Por defecto será 'true' (4 segundos).
  void _escanearEspacio({bool esDramatico = true}) async {
    if (!mounted) return;

    setState(() {
      _estaEscaneando = true; 
    });

    // 🔊 ¡Encendemos la animación del radar!
    _radarController.repeat();

    debugPrint('🛰️ [RADAR] Iniciando barrido ${esDramatico ? "PROFUNDO" : "TURBO"}...');

    // 🕒 LA CLAVE: Si es dramático esperamos 4s, si no, solo 1s.
    // 1 segundo es ideal para que el usuario vea un breve parpadeo púrpura
    // y sienta que la app realmente verificó los datos al volver.
    int segundos = esDramatico ? 4 : 1;
    await Future.delayed(Duration(seconds: segundos));

    final radar = await getNeoRadarInfoDio();
    
    if (radar != null && mounted) {
      setState(() {
        final ahora = DateTime.now();
        final limiteFuturo = ahora.add(const Duration(hours: 5));

        final meses = {
          'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04',
          'May': '05', 'Jun': '06', 'Jul': '07', 'Aug': '08',
          'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12'
        };

        final listaFiltrada = radar.asteroides.where((a) {
          try {
            List<String> bloqueFechaHora = a.fechaAproximacion.split(' ');
            List<String> partesFecha = bloqueFechaHora[0].split('-');
            String mesNum = meses[partesFecha[1]] ?? '01';
            DateTime horaAsteroide = DateTime.parse("${partesFecha[0]}-$mesNum-${partesFecha[2]} ${bloqueFechaHora[1]}");
            return horaAsteroide.isAfter(ahora) && horaAsteroide.isBefore(limiteFuturo);
          } catch (e) { return false; }
        }).toList();

        _asteroidesVisibles = listaFiltrada;

        if (listaFiltrada.isEmpty) {
          _nivelAlerta = 0;
        } else {
          bool hayPeligroReal = listaFiltrada.any((a) => a.esPeligroso);
          _nivelAlerta = hayPeligroReal ? 2 : 1;
        }

        _estaEscaneando = false; 
      });
    } else if (mounted) {
      setState(() {
        _estaEscaneando = false;
        // 🔇 ¡Apagamos la animación del radar porque ya terminó!
        _radarController.stop();
        _radarController.reset();
      });
    }
  }

  @override
  void dispose() {
    _chocoCronometro?.cancel(); // Apagamos el motor para no gastar batería
    _radarController.dispose(); // IMPORTANTÍSIMO: Destruir el motor al salir
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🎨 Declaramos las variables para nuestra nueva UI Premium
    String rutaImagen;
    String textoAlerta;
    Color colorTexto;
    /*rutaImagen = 'assets/images/planetas/satelite_purpura.png';
      textoAlerta = "ESCANEANDO SECTOR...";
      colorTexto = const Color.fromARGB(255, 126, 92, 184); // Morado
    */
    // 🧠 Lógica del Camaleón 3D
    if (_estaEscaneando) {
      rutaImagen = 'assets/images/planetas/satelite_purpura.png';
      textoAlerta = "ESCANEANDO SECTOR...";
      colorTexto = const Color.fromARGB(255, 126, 92, 184); // Morado
    } else {
      if (_nivelAlerta == 2) {
        rutaImagen = 'assets/images/planetas/satelite_rojo.png';
        textoAlerta = "¡Choco-Amenaza!";
        colorTexto = Colors.redAccent;
      } else if (_nivelAlerta == 1) {
        rutaImagen = 'assets/images/planetas/satelite_naranja.png';
        textoAlerta = "Objetos cercanos";
        colorTexto = Colors.orangeAccent;
      } else {
        rutaImagen = 'assets/images/planetas/satelite_verde.png';
        textoAlerta = "Choco-Seguro";
        colorTexto = Colors.greenAccent;
      }
    }

    return Positioned(
      bottom: -40,
      left: -1,
      child: GestureDetector(
        onTap: () async {
          // Vamos al radar
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ThreatRadarScreen(
                asteroidesFiltrados: _asteroidesVisibles, 
              ),
            ),
          );
          // 2. ¡ESTA ES LA JUGADA! 
          // En cuanto el usuario regresa (hace pop), lanzamos el escaneo rápido.
          // No necesitamos el setState manual aquí porque _escanearEspacio ya lo hace.
          _escanearEspacio(esDramatico: false);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🛰️ ¡ADIÓS ICONO VIEJO, HOLA IMAGEN 3D!
            Stack(
              children: [

                // 📡 Las ondas de radio (Ahora flotan sin ocupar espacio real)
                if (_estaEscaneando)
                  Positioned(
                    bottom: 18,
                    right: 20,
                    // 👈 Al ponerlo en un Positioned, Flutter lo ignora para el tamaño
                    width: 60, 
                    height: 60,
                    child: AnimatedBuilder(
                      animation: _radarController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: RadarWavesPainter(
                            progreso: _radarController.value,
                            colorOnda: colorTexto, 
                          ),
                        );
                      },
                    ),
                  ),
                // Tu Satélite 3D Intacto (Encima de las ondas)
                Image.asset(
                rutaImagen,
                key: ValueKey(rutaImagen),
                gaplessPlayback: false,
                width: 110, // Puedes hacer este número más grande o pequeño según te guste
                height: 110,
                fit: BoxFit.contain, // Asegura que no se deforme
              ),
              ],
            ),
            
            // 📟 Mini Panel de Estado (Mantenemos tu diseño que estaba genial)
            Transform.translate(
              offset:const Offset(0, -29), // <--- LA MAGIA: El -15 empuja el texto hacia arriba
              child: Container(
                width: 132.0,
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: colorTexto.withValues(alpha: 0.1),
                  border: Border.all(color: colorTexto, width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  textoAlerta,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorTexto,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------------
// 🎨 PINTOR DE ONDAS DE RADAR
// --------------------------------------------------------
class RadarWavesPainter extends CustomPainter {
  final double progreso;
  final Color colorOnda;

  RadarWavesPainter({required this.progreso, required this.colorOnda});

  @override
  void paint(Canvas canvas, Size size) {
    final centro = Offset(size.width / 2, size.height / 2);
    final radioMaximo = size.width / 2;

    // Función interna para dibujar un anillo
    void dibujarAnillo(double desfase) {
      // El valor fluye de 0.0 a 1.0 y vuelve a empezar
      double progresoActual = (progreso + desfase) % 1.0;
      
      final radioActual = radioMaximo * progresoActual;
      // La opacidad baja a medida que se hace grande (se desvanece)
      final opacidad = 1.0 - progresoActual;

      final pintura = Paint()
        ..color = colorOnda.withValues(alpha: opacidad)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0; // Grosor del rayito

      canvas.drawCircle(centro, radioActual, pintura);
    }

    // Dibujamos 3 ondas al mismo tiempo, desfasadas para dar un efecto continuo
    dibujarAnillo(0.0);
    dibujarAnillo(0.33);
    dibujarAnillo(0.66);
  }

  @override
  bool shouldRepaint(covariant RadarWavesPainter oldDelegate) {
    // Redibujar siempre que el progreso cambie
    return oldDelegate.progreso != progreso;
  }
}
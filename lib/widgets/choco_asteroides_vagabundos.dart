//Archivo: widgets/asteroides_vagabundos.dart
import '../services/choco_service_http.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math; // 🎲 El generador de azar
import '../screens/choco_threat_radar_screen.dart'; // Tu pantalla del radar

class AsteroidesVagabundos extends StatefulWidget {
  const AsteroidesVagabundos({super.key});

  @override
  State<AsteroidesVagabundos> createState() => _AsteroidesVagabundosState();
}

// 🧘‍♂️ SingleTickerProviderStateMixin es la licencia para animar
class _AsteroidesVagabundosState extends State<AsteroidesVagabundos> 

    with SingleTickerProviderStateMixin {
  
  // 🎮 Nuestro motor de movimiento
  late AnimationController _controladorVagabundo;
  // 🛤️ El camino que recorrerá (Coordenadas X, Y)
  late Animation<Offset> _animacionPosicion;
  // 🎲 El dado espacial
  final math.Random _random = math.Random();
  
  // Como nuestro Sol (0,0) está en el centro, los asteroides pueden 
  // viajar en coordenadas negativas (ej. -250) o positivas (ej. 250).
  Offset _posicionActual = const Offset(0.0, 0.0);

  // 🚦 Nuestro semáforo (null = escaneando, true = rojo, false = verde) para que se mantenga verde si no hay amenazas y cambie a rojo si las hay
  bool? _hayPeligro;

  @override
  void initState() {
    super.initState();
    
    // 1. Configuramos el motor: viaje dura entre 10 y 15 segundos (aleatorio)
    _controladorVagabundo = AnimationController(
      vsync: this,
      // Un tiempo variable para que no parezca un robot
      duration: Duration(seconds: _random.nextInt(6) + 10), 
    );

    // Llamamos a la NASA en silencio
    _escanearPeligroOculto();

    // 2. Iniciamos el primer viaje
    _generarNuevoViaje();

    // 3. 🚨 El Bucle Infinito: Escuchamos cuando termina el viaje
    _controladorVagabundo.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Cuando llega a su destino, generamos uno nuevo y volvemos a arrancar
        _generarNuevoViaje();
        _controladorVagabundo.forward(from: 0.0); // Reset y arranca
      }
    });

    // 4. Arrancamos el primer viaje
    _controladorVagabundo.forward();
  }

  // 🎲 Táctica: Generar nuevas coordenadas aleatorias dentro de la pantalla
  void _generarNuevoViaje() {
    // Generamos coordenadas X y Y aleatorias entre -250 y 250 píxeles.
    // Esto hace que viajen por toda la caja de 520 de alto de tu Sistema Solar.
    // Le doy un poco más de rango (500 de ancho total).
    double destinoX = (_random.nextDouble() * 500) - 250;
    double destinoY = (_random.nextDouble() * 500) - 250;

    Offset posicionDestino = Offset(destinoX, destinoY);

    // Creamos la animación del camino suave (de la actual a la de destino)
    _animacionPosicion = Tween<Offset>(
      begin: _posicionActual,
      end: posicionDestino,
    ).animate(CurvedAnimation(
      parent: _controladorVagabundo,
      curve: Curves.easeInOutSine, // Una curva suave y "espacial"
    ));

    // Actualizamos la posición actual para el próximo viaje
    _posicionActual = posicionDestino;
  }

  @override
  void dispose() {
    // 🛑 Apagamos el motor al salir (Vital para la memoria)
    _controladorVagabundo.dispose();
    super.dispose();
  }


  // 📡 El asteroide llama a la NASA en secreto
  void _escanearPeligroOculto() async {
    final radar = await getNeoRadarInfoDio();
    if (radar != null && mounted) {
      setState(() {
        // Buscamos si AL MENOS UN asteroide es peligroso hoy
        _hayPeligro = radar.asteroides.any((asteroide) => asteroide.esPeligroso);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos AnimatedBuilder para redibujar en cada frame sin Positioned
    
    // 🚦 LÓGICA DEL SEMÁFORO: Decidimos color y texto
    final colorHolograma = _hayPeligro == null
        ? Colors.orangeAccent // 🟠 Mientras le pregunta a la NASA
        : _hayPeligro! 
            ? Colors.redAccent // 🔴 ¡Peligro inminente!
            : Colors.greenAccent; // 🟢 Todo tranquilo

    final textoHolograma = _hayPeligro == null
        ? 'ESCANEANDO...'
        : _hayPeligro! 
            ? 'ALERTA NEO'
            : 'ESPACIO SEGURO';
    return AnimatedBuilder(
      animation: _animacionPosicion,
      builder: (context, child) {
        // Transform.translate mueve el widget libremente en el espacio X, Y 
        // desde el centro (el Sol, punto 0,0)
        return Transform.translate(
          offset: _animacionPosicion.value,
          child: child!, // Pintamos el asteroide (que pasamos como 'child' abajo)
        );
      },
      
      // 🍫 EL ASTEROIDE INTERACTIVO (Tu código original, LIMPIO)
      child: GestureDetector(
        onTap: () {
          // 🚀 ¡Hiperespacio hacia el Radar NEO!
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ThreatRadarScreen()),
          );
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Vital para no ocupar todo el alto
          children: [
            // 🛡️ CORRECCIÓN VISUAL: Eliminamos el Container con boxShadow.
            // Ahora dibujamos la imagen PURA dentro de un SizedBox para el tamaño.
            SizedBox(
              width: 80.0, // Un poquito más grande para que se note el chocolate
              height: 80.0,
              child: Image.asset(
                'assets/images/planetas/choco_asteroides.png', // ⚠️ Asegúrate de tu ruta correcta
                fit: BoxFit.contain,
              ),
            ),
            
            const SizedBox(height: 10.0),
            
            // 📟 EL HOLOGRAMA DE ALERTA (Se queda igual porque es puro diseño HUDS)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
              decoration: BoxDecoration(
                color: colorHolograma.withValues(alpha: 0.2), // Casi transparente
                border: Border.all(color: colorHolograma, width: 1),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                textoHolograma,
                style: TextStyle(
                  color: colorHolograma,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
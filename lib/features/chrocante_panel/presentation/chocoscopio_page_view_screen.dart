import 'package:choco_universe/models/choco_imagen_deldia_model.dart';
import 'package:choco_universe/models/choco_systeme_solaire_model.dart';
import 'package:flutter/material.dart';

// 🪐 NUEVA CLASE: Nuestro formato de datos traducido
class AstroLocal {
  final String idOriginal;
  final String nombreEspanol;
  final String gravedad;
  final String densidad;
  final String temperatura;
  final String lunas;

  AstroLocal({
    required this.idOriginal,
    required this.nombreEspanol,
    required this.gravedad,
    required this.densidad,
    required this.temperatura,
    required this.lunas,
  });
}

class ChocosCopioPageViewScreen extends StatefulWidget {
  final ImagenDelDia? image;
  final SystemeSolaire? planets;

  const ChocosCopioPageViewScreen({super.key, this.image, this.planets});

  @override
  State<ChocosCopioPageViewScreen> createState() => _ChocosCopioPageViewScreen();
}

class _ChocosCopioPageViewScreen extends State<ChocosCopioPageViewScreen> with SingleTickerProviderStateMixin {
  int _planetaActualIndex = 0;
  late AnimationController _anillosController;
  
  List<AstroLocal> _astros = [];

  @override
  void initState() {
    super.initState();
    _anillosController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    _prepararDatosEspaciales();
  }

  void _prepararDatosEspaciales() {
    if (widget.planets == null || widget.planets!.bodies.isEmpty) return;

    final traducciones = {
      'Mercure': 'MERCURIO',
      'Vénus': 'VENUS',
      'La Terre': 'LA TIERRA',
      'Mars': 'MARTE',
      'Jupiter': 'JÚPITER',
      'Saturne': 'SATURNO',
      'Uranus': 'URANO',
      'Neptune': 'NEPTUNO',
    };

    List<AstroLocal> nuevaLista = [];

    nuevaLista.add(AstroLocal(
      idOriginal: 'Soleil',
      nombreEspanol: 'EL SOL',
      gravedad: '274.0',
      densidad: '1.41',
      temperatura: '5778',
      lunas: '8 planetas',
    ));

    for (var p in widget.planets!.bodies) {
      nuevaLista.add(AstroLocal(
        idOriginal: p.name,
        nombreEspanol: traducciones[p.name] ?? p.name.toUpperCase(),
        gravedad: p.gravity.toString(),
        densidad: p.density.toString(),
        temperatura: p.avgTemp.toString(),
        lunas: '${p.moons?.length ?? 0} detectados',
      ));
    }

    setState(() {
      _astros = nuevaLista;
    });
  }

  @override
  void dispose() {
    _anillosController.dispose();
    super.dispose();
  }

  final Map<String, String> posters2D = {
    'Soleil': 'assets/images/planetas/sol.png',
    'Mercure': 'assets/images/planetas/mercurio.png',
    'Vénus': 'assets/images/planetas/venus.png',
    'La Terre': 'assets/images/planetas/tierra.png',
    'Mars': 'assets/images/planetas/marte.png',
    'Jupiter': 'assets/images/planetas/jupiter.png',
    'Saturne': 'assets/images/planetas/saturno.png',
    'Uranus': 'assets/images/planetas/urano.png',
    'Neptune': 'assets/images/planetas/neptuno.png',
  };

  void _cambiarDestino(int nuevoIndex) {
    setState(() {
      _planetaActualIndex = nuevoIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_astros.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Color(0xFFCD7F32))),
      );
    }

    final astroActual = _astros[_planetaActualIndex];
    final urlPoster = posters2D[astroActual.idOriginal] ?? 'assets/images/planetas/tierra.png';

    return Scaffold(
      backgroundColor: const Color(0xFF0B0D17),
      body: Stack(
        children: [
          // 1. EL RESPLANDOR ESTELAR DE FONDO
          Positioned(
            top: 0,
            right: 100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFCD7F32).withValues(alpha: 0.08),
                    blurRadius: 200,
                    spreadRadius: 80,
                  ),
                ],
              ),
            ),
          ),

          // 2. LA LÍNEA DE ÓRBITA
          Center(
            child: Transform.rotate(
              angle: -0.3, 
              child: Container(
                width: double.infinity,
                height: 2,
                color: const Color(0xFFCD7F32).withValues(alpha: 0.2),
              ),
            ),
          ),

          // 3. EL PLANETA ANTERIOR (Allá lejos en el fondo, abajo a la izquierda)
          Positioned(
            bottom: 120,
            left: 40,
            child: _planetaActualIndex > 0
                ? _buildPlanetaDistante(
                    astro: _astros[_planetaActualIndex - 1],
                    indiceDestino: _planetaActualIndex - 1,
                  )
                // 🛡️ TRUCO PRIME: Si no hay planeta, ponemos una caja vacía en vez de borrar el widget
                : const SizedBox.shrink(), 
          ),

          // 4. EL SIGUIENTE PLANETA (Allá lejos en el fondo, arriba a la derecha)
          Positioned(
            top: 140,
            right: 40,
            child: _planetaActualIndex < _astros.length - 1
                ? _buildPlanetaDistante(
                    astro: _astros[_planetaActualIndex + 1],
                    indiceDestino: _planetaActualIndex + 1,
                  )
                // 🛡️ TRUCO PRIME: Mantiene la estructura del árbol de widgets intacta
                : const SizedBox.shrink(),
          ),

          // 5. EL PLANETA ACTIVO (LA MAGIA DE HOWARTS ESTÁ AQUÍ 🪄✨)
          Positioned(
            right: 20,
            top: MediaQuery.of(context).size.height * 0.25,
            child: SizedBox(
              width: 280,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildAnillosHolograficos(280),
                  
                  SizedBox(
                    width: 200, 
                    height: 200,
                    // 🔥 EL MOTOR DE CURVATURA "WARP JUMP" 🔥
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 700),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      
                      // 🛠️ EL ARREGLO TÁCTICO: Comparamos usando el ÍNDICE, no la URL
                      final isEntering = child.key == ValueKey<int>(_planetaActualIndex);

                      if (isEntering) {
                        // 🌠 El nuevo astro viene desde el fondo
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.05, end: 1.0).animate(animation),
                            child: child,
                          ),
                        );
                      } else {
                        // 💥 El astro viejo vuela hacia nosotros
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 4.0, end: 1.0).animate(animation),
                            child: child,
                          ),
                        );
                      }
                    },
                    child: Image.asset(
                      urlPoster,
                      // 🛠️ EL NÚCLEO DEL ARREGLO: La llave ahora es el índice del planeta (0, 1, 2, 3...)
                      key: ValueKey<int>(_planetaActualIndex), 
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.warning, color: Colors.red, size: 50),
                    ),
                  ),
                  ),
                ],
              ),
            ),
          ),

          // 6. PANEL DE DATOS ESTILO "KORHAL" (Con desvanecimiento holográfico)
          Positioned(
            left: 30,
            top: MediaQuery.of(context).size.height * 0.35,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              // La clave es el índice. Al cambiar, todo el panel de texto hace Cross-Fade
              child: Column(
                key: ValueKey<int>(_planetaActualIndex),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        astroActual.nombreEspanol,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4.0,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.my_location, color: Color(0xFFCD7F32), size: 20),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(width: 200, height: 1, color: const Color(0xFFCD7F32).withValues(alpha: 0.5)),
                  const SizedBox(height: 15),
                  
                  _buildDatoLateral('GRAVEDAD', '${astroActual.gravedad} m/s²'),
                  _buildDatoLateral('DENSIDAD', '${astroActual.densidad} g/cm³'),
                  _buildDatoLateral('TEMP. MEDIA', '${astroActual.temperatura} K'),
                  _buildDatoLateral('SATÉLITES', astroActual.lunas),
                ],
              ),
            ),
          ),

          // 7. ENCABEZADO SUPERIOR
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'MAPA CELESTIAL',
                    style: TextStyle(
                      color: Color(0xFFCD7F32),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 6.0,
                    ),
                  ),
                  Text(
                    'SELECCIONA DESTINO',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 10, letterSpacing: 4.0),
                  ),
                ],
              ),
            ),
          ),

          // 8. BOTÓN DE VIAJE CENTRAL (Abajo)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Preparando salto hiperespacial hacia ${astroActual.nombreEspanol}... 🚀'), 
                      backgroundColor: const Color(0xFFCD7F32)
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B0D17),
                    border: Border.all(color: const Color(0xFFCD7F32), width: 2),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFFCD7F32).withValues(alpha: 0.3), blurRadius: 10, spreadRadius: 1),
                    ],
                  ),
                  child: const Text(
                    'VIAJAR',
                    style: TextStyle(color: Color(0xFFCD7F32), fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 3.0),
                  ),
                ),
              ),
            ),
          ),

          // 9. BOTÓN CERRAR (Arriba Izquierda)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFCD7F32), size: 24),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanetaDistante({required AstroLocal astro, required int indiceDestino}) {
    final poster = posters2D[astro.idOriginal] ?? 'assets/images/planetas/tierra.png';
    
    return GestureDetector(
      onTap: () => _cambiarDestino(indiceDestino),
      child: Column(
        children: [
          Text(
            astro.nombreEspanol,
            style: const TextStyle(
              color: Color(0xFFCD7F32), 
              fontSize: 12, 
              fontWeight: FontWeight.bold, 
              letterSpacing: 2.0
            ),
          ),
          const SizedBox(height: 5),
          Opacity(
            opacity: 0.6,
            child: Image.asset(poster, width: 70, height: 70),
          ),
        ],
      ),
    );
  }

  Widget _buildDatoLateral(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              titulo,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 10, letterSpacing: 1.5),
            ),
          ),
          Text(
            valor,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildAnillosHolograficos(double size) {
    return AnimatedBuilder(
      animation: _anillosController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: _anillosController.value * 2 * 3.1415,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFCD7F32).withValues(alpha: 0.2), width: 1),
                ),
              ),
            ),
            Transform.rotate(
              angle: -(_anillosController.value * 4 * 3.1415),
              child: Container(
                width: size * 0.85,
                height: size * 0.85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFCD7F32).withValues(alpha: 0.4), width: 2),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
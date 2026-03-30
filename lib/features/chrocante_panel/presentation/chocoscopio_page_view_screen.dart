import 'dart:math';
import 'package:choco_universe/features/chrocante_panel/presentation/chocoscopio_orbita_screen.dart';
import 'package:choco_universe/models/choco_imagen_deldia_model.dart';
import 'package:choco_universe/models/choco_systeme_solaire_model.dart';
import 'package:flutter/material.dart';

// ☀️ DOBLE DE ACCIÓN PARA EL SOL (Para engañar a la pantalla de Órbita)
class EstrellaMock {
  final String bodyType = 'Estrella (Enana Amarilla)';
  final String discoveredBy = 'La Humanidad';
  final String discoveryDate = 'Desde el principio de los tiempos';
  final String englishName = 'The Sun';
}

// 🪐 NUESTRO FORMATO TRADUCIDO
class AstroLocal {
  final String idOriginal;
  final String nombreEspanol;
  final String gravedad;
  final String densidad;
  final String temperatura;
  final String lunas;
  final dynamic planetaCrudo; // 👈 ¡AQUÍ GUARDAMOS LOS DATOS DE LA API!

  AstroLocal({
    required this.idOriginal,
    required this.nombreEspanol,
    required this.gravedad,
    required this.densidad,
    required this.temperatura,
    required this.lunas,
    required this.planetaCrudo,
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
  bool _movimientoHaciaAdelante = true; // 👈 BRÚJULA TÁCTICA PARA EL CARRUSEL
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
      'Mercure': 'MERCURIO', 'Vénus': 'VENUS', 'La Terre': 'LA TIERRA',
      'Mars': 'MARTE', 'Jupiter': 'JÚPITER', 'Saturne': 'SATURNO',
      'Uranus': 'URANO', 'Neptune': 'NEPTUNO',
    };

    List<AstroLocal> nuevaLista = [];

    // INYECTAMOS AL SOL
    nuevaLista.add(AstroLocal(
      idOriginal: 'Soleil',
      nombreEspanol: 'EL SOL',
      gravedad: '274.0', densidad: '1.41', temperatura: '5778', lunas: '8 planetas',
      planetaCrudo: EstrellaMock(), // 👈 Le pasamos nuestro doble de acción
    ));

    for (var p in widget.planets!.bodies) {
      nuevaLista.add(AstroLocal(
        idOriginal: p.name,
        nombreEspanol: traducciones[p.name] ?? p.name.toUpperCase(),
        gravedad: p.gravity.toString(), densidad: p.density.toString(),
        temperatura: p.avgTemp.toString(), lunas: '${p.moons?.length ?? 0} detectados',
        planetaCrudo: p, // 👈 Le pasamos los datos reales de la API
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

  // 🛑 MAPA DE MODELOS 3D (Lo necesitamos de vuelta para pasarlo a la Órbita)
  final Map<String, String> modelos3D = {
    'Mercure': 'assets/images/3d/mercurio.glb',
    'Vénus': 'assets/images/3d/venus.glb',
    'La Terre': 'assets/images/3d/tierra.glb',
    'Mars': 'assets/images/3d/marte.glb',
    'Jupiter': 'assets/images/3d/jupiter.glb',
    'Saturne': 'assets/images/3d/saturno.glb',
    'Uranus': 'assets/images/3d/urano.glb',
    'Neptune': 'assets/images/3d/neptuno.glb',
  };

  final Map<String, String> posters2D = {
    'Soleil': 'assets/images/planetas/sol.png',
    'Mercure': 'assets/images/planetas/mercurio.png',
    'Vénus': 'assets/images/planetas/venus.png',
    'La Terre': 'assets/images/planetas/tierra.png',
    'Mars': 'assets/images/planetas/marte.png',
    'Jupiter': 'assets/images/planetas/jupiter.png',
    'Saturne': 'assets/images/planetas/saturno2.png',
    'Uranus': 'assets/images/planetas/urano.png',
    'Neptune': 'assets/images/planetas/neptuno.png',
  };

  void _cambiarDestino(int nuevoIndex) {
    setState(() {
      _movimientoHaciaAdelante = nuevoIndex > _planetaActualIndex;
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

          // ✨ 0. EL NUEVO POLVO ESTELAR
          const FondoEstelar(),
          // 1. EL RESPLANDOR ESTELAR DE FONDO
          Positioned(
            top: 0, right: 100,
            child: Container(
              width: 500, height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: const Color(0xFFCD7F32).withValues(alpha: 0.08), blurRadius: 200, spreadRadius: 80),
                ],
              ),
            ),
          ),

          // 2. LA LÍNEA DE ÓRBITA
          Center(
            child: Transform.rotate(
              angle: -0.3,
              child: Container(width: double.infinity, height: 2, color: const Color(0xFFCD7F32).withValues(alpha: 0.2)),
            ),
          ),

          // 3. EL PLANETA ANTERIOR (Escudo Estructural Activo 🛡️)
          Positioned(
            bottom: 120, left: 40,
            // Usamos Opacity en vez de "if" para que el widget NUNCA desaparezca del árbol
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _planetaActualIndex > 0 ? 1.0 : 0.0,
              child: IgnorePointer(
                ignoring: _planetaActualIndex <= 0,
                child: _buildPlanetaDistante(
                  astro: _astros[_planetaActualIndex > 0 ? _planetaActualIndex - 1 : 0],
                  indiceDestino: _planetaActualIndex > 0 ? _planetaActualIndex - 1 : 0,
                ),
              ),
            ),
          ),

          // 4. EL SIGUIENTE PLANETA (Escudo Estructural Activo 🛡️)
          Positioned(
            top: 140, right: 40,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _planetaActualIndex < _astros.length - 1 ? 1.0 : 0.0,
              child: IgnorePointer(
                ignoring: _planetaActualIndex >= _astros.length - 1,
                child: _buildPlanetaDistante(
                  astro: _astros[_planetaActualIndex < _astros.length - 1 ? _planetaActualIndex + 1 : _astros.length - 1],
                  indiceDestino: _planetaActualIndex < _astros.length - 1 ? _planetaActualIndex + 1 : _astros.length - 1,
                ),
              ),
            ),
          ),

          // 5. EL PLANETA ACTIVO (CARRUSEL CILÍNDRICO DE FLUTTER MÉXICO 🚀)
          Positioned(
            right: 20,
            top: MediaQuery.of(context).size.height * 0.25,
            child: SizedBox(
              width: 280, height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildAnillosHolograficos(280),
                  
                  SizedBox(
                    width: 200, height: 200,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 700),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        final isEntering = child.key == ValueKey<int>(_planetaActualIndex);

                        // Lógica de movimiento diagonal interactivo
                        Offset posicionLejana;
                        if (_movimientoHaciaAdelante) {
                          posicionLejana = isEntering ? const Offset(0.8, -0.8) : const Offset(-0.8, 0.8);
                        } else {
                          posicionLejana = isEntering ? const Offset(-0.8, 0.8) : const Offset(0.8, -0.8);
                        }

                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: isEntering
                                ? Tween<Offset>(begin: posicionLejana, end: Offset.zero).animate(animation)
                                : Tween<Offset>(begin: Offset.zero, end: posicionLejana).animate(animation),
                            child: ScaleTransition(
                              scale: isEntering
                                  ? Tween<double>(begin: 0.4, end: 1.0).animate(animation)
                                  : Tween<double>(begin: 1.0, end: 0.4).animate(animation),
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: Image.asset(
                        urlPoster,
                        key: ValueKey<int>(_planetaActualIndex), // Crucial para la animación
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.warning, color: Colors.red, size: 50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 6. PANEL DE DATOS ESTILO "KORHAL" (Sincronizado y fluido)
          Positioned(
            left: 30,
            top: MediaQuery.of(context).size.height * 0.35,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
                return Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[...previousChildren, if (currentChild != null) currentChild],
                );
              },
              child: Column(
                key: ValueKey<int>(_planetaActualIndex),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        astroActual.nombreEspanol,
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 4.0),
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
                  const Text('MAPA CELESTIAL', style: TextStyle(color: Color(0xFFCD7F32), fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 6.0)),
                  Text('SELECCIONA DESTINO', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 10, letterSpacing: 4.0)),
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
                  // 🚀 INICIANDO SALTO HIPERESPACIAL (Ajustado)
                  // Quitamos el default '?? tierra.glb' para que sea nulo si no existe
                  final String? urlModelo = modelos3D[astroActual.idOriginal]; 

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChocosCopioOrbitaScreen(
                        nombreEspanol: astroActual.nombreEspanol,
                        urlPoster: urlPoster,
                        urlModelo: urlModelo, // 👈 Ahora pasamos la URL o pasamos NULL
                        planetaOriginal: astroActual.planetaCrudo,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B0D17),
                    border: Border.all(color: const Color(0xFFCD7F32), width: 2),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [BoxShadow(color: const Color(0xFFCD7F32).withValues(alpha: 0.3), blurRadius: 10, spreadRadius: 1)],
                  ),
                  child: const Text('VIAJAR', style: TextStyle(color: Color(0xFFCD7F32), fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 3.0)),
                ),
              ),
            ),
          ),

          // 9. BOTÓN CERRAR
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
          Text(astro.nombreEspanol, style: const TextStyle(color: Color(0xFFCD7F32), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
          const SizedBox(height: 5),
          Opacity(opacity: 0.6, child: Image.asset(poster, width: 70, height: 70)),
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
          SizedBox(width: 100, child: Text(titulo, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 10, letterSpacing: 1.5))),
          Text(valor, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
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
            Transform.rotate(angle: _anillosController.value * 2 * 3.1415, child: Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFCD7F32).withValues(alpha: 0.2), width: 1)))),
            Transform.rotate(angle: -(_anillosController.value * 4 * 3.1415), child: Container(width: size * 0.85, height: size * 0.85, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFCD7F32).withValues(alpha: 0.4), width: 2)))),
          ],
        );
      },
    );
  }
}


// ✨ WIDGET: EL FONDO ESTELAR MATEMÁTICO
class FondoEstelar extends StatelessWidget {
  const FondoEstelar({super.key});

  @override
  Widget build(BuildContext context) {

    final random = Random(42); // La semilla '42' mantiene las estrellas quietas en cada recarga

    return Stack(
      children: List.generate(150, (index) {
        return Positioned(
          top: random.nextDouble() * MediaQuery.of(context).size.height,
          left: random.nextDouble() * MediaQuery.of(context).size.width,
          child: Container(
            width: random.nextDouble() * 2 + 1, // Tamaño aleatorio entre 1 y 3 píxeles
            height: random.nextDouble() * 2 + 1,
            decoration: BoxDecoration(
              // Opacidad aleatoria para dar sensación de profundidad (algunas más lejos que otras)
              color: Colors.white.withValues(alpha: random.nextDouble() * 0.8 + 0.2),
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}
import 'package:choco_universe/models/choco_imagen_deldia_model.dart';
import 'package:choco_universe/models/choco_systeme_solaire_model.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
// IMPORTANTE: Importamos el motor 3D
import 'package:model_viewer_plus/model_viewer_plus.dart'; 

class ChocosCopioPageViewScreen extends StatefulWidget {
  // Recibimos la imagen de fondo y los planetas
  final ImagenDelDia? image;
  final SystemeSolaire? planets;

  const ChocosCopioPageViewScreen({super.key, this.image, this.planets});

  @override
  State<ChocosCopioPageViewScreen> createState() => _ChocosCopioPageViewScreen();
}

class _ChocosCopioPageViewScreen extends State<ChocosCopioPageViewScreen> {
  // Controlador para saber en qué página (planeta) estamos
  final PageController _pageController = PageController(initialPage: 0);
  int _planetaActual = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // 🛑 TEMPORAL: Mapa de URLs de sus modelos en Cloudinary o rutas locales
  // Ajuste estas rutas con sus links reales de Cloudinary o 'assets/models/...'
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

  // 🖼️ MAPA DE PÓSTERS 2D (Para evitar la pantalla negra mientras carga el 3D)
  final Map<String, String> posters2D = {
    'Mercure': 'assets/images/planetas/mercurio.png',
    'Vénus': 'assets/images/planetas/venus.png',
    'La Terre': 'assets/images/planetas/tierra.png',
    'Mars': 'assets/images/planetas/marte.png',
    'Jupiter': 'assets/images/planetas/jupiter.png',
    'Saturne': 'assets/images/planetas/saturno.png',
    'Uranus': 'assets/images/planetas/urano.png',
    'Neptune': 'assets/images/planetas/neptuno.png',
  };

  @override
  Widget build(BuildContext context) {
    // Si no hay planetas, mostramos un radar buscando
    if (widget.planets == null || widget.planets!.bodies.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Color(0xFFCD7F32))),
      );
    }

    final listaPlanetas = widget.planets!.bodies;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0D17), // Fondo espacial
      body: Stack(
        children: [
          // 1. EL NAVEGADOR PRINCIPAL (PageView)
          // 1. EL NAVEGADOR PRINCIPAL (PageView)
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _planetaActual = index;
              });
            },
            itemCount: listaPlanetas.length,
            itemBuilder: (context, index) {
              final planeta = listaPlanetas[index];
              final urlModelo = modelos3D[planeta.name] ?? 'assets/images/3d/tierra.glb';
              final urlPoster = posters2D[planeta.name] ?? 'assets/images/planetas/tierra.png';
              
              // 🧠 EL CEREBRO DE LA OPERACIÓN: ¿Es este el planeta que estoy viendo?
              final bool esPlanetaActivo = _planetaActual == index;

              return SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 60.0), 
                    // TÍTULO MAJESTUOSO
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'CHOCOSCOPIO POV',
                        style: TextStyle(
                          color: Color(0xFFCD7F32),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4.0,
                        ),
                      ),
                    ),
                    Text(
                      planeta.name.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 8.0,
                      ),
                    ),
                    
                    // 🚀 EL MOTOR INTELIGENTE (Solo se enciende si es el planeta actual)
                    Expanded(
                      child: esPlanetaActivo 
                        ? ModelViewer(
                            backgroundColor: Colors.transparent,
                            src: urlModelo,
                            alt: "Modelo 3D de ${planeta.name}",
                            ar: false,
                            autoRotate: true, 
                            cameraControls: true, 
                            disableZoom: false,
                          )
                        // 🖼️ SI NO ES EL PLANETA ACTUAL, MOSTRAMOS LA IMAGEN 2D LIGERA
                        : Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Image.asset(urlPoster, fit: BoxFit.contain),
                          ),
                    ),
                    
                    const SizedBox(height: 140), 
                  ],
                ),
              );
            },
          ),

          // 👇 NUEVO: FLECHA IZQUIERDA
          if (_planetaActual > 0) // Solo se muestra si no estamos en el primer planeta
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white54, size: 40),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 500), 
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),

          // 👇 NUEVO: FLECHA DERECHA
          if (_planetaActual < listaPlanetas.length - 1) // Solo se muestra si no es el último
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 40),
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500), 
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),

          // 2. BOTÓN DE REGRESO (Arriba a la izquierda)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30), // Cambié a una 'X' para no confundir con las flechas de navegación
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // 3. EL HUD DE TELEMETRÍA (Panel de Cristal abajo)
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildHUDTelemetria(listaPlanetas[_planetaActual]),
          ),
        ],
      ),
    );
  }

  // 🎛️ PANEL DE CRISTAL (Glassmorphism) CON DATOS DE LA NASA
  Widget _buildHUDTelemetria(dynamic planeta) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          height: 130,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0B0D17).withValues(alpha: 0.7),
            border: Border(
              top: BorderSide(color: const Color(0xFFCD7F32).withValues(alpha: 0.5), width: 1.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDatoHUD(Icons.speed, 'Gravedad', '${planeta.gravity} m/s²'),
              _buildDatoHUD(Icons.public, 'Densidad', '${planeta.density} g/cm³'),
              _buildDatoHUD(Icons.thermostat, 'Temp. Media', '${planeta.avgTemp} K'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatoHUD(IconData icon, String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFFCD7F32), size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}
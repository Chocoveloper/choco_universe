import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ChocosCopioOrbitaScreen extends StatefulWidget {
  final String nombreEspanol;
  final String urlPoster;
  final String? urlModelo;
  final dynamic planetaOriginal; // Para sacar los datos de la API

  const ChocosCopioOrbitaScreen({
    super.key,
    required this.nombreEspanol,
    required this.urlPoster,
    this.urlModelo,
    required this.planetaOriginal,
  });

  @override
  State<ChocosCopioOrbitaScreen> createState() => _ChocosCopioOrbitaScreenState();
}

class _ChocosCopioOrbitaScreenState extends State<ChocosCopioOrbitaScreen> {
  // 🎛️ EL INTERRUPTOR MAESTRO: Controla si mostramos 2D o 3D
  bool _mostrar3D = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D17), // Fondo del espacio profundo
      body: Stack(
        children: [
          // 1. Resplandor de fondo
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFCD7F32).withValues(alpha: 0.15),
                    blurRadius: 150,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          // 2. Contenido principal (Scrollable por si hay mucha historia)
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ENCABEZADO Y BOTÓN VOLVER
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFCD7F32)),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          'ÓRBITA ESTABLECIDA',
                          style: TextStyle(color: Color(0xFFCD7F32), letterSpacing: 4.0, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        const SizedBox(width: 40), // Balance visual
                      ],
                    ),
                  ),

                  // EL VISOR CENTRAL (Alterna entre 2D y 3D)
                  SizedBox(
                    height: 350,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 800),
                      switchInCurve: Curves.easeOutBack,
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: FadeTransition(opacity: animation, child: child));
                      },
                      child: _mostrar3D
                          ? ModelViewer(
                              key: const ValueKey('visor_3d'),
                              backgroundColor: Colors.transparent,
                              src: widget.urlModelo ?? '',
                              alt: "Modelo 3D de ${widget.nombreEspanol}",
                              ar: false,
                              autoRotate: true,
                              cameraControls: true,
                            )
                          : Image.asset(
                              widget.urlPoster,
                              key: const ValueKey('visor_2d'),
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),

                  // TÍTULO DEL ASTRO
                  Text(
                    widget.nombreEspanol,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 10.0,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🎛️ BOTÓN DE ENCENDIDO 3D (Ocultado estratégicamente si no hay modelo)
                  if (widget.urlModelo != null && widget.urlModelo!.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _mostrar3D = !_mostrar3D;
                        });
                      },
                      child: Container(
                        // ... todo el código interno del Container, Row, Icon, Text queda igual ...
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        decoration: BoxDecoration(
                          color: _mostrar3D ? const Color(0xFFCD7F32) : Colors.transparent,
                          border: Border.all(color: const Color(0xFFCD7F32), width: 2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _mostrar3D ? Icons.memory : Icons.view_in_ar,
                              color: _mostrar3D ? Colors.black : const Color(0xFFCD7F32),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _mostrar3D ? 'APAGAR MOTOR 3D' : 'EXPLORAR EN 3D',
                              style: TextStyle(
                                color: _mostrar3D ? Colors.black : const Color(0xFFCD7F32),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                  if (widget.urlModelo == null) const SizedBox(height: 10), // Espacio extra si ocultamos el botón

                  const SizedBox(height: 40),

                  // DATOS DE LA API (HISTORIA / DETALLES)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFCD7F32).withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'REGISTRO DE TELEMETRÍA AVANZADA',
                            style: TextStyle(color: Color(0xFFCD7F32), fontSize: 12, letterSpacing: 2.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          _buildFilaDato('TIPO DE CUERPO', widget.planetaOriginal.bodyType),
                          _buildFilaDato('DESCUBIERTO POR', widget.planetaOriginal.discoveredBy.isEmpty ? 'Desconocido / Antigüedad' : widget.planetaOriginal.discoveredBy),
                          _buildFilaDato('FECHA DE DESC.', widget.planetaOriginal.discoveryDate.isEmpty ? 'Desde el principio de los tiempos' : widget.planetaOriginal.discoveryDate),
                          _buildFilaDato('NOMBRE INGLÉS', widget.planetaOriginal.englishName),
                          // Aquí puedes agregar más datos que vengan en tu clase 'Body'
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50), // Espacio al final
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET AUXILIAR PARA LA TABLA DE DATOS
  Widget _buildFilaDato(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              etiqueta,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12, letterSpacing: 1.0),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
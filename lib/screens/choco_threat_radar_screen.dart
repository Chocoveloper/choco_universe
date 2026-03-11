import 'package:choco_universe/models/choco_neo_radar_model.dart';
import 'package:choco_universe/services/choco_service_http.dart';
import 'package:flutter/material.dart';


class ThreatRadarScreen extends StatefulWidget {
  const ThreatRadarScreen({super.key});

  @override
  State<ThreatRadarScreen> createState() => _ThreatRadarScreenState();
}

class _ThreatRadarScreenState extends State<ThreatRadarScreen> {
  // 1. Declaramos nuestro "vigilante" del futuro.
  // Lo hacemos aquí para que la NASA solo se llame UNA VEZ al abrir la pantalla.
  late Future<NeoRadarResponse?> _radarFuture;

  @override
  void initState() {
    super.initState();
    // 2. Disparamos la petición a la NASA apenas entramos a la pantalla
    // (Asegúrate de instanciar tu servicio. Asumo que creaste una clase llamada NeoService)
    _radarFuture = getNeoRadarInfoDio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D17), // Nuestro fondo espacial profundo
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Barra transparente
        elevation: 0,
        title: const Text(
          'RADAR DE AMENAZAS ☄️',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Flecha de retroceso blanca
      ),
      
      // 📡 EL CORAZÓN DEL RADAR: El FutureBuilder
      body: FutureBuilder<NeoRadarResponse?>(
        future: _radarFuture,
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFCD7F32)));
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Error en el radar 📡', style: TextStyle(color: Colors.white)));
          }

          final listaAsteroides = snapshot.data!.asteroides;

          // 🛡️ AQUÍ ESTÁ EL CAMBIO: La columna que organiza todo
          return Column(
            children: [
              
              // 1. El cuadro de información (Altura fija, no da problemas)
              _buildBriefingBox(),

              // 2. La lista (¡ENVUELTA EN EXPANDED!)
              // Expanded obliga al ListView a ocupar SOLO el espacio que sobra,
              // evitando que se vuelva infinito y congele la app.
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 100.0,
                    ),
                  itemCount: listaAsteroides.length,
                  itemBuilder: (context, index) {
                    final asteroide = listaAsteroides[index];
                    return _buildAsteroidCard(asteroide); 
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --------------------------------------------------------
  // 🎨 PINTOR DE TARJETAS (Evitando el Código Spaghetti)
  // --------------------------------------------------------
  Widget _buildAsteroidCard(Asteroid asteroide) {
    // 🚦 Lógica visual: Si es peligroso, color rojo neón; si no, azul cian.
    final Color colorPeligro = asteroide.esPeligroso ? Colors.redAccent : Colors.cyan;

    // 1. Preparamos el texto de peligro
    final String textoPeligro = asteroide.esPeligroso ? 'SÍ ⚠️' : 'NO ✅';

    // 2. Formateamos la distancia para que no sea un número crudo
    // Convertimos a doble, redondeamos y le ponemos formato legible
    final double distanciaKm = double.parse(asteroide.distanciaKm);
    final String distanciaFormateada = "${(distanciaKm / 1000000).toStringAsFixed(2)} Millones de Km";

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C), 
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: colorPeligro.withValues(alpha: 0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: colorPeligro.withValues(alpha: 0.2), 
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila 1: Título "Nombre: [Asteroide]" y Alerta
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded( // Expanded evita que nombres muy largos rompan la pantalla
                  child: Text(
                    'Nombre: ${asteroide.name}', // 📝 Agregamos la palabra "Nombre:"
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0, // Un poco más pequeño para que quepa bien
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (asteroide.esPeligroso)
                  const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28)
                else
                  const Icon(Icons.check_circle_outline, color: Colors.cyan, size: 28),
              ],
            ),
            const Divider(color: Colors.white24, height: 20),
            
            // 📝 Etiqueta de Peligro Clara
            _buildInfoRow(Icons.dangerous, 'Posible impacto:', textoPeligro),

            // 📝 Nombre con etiqueta
            _buildInfoRow(Icons.label, 'Nombre:', asteroide.name),

            // 📝 Detalles técnicos con formato humano
            _buildInfoRow(Icons.speed, 'Velocidad:', '${double.parse(asteroide.velocidadKmh).toStringAsFixed(0)} km/h'),
            _buildInfoRow(Icons.straighten, 'Tamaño max:', '${asteroide.diametroMaximoMetros.toStringAsFixed(0)} metros'),
            _buildInfoRow(Icons.social_distance, 'Distancia:', distanciaFormateada), // 🚀 ¡Mucho más fácil de leer!
            
            _buildInfoRow(Icons.access_time, 'Fecha de paso:', asteroide.fechaAproximacion),
          ],
        ),
      ),
    );
  }

  Widget _buildBriefingBox() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFCD7F32).withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Color(0xFFCD7F32), size: 30),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Base de datos NEO: Analizando asteroides que pasarán cerca de la Tierra hoy.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // 🛠️ MINI-WIDGET AUXILIAR: Para que las filas se vean parejitas
  Widget _buildInfoRow(IconData icono, String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icono, color: Colors.white70, size: 18.0),
          const SizedBox(width: 8.0),
          Text(
            etiqueta,
            style: const TextStyle(color: Colors.white70, fontSize: 14.0),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              valor,
              style: const TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right, // Empuja el valor hacia la derecha
            ),
          ),
        ],
      ),
    );
  }
}

class NeoService {
}
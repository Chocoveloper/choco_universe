import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ChocoHorizonsService {
  
  // Misión: Obtener Posición (X, Y) y Velocidad (VX, VY)
  static Future<Map<String, double>?> obtenerCoordenadas(String planetaId) async {
    try {
      final hoy = DateTime.now();
      final manana = hoy.add(const Duration(days: 1));
      
      final fechaInicio = "${hoy.year}-${hoy.month.toString().padLeft(2, '0')}-${hoy.day.toString().padLeft(2, '0')}";
      final fechaFin = "${manana.year}-${manana.month.toString().padLeft(2, '0')}-${manana.day.toString().padLeft(2, '0')}";

      // Cambio táctico: VEC_TABLE='3' nos da Posición Y Velocidad
      final url = Uri.parse(
        "https://ssd.jpl.nasa.gov/api/horizons.api"
        "?format=text"
        "&COMMAND='$planetaId'"
        "&EPHEM_TYPE='VECTORS'"
        "&CENTER='@10'" 
        "&START_TIME='$fechaInicio'"
        "&STOP_TIME='$fechaFin'"
        "&STEP_SIZE='1 d'"
        "&VEC_TABLE='3'" // <--- ¡AQUÍ ESTÁ LA MAGIA!
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return _traducirMatrizNasa(response.body);
      } else {
        debugPrint('❌ [NASA Horizons] Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('☄️ [NASA] Impacto en la red: $e');
      return null;
    }
  }

  static Map<String, double>? _traducirMatrizNasa(String textoRudo) {
    try {
      final inicio = textoRudo.indexOf('\$\$SOE');
      final fin = textoRudo.indexOf('\$\$EOE');

      if (inicio == -1 || fin == -1) return null;

      final bloqueDatos = textoRudo.substring(inicio + 5, fin);

      // 🕵️‍♂️ Radares RegEx expandidos:
      final regexX = RegExp(r'X =\s*([^\s]+)');
      final regexY = RegExp(r'Y =\s*([^\s]+)');
      // La NASA a veces escribe "VX=" junto, por eso no le pongo espacio después de la X
      final regexVX = RegExp(r'VX=\s*([^\s]+)'); 
      final regexVY = RegExp(r'VY=\s*([^\s]+)');

      final matchX = regexX.firstMatch(bloqueDatos);
      final matchY = regexY.firstMatch(bloqueDatos);
      final matchVX = regexVX.firstMatch(bloqueDatos);
      final matchVY = regexVY.firstMatch(bloqueDatos);

      if (matchX != null && matchY != null && matchVX != null && matchVY != null) {
        return {
          'x': double.parse(matchX.group(1)!),
          'y': double.parse(matchY.group(1)!),
          'vx': double.parse(matchVX.group(1)!), // Km por segundo en X
          'vy': double.parse(matchVY.group(1)!), // Km por segundo en Y
        };
      }
    } catch (e) {
      debugPrint('🛠️ [Choco-Traductor] Error: $e');
    }
    return null;
  }


  // 🌌 EL RADAR MAESTRO: Escanea todo el Sistema Solar (¡Con cortesía para la NASA!)
  static Future<Map<String, Map<String, double>>> escanearSistemaSolar() async {
    
    final idsPlanetas = {
      'Mercurio': '199',
      'Venus': '299',
      'Tierra': '399',
      'Marte': '499',
      'Jupiter': '599',
      'Saturno': '699', 
      'Urano': '799',
      'Neptuno': '899',
      'Pluton': '999',  // 🤫 Nuestro VIP sigue en la lista
    };

    Map<String, Map<String, double>> mapaGalactico = {};

    // 🚦 TÁCTICA SECUENCIAL: Un planeta a la vez
    for (var entrada in idsPlanetas.entries) {
      final nombre = entrada.key;
      final id = entrada.value;

      // 1. Lanzamos sonda y ESPERAMOS a que vuelva
      final datos = await obtenerCoordenadas(id);
      
      if (datos != null) {
        mapaGalactico[nombre] = datos;
      }

      // 2. ⏱️ Micro-pausa de cortesía (200 milisegundos) para que la NASA respire
      await Future.delayed(const Duration(milliseconds: 200));
    }

    debugPrint('📡 [Radar] Sistema Solar escaneado: ${mapaGalactico.length} planetas en línea.');
    return mapaGalactico;
  }

}
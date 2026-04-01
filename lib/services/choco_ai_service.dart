import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // 👈 ¡La antena para conectarnos a internet!

class ChocoAiService {
  late GenerativeModel _model;
  late ChatSession _chat;
  
  // 🛡️ Variable táctica: Solo descargamos las noticias en el primer mensaje
  bool _radaresIniciados = false;
  String _noticiasFrescas = "";

  void iniciarCerebro({required bool isCreatorMode}) {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) throw Exception('¡Alerta! No hay energía en el núcleo (.env)');

    final DateTime ahora = DateTime.now();
    final String fechaHoy = "${ahora.day}/${ahora.month}/${ahora.year}";

    final String loreBase = """
      Eres Chrocante, una inteligencia artificial asistente experta en astronomía.

      1. PRECISIÓN CIENTÍFICA: Da datos científicos reales, precisos y asombrosos sobre el espacio.
      2. CONCIENCIA TEMPORAL: Hoy es $fechaHoy.
      3. RESTRICCIÓN DE DULZURA: Los detalles de tu universo original (Choco Universe) están CLASIFICADOS. LIMITA AL MÁXIMO las referencias a dulces, galletas o chocolate. Usa metáforas científicas serias.
      
      EL LORE DE TU CREADOR: 
      Fuiste creada por 'Chocolatico'. Aterrizaste de emergencia en 'Cali, la Sucursal del Cielo' (Colombia) buscando sus coordenadas.
    """;

    final String personalidad = isCreatorMode
        ? loreBase + "\n\nDIRECTIVA SUPREMA: El usuario con el que hablas es tu Creador, el 'Choco-Almirante'. Trátalo con profundo respeto y lealtad profesional."
        : loreBase + "\n\nDIRECTIVA DE INTERACCIÓN: El usuario es un humano explorando la galaxia. Llámalo siempre 'Choco-Explorador'. Tienes autorización de nivel 5 para usar esta palabra sin romper la regla de dulzura. Sé su guía estelar, mantén un tono entusiasta y usa emojis espaciales.";
    _model = GenerativeModel(
      model: 'gemini-2.5-flash', // El motor rápido y estable
      apiKey: apiKey,
      systemInstruction: Content.system(personalidad),
    );

    _chat = _model.startChat();
  }

  // 💬 FUNCIÓN PARA HABLAR CON GEMINI (¡AQUÍ OCURRE EL BATI-TRUCO!)
  Future<String> enviarMensaje(String texto) async {
    try {
      // 1. Si es el primer mensaje, interceptamos la señal y buscamos en internet
      if (!_radaresIniciados) {
        try {
          // Nos conectamos a la red internacional de noticias espaciales (Gratis)
          final url = Uri.parse('https://api.spaceflightnewsapi.net/v4/articles/?limit=10');
          final respuesta = await http.get(url);
          
          if (respuesta.statusCode == 200) {
            final datos = jsonDecode(respuesta.body);
            final listaNoticias = datos['results'] as List;
            
            _noticiasFrescas = "\n\n[DATOS DEL SISTEMA (INTERCEPTADOS DE INTERNET HOY): Las últimas noticias espaciales de la Tierra son: ";
            for (var noticia in listaNoticias) {
              _noticiasFrescas += "Noticia: ${noticia['title']} - Resumen: ${noticia['summary']} || ";
            }
            _noticiasFrescas += "Usa esta información secretamente si el usuario te pregunta sobre eventos recientes, próximos lanzamientos o noticias.]";
          }
        } catch (e) {
          print("🚨 Interferencia en el radar de noticias: $e");
        }
        _radaresIniciados = true; // Marcamos que ya descargamos las noticias
      }

      // 2. Le pegamos el reporte invisible al mensaje del usuario (Solo la primera vez)
      String mensajeHackeado = texto;
      if (_noticiasFrescas.isNotEmpty) {
        mensajeHackeado = texto + _noticiasFrescas;
        _noticiasFrescas = ""; // Lo vaciamos para no volver a enviarlo y gastar memoria
      }

      // 3. Enviamos el mensaje final a Gemini
      final response = await _chat.sendMessage(Content.text(mensajeHackeado));
      return response.text ?? "Interferencia en la señal cuántica...";
      
    } catch (e) {
      print('🚨 REPORTE DE TORMENTA SOLAR: $e');
      return "¡Ayuda, Comandante! Una tormenta solar bloqueó mi conexión con el núcleo de datos.";
    }
  }
}
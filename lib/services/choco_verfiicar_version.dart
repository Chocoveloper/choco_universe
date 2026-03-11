// Archivo: services/verificar_version.dart
//https://github.com/Chocoveloper/choco_universe.git
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class VersionService {
  // ⚠️ ATENCIÓN: Cambia 'TuUsuario' por tu nombre real de GitHub
  // Apuntamos a la rama 'main' de choco_universe
  static const String _urlJson =
      "https://raw.githubusercontent.com/Chocoveloper/choco_universe/refs/heads/main/version.json";

  static Future<Map<String, dynamic>?> checkUpdate() async {
    try {
      final response = await http.get(Uri.parse(_urlJson));
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        // Comparamos versión instalada (ej. 1.0.0) vs versión en la nube
        if (data['latest_version'] != packageInfo.version) {
          return data; // ¡Hay una actualización sorpresa! 🎁
        }
      }
    } catch (e) {
      // Silencio de radio si falla, para no asustar al usuario
    }
    return null; // Todo está al día
  }
}


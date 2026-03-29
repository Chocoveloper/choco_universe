import 'dart:convert';
import 'dart:io'; // Para manejar errores de conexión
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class VersionService {
  // 🛰️ URL del JSON en GitHub (Pública y Raw)
  static const String _urlJson =
      "https://raw.githubusercontent.com/Chocoveloper/choco_universe/refs/heads/main/version.json";

  static Future<Map<String, dynamic>?> checkUpdate() async {
    try {
      final response = await http.get(Uri.parse(_urlJson));
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();

      if (response.statusCode == 200) {
        // 🛠️ MEJORA 1: Usamos utf8.decode para que las notas con tildes, 
        // eñes o emojis no rompan el JSON.
        final String body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = json.decode(body);
        
        String remoteVersion = data['latest_version'] ?? "0.0.0";
        String localVersion = packageInfo.version;

        // 🛠️ MEJORA 2: Cambiamos != por una lógica más segura.
        // Si la versión de la nube es distinta a la local, hay misión.
        if (remoteVersion != localVersion) {
          return data; 
        }
      }
    } on SocketException {
      print("📡 Choco-Error: No hay conexión a internet.");
    } catch (e) {
      print("📡 Choco-Error en el servicio de versión: $e");
    }
    return null; 
  }
}

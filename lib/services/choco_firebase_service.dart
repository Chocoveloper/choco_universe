import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/choco_pluto_backup_model.dart'; // Asegúrate de que la ruta sea correcta

class ChocoFirebaseService {
  // 🛰️ Referencia a nuestra base de datos
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Método para obtener el respaldo de Plutón cuando la NASA falla
  Future<PlutoBackupModel?> getPlutoBackup() async {
    try {
      // 1. Apuntamos a la colección que creaste en la consola
      // Usamos .limit(1) para traer solo el último respaldo activo
      var snapshot = await _db.collection('backup_apod').limit(1).get();

      if (snapshot.docs.isNotEmpty) {
        // 2. Extraemos el mapa de datos del primer documento encontrado
        Map<String, dynamic> data = snapshot.docs.first.data();
        
        // 3. ¡TIKI-TAKA! Usamos la 'factory' de tu modelo para convertirlo
        return PlutoBackupModel.fromFirestore(data);
      }
      return null;
    } catch (e) {
      // Si incluso Firebase falla (tormenta solar extrema), devolvemos null
      print('❌ [FIREBASE ERROR]: $e');
      return null;
    }
  }
}


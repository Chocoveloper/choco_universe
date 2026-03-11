// Archivo: models/asteroid_model.dart

class NeoRadarResponse {
  final int elementCount;
  // En lugar de un Map raro con fechas, le entregamos a la UI una lista limpia
  final List<Asteroid> asteroides; 

  NeoRadarResponse({
    required this.elementCount,
    required this.asteroides,
  });

  factory NeoRadarResponse.fromJson(Map<String, dynamic> json) {
    final mapObjetos = json["near_earth_objects"] as Map<String, dynamic>;
    final List<Asteroid> listaPlana = [];

    // 🪄 MAGIA: Recorremos el mapa sin importar qué fecha tenga hoy
    mapObjetos.forEach((fecha, listaJson) {
      for (var asteroideJson in listaJson) {
        listaPlana.add(Asteroid.fromJson(asteroideJson));
      }
    });

    return NeoRadarResponse(
      elementCount: json["element_count"],
      asteroides: listaPlana,
    );
  }
}

class Asteroid {
  final String id;
  final String name;
  final double diametroMaximoMetros;
  final bool esPeligroso;
  final String velocidadKmh;
  final String distanciaKm;
  final String fechaAproximacion;

  Asteroid({
    required this.id,
    required this.name,
    required this.diametroMaximoMetros,
    required this.esPeligroso,
    required this.velocidadKmh,
    required this.distanciaKm,
    required this.fechaAproximacion,
  });

  factory Asteroid.fromJson(Map<String, dynamic> json) {
    // La NASA manda un arreglo de acercamientos, tomamos el primero [0]
    final closeApproach = json["close_approach_data"][0];

    return Asteroid(
      id: json["id"],
      name: json["name"],
      // Navegamos por el JSON solo para sacar la carnita que nos importa
      diametroMaximoMetros: json["estimated_diameter"]["meters"]["estimated_diameter_max"].toDouble(),
      esPeligroso: json["is_potentially_hazardous_asteroid"],
      velocidadKmh: closeApproach["relative_velocity"]["kilometers_per_hour"],
      distanciaKm: closeApproach["miss_distance"]["kilometers"],
      fechaAproximacion: closeApproach["close_approach_date_full"],
    );
  }
}
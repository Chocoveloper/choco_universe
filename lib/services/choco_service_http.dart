import 'package:choco_universe/models/choco_imagen_deldia_model.dart';
import 'package:choco_universe/models/choco_systeme_solaire_model.dart';
import 'package:choco_universe/models/choco_neo_radar_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


//Aqui, voy a hacer la petición para la imagen del día, desde la API de la NASA
// Colocamos el signo de interrogación ?, para indicar que nuestro Future puede resolver null
//En caso de que la API de la NASA falle y no envíe nada y nuestra aplicación crashee (explote) por que recibe null.
Future<ImagenDelDia?> getImageDay() async{

  final url = Uri.parse('https://api.nasa.gov/planetary/apod?api_key=R7btzQoaCKF2L7SCvoygpdvA9VgxYatrc4KwnIB4');

  try{

    final response = await http.get(url,);

    if(response.statusCode == 200){
      final body = imagenDelDiaFromJson(response.body);

      debugPrint('La imagen del día es: ${body.url}');

      
      return body;
    }else{
      debugPrint('No fue posible obtener la imagen ${response.statusCode}');
      return null; //Retornamos null, ya que nuestro valor de retorno es de tipo: ImagenDelDia y como en este punto se espera recibir un error, pues retornamos null.
    }
  
  }catch(error){
    debugPrint('Houstoun tenemos problemas: $error');
    return null; //Retornamos null, ya que nuestro valor de retorno es de tipo: ImagenDelDia y como en este punto también se espera recibir un error, pues retornamos null.
  }

  
}

Future<ImagenDelDia?> getImageDayDio()async{

  final dio = Dio();

  try{

    final response = await dio.get('https://api.nasa.gov/planetary/apod?api_key=R7btzQoaCKF2L7SCvoygpdvA9VgxYatrc4KwnIB4', 
    //Este options, es para que Dio valide los errores como el paquete http, es decir, menos detallado. Y deje que el error pase por el else
    options: Options(validateStatus: (status) => true));

    if(response.statusCode == 200){

      debugPrint('Planeta a la vista ${response.statusCode} ${response.statusMessage}');

      final ImagenDelDia body = ImagenDelDia.fromJson(response.data);

      debugPrint('La sonda ya tiene las coordenadas: ${body.url}');
      return body;
    }else{
      debugPrint('6 horas, 1 minuto, ascensión derecha, 14 grados, declinación 22 minutos... ¡No hay cuerpos! ${response.statusCode} ${response.statusMessage}');
      return null;
    }

  }catch(e){
    debugPrint('Houston, ¡tenemos un problema! $e');
    return null;
  }

}


Future<SystemeSolaire?> getPlanetsDio() async{

  final dioPlanets = Dio();
  const token = 'ba761a75-2cd5-467f-9c90-2937b358e257';
  try{

    final response = await dioPlanets.get('https://api.le-systeme-solaire.net/rest/bodies?filter[]=bodyType,eq,Planet',
    options: Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    ),
    );

    if(response.statusCode == 200){
      debugPrint('Es un pequeño paso para el hombre, pero un gran salto para la humanidad ${response.statusCode} ${response.statusMessage}');

      final  systemSolaire = SystemeSolaire.fromJson(response.data);

      //Ordenamos los planetas por distancia al sol
      systemSolaire.bodies.sort((a, b) => a.semimajorAxis.compareTo(b.semimajorAxis),);

      debugPrint('${systemSolaire.bodies}');
      debugPrint(systemSolaire.bodies[0].id);
      return systemSolaire;

    }else{
      debugPrint('6 horas, 1 minuto, ascensión derecha, 14 grados, declinación 22 minutos... ¡No hay cuerpos! ${response.statusCode} ${response.statusMessage}');
      return null;
    }


  }catch(blackHole){
    debugPrint('Houston, ¡we have a problem $blackHole');
    return null;
  }
  
}

//Aqui vamos a traer la información de los asteroides cercanos a la tierra


Future<NeoRadarResponse?> getNeoRadarInfoDio() async {

  final dio = Dio();

  //No podemos poner fechas fijas, porque la API de la NASA cambia las fechas constantemente
  // ⏱️ Obtenemos la fecha actual automáticamente
  final hoy = DateTime.now();
  final fechaHoy = "${hoy.year}-${hoy.month.toString().padLeft(2, '0')}-${hoy.day.toString().padLeft(2, '0')}";

  
  try{
      final response = await dio.get('https://api.nasa.gov/neo/rest/v1/feed?start_date=$fechaHoy&end_date=$fechaHoy&api_key=R7btzQoaCKF2L7SCvoygpdvA9VgxYatrc4KwnIB4');


    if(response.statusCode == 200){

      final NeoRadarResponse neoRadar = NeoRadarResponse.fromJson(response.data);

      debugPrint('Asteroides a la vista ${response.statusCode} ${response.statusMessage}');

      return neoRadar;
    }else{
      debugPrint('Jum, ¡Déjà vu! ${response.statusCode}');
      return null;
    }

  }catch(e){

    debugPrint('Trinity auxilio! $e');
    return null;

  }
}

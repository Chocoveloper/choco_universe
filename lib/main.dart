import 'package:choco_universe/models/choco_pluto_backup_model.dart';
import 'package:choco_universe/screens/choco_splash_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:choco_universe/models/choco_imagen_deldia_model.dart';
import 'package:choco_universe/models/choco_systeme_solaire_model.dart';
import 'package:choco_universe/screens/choco_home_universe.dart';
import 'package:choco_universe/services/choco_firebase_service.dart';
import 'package:choco_universe/services/choco_service_http.dart';
import 'package:firebase_core/firebase_core.dart'; // 👈 Motor principal
import 'firebase_options.dart'; // 👈 El archivo que acabas de generar
import 'package:flutter/material.dart';


//void main() => runApp(const MyApp());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  ImagenDelDia? imagenFinal;
  SystemeSolaire? planetas;

  // 📡 1. Intentamos conseguir los datos normales
  try {
    final resultados = await Future.wait([
      getImageDayDio(),
      getPlanetsDio(),
    ]);
    
    imagenFinal = resultados[0] as ImagenDelDia?;
    planetas = resultados[1] as SystemeSolaire?;
  } catch (e) {
    debugPrint('🚨 [SISTEMA]: Error en las APIs principales.');
  }

  // 🆘 2. EL VERDADERO PARACAÍDAS
  // Si la NASA falló (por error o por devolver null), activamos a Plutón AQUÍ.
  if (imagenFinal == null) {
    debugPrint('🚨 [SISTEMA]: NASA sin imagen. Activando respaldo de Plutón...');
    
    try {
      final service = ChocoFirebaseService();
      final backup = await service.getPlutoBackup();

      if (backup != null) {
        // 🧙‍♂️ Disfrazamos a Plutón de ImagenDelDia
        imagenFinal = ImagenDelDia(
          title: backup.title,
          url: backup.url,
          hdurl: backup.url,
          explanation: backup.description,
          date: DateTime.parse("2006-08-24"),
          mediaType: "image",
          serviceVersion: "v1",
        );
        debugPrint('✅ [SISTEMA]: Plutón ha tomado el control.');
      }
    } catch (fireError) {
      debugPrint('🚨 [SISTEMA]: Error crítico en Firebase: $fireError');
    }
  } else {
    debugPrint('🚀 [SISTEMA]: Enlace con la NASA exitoso.');
  }

  // 3. Por si la API de planetas también falló, intentamos de nuevo o lo dejamos nulo
  if (planetas == null) {
     try { planetas = await getPlanetsDio(); } catch(_) {}
  }

  // 🚀 Lanzamos la app
  runApp(MyApp(
    imagenDelDia: imagenFinal,
    planetas: planetas,
  ));
}
class MyApp extends StatefulWidget {

  final ImagenDelDia? imagenDelDia;
  final SystemeSolaire? planetas;

  const MyApp({super.key, this.imagenDelDia, this.planetas});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // 1. Nueva bandera para saber si la RAM está "caliente"
  bool _readyForTakeoff = false;

 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_readyForTakeoff) {
      // 1. Creamos una lista de misiones de carga (Promesas)
      List<Future<void>> misionesDeCarga = [];

      // 2. Misión 1: Cargar la Imagen de la NASA (Si existe)
      if (widget.imagenDelDia != null) {
        misionesDeCarga.add(
          precacheImage(CachedNetworkImageProvider(widget.imagenDelDia!.url), context)
        );
      }

      // 3. Misión 2: Cargar las 8 imágenes de los planetas
      for (String rutaLocal in imagenesPlanetasLocal) {
        misionesDeCarga.add(
          precacheImage(AssetImage(rutaLocal), context)
        );
      }

      // ⏱️ Misión 3: La Pausa de Riquelme (Obligamos a la app a esperar 3 segundos)
      misionesDeCarga.add(Future.delayed(const Duration(seconds: 3)));

      // 4. PROTOCOLO RAPPI SUPERIOR: Esperamos que TODAS las imágenes suban a la RAM
      Future.wait(misionesDeCarga).then((_) {
        if (mounted) {
          setState(() {
            _readyForTakeoff = true; // ¡Ahora sí estamos 100% listos!
          });
          debugPrint('🚀 RAM Caliente: NASA y Planetas cargados. Sin pop-in, puro estilo.');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    

    return MaterialApp(
      title: 'Choco-Universe',
      debugShowCheckedModeBanner: false,
      home: _readyForTakeoff
          ? ChocoHomeUniverse(
            image: widget.imagenDelDia,
            planets: widget.planetas,
            )
            //Cargamos nuetro SplashScreen
          :Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.brown)),
      ),
    );
  }
}

// Creamos la lista de RUTAS LOCALES para que Flutter las suba a la RAM
const List<String> imagenesPlanetasLocal = [
  'assets/images/planetas/mercurio.png',
  'assets/images/planetas/venus.png',
  'assets/images/planetas/tierra.png',
  'assets/images/planetas/marte.png',
  'assets/images/planetas/jupiter.png',
  'assets/images/planetas/saturno.png',
  'assets/images/planetas/urano.png',
  'assets/images/planetas/neptuno.png',
];
import 'package:choco_universe/screens/choco_splash_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:choco_universe/models/choco_imagen_deldia_model.dart';
import 'package:choco_universe/models/choco_systeme_solaire_model.dart';
import 'package:choco_universe/screens/choco_home_universe.dart';
import 'package:choco_universe/services/choco_service_http.dart';
import 'package:flutter/material.dart';


//void main() => runApp(const MyApp());

void main() async {
  // 1. Encendemos los motores internos de Flutter (necesario siempre que el main sea async)
  WidgetsFlutterBinding.ensureInitialized();

  //Usamos un Future.wait[] para cargar las dos funicones que llaman a nuestra APIs
  //La APi de la imagen del día de la NASA y la API del Sistema Solar

  final resultados = await Future.wait([
    getImageDayDio(),
    getPlanetsDio(), // <--- Aquí descargamos los planetas
  ]);

  // Lanzamos la app inyectando el tesoro de la NASA
  runApp(MyApp(
    imagenDelDia: resultados[0] as ImagenDelDia?,
    planetas: resultados[1] as SystemeSolaire?,
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
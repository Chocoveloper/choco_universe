import 'package:cached_network_image/cached_network_image.dart';
import 'package:choco_universe/models/choco_imagen_deldia_model.dart';
import 'package:choco_universe/models/choco_systeme_solaire_model.dart';
import 'package:choco_universe/provider/choco_chrocante_provider.dart';
import 'package:choco_universe/screens/choco_home_universe.dart';
import 'package:choco_universe/services/choco_firebase_service.dart';
import 'package:choco_universe/services/choco_horizons_service.dart';
import 'package:choco_universe/services/choco_service_http.dart';
import 'package:firebase_core/firebase_core.dart'; // 👈 Motor principal
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // 👈 El archivo que acabas de generar
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';

//void main() => runApp(const MyApp());

void main() async {
  //INYECTAMOS EL BYPASS AQUÍ:
  HttpOverrides.global = ChocoHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  ImagenDelDia? imagenFinal;
  SystemeSolaire? planetas;
  Map<String, Map<String, double>>? mapaReal;

  // 📡 1. Intentamos conseguir los datos normales
  try {
    final resultados = await Future.wait([getImageDayDio(), getPlanetsDio()]);

    mapaReal = await ChocoHorizonsService.escanearSistemaSolar();


    void analizarTelemetria(Map<String, Map<String, double>> mapaReal) {
  debugPrint('--- 📊 REPORTE DEL CHOCOSCOPIO ---');
  
  // Factor de escala: 10 millones de km = 1 pixel
  const double escalaVuelo = 10000000.0; 

  mapaReal.forEach((nombre, datos) {
    final x = datos['x']!;
    final y = datos['y']!;
    final vx = datos['vx']!;
    final vy = datos['vy']!;

    // 1. Calculamos la Distancia Real al Sol (Pitágoras de X e Y)
    final distanciaAlSolKm = sqrt((x * x) + (y * y));
    
    // 2. Calculamos la Posición en Píxeles para la pantalla
    final pixelX = x / escalaVuelo;
    final pixelY = y / escalaVuelo;

    // 3. Calculamos la Velocidad Absoluta (Pitágoras de VX y VY)
    final velocidadKmS = sqrt((vx * vx) + (vy * vy));
    // Y si la queremos en km/h, multiplicamos por 3600 (los segundos en una hora)
    final velocidadKmH = velocidadKmS * 3600;

    debugPrint('🪐 $nombre:');
    debugPrint('   📍 Posición en Pantalla: X: ${pixelX.toStringAsFixed(1)} px, Y: ${pixelY.toStringAsFixed(1)} px');
    debugPrint('   📏 Distancia al Sol: ${(distanciaAlSolKm / 1000000).toStringAsFixed(2)} Millones de km');
    debugPrint('   ⚡ Velocidad: ${velocidadKmS.toStringAsFixed(2)} km/s (${velocidadKmH.toStringAsFixed(0)} km/h)');
    debugPrint('-----------------------------------');
  });
}
analizarTelemetria(mapaReal);

    imagenFinal = resultados[0] as ImagenDelDia?;
    planetas = resultados[1] as SystemeSolaire?;
  } catch (e) {
    debugPrint('🚨 [SISTEMA]: Error en las APIs principales.');
  }

  // 🆘 2. EL VERDADERO PARACAÍDAS
  // Si la NASA falló (por error o por devolver null), activamos a Plutón AQUÍ.
  if (imagenFinal == null) {
    debugPrint(
      '🚨 [SISTEMA]: NASA sin imagen. Activando respaldo de Plutón...',
    );

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
    try {
      planetas = await getPlanetsDio();
    } catch (_) {}
  }

  // 🚀 Lanzamos la app
  runApp(
    ChangeNotifierProvider(
      create: (_) => ChocoChrocanteProvider(),
      child: MyApp(
        imagenDelDia: imagenFinal, 
        planetas: planetas,
        mapaGalactico: mapaReal,
        ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final ImagenDelDia? imagenDelDia;
  final SystemeSolaire? planetas;
  final Map<String, Map<String, double>>? mapaGalactico; // 👈 NUEVO: La maleta de la NASA
  const MyApp({super.key, this.imagenDelDia, this.planetas, this.mapaGalactico});

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
          precacheImage(
            CachedNetworkImageProvider(widget.imagenDelDia!.url),
            context,
          ),
        );
      }

      // 3. Misión 2: Cargar las 8 imágenes de los planetas
      for (String rutaLocal in imagenesPlanetasLocal) {
        misionesDeCarga.add(precacheImage(AssetImage(rutaLocal), context));
      }

      // ⏱️ Misión 3: La Pausa de Riquelme (Obligamos a la app a esperar 3 segundos)
      misionesDeCarga.add(Future.delayed(const Duration(seconds: 3)));

      // 4. PROTOCOLO RAPPI SUPERIOR: Esperamos que TODAS las imágenes suban a la RAM
      Future.wait(misionesDeCarga).then((_) {
        if (mounted) {
          setState(() {
            _readyForTakeoff = true; // ¡Ahora sí estamos 100% listos!
          });
          debugPrint(
            '🚀 RAM Caliente: NASA y Planetas cargados. Sin pop-in, puro estilo.',
          );
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
              mapaGalactico: widget.mapaGalactico, // 👈 SIGUE EL VIAJE
            )
          //Cargamos nuetro SplashScreen
          : Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: CircularProgressIndicator(color: Colors.brown),
              ),
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

// 🛡️ PARCHE DE SEGURIDAD (Solo para Desarrollo)
class ChocoHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

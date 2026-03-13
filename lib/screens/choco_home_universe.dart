import 'package:cached_network_image/cached_network_image.dart';
import 'package:choco_universe/models/choco_imagen_deldia_model.dart';
import 'package:choco_universe/models/choco_systeme_solaire_model.dart';
import 'package:choco_universe/screens/choco_page_view_screen.dart';
import 'package:choco_universe/screens/choco_solarsystem_screen.dart';
import 'package:choco_universe/services/choco_verfiicar_version.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class ChocoHomeUniverse extends StatefulWidget {
  final ImagenDelDia? image;
  final SystemeSolaire? planets;
  const ChocoHomeUniverse({super.key, required this.image, this.planets});

  @override
  State<ChocoHomeUniverse> createState() => _ChocoHomeUniverseState();
}

class _ChocoHomeUniverseState extends State<ChocoHomeUniverse> {
  // 1. Bandera para saber si la imagen ya llegó
  bool _imagenLista = false;

  @override
  void initState() {
    super.initState();
    // Encendemos el radar si tenemos una imagen de la NASA
    if (widget.image != null) {
      _avisarCuandoCargue();
    }

<<<<<<< HEAD
    // 🚀 NUEVO: Le decimos a Flutter que espere a dibujar la pantalla
    // y luego lance el escáner de versiones.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _escanearVersion();
      //_mostrarPopUpActualizacion({'release_notes': 'Mensaje de prueba para ver el diseño.'});
    });
  }

  // 📡 Función que llama al servicio
  void _escanearVersion() async {
    final nuevaVersion = await VersionService.checkUpdate();

=======
    // 🚀 NUEVO: Le decimos a Flutter que espere a dibujar la pantalla 
    // y luego lance el escáner de versiones.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _escanearVersion();
        //_mostrarPopUpActualizacion({'release_notes': 'Mensaje de prueba para ver el diseño.'});
    
    });

  }

  
  // 📡 Función que llama al servicio
  void _escanearVersion() async {
    final nuevaVersion = await VersionService.checkUpdate();
    
>>>>>>> c9216061f45c7f1aca484c67e8a363723dc8beaf
    if (nuevaVersion != null && mounted) {
      // ¡BINGO! Hay una nueva versión en GitHub
      _mostrarPopUpActualizacion(nuevaVersion);
    }
  }

  // 🎨 Diseño del cuadro de diálogo
  void _mostrarPopUpActualizacion(Map<String, dynamic> data) {
    showDialog(
      context: context,
<<<<<<< HEAD
      barrierDismissible:
          false, // false = No puede cerrarlo tocando afuera, debe leerlo.
=======
      barrierDismissible: false, // false = No puede cerrarlo tocando afuera, debe leerlo.
>>>>>>> c9216061f45c7f1aca484c67e8a363723dc8beaf
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C), // Fondo espacial
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
<<<<<<< HEAD
            side: const BorderSide(
              color: Color(0xFFCD7F32),
              width: 1.5,
            ), // Borde caramelo
=======
            side: const BorderSide(color: Color(0xFFCD7F32), width: 1.5), // Borde caramelo
>>>>>>> c9216061f45c7f1aca484c67e8a363723dc8beaf
          ),
          title: const Row(
            children: [
              Icon(Icons.rocket_launch, color: Color(0xFFCD7F32)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  '¡Alerta de Sistema!',
<<<<<<< HEAD
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
=======
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
>>>>>>> c9216061f45c7f1aca484c67e8a363723dc8beaf
                ),
              ),
            ],
          ),
          content: Text(
<<<<<<< HEAD
            data['release_notes'] ??
                'Hay una nueva versión del universo disponible. 🌌',
=======
            data['release_notes'] ?? 'Hay una nueva versión del universo disponible. 🌌',
>>>>>>> c9216061f45c7f1aca484c67e8a363723dc8beaf
            style: const TextStyle(color: Colors.white70, fontSize: 16.0),
          ),
          actions: [
            // Botón de "Más tarde" (Opcional, pero de buen UX)
            TextButton(
              onPressed: () => Navigator.pop(context),
<<<<<<< HEAD
              child: const Text(
                'Más tarde',
                style: TextStyle(color: Colors.grey),
              ),
=======
              child: const Text('Más tarde', style: TextStyle(color: Colors.grey)),
>>>>>>> c9216061f45c7f1aca484c67e8a363723dc8beaf
            ),
            // Botón de "Actualizar"
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCD7F32), // Color Caramelo
<<<<<<< HEAD
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                // 🚀 Aquí en el futuro puedes poner el código (url_launcher)
=======
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(context);
                // 🚀 Aquí en el futuro puedes poner el código (url_launcher) 
>>>>>>> c9216061f45c7f1aca484c67e8a363723dc8beaf
                // para que la lleve al link de descarga (data['update_url']).
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Iniciando secuencia de hiperespacio... 🚀'),
                    backgroundColor: Color(0xFFCD7F32),
                  ),
                );
              },
              child: const Text(
                'Actualizar Ahora',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 2. Función que nos ayuda a validar si la imagen ya cargo y mostrar el titulo
  void _avisarCuandoCargue() {
    final proveedor = CachedNetworkImageProvider(widget.image!.url);
    proveedor
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((info, _) {
            if (mounted) {
              setState(() {
                _imagenLista = true; // ¡La imagen ya está en pantalla!
              });
            }
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // 🌌 1. Añadimos el color espacial a TODA la pantalla
      backgroundColor: const Color(0xFF0B0D17),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight:
                //Usamos nuestro Query para que ocupe exactamente el 40% del alto en cualquier dispositivo
                size.height *
                0.20, //Nos ayuda para decir que tan grande queremos el espacio del SliverAppBar cuando esta desplegada.
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              // Widget especial para poner fondos que se adaptan al movimiento.
              centerTitle: true,
              title: AnimatedOpacity(
                // La animación durará casi un segundo, muy cinematográfico
                duration: const Duration(milliseconds: 800),
                // Si la imagen está lista, opacidad 1 (visible). Si no, 0 (invisible).
                opacity: _imagenLista ? 1.0 : 0.0,
                child: Container(
                  width: double
                      .infinity, // Esto hace que la cinta ocupe todo el ancho de la pantalla
                  color: Colors
                      .black54, // ¡Aquí está la magia! Negro con 54% de opacidad (transparencia)
                  padding: const EdgeInsets.only(
                    top: 2.5,
                  ), // Un pequeño empujón hacia abajo para centrar las letras

                  child: Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: Text(
                      widget.image?.title ?? 'Buscando señal...',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              //Quiero poner image.url aqui
              background: widget.image != null
                  ? GestureDetector(
                      onTap: () {
                        //Aqui enviamos a la otra pantalla, todo lo que contiene nuestra variable image.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChocoPageViewScreen(image: widget.image!),
                          ),
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: widget.image!.url,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: Lottie.asset(
                            'assets/lottie/AstronautIllustration.json',
                            fit: BoxFit.contain,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.black,
                          child: const Center(
                            child: Icon(
                              Icons.satellite_alt,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.black,
                      child: const Center(
                        child: Icon(
                          Icons.satellite_alt,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ChocoSolarSystemScreen(planets: widget.planets),
            ),
          ),
        ],
      ),
    );
  }
}

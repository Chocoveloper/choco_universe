import 'package:cached_network_image/cached_network_image.dart';
import 'package:choco_universe/models/choco_imagen_deldia_model.dart';
import 'package:translator/translator.dart';
import 'package:flutter/material.dart';

class ChocoPageViewScreen extends StatefulWidget {
  final ImagenDelDia image;
  const ChocoPageViewScreen({super.key, required this.image});

  @override
  State<ChocoPageViewScreen> createState() => _ChocoPageViewScreenState();
}

class _ChocoPageViewScreenState extends State<ChocoPageViewScreen> {
  // Variables de nuestra nave
  bool _esVertical = true; // Por defecto asumimos que es vertical
  bool _escaneando = true; // Mientras el radar hace su trabajo
  bool _errorImagen = false; // 👈 NUEVA: Nuestro detector de caidas de imagenes
  // Variable para saber en qué página estamos (0 es la primera, 1 es la segunda)
  int _paginaActual = 0;

  String _textoTraducido = "Traduciendo mensaje de la NASA...";

  @override
  void initState() {
    super.initState();
    _analizarFormaDeImagen(); // ¡Encendemos el radar al entrar a la pantalla!
    _traducirExplicacion();
  }

  //Función para girar en vertical cualquier imagen que venga horizontal desde la API de la NASA

  void _analizarFormaDeImagen() {
    // Usamos CachedNetworkImageProvider para que use el mismo caché que el Home
    final proveedorImagen = CachedNetworkImageProvider(widget.image.url);

    proveedorImagen
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener(
            (ImageInfo info, bool _) {
              if (mounted) {
                setState(() {
                  _esVertical = info.image.height >= info.image.width;
                  _escaneando = false;
                });
              }
            },
            // 🚨 EL SALVAVIDAS: Si la URL está rota, entramos aquí
            onError: (dynamic error, StackTrace? stackTrace) {
              if (mounted) {
                setState(() {
                  _errorImagen = true; // Marcamos que hubo un fallo
                  _escaneando =
                      false; // ¡Apagamos el radar para que no se congele!
                });
              }
            },
          ),
        );
  }

  //Función para traducir el texo que viene desde la API de la NASA

  void _traducirExplicacion() async {
    final translator = GoogleTranslator();

    // Enviamos el inglés a los servidores de Google
    var translation = await translator.translate(
      widget.image.explanation,
      from: 'en',
      to: 'es',
    );

    if (mounted) {
      setState(() {
        _textoTraducido = translation.text; // ¡Ya tenemos español!
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final paddingInferior = MediaQuery.of(
      context,
    ).padding.bottom; //Para medir el espacio de los botones guia del PageView

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // Esto hace que la imagen se dibuje incluso detrás de la flecha de regresar
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          //PageView en el fondo del Stack
          //Con la imagen del día que envia la Nasa.
          PageView(
            //Esta la propiedad del PageView que me avisa cuando el usuario desliza
            onPageChanged: (int index) {
              setState(() {
                _paginaActual =
                    index; //Actualizamos para saber en que pagina esta el usuario
              });
            },
            children: [
              Center(
                // Si el radar sigue escaneando, mostramos un circulo de carga
                child: _escaneando
                    ? const CircularProgressIndicator(color: Colors.white)
                    // 2. ¿Hubo un error con la URL? ¡Mostramos el Satélite!
                    : _errorImagen
                    ? const Icon(
                        Icons.satellite_alt,
                        color: Colors.white54,
                        size: 100, // Un satélite bien grande
                      )
                    // 3. ¿Todo bien? Evaluamos si es vertical u horizontal
                    : _esVertical
                    ? CachedNetworkImage(
                        // 👈 Usamos CachedNetworkImage
                        imageUrl: widget.image.url,
                        fit: BoxFit.contain,
                      )
                    : RotatedBox(
                        quarterTurns: 1,
                        child: CachedNetworkImage(
                          // 👈 Usamos CachedNetworkImage
                          imageUrl: widget.image.url,
                          fit: BoxFit.contain,
                        ),
                      ),
              ),

              // El texto explicativo de la imagen del día.
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: chocoVibranteGradient,
                child: SafeArea(
                  // SafeArea evita que el texto se esconda detrás de la cámara del celular
                  child: Center(
                    //Centramos el bloque de texto
                    child: SizedBox(
                      // 2. Aquí está la magia:
                      // Si el ancho de la pantalla es mayor a 800px, el texto solo ocupa 600px.
                      // Si es menor (un celular), ocupa el 100% del ancho disponible.
                      width: MediaQuery.of(context).size.width > 800
                          ? 600
                          : double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: SingleChildScrollView(
                          // Por si el texto de la NASA es muy largo
                          child: Text(
                            _textoTraducido,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              height:
                                  1.5, // Interlineado para que sea fácil de leer
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Ingrediente 2: El indicador flotante
          Positioned(
            bottom: paddingInferior + 40.0, // A 40 píxeles del suelo
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Puntito de la Página 0 (La Imagen)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  // Si estamos en la página 0, se hace más ancho (25) y brillante
                  width: _paginaActual == 0 ? 25.0 : 10.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: _paginaActual == 0
                        ? Colors.deepOrangeAccent
                        : Colors.white38,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),

                // Puntito de la Página 1 (El Texto)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  // Si estamos en la página 1, este es el que se hace ancho
                  width: _paginaActual == 1 ? 25.0 : 10.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: _paginaActual == 1
                        ? Colors.deepOrangeAccent
                        : Colors.white38,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const chocoVibranteGradient = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0D0503), // Negro Café
      Color(0xFF4E2A14), // Chocolate Negro
      Color(0xFF8B4513), // Chocolate con Leche
      Color(0xFFCD7F32), // Bronce/Caramelo Vibrante
    ],
    stops: [0.1, 0.4, 0.7, 1.0],
  ),
);

import 'package:choco_universe/models/choco_systeme_solaire_model.dart';
import 'package:flutter/material.dart';

class ChocoShowPlanetsWidget extends StatefulWidget {
  final Planets? planets;
  const ChocoShowPlanetsWidget({super.key, this.planets});

  @override
  State<ChocoShowPlanetsWidget> createState() => _ChocoShowPlanetsWidgetState();
}

class _ChocoShowPlanetsWidgetState extends State<ChocoShowPlanetsWidget> {
  
  //Creamos un diccionario para traducir los nombres de los planetas

  String _traducirPlaneta(String nombreIngles) {
    const diccionario = {
      'Mercury': 'Mercurio',
      'Venus': 'Venus',
      'Earth': 'La Tierra',
      'Mars': 'Marte',
      'Jupiter': 'Júpiter',
      'Saturn': 'Saturno',
      'Uranus': 'Urano',
      'Neptune': 'Neptuno',
      
    };
    // Si encuentra el nombre en inglés, devuelve el de español. Si no, devuelve el original.
    return diccionario[nombreIngles] ?? nombreIngles; 
  }

  
  // 📏 Calculadora de Tamaños Relativos. Ayuda a darle un tamaño visual diferente a los planetas
  double _calcularTamano(double radioReal) {
    // El tamaño mínimo para que cualquier planeta se pueda ver bien
    const double tamanoBase = 15.0; 
    // Júpiter tiene aprox 69,911 km de radio. Lo usaremos como el 100% de la escala extra (30 píxeles más)
    final double bonoTamano = (radioReal / 70000.0) * 30.0; 
    
    return tamanoBase + bonoTamano;
  }

 // 🖼️ Diccionario de Rutas: Inglés -> Foto LOCAL
  String _obtenerImagenPlaneta(String nombreIngles) {
    const imagenes = {
      'Mercury': 'assets/images/planetas/mercurio.png',
      'Venus': 'assets/images/planetas/venus.png',
      'Earth': 'assets/images/planetas/tierra.png',
      'Mars': 'assets/images/planetas/marte.png',
      'Jupiter': 'assets/images/planetas/jupiter.png',
      'Saturn': 'assets/images/planetas/saturno.png',
      'Uranus': 'assets/images/planetas/urano.png',
      'Neptune': 'assets/images/planetas/neptuno.png',
    };
    // Si no encuentra la imagen, pone a la Tierra por defecto
    return imagenes[nombreIngles] ?? 'assets/images/planetas/tierra.png';
  }

  @override
  Widget build(BuildContext context) {

    // 🧮 Calculamos el tamaño exacto ANTES de dibujar
    final double tamanoPlaneta = _calcularTamano(widget.planets!.meanRadius);

    return Column(
      mainAxisSize: MainAxisSize.min, // Para que ocupe toda la pantalla.
      children: [
          // 🪐 El Planeta
        Container(
          height: tamanoPlaneta,
          width: tamanoPlaneta,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // Quitamos el LinearGradient y ponemos un DecorationImage
            image: DecorationImage(
              image: AssetImage(
                _obtenerImagenPlaneta(widget.planets!.englishName)
              ),
              fit: BoxFit.cover, // Para que la imagen llene el círculo perfecto
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4.0),
        // 📝 El Nombre (Pequeñito para que quepa en la órbita)
        Text(
          _traducirPlaneta(widget.planets!.englishName),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

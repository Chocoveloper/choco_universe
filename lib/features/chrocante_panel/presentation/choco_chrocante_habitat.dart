import 'dart:ui'; // 👈 ¡NUEVO! Necesario para el efecto de cristal esmerilado
import 'package:choco_universe/features/chrocante_panel/presentation/chocoscopio_page_view_screen.dart';
import 'package:choco_universe/models/choco_systeme_solaire_model.dart';
import 'package:choco_universe/provider/choco_chrocante_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChocoChrocanteHabitat extends StatelessWidget {

  final SystemeSolaire? planets;
  ChocoChrocanteHabitat({super.key, this.planets});

  @override
  Widget build(BuildContext context) {
    // Escuchamos al cerebro
    final chrocanteProvider = context.watch<ChocoChrocanteProvider>();

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack, 
      bottom: chrocanteProvider.isExpanded ? 15 : -45, 
      right: chrocanteProvider.isExpanded ? 30 : 10, 
      child: GestureDetector(
        onTap: () => chrocanteProvider.togglePanel(),
        child: Column(
          // Alineamos a la derecha para que la píldora crezca hacia la izquierda (hacia el centro del mapa)
          crossAxisAlignment: CrossAxisAlignment.end, 
          children: [
            // 🌟 EL NUEVO PANEL HOLOGRÁFICO
            if (chrocanteProvider.isExpanded) _buildPanelHolografico(context),
            const SizedBox(height: 10),
            // 🐒 NUESTRO CAPITÁN
            Image.asset(
              'assets/images/planetas/chrocante4.png', 
              width: 120,
            ),
          ],
        ),
      ),
    );
  }

  // 🎛️ EL PANEL DE CRISTAL (Glassmorphism)
  Widget _buildPanelHolografico(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30.0), // Forma de píldora
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0), // Efecto de cristal borroso
        child: Container(
          height: 85, // Altura súper compacta para no tapar el mapa
          width: 260, // Ancho para que quepan las tarjetas y se pueda hacer scroll
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF0B0D17).withValues(alpha: 0.6), // Fondo espacial oscuro y transparente
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(
              color: const Color(0xFFCD7F32).withValues(alpha: 0.5), // Borde Caramelo/Bronce
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFCD7F32).withValues(alpha: 0.1), // Resplandor súper sutil
                blurRadius: 20,
                spreadRadius: 1,
              )
            ]
          ),
          // 🚀 EL CARRUSEL HORIZONTAL
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(), // Efecto de rebote al llegar al final (estilo iOS)
            children: [
              // 🃏 TARJETA 1: CHOCOSCOPIO (¡Lista para despegar!)
              // 🃏 TARJETA 1: CHOCOSCOPIO (¡Lista para despegar!)
              _buildTarjetaHolografica(
                icon: Icons.travel_explore, 
                titulo: 'Visor 3D',
                isActiva: true,
                onTap: () {
                  // 🚀 1. Leemos los planetas directamente del cerebro (Provider) aquí mismo
                  //final planetasGuardados = context.read<ChocoChrocanteProvider>().planetasGuardados;

                  // 🚀 2. SALTO AL HIPERESPACIO
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChocosCopioPageViewScreen(planets: planets), 
                    ),
                  );
                },
              ),
              // 🃏 TARJETA 2: RADAR (Bloqueada)
              _buildTarjetaHolografica(
                icon: Icons.radar,
                titulo: 'Radar',
                isActiva: false,
              ),
              // 🃏 TARJETA 3: ENCICLOPEDIA (Bloqueada)
              _buildTarjetaHolografica(
                icon: Icons.menu_book,
                titulo: 'Bitácora',
                isActiva: false,
              ),
               // 🃏 TARJETA 4: CONFIGURACIÓN (Bloqueada - Solo para mostrar el Scroll)
              _buildTarjetaHolografica(
                icon: Icons.settings,
                titulo: 'Ajustes',
                isActiva: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🃏 MOLDE PARA LAS TARJETAS COMPACTAS (Squircles)
  Widget _buildTarjetaHolografica({
    required IconData icon,
    required String titulo,
    required bool isActiva,
    VoidCallback? onTap,
  }) {
    // Si está activa, brilla en bronce. Si no, se ve gris y apagada.
    final colorBase = isActiva ? const Color(0xFFCD7F32) : Colors.grey.withValues(alpha: 0.4);

    return GestureDetector(
      onTap: isActiva ? onTap : () {}, // Si no está activa, no hace nada al tocar
      child: Container(
        width: 65, // Cuadrado perfecto
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: colorBase.withValues(alpha: 0.1), // Fondo muy transparente
          borderRadius: BorderRadius.circular(18.0), // Bordes redondeados estilo app
          border: Border.all(
            color: colorBase.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topRight,
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: colorBase, size: 26),
                // 🔒 Ponemos un candadito si la tarjeta está inactiva
                if (!isActiva)
                  Positioned(
                    right: -5,
                    top: -5,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.black87,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock, color: Colors.white54, size: 10),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              titulo,
              style: TextStyle(
                color: isActiva ? Colors.white : Colors.white54,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
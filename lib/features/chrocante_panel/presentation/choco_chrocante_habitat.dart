import 'package:choco_universe/features/chrocante_panel/presentation/choco_artemis_live_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 👈 IMPORTAMOS LA MEMORIA
import 'chocoscopio_choconauta_screen.dart';
import 'dart:ui'; 
import 'package:choco_universe/features/chrocante_panel/presentation/chocoscopio_page_view_screen.dart';
import 'package:choco_universe/models/choco_systeme_solaire_model.dart';
import 'package:choco_universe/provider/choco_chrocante_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chocoscopio_welcome_overlay.dart'; 

class ChocoChrocanteHabitat extends StatefulWidget {
  final SystemeSolaire? planets;
  const ChocoChrocanteHabitat({super.key, this.planets});

  @override
  State<ChocoChrocanteHabitat> createState() => _ChocoChrocanteHabitatState();
}

class _ChocoChrocanteHabitatState extends State<ChocoChrocanteHabitat> {
  int _tapCount = 0;
  DateTime? _lastTapTime;
  bool _dialogAbierto = false;
  bool _soyElCreador = false;

  @override
  void initState() {
    super.initState();
    // 🚀 PROTOCOLO DE DESPERTAR AUTOMÁTICO (AHORA CON MEMORIA)
    _verificarSiEsPrimerVuelo();
  }

  // 🧠 CONSULTA AL DISCO DURO
  Future<void> _verificarSiEsPrimerVuelo() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Leemos el dato. Si no existe (es la primera vez), devolverá 'false' o null.
    final yaSePresento = prefs.getBool('chrocante_presentada') ?? false;

    if (!yaSePresento) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _lanzarHologramaBienvenida(isCreator: false);
      });
    }
  }

  void _onAjustesTapped() {
    if (_dialogAbierto) return; 

    final now = DateTime.now();
    
    if (_lastTapTime == null || now.difference(_lastTapTime!).inMilliseconds > 800) {
      _tapCount = 1;
    } else {
      _tapCount++;
    }
    
    _lastTapTime = now;

    if (_tapCount >= 7) {
      _tapCount = 0;
      _showPasswordInput(); 
    }
  }

  void _showPasswordInput() {
    setState(() { _dialogAbierto = true; });

    String password = '';
    
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), 
          child: AlertDialog(
            backgroundColor: const Color(0xFF0B0D17),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFCD7F32), width: 1.5),
            ),
            title: const Text('AUTENTICACIÓN DE PROTOCOLO PRIMARIO', style: TextStyle(color: Color(0xFFCD7F32), fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            content: TextField(
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(hintText: 'Ingrese Palabra Clave...', hintStyle: TextStyle(color: Colors.white24), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFCD7F32)))),
              onChanged: (value) => password = value,
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR', style: TextStyle(color: Colors.white54))),
              TextButton(
                onPressed: () {
                  if (password == 'DumbleDinhoPrime') {
                    Navigator.pop(context); 
                    setState(() { _soyElCreador = true; });
                    _lanzarHologramaBienvenida(isCreator: true);
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Código Incorrecto.'), backgroundColor: Colors.redAccent));
                  }
                },
                child: const Text('AUTENTICAR', style: TextStyle(color: Color(0xFFCD7F32))),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      setState(() { _dialogAbierto = false; });
    });
  }

  void _lanzarHologramaBienvenida({required bool isCreator}) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.transparent, 
      pageBuilder: (context, animation, secondaryAnimation) {
        return ChocosCopioWelcomeOverlay(
          isCreatorMode: isCreator,
          onDismissed: () async {
            // 🧠 GUARDAMOS EN DISCO DURO QUE YA SE PRESENTÓ (Solo si NO es el creador probando)
            if (!isCreator) {
               final prefs = await SharedPreferences.getInstance();
               await prefs.setBool('chrocante_presentada', true);
            }
            Navigator.pop(context); 
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final chrocanteProvider = context.watch<ChocoChrocanteProvider>();

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack, 
      bottom: chrocanteProvider.isExpanded ? 15 : -45, 
      right: chrocanteProvider.isExpanded ? 30 : 10, 
      child: GestureDetector(
        onTap: () => chrocanteProvider.togglePanel(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end, 
          children: [
            if (chrocanteProvider.isExpanded) _buildPanelHolografico(context),
            const SizedBox(height: 10),
            Image.asset(
              'assets/images/planetas/chrocante4.png', 
              width: 120,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanelHolografico(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30.0), 
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0), 
        child: Container(
          height: 85, 
          width: 260, 
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF0B0D17).withValues(alpha: 0.6), 
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(color: const Color(0xFFCD7F32).withValues(alpha: 0.5), width: 1.5),
            boxShadow: [BoxShadow(color: const Color(0xFFCD7F32).withValues(alpha: 0.1), blurRadius: 20, spreadRadius: 1)]
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(), 
            children: [
              _buildTarjetaHolografica(
                icon: Icons.travel_explore, titulo: 'Visor 3D', isActiva: true,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChocosCopioPageViewScreen(planets: widget.planets))),
              ),
              _buildTarjetaHolografica(
                icon: Icons.chat_bubble_outline, titulo: 'Choco-Nauta', isActiva: true,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChocoscopioChoconautaScreen(isCreatorMode: _soyElCreador))),
              ),
              _buildTarjetaHolografica(icon: Icons.rocket_launch, titulo: 'Misiones', isActiva: false),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('nasa_transmisions').doc('nasa_live').snapshots(),
                builder: (context, snapshot) {
                  bool hayEvento = false;
                  String videoId = '';
                  String titulo = '';
                  String mensaje = '';

                  if (snapshot.hasData && snapshot.data!.exists) {
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    final mapaEstado = data['currente_state'] as Map<String, dynamic>?;

                    if (mapaEstado != null) {
                      hayEvento = mapaEstado['en_vivo'] ?? false;
                      videoId = mapaEstado['youtube_id'] ?? '';
                      titulo = mapaEstado['titulo'] ?? '🔴 TRANSMISIÓN EN VIVO';
                      mensaje = mapaEstado['mensaje'] ?? 'Interceptando señal...';
                    }
                  }

                  return _buildTarjetaHolografica(
                    icon: Icons.live_tv, titulo: 'En Vivo', isActiva: true,
                    onTap: () {
                      if (hayEvento && videoId.isNotEmpty) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChocoArtemisLiveScreen(videoId: videoId, titulo: titulo, mensaje: mensaje)));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ChocoSinTransmisionScreen()));
                      }
                    },
                  );
                }
              ),
              _buildTarjetaHolografica(icon: Icons.settings, titulo: 'Ajustes', isActiva: true, esSecreta: true, onTap: _onAjustesTapped),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTarjetaHolografica({required IconData icon, required String titulo, required bool isActiva, bool esSecreta = false, VoidCallback? onTap}) {
    final colorBase = (isActiva && !esSecreta) ? const Color(0xFFCD7F32) : Colors.grey.withValues(alpha: 0.4);

    return GestureDetector(
      onTap: isActiva ? onTap : () {}, 
      child: Container(
        width: 65, margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(color: colorBase.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(18.0), border: Border.all(color: colorBase.withValues(alpha: 0.4), width: 1.5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topRight, clipBehavior: Clip.none,
              children: [
                Icon(icon, color: colorBase, size: 26),
                if (!isActiva || esSecreta)
                  Positioned(right: -5, top: -5, child: Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle), child: const Icon(Icons.lock, color: Colors.white54, size: 10))),
              ],
            ),
            const SizedBox(height: 4),
            Text(titulo, style: TextStyle(color: (isActiva && !esSecreta) ? Colors.white : Colors.white54, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';

// 📝 ESTRUCTURA DE UN MENSAJE
class ChocoMensaje {
  final String texto;
  final bool esUsuario; // true = Usted, false = Chrocante
  final DateTime fecha;

  ChocoMensaje({required this.texto, required this.esUsuario}) : fecha = DateTime.now();
}

class ChocoscopioChoconautaScreen extends StatefulWidget {
  final bool isCreatorMode; // 👈 Recibimos si usted es el padre o no

  const ChocoscopioChoconautaScreen({super.key, this.isCreatorMode = false});

  @override
  State<ChocoscopioChoconautaScreen> createState() => _ChocoscopioChoconautaScreenState();
}

class _ChocoscopioChoconautaScreenState extends State<ChocoscopioChoconautaScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  final List<ChocoMensaje> _mensajes = [];
  bool _estaPensando = false;

  @override
  void initState() {
    super.initState();
    // 🤖 Mensaje inicial de bienvenida al abrir el chat
    _mensajes.add(
      ChocoMensaje(
        texto: widget.isCreatorMode 
            ? "¡Frecuencia segura establecida, papá! 💖 Mis núcleos de procesamiento están listos. ¿Qué ordenas?"
            : "¡Frecuencia abierta, Choco-Explorador! ✨ Pregúntame lo que quieras sobre el cosmos.",
        esUsuario: false,
      ),
    );
  }

  // 🚀 FUNCIÓN PARA ENVIAR MENSAJES (Simulador Temporal)
  void _enviarMensaje() async {
    final texto = _textController.text.trim();
    if (texto.isEmpty) return;

    // 1. Agregamos su mensaje
    setState(() {
      _mensajes.add(ChocoMensaje(texto: texto, esUsuario: true));
      _textController.clear();
      _estaPensando = true; // Chrocante empieza a procesar
    });
    _hacerScrollHaciaAbajo();

    // 2. Simulamos que la IA real está pensando (2 segundos)
    await Future.delayed(const Duration(seconds: 2));

    // 3. Respuesta simulada (Aquí luego conectaremos a Gemini/ChatGPT)
    final respuestaSimulada = widget.isCreatorMode 
        ? "Analizando tu orden, Choco-Padre... ¡Entendido! Todo en el Choco Universe funciona según tus cálculos maestros."
        : "¡Interesante pregunta! Las estrellas son fascinantes, ¿sabías que en el Choco Universe tenemos un Sol de Miel?";

    if (mounted) {
      setState(() {
        _mensajes.add(ChocoMensaje(texto: respuestaSimulada, esUsuario: false));
        _estaPensando = false;
      });
      _hacerScrollHaciaAbajo();
    }
  }

  void _hacerScrollHaciaAbajo() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D17),
      body: Stack(
        children: [
          // ✨ EL FONDO ESTELAR
          const FondoEstelarChat(),

          SafeArea(
            child: Column(
              children: [
                // 📡 ENCABEZADO DE LA TERMINAL
                _buildEncabezado(),

                // 💬 LISTA DE MENSAJES
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    itemCount: _mensajes.length + (_estaPensando ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Si está pensando, mostramos el indicador al final
                      if (index == _mensajes.length && _estaPensando) {
                        return _buildIndicadorPensando();
                      }
                      
                      final mensaje = _mensajes[index];
                      return _buildBurbujaChat(mensaje);
                    },
                  ),
                ),

                // ⌨️ ZONA DE ESCRITURA
                _buildZonaEscritura(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- COMPONENTES VISUALES ---

  Widget _buildEncabezado() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0D17).withValues(alpha: 0.8),
        border: Border(bottom: BorderSide(color: const Color(0xFFCD7F32).withValues(alpha: 0.3))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFCD7F32), size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          CircleAvatar(
            backgroundColor: const Color(0xFFCD7F32).withValues(alpha: 0.2),
            backgroundImage: const AssetImage('assets/images/ia/chrocante.png'), // Su imagen
            radius: 20,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FRECUENCIA CHOCO-NAUTA',
                style: TextStyle(color: Color(0xFFCD7F32), fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2.0),
              ),
              Text(
                widget.isCreatorMode ? 'Conexión Prime: Encriptada' : 'IA Residente: En Línea',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 10, letterSpacing: 1.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBurbujaChat(ChocoMensaje mensaje) {
    final esUsted = mensaje.esUsuario;

    return Align(
      alignment: esUsted ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          // Si es usted, bronce oscuro. Si es Chrocante, cristal negro
          color: esUsted ? const Color(0xFFCD7F32).withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.5),
          border: Border.all(color: esUsted ? const Color(0xFFCD7F32) : const Color(0xFFCD7F32).withValues(alpha: 0.3)),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(esUsted ? 20 : 0), // Punta del globo de texto
            bottomRight: Radius.circular(esUsted ? 0 : 20),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          mensaje.texto,
          style: TextStyle(color: esUsted ? const Color(0xFFCD7F32) : Colors.white, fontSize: 14, height: 1.4),
        ),
      ),
    );
  }

  Widget _buildIndicadorPensando() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          border: Border.all(color: const Color(0xFFCD7F32).withValues(alpha: 0.3)),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFCD7F32))),
            const SizedBox(width: 10),
            Text('Procesando datos...', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }

  Widget _buildZonaEscritura() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF0B0D17).withValues(alpha: 0.8),
            border: Border(top: BorderSide(color: const Color(0xFFCD7F32).withValues(alpha: 0.3))),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xFFCD7F32).withValues(alpha: 0.5)),
                  ),
                  child: TextField(
                    controller: _textController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: widget.isCreatorMode ? 'Comando, Choco-Almirante...' : 'Escribe tu pregunta...',
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _enviarMensaje(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _enviarMensaje,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(color: Color(0xFFCD7F32), shape: BoxShape.circle),
                  child: const Icon(Icons.send, color: Colors.black, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ✨ WIDGET RECICLADO: EL FONDO ESTELAR (Solo para que no lo tenga que exportar)
class FondoEstelarChat extends StatelessWidget {
  const FondoEstelarChat({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random(42); 
    return Stack(
      children: List.generate(100, (index) {
        return Positioned(
          top: random.nextDouble() * MediaQuery.of(context).size.height,
          left: random.nextDouble() * MediaQuery.of(context).size.width,
          child: Container(
            width: random.nextDouble() * 2 + 1,
            height: random.nextDouble() * 2 + 1,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: random.nextDouble() * 0.6 + 0.1),
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}
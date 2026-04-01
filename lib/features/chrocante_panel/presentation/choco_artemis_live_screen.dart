import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChocoArtemisLiveScreen extends StatefulWidget {
  final String videoId;
  final String titulo;
  final String mensaje;

  const ChocoArtemisLiveScreen({
    super.key, 
    required this.videoId,
    required this.titulo,
    required this.mensaje,
  });

  @override
  State<ChocoArtemisLiveScreen> createState() => _ChocoArtemisLiveScreenState();
}

class _ChocoArtemisLiveScreenState extends State<ChocoArtemisLiveScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // 🦇 EL BATI-HACK DEL COMANDANTE + INYECCIÓN JAVASCRIPT
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0B0D17))
      // 🕵️‍♂️ AQUÍ ESTÁ LA MAGIA: Escuchamos cuándo termina de cargar la página
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            // 🦠 Inyectamos código directamente a la página de YouTube para apagar sus paneles
            _controller.runJavaScript('''
              try {
                // 1. Ocultamos la barra superior roja de búsqueda
                var headers = document.getElementsByTagName('ytm-mobile-topbar-renderer');
                if(headers.length > 0) headers[0].style.display = 'none';
                
                // Quitamos el margen en blanco que deja la barra superior
                document.body.style.marginTop = '-50px';

                // 2. Ocultamos los videos recomendados y los comentarios
                var sections = document.getElementsByTagName('ytm-item-section-renderer');
                for(var i = 0; i < sections.length; i++) {
                  sections[i].style.display = 'none';
                }

                // 3. Bloqueamos el scroll de la página para que se sienta como un reproductor fijo
                document.body.style.overflow = 'hidden';
              } catch(e) {}
            ''');
          },
        ),
      )
      ..loadRequest(Uri.parse('https://m.youtube.com/watch?v=${widget.videoId}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.titulo, 
          style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFCD7F32)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 📺 EL NAVEGADOR INFILTRADO
          // Le damos un poco más de altura (300) para que la página web móvil de YouTube se vea bien
          SizedBox(
            width: double.infinity,
            height: 300,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: WebViewWidget(controller: _controller),
            ),
          ),
          
          const SizedBox(height: 20),

          // 👩‍🚀 MENSAJE DINÁMICO DE CHROCANTE (Desde Firebase)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/ia/chrocante1.png'),
                    radius: 30,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFFCD7F32).withValues(alpha: 0.3)),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          // Respetamos los saltos de línea que usted escriba en Firebase
                          widget.mensaje.replaceAll('\\n', '\n'), 
                          style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 📺 PANTALLA DE SIN SEÑAL (ESTÁTICA)
class ChocoSinTransmisionScreen extends StatelessWidget {
  const ChocoSinTransmisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D17),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Color(0xFFCD7F32))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/planetas/satelite.png'),
              const SizedBox(height: 20),
              const Text('SIN SEÑAL INTERGALÁCTICA', style: TextStyle(color: Color(0xFFCD7F32), fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2)),
              const SizedBox(height: 15),
              Text('Mi choco-satélite no detecta ninguna señal en vivo en este momento. ¡Vuelve más tarde!', textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14, height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }
}
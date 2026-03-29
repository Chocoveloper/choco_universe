import 'package:flutter/material.dart';

// Este es el "Cerebro". No dibuja nada, solo piensa.
class ChocoChrocanteProvider extends ChangeNotifier {
  bool _isExpanded = false;

  bool get isExpanded => _isExpanded;

  void togglePanel() {
    _isExpanded = !_isExpanded;
    // ¡ESTA ES LA MAGIA! Avisa a los widgets que deben redibujarse
    notifyListeners(); 
  }
}
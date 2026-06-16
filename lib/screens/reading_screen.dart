import 'dart:async';
import 'package:flutter/material.dart';
import '../data/sample_texts.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  static const Duration _duracionLectura = Duration(seconds: 60);

  late final String _textoOriginal = obtenerTextoAleatorio();

  Timer? _temporizador;
  int _segundosRestantes = _duracionLectura.inSeconds;
  bool _finalizado = false;

  @override
  void initState() {
    super.initState();
    _iniciarCuentaAtras();
  }

  void _iniciarCuentaAtras() {
    _temporizador = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_segundosRestantes <= 1) {
          _segundosRestantes = 0;
          _finalizado = true;
          timer.cancel();
          _alFinalizarTiempo();
        } else {
          _segundosRestantes--;
        }
      });
    });
  }

  void _alFinalizarTiempo() {
    // Aquí se generarán las estadísticas en una próxima implementación.
  }

  @override
  void dispose() {
    _temporizador?.cancel();
    super.dispose();
  }

  String get _tiempoFormateado {
    final minutos = (_segundosRestantes ~/ 60).toString().padLeft(2, '0');
    final segundos = (_segundosRestantes % 60).toString().padLeft(2, '0');
    return '$minutos:$segundos';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lee que te cuento')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Lee el siguiente texto en voz alta:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  _tiempoFormateado,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _textoOriginal,
                  style: const TextStyle(fontSize: 20, height: 1.4),
                ),
              ),
            ),
            if (_finalizado)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  '¡Tiempo terminado!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

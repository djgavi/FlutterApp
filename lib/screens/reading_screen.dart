import 'dart:async';
import 'package:flutter/material.dart';
import '../data/sample_texts.dart';
import '../services/text_comparator.dart';
import '../services/transcription_service.dart';
import 'stats_screen.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  /// Duración total del ejercicio de lectura.
  static const Duration duracionLectura = Duration(seconds: 20);

  late final String _textoOriginal = obtenerTextoAleatorio();
  final TranscriptionService _transcripcion = TranscriptionService();

  Timer? _temporizador;
  String _textoTranscrito = '';
  bool _finalizando = false;

  @override
  void initState() {
    super.initState();
    _iniciarCuentaAtras();
    _iniciarTranscripcion();
  }

  Future<void> _iniciarTranscripcion() async {
    final disponible = await _transcripcion.inicializar();
    if (!disponible || !mounted) return;
    await _transcripcion.empezarAEscuchar(
      textoApoyo: _textoOriginal,
      onResultado: (transcripcionParcial) {
        if (!mounted) return;
        setState(() => _textoTranscrito = transcripcionParcial);
      },
    );
  }

  void _iniciarCuentaAtras() {
    _temporizador = Timer(duracionLectura, _finalizar);
  }

  void _finalizar() {
    if (_finalizando || !mounted) return;
    _finalizando = true;
    _temporizador?.cancel();
    _transcripcion.detener();
    final estadisticas = TextComparator.comparar(_textoOriginal, _textoTranscrito);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => StatsScreen(
          stats: estadisticas,
          textoOriginal: _textoOriginal,
          textoTranscrito: _textoTranscrito,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _temporizador?.cancel();
    _transcripcion.liberar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lee que te cuento'),
        actions: [
          TextButton(
            onPressed: _finalizar,
            child: const Text(
              'Finalizar',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lee el siguiente texto en voz alta:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
            const SizedBox(height: 16),
            const Text(
              'Transcripción en directo:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              _textoTranscrito.isEmpty ? '...' : _textoTranscrito,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

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

  /// Tiempo sin reconocer voz nueva tras el cual se da por terminada la lectura.
  static const Duration duracionSilencio = Duration(seconds: 5);

  late final String _textoOriginal = obtenerTextoAleatorio();
  final TranscriptionService _transcripcion = TranscriptionService();

  Timer? _temporizador;
  Timer? _temporizadorSilencio;
  int _segundosRestantes = duracionLectura.inSeconds;
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
    _reiniciarTemporizadorSilencio();
    await _transcripcion.empezarAEscuchar(
      textoApoyo: _textoOriginal,
      onResultado: (transcripcionParcial) {
        if (!mounted) return;
        setState(() => _textoTranscrito = transcripcionParcial);
        _reiniciarTemporizadorSilencio();
      },
    );
  }

  void _reiniciarTemporizadorSilencio() {
    _temporizadorSilencio?.cancel();
    _temporizadorSilencio = Timer(duracionSilencio, _alFinalizarTiempo);
  }

  void _iniciarCuentaAtras() {
    _temporizador = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_segundosRestantes <= 1) {
          _segundosRestantes = 0;
          timer.cancel();
          _alFinalizarTiempo();
        } else {
          _segundosRestantes--;
        }
      });
    });
  }

  void _alFinalizarTiempo() {
    if (_finalizando || !mounted) return;
    _finalizando = true;
    _temporizador?.cancel();
    _temporizadorSilencio?.cancel();
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
    _temporizadorSilencio?.cancel();
    _transcripcion.liberar();
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

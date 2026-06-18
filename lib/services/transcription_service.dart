import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Encapsula el reconocimiento de voz durante la lectura.
/// El motor permanece escuchando durante toda la [duracion] indicada
/// sin necesidad de reinicios.
class TranscriptionService {
  final SpeechToText _speech = SpeechToText();
  bool _disponible = false;

  Future<bool> inicializar() async {
    final permiso = await Permission.microphone.request();
    if (!permiso.isGranted) return false;
    _disponible = await _speech.initialize();
    return _disponible;
  }

  /// Escucha durante exactamente [duracion]. El motor no se detiene
  /// por pausas en el habla: solo para al agotarse el tiempo o al
  /// llamar a [detener].
  Future<void> empezarAEscuchar({
    required void Function(String transcripcionParcial) onResultado,
    required Duration duracion,
  }) async {
    if (!_disponible) return;
    await _speech.listen(
      onResult: (result) => onResultado(result.recognizedWords),
      listenOptions: SpeechListenOptions(
        partialResults: true,
        listenMode: ListenMode.dictation,
        localeId: 'es_ES',
        listenFor: duracion,
        // pauseFor igual a listenFor evita que el timeout de silencio
        // nativo de Android corte la escucha al hacer una pausa.
        pauseFor: duracion,
      ),
    );
  }

  Future<void> detener() async {
    if (_speech.isListening) await _speech.stop();
  }

  void liberar() {
    _speech.cancel();
  }
}

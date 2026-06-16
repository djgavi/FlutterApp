import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Encapsula el reconocimiento de voz continuo usado durante la lectura.
class TranscriptionService {
  final SpeechToText _speech = SpeechToText();
  bool _disponible = false;

  /// Pide permiso de micrófono e inicializa el motor de reconocimiento de voz.
  Future<bool> inicializar() async {
    final permiso = await Permission.microphone.request();
    if (!permiso.isGranted) {
      return false;
    }
    _disponible = await _speech.initialize();
    return _disponible;
  }

  /// Empieza a escuchar y transcribir. [textoApoyo] se usa como pista de
  /// contexto para ayudar al motor a reconocer mejor las palabras del texto
  /// que se está leyendo.
  Future<void> empezarAEscuchar({
    required void Function(String transcripcionParcial) onResultado,
    String? textoApoyo,
  }) async {
    if (!_disponible) return;
    await _speech.listen(
      onResult: (result) => onResultado(result.recognizedWords),
      listenOptions: SpeechListenOptions(
        partialResults: true,
        listenMode: ListenMode.dictation,
        localeId: 'es_ES',
      ),
    );
  }

  Future<void> detener() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }

  void liberar() {
    _speech.cancel();
  }
}

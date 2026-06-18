import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Encapsula el reconocimiento de voz continuo usado durante la lectura.
/// Cuando el motor se detiene por silencio, se reinicia automáticamente
/// hasta que se llame a [detener].
class TranscriptionService {
  final SpeechToText _speech = SpeechToText();
  bool _disponible = false;
  bool _activo = false;

  void Function(String)? _onResultado;

  /// Pide permiso de micrófono e inicializa el motor de reconocimiento de voz.
  /// Registra el callback de estado para relanzar la escucha automáticamente.
  Future<bool> inicializar() async {
    final permiso = await Permission.microphone.request();
    if (!permiso.isGranted) return false;

    _disponible = await _speech.initialize(
      onStatus: (status) {
        // Cuando el motor para por silencio o timeout, reiniciamos si seguimos activos.
        if (_activo && (status == 'done' || status == 'notListening')) {
          _escuchar();
        }
      },
    );
    return _disponible;
  }

  /// Inicia la escucha continua. [textoApoyo] se usa como pista de contexto.
  Future<void> empezarAEscuchar({
    required void Function(String transcripcionParcial) onResultado,
    String? textoApoyo,
  }) async {
    if (!_disponible) return;
    _onResultado = onResultado;
    _activo = true;
    await _escuchar();
  }

  Future<void> _escuchar() async {
    if (!_activo || _speech.isListening) return;
    await _speech.listen(
      onResult: (result) => _onResultado?.call(result.recognizedWords),
      listenOptions: SpeechListenOptions(
        partialResults: true,
        listenMode: ListenMode.dictation,
        localeId: 'es_ES',
      ),
    );
  }

  Future<void> detener() async {
    _activo = false;
    if (_speech.isListening) {
      await _speech.stop();
    }
  }

  void liberar() {
    _activo = false;
    _speech.cancel();
  }
}

import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Encapsula el reconocimiento de voz continuo usado durante la lectura.
/// Cuando el motor se detiene por silencio, se reinicia automáticamente
/// tras un breve retardo, hasta que se llame a [detener].
class TranscriptionService {
  final SpeechToText _speech = SpeechToText();
  bool _disponible = false;
  bool _activo = false;
  bool _reiniciando = false;

  void Function(String)? _onResultado;

  Future<bool> inicializar() async {
    final permiso = await Permission.microphone.request();
    if (!permiso.isGranted) return false;

    _disponible = await _speech.initialize(
      onStatus: (status) {
        // Evitamos relanzar si ya hay un reinicio pendiente o si estamos activos.
        if (!_activo || _reiniciando) return;
        if (status == 'done' || status == 'notListening') {
          _reiniciando = true;
          // Pequeño retardo para que el motor libere el micrófono completamente
          // antes de volver a abrirlo.
          Future.delayed(const Duration(milliseconds: 400), () {
            _reiniciando = false;
            if (_activo) _escuchar();
          });
        }
      },
    );
    return _disponible;
  }

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
    _reiniciando = false;
    if (_speech.isListening) await _speech.stop();
  }

  void liberar() {
    _activo = false;
    _reiniciando = false;
    _speech.cancel();
  }
}

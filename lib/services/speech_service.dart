import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isInitialized = false;

  Future<bool> initSpeech() async {
    // Minta izin mikrofon & inisialisasi speech recognition
    _isInitialized = await _speechToText.initialize();
    return _isInitialized;
  }

  void startListening(
    Function(String) onResult, {
    String localeId = 'id-ID',
  }) {
    if (!_isInitialized) return;

    _speechToText.listen(
      onResult: (val) {
        onResult(val.recognizedWords);
      },
      localeId: localeId,
    );
  }

  void stopListening() {
    _speechToText.stop();
  }

  void cancelListening() {
    _speechToText.cancel();
  }
}

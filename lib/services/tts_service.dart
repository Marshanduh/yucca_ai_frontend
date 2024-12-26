// import 'package:flutter_tts/flutter_tts.dart';

// class TtsService {
//   final FlutterTts _flutterTts = FlutterTts();

//   TtsService() {
//     // Default - kita set ke Indonesia, nanti bisa diubah
//     _flutterTts.setLanguage("id-ID");
//     _flutterTts.setPitch(1.0);
//     _flutterTts.setSpeechRate(0.9);
//   }

//   Future<void> setLanguage(String languageCode) async {
//     // Misalnya "id-ID" atau "en-US"
//     await _flutterTts.setLanguage(languageCode);
//   }

//   Future<void> speak(String text) async {
//     await _flutterTts.speak(text);
//   }

//   Future<void> stop() async {
//     await _flutterTts.stop();
//   }
// }

// lib/services/tts_service.dart

import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  // Dibuat public agar bisa pasang event handler (setCompletionHandler) di luar
  final FlutterTts flutterTts = FlutterTts();

  TtsService() {
    flutterTts.setLanguage("id-ID"); // Default Indonesia
    flutterTts.setPitch(1.0);
    flutterTts.setSpeechRate(0.9);
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }
}

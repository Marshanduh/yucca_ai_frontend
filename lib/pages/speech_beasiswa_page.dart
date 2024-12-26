// lib/pages/speech_beasiswa_page.dart

import 'package:flutter/material.dart';
import '../services/speech_service.dart';
import '../services/tts_service.dart';
import '../data/faq_data.dart';

class SpeechBeasiswaPage extends StatefulWidget {
  const SpeechBeasiswaPage({Key? key}) : super(key: key);

  @override
  _SpeechBeasiswaPageState createState() => _SpeechBeasiswaPageState();
}

class _SpeechBeasiswaPageState extends State<SpeechBeasiswaPage> {
  late SpeechService _speechService;
  late TtsService _ttsService;

  bool _isListening = false;
  bool _isSpeaking = false; // Indikator apakah TTS masih berjalan
  String _recognizedText = "";
  String _answer = "";

  @override
  void initState() {
    super.initState();
    _speechService = SpeechService();
    _ttsService = TtsService();
    _initializeServices();

    // Pasang handler ketika TTS selesai bicara
    _ttsService.flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false; // TTS sudah selesai, user bisa start lagi
      });
    });
  }

  Future<void> _initializeServices() async {
    bool available = await _speechService.initSpeech();
    if (!available) {
      print("Speech recognition tidak tersedia atau izin mic ditolak.");
    }
  }

  // Tombol Start ditekan
  void _startListening() {
    setState(() => _isListening = true);

    _speechService.startListening((text) {
      setState(() => _recognizedText = text);
    }, localeId: 'id-ID'); // Pakai bahasa Indonesia
  }

  // Tombol Stop ditekan
  void _stopListening() {
    setState(() => _isListening = false);
    _speechService.stopListening();
    _processQuestion(_recognizedText);
  }

  // Cek kata kunci
  void _processQuestion(String question) {
    final lower = question.toLowerCase();
    bool foundMatch = false;

    faqData.forEach((keyword, response) {
      if (lower.contains(keyword)) {
        _answer = response;
        foundMatch = true;
      }
    });

    if (!foundMatch) {
      _answer = "Maaf, belum ada jawaban untuk pertanyaan tersebut.";
    }

    setState(() {});

    // Mulai TTS -> set _isSpeaking = true
    _isSpeaking = true;
    _ttsService.speak(_answer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Beasiswa Q&A (Disable Start during TTS)"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Terdengar (STT): $_recognizedText"),
            const SizedBox(height: 20),
            Text("Jawaban (TTS):\n$_answer"),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol Start: hanya aktif bila TIDAK listening & TIDAK speaking
                ElevatedButton(
                  onPressed: (_isListening || _isSpeaking)
                      ? null
                      : _startListening,
                  child: const Text("Start"),
                ),
                const SizedBox(width: 20),

                // Tombol Stop: hanya aktif bila SEDANG listening
                ElevatedButton(
                  onPressed: _isListening ? _stopListening : null,
                  child: const Text("Stop"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

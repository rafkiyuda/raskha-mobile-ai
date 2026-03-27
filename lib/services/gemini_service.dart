import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey = "AIzaSyBogShSC8EUszgklDUb0_hC_uu7XQD-9L8";
  
  late final GenerativeModel _model;
  ChatSession? _chat;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
      systemInstruction: Content.system('Anda adalah Raksha AI, asisten keamanan investasi cerdas. Tugas Anda adalah membantu investor ritel mendeteksi penipuan, pump-and-dump, dan memberikan edukasi risiko investasi. Selalu berikan jawaban yang faktual, waspada, dan berfokus pada perlindungan dana investor. Gunakan gaya bahasa profesional namun mudah dimengerti (Bahasa Indonesia). Jika ditanya tentang saham spesifik, berikan analisis risiko berdasarkan sentimen sosial dan data fundamental.'),
    );
    _chat = _model.startChat();
  }

  Future<String> sendMessage(String message) async {
    try {
      final response = await _chat?.sendMessage(Content.text(message));
      return response?.text ?? "Maaf, saya tidak bisa memberikan jawaban saat ini.";
    } catch (e) {
      return "Terjadi kesalahan saat menghubungi AI: $e";
    }
  }

  void resetChat() {
    _chat = _model.startChat();
  }
}

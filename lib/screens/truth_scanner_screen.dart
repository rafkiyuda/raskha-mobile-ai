import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../widgets/raksha_card.dart';
import '../services/gemini_service.dart';

class TruthScannerScreen extends StatefulWidget {
  const TruthScannerScreen({super.key});

  @override
  State<TruthScannerScreen> createState() => _TruthScannerScreenState();
}

class _TruthScannerScreenState extends State<TruthScannerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _textController = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResult;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _startScanning() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isAnalyzing = true;
      _analysisResult = null;
    });

    final prompt = """
Analisis teks/link berikut untuk mendeteksi 'red flags' investasi (penipuan, pump-and-dump, klaim tidak realistis):
"$text"

Berikan jawaban dalam format JSON mentah (hanya JSON, tanpa markdown) dengan struktur:
{
  "risk_level": "MODERATE" | "HIGH" | "LOW",
  "truth_score": (angka 0-100),
  "findings": "penjelasan singkat tentang temuan Anda"
}
""";

    try {
      final response = await _geminiService.sendMessage(prompt);
      
      // Check if it's an error message from our service
      if (response.startsWith('Terjadi kesalahan')) {
        throw response;
      }

      // Clean the response if AI adds markdown
      final jsonStr = response.replaceAll('```json', '').replaceAll('```', '').trim();
      
      try {
        final data = jsonDecode(jsonStr);
        setState(() {
          _isAnalyzing = false;
          _analysisResult = data;
        });
      } catch (e) {
        // Fallback for non-JSON AI response but still a valid AI message
        setState(() {
          _isAnalyzing = false;
          _analysisResult = {
            "risk_level": "MODERATE",
            "truth_score": 50,
            "findings": response
          };
        });
      }
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
        _analysisResult = {
          "risk_level": "UNKNOWN",
          "truth_score": 0,
          "findings": "Gagal menganalisis teks. Coba lagi nanti. Error: $e"
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Truth Hub', style: TextStyle(color: RakshaColors.textDark, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: RakshaColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            const Text(
              'Deep-scan influencer claims and links',
              style: TextStyle(fontSize: 14, color: RakshaColors.textGray),
            ),
            const SizedBox(height: 24),
            _buildTabSelector(),
            const SizedBox(height: 24),
            _buildInputArea(),
            const SizedBox(height: 24),
            _buildScanButton(),
            if (_analysisResult != null || _isAnalyzing) ...[
              const SizedBox(height: 32),
              _buildAnalysisResult(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECEF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: RakshaColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: RakshaColors.textGray,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: 'URL Link'),
          Tab(text: 'Teks Biasa'),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return RakshaCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.search, size: 20, color: RakshaColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    _tabController.index == 0 ? 'PASTE ARTICLE/SOCIAL LINK' : 'PASTE TEXT/CLAIM',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: RakshaColors.primary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: RakshaColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Paste', style: TextStyle(color: RakshaColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: _tabController.index == 0 
                ? 'https://tiktok.com/@pompom...' 
                : 'Ketikkan klaim berlebihan yang mencurigakan di WhatsApp...',
              hintStyle: const TextStyle(color: RakshaColors.textLight, fontSize: 14),
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _isAnalyzing ? null : _startScanning,
        style: ElevatedButton.styleFrom(
          backgroundColor: RakshaColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        icon: _isAnalyzing 
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : const Icon(Icons.search),
        label: Text(
          _isAnalyzing ? 'Analyzing the Truth...' : 'Scan Red Flags',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildAnalysisResult() {
    if (_isAnalyzing) {
      return const Column(
        children: [
          CircularProgressIndicator(color: RakshaColors.primary),
          SizedBox(height: 16),
          Text('Checking patterns and claim history...', style: TextStyle(color: RakshaColors.textGray)),
        ],
      );
    }

    final score = _analysisResult?['truth_score'] ?? 0;
    final risk = _analysisResult?['risk_level'] ?? 'UNKNOWN';
    final findings = _analysisResult?['findings'] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Analysis Result',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: RakshaColors.textDark),
        ),
        const SizedBox(height: 16),
        RakshaCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RISK: $risk',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: RakshaColors.primary),
              ),
              const SizedBox(height: 8),
              Text(
                'Truth Score: $score/100',
                style: const TextStyle(fontSize: 14, color: RakshaColors.textGray),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: score / 100,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFE9ECEF),
                  valueColor: const AlwaysStoppedAnimation<Color>(RakshaColors.primary),
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'AI FINDINGS:',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: RakshaColors.textDark),
              ),
              const SizedBox(height: 8),
              Text(
                findings,
                style: const TextStyle(fontSize: 14, color: RakshaColors.textGray, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

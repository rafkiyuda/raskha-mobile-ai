import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../widgets/raksha_card.dart';
import 'sentiment_analyzer_screen.dart';
import 'truth_dashboard_screen.dart';

class TruthSelectionScreen extends StatelessWidget {
  const TruthSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Truth Hub',
          style: TextStyle(color: RakshaColors.textDark, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Market Intelligence',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: RakshaColors.textDark),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pilih alat analisis untuk mendeteksi bias dan kebenaran investasi.',
              style: TextStyle(fontSize: 14, color: RakshaColors.textGray),
            ),
            const SizedBox(height: 32),
            _buildSentimentCard(context),
            const SizedBox(height: 20),
            _buildFactCheckerCard(context),
            const SizedBox(height: 32),
            _buildBottomNote(),
          ],
        ),
      ),
    );
  }

  Widget _buildSentimentCard(BuildContext context) {
    return RakshaCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SentimentAnalyzerScreen())),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.purple.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.psychology, color: Colors.purple, size: 28),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sentiment AI', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('Deteksi emosi pasar (FOMO/Panic)', style: TextStyle(fontSize: 13, color: RakshaColors.textGray)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: RakshaColors.textLight),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Market Sentiment Meter', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: RakshaColors.textDark)),
              const SizedBox(height: 12),
              _buildSentimentMeter(),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('FOMO', style: TextStyle(fontSize: 10, color: RakshaColors.textGray)),
                  Text('Bullish', style: TextStyle(fontSize: 10, color: RakshaColors.textGray)),
                  Text('Neutral', style: TextStyle(fontSize: 10, color: RakshaColors.textGray)),
                  Text('Bearish', style: TextStyle(fontSize: 10, color: RakshaColors.textGray)),
                  Text('Panic', style: TextStyle(fontSize: 10, color: RakshaColors.textGray)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSentimentMeter() {
    return Container(
      height: 12,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFF8A00), // FOMO
            Color(0xFF8DC63F), // Bullish
            Color(0xFF5AB9EA), // Neutral
            Color(0xFF9155FD), // Bearish
            Color(0xFFF06292), // Panic
          ],
        ),
      ),
    );
  }

  Widget _buildFactCheckerCard(BuildContext context) {
    return RakshaCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TruthDashboardScreen())),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.fact_check, color: Colors.blue, size: 28),
              ),
              const SizedBox(width: 20),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fact Checker (Scanner)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(
                      'Scan red flags pada klaim influencer, berita, dan link mencurigakan.',
                      style: TextStyle(fontSize: 13, color: RakshaColors.textGray),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: RakshaColors.textLight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNote() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(color: RakshaColors.primary, shape: BoxShape.circle),
            child: const Icon(Icons.check, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Semua hasil didasarkan pada data real-time dari bursa dan literasi keuangan resmi.',
              style: TextStyle(fontSize: 12, color: RakshaColors.textGray, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

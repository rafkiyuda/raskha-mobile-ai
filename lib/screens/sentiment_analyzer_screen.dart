import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../widgets/raksha_card.dart';
import '../widgets/crisis_accordion_card.dart';
import '../services/idx_service.dart';

class SentimentAnalyzerScreen extends StatelessWidget {
  const SentimentAnalyzerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final feed = IdxService.getSentimentFeed();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('IndoBERT-powered bias detection', style: TextStyle(color: RakshaColors.textGray, fontSize: 13)),
          const SizedBox(height: 24),
          _buildSentimentMeter(),
          const SizedBox(height: 32),
          const Text('STOCK SENTIMENT FEED', style: TextStyle(color: RakshaColors.textGray, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...feed.map((f) => _buildSentimentCard(context, f)),
        ],
      ),
    );
  }

  Widget _buildSentimentMeter() {
    return RakshaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Market Sentiment Meter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                child: const Text('2 FOMO Alerts', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: const LinearGradient(
                colors: [Colors.red, Colors.orange, Colors.blue, Colors.blueAccent, Colors.redAccent],
              ),
            ),
          ),
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
          const SizedBox(height: 24),
          _buildAlert('Elevated emotional trading detected across IDX. Exercise caution with trending stocks.'),
        ],
      ),
    );
  }

  Widget _buildAlert(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.05), border: Border.all(color: Colors.orange.withOpacity(0.1), width: 1), borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.orangeAccent))),
        ],
      ),
    );
  }

  Widget _buildSentimentCard(BuildContext context, Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CrisisAccordionCard(
        symbol: data['symbol'],
        name: data['name'],
        priceChange: data['trend'],
        tags: [data['sentiment'], 'Finfluencer'],
        alertText: (data['alerts'] as List).first,
        stats: {
          'Mentions': data['mentions'],
          'Herding': '${data['herding']}%',
          'Fundamental': '${data['fundamental']}',
        },
        socialHype: data['score'],
        sourceDistribution: Map<String, double>.from(data['sources']),
      ),
    );
  }

  Widget _metricBox(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: RakshaColors.bgSlate, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: RakshaColors.textGray, fontSize: 10)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

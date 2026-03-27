import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../widgets/raksha_card.dart';
import '../services/idx_service.dart';

class CrisisPlaybookScreen extends StatelessWidget {
  const CrisisPlaybookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final market = IdxService.getMarketOverview();
    final options = IdxService.getSafeHavenOptions();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crisis Playbook', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Early warning based on IDX real-time volatility', style: TextStyle(color: RakshaColors.textGray, fontSize: 13)),
            const SizedBox(height: 24),
            _buildVolatilityAlert(),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _metricCard('JCI Change', '${market['jci_change'] ?? 0}%', Colors.red),
                _metricCard('VIX Index', '${market['vix_index'] ?? 0}', Colors.orange),
                _metricCard('USD/IDR', '${(market['usd_idr'] ?? 0.0).toInt()}', Colors.blue),
                _metricCard('Foreign Selling', '${market['foreign_net_sell'] ?? 0}T', Colors.red),
              ],
            ),
            const SizedBox(height: 32),
            const Text('SAFE HAVEN OPTIONS', style: TextStyle(color: RakshaColors.textGray, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...options.map((o) => _buildSafeHavenCard(o)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildVolatilityAlert() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.priority_high, color: Colors.red, size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Market Volatility Alert', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red)),
                SizedBox(height: 4),
                Text('IHSG turun mendadak. Mode krisis direkomendasikan untuk proteksi modal.', style: TextStyle(fontSize: 12, color: RakshaColors.textGray)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricCard(String label, String value, Color color) {
    return RakshaCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: RakshaColors.textGray, fontSize: 11)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
        ],
      ),
    );
  }

  Widget _buildSafeHavenCard(Map<String, String> option) {
    return RakshaCard(
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(option['name'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('Risk: ${option['risk'] ?? 'N/A'}', style: const TextStyle(color: RakshaColors.textGray, fontSize: 12)),
              ],
            ),
          ),
          Text(option['yield'] ?? '0%', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

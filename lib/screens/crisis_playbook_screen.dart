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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('Crisis Playbook', style: TextStyle(color: RakshaColors.textDark, fontWeight: FontWeight.bold)),
        leading: const BackButton(color: RakshaColors.textDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                border: Border.all(color: Colors.redAccent.withOpacity(0.3), width: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 8, color: Colors.redAccent),
                  SizedBox(width: 6),
                  Text('CRISIS MODE ACTIVE', style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildCrisisIntensity(market['vix_index'] ?? 0.0),
            const SizedBox(height: 32),
            const Text(
              'MARKET VOLATILITY FEED',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: RakshaColors.textGray, letterSpacing: 1.2),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                _buildMetricCard('JCI Change', '${market['jci_change'] ?? 0}%', Colors.red, Icons.trending_down),
                _buildMetricCard('VIX Index', '${market['vix_index'] ?? 0}', Colors.orange, Icons.warning_amber),
                _buildMetricCard('USD/IDR', '${(market['usd_idr'] ?? 0.0).toInt()}', Colors.blue, Icons.attach_money),
                _buildMetricCard('Foreign Net', '${market['foreign_net_sell'] ?? 0}T', Colors.red, Icons.show_chart),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'PROTECTION STRATEGIES',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: RakshaColors.textGray, letterSpacing: 1.2),
            ),
            const SizedBox(height: 16),
            ...options.map((o) => _buildSafeHavenCard(o)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCrisisIntensity(double vix) {
    return RakshaCard(
      padding: const EdgeInsets.all(24),
      backgroundIcon: Icons.speed,
      backgroundIconOpacity: 0.03,
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: vix / 100,
                  strokeWidth: 10,
                  backgroundColor: Colors.black12,
                  color: Colors.redAccent,
                  strokeCap: StrokeCap.round,
                ),
              ),
              const Column(
                children: [
                  Text('Level', style: TextStyle(color: RakshaColors.textGray, fontSize: 10)),
                  Text('HIGH', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.redAccent)),
                ],
              ),
            ],
          ),
          const SizedBox(width: 24),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Real-time Volatility Score', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                SizedBox(height: 6),
                Text(
                  'Skor di atas 30 menunjukkan kepanikan pasar. Gunakan instrumen proteksi sekarang.',
                  style: TextStyle(fontSize: 12, color: RakshaColors.textGray, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, Color color, IconData motif) {
    return RakshaCard(
      padding: const EdgeInsets.all(16),
      backgroundIcon: motif,
      backgroundIconOpacity: 0.04,
      backgroundIconSize: 70,
      backgroundIconOffset: const Offset(1.15, 0.45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: RakshaColors.textGray, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: color)),
        ],
      ),
    );
  }

  Widget _buildSafeHavenCard(Map<String, String> option) {
    IconData getIcon(String? name) {
      if (name?.contains('Gold') ?? false) return Icons.stars;
      if (name?.contains('Bonds') ?? false) return Icons.account_balance;
      return Icons.shield_outlined;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RakshaCard(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: RakshaColors.info.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(getIcon(option['name']), color: RakshaColors.info, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option['name'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text('Risk level: ${option['risk'] ?? 'N/A'}', style: const TextStyle(color: RakshaColors.textGray, fontSize: 12)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Est. Yield', style: TextStyle(fontSize: 10, color: RakshaColors.textGray)),
                Text(option['yield'] ?? '0%', style: const TextStyle(color: RakshaColors.info, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

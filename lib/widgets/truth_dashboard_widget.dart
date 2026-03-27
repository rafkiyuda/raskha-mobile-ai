import 'dart:math';
import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../widgets/raksha_card.dart';
import '../services/idx_service.dart';
import '../main.dart';

class TruthDashboardWidget extends StatefulWidget {
  const TruthDashboardWidget({super.key});

  @override
  State<TruthDashboardWidget> createState() => _TruthDashboardWidgetState();
}

class _TruthDashboardWidgetState extends State<TruthDashboardWidget> {
  late List<Map<String, dynamic>> _data;
  final Map<int, String?> _aiInsights = {};
  final Set<int> _loadingInsights = {};

  @override
  void initState() {
    super.initState();
    _data = IdxService.getFinancialIntegrityData();
  }

  Future<void> _fetchAIInsight(int index, String symbol) async {
    if (_loadingInsights.contains(index)) return;

    setState(() {
      _loadingInsights.add(index);
    });

    try {
      final insight = await IdxService.getAIInsight(symbol);
      setState(() {
        _aiInsights[index] = insight;
      });
    } catch (e) {
      setState(() {
        _aiInsights[index] = 'Gagal memuat insight dari AI. Silakan coba lagi nanti.';
      });
    } finally {
      setState(() {
        _loadingInsights.remove(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'AI-powered financial statement integrity',
              style: TextStyle(color: RakshaColors.textGray, fontSize: 13),
            ),
          ),
          const SizedBox(height: 24),
          _buildMainGauge(),
          const SizedBox(height: 16),
          _buildGaugeLegend(),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'STOCK ANALYSIS',
                style: TextStyle(color: RakshaColors.textGray, fontSize: 13, fontWeight: FontWeight.bold),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.swap_vert, size: 14),
                label: const Text('Score High', style: TextStyle(fontSize: 11)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: RakshaColors.textDark,
                  side: const BorderSide(color: Colors.black12),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._data.asMap().entries.map((entry) => _buildStockCard(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildMainGauge() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          const SizedBox(
            width: 140,
            height: 140,
            child: CircularProgressIndicator(
              value: 0.73,
              strokeWidth: 12,
              backgroundColor: Colors.black12,
              color: RakshaColors.primary,
              strokeCap: StrokeCap.round,
            ),
          ),
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '73',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: RakshaColors.textDark),
              ),
              Text(
                'Average Score',
                style: TextStyle(fontSize: 10, color: RakshaColors.textGray),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGaugeLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(Colors.green, '70-100 Safe'),
        const SizedBox(width: 16),
        _legendItem(Colors.orange, '40-69 Caution'),
        const SizedBox(width: 16),
        _legendItem(Colors.red, '0-39 Danger'),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 10, color: RakshaColors.textGray)),
      ],
    );
  }

  Widget _buildStockCard(int index, Map<String, dynamic> stock) {
    final bool isExpanded = stock['isExpanded'] ?? false;
    final int score = stock['score'];
    final Color scoreColor = score >= 70 ? Colors.green : (score >= 40 ? Colors.orange : Colors.red);
    final bool isLoadingInsight = _loadingInsights.contains(index);
    final String? aiInsight = _aiInsights[index];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RakshaCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _data[index]['isExpanded'] = !isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 44,
                          height: 44,
                          child: CircularProgressIndicator(
                            value: score / 100,
                            strokeWidth: 4,
                            backgroundColor: Colors.black12,
                            color: scoreColor,
                          ),
                        ),
                        Text(
                          '$score',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(stock['symbol'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: RakshaColors.bgSlate, borderRadius: BorderRadius.circular(4)),
                                child: Text(stock['grade'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: RakshaColors.textGray)),
                              ),
                            ],
                          ),
                          Text(stock['name'], style: const TextStyle(color: RakshaColors.textGray, fontSize: 13)),
                        ],
                      ),
                    ),
                    Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: RakshaColors.textLight),
                  ],
                ),
              ),
            ),
            if (isExpanded) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _metricBox('Net Profit', stock['netProfit'], Icons.trending_up),
                        const SizedBox(width: 12),
                        _metricBox('Cash Flow', stock['cashFlow'], Icons.account_balance_wallet_outlined),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Profit-Cash Alignment', style: TextStyle(fontSize: 12, color: RakshaColors.textGray)),
                        Text('${stock['alignment']}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: RakshaColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: stock['alignment'] / 100,
                      backgroundColor: Colors.black12,
                      color: RakshaColors.primary,
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 8,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          const Icon(Icons.description_outlined, color: Colors.blue, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              stock['anomalies'],
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _fetchAIInsight(index, stock['symbol']);
                            },
                            icon: Icon(isLoadingInsight ? Icons.hourglass_empty : Icons.auto_awesome_outlined, size: 16),
                            label: Text(isLoadingInsight ? 'Menganalisis...' : 'Insight Cepat (AI)', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: RakshaColors.textDark,
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: Colors.black12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final nav = MainNavigation.of(context);
                              if (nav != null) {
                                // Pop the dashboard screen first to return to MainNavigation
                                Navigator.of(context).pop();
                                
                                // Then switch to Chat tab with context
                                nav.setIndex(
                                  4,
                                  stockContext: {
                                    'symbol': stock['symbol'],
                                    'name': stock['name'],
                                    'score': stock['score'],
                                  },
                                );
                              }
                            },
                            icon: const Icon(Icons.chat_bubble_outline, size: 16),
                            label: const Text('Chat AI Detailnya', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: RakshaColors.textDark,
                              backgroundColor: const Color(0xFFE2E8F0),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (aiInsight != null) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'AI FUNDAMENTAL INSIGHT',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: RakshaColors.textGray),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.purple.withOpacity(0.1)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.psychology, color: Colors.purple, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                aiInsight,
                                style: const TextStyle(fontSize: 13, color: RakshaColors.textDark, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _metricBox(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: RakshaColors.bgSlate, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: RakshaColors.textGray),
                const SizedBox(width: 4),
                Text(label, style: const TextStyle(color: RakshaColors.textGray, fontSize: 10)),
              ],
            ),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(String label, IconData icon, {required bool isPrimary, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFFE2E8F0) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isPrimary ? null : Border.all(color: Colors.black12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: RakshaColors.textDark),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: RakshaColors.textDark)),
          ],
        ),
      ),
    );
  }
}

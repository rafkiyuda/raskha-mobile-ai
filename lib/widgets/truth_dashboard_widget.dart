import 'dart:math';
import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../widgets/raksha_card.dart';
import '../services/idx_service.dart';

class TruthDashboardWidget extends StatefulWidget {
  const TruthDashboardWidget({super.key});

  @override
  State<TruthDashboardWidget> createState() => _TruthDashboardWidgetState();
}

class _TruthDashboardWidgetState extends State<TruthDashboardWidget> {
  late List<Map<String, dynamic>> _data;

  @override
  void initState() {
    super.initState();
    _data = IdxService.getFinancialIntegrityData();
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
          SizedBox(
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
                        Expanded(child: _actionButton('Insight Cepat (AI)', Icons.auto_awesome_outlined, isPrimary: false)),
                        const SizedBox(width: 12),
                        Expanded(child: _actionButton('Chat AI Detailnya', Icons.chat_bubble_outline, isPrimary: true)),
                      ],
                    ),
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

  Widget _actionButton(String label, IconData icon, {required bool isPrimary}) {
    return Container(
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
    );
  }
}

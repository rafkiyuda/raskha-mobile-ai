import 'package:flutter/material.dart';
import '../core/colors.dart';
import 'raksha_card.dart';

class CrisisAccordionCard extends StatefulWidget {
  final String symbol;
  final String name;
  final double priceChange;
  final List<String> tags;
  final String alertText;
  final Map<String, String> stats;
  final double socialHype;
  final Map<String, double> sourceDistribution;

  const CrisisAccordionCard({
    super.key,
    required this.symbol,
    required this.name,
    required this.priceChange,
    required this.tags,
    required this.alertText,
    required this.stats,
    required this.socialHype,
    required this.sourceDistribution,
  });

  @override
  State<CrisisAccordionCard> createState() => _CrisisAccordionCardState();
}

class _CrisisAccordionCardState extends State<CrisisAccordionCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return RakshaCard(
      color: Colors.white,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildHeader(),
          if (_isExpanded) _buildExpandedContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            _buildLogo(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.symbol,
                        style: const TextStyle(color: RakshaColors.textDark, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      ...widget.tags.map((tag) => _buildTag(tag)).toList(),
                    ],
                  ),
                  Text(
                    widget.name,
                    style: const TextStyle(color: RakshaColors.textGray, fontSize: 13),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      '${widget.priceChange > 0 ? '+' : ''}${widget.priceChange}%',
                      style: TextStyle(
                        color: widget.priceChange > 0 ? RakshaColors.info : RakshaColors.danger,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: RakshaColors.textLight,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: RakshaColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.local_fire_department, color: RakshaColors.primary, size: 24),
    );
  }

  Widget _buildTag(String text) {
    final isFomo = text.contains('FOMO');
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isFomo ? Colors.red.withOpacity(0.1) : RakshaColors.bgSlate,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isFomo ? Colors.redAccent : RakshaColors.textGray,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.black12, height: 24),
          _buildStatsRow(),
          const SizedBox(height: 24),
          _buildHypeBar(),
          const SizedBox(height: 24),
          _buildSourceDistribution(),
          const SizedBox(height: 16),
          _buildActionTags(),
          const SizedBox(height: 16),
          _buildAlertBox(),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widget.stats.entries.map((e) => _buildStatItem(e.key, e.value)).toList(),
    );
  }

  Widget _buildStatItem(String label, String value) {
    final isHerding = label == 'Herding';
    return Column(
      children: [
        Row(
          children: [
            Icon(
              label == 'Mentions' ? Icons.chat_bubble_outline : (label == 'Herding' ? Icons.groups_outlined : Icons.analytics_outlined),
              size: 14,
              color: RakshaColors.textGray,
            ),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: RakshaColors.textGray, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: isHerding ? Colors.redAccent : RakshaColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildHypeBar() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Social Hype', style: TextStyle(color: RakshaColors.textGray, fontSize: 12)),
            Text('Fundamentals', style: TextStyle(color: RakshaColors.textGray, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(color: RakshaColors.bgSlate, borderRadius: BorderRadius.circular(4)),
            ),
            FractionallySizedBox(
              widthFactor: widget.socialHype / 100,
              child: Container(
                height: 8,
                decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSourceDistribution() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Source Distribution', style: TextStyle(color: RakshaColors.textGray, fontSize: 12)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widget.sourceDistribution.entries.map((e) {
            return Column(
              children: [
                Text(e.key, style: const TextStyle(color: RakshaColors.textGray, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  '${e.value.toInt()}%',
                  style: const TextStyle(color: RakshaColors.textDark, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionTags() {
    return Row(
      children: [
        _buildSmallTag('GOTO to the moon'),
        const SizedBox(width: 8),
        _buildSmallTag('GOTO rally continues'),
      ],
    );
  }

  Widget _buildSmallTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: RakshaColors.bgSlate,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(color: RakshaColors.textGray, fontSize: 11),
      ),
    );
  }

  Widget _buildAlertBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.alertText,
              style: const TextStyle(color: Colors.orange, fontSize: 12, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../widgets/raksha_card.dart';
import '../models/news_item.dart';
import 'news_list_screen.dart';
import 'news_detail_screen.dart';

import '../services/idx_service.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<_WatchlistStock> _stocks = [
    _WatchlistStock(
      symbol: 'GOTO',
      name: 'GoTo Gojek Tokopedia',
      riskScore: 95,
      riskTag: 'HIGH RISK',
      priceChange: -4.2,
      alertText: 'Special Monitoring - High Volatility',
      insight: 'Social sentiment anomaly detected. Truth Score indicates mismatch with projected earnings. Protective recommendation active due to potential pump-and-dump signals detected in retail channels.',
      isHighRisk: true,
    ),
    _WatchlistStock(
      symbol: 'BUKA',
      name: 'Bukalapak.com',
      riskScore: 65,
      riskTag: 'REVIEW',
      priceChange: 1.5,
      alertText: 'Sentiment Anomaly Detected',
      insight: 'Heavy selling pressure from retail sector. Sentiment anomaly detected in community forums. Alignment with fundamental data remains moderate.',
      isHighRisk: false,
    ),
  ];

  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildCrisisAlert(context),
              const SizedBox(height: 24),
              _buildPortfolioCard(),
              const SizedBox(height: 24),
              _buildQuickActions(context),
              const SizedBox(height: 32),
              _buildInvestorInsights(context),
              const SizedBox(height: 32),
              _buildWatchlistInsights(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => MainNavigation.of(context)?.setIndex(4),
          child: CircleAvatar(
            backgroundColor: RakshaColors.primary.withOpacity(0.1),
            child: const Text('S', style: TextStyle(color: RakshaColors.primary, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back,', style: TextStyle(color: RakshaColors.textGray, fontSize: 12)),
            Text('Sherine', style: TextStyle(color: RakshaColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.notifications_none, color: RakshaColors.textDark),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications coming soon')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPortfolioCard() {
    return RakshaCard(
      isEmerald: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Portfolio Value', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          const Text('Rp 150.000.000', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: RakshaCard(
                  isGlass: true,
                  padding: const EdgeInsets.all(12),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Truth Score Avg', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      SizedBox(height: 4),
                      Text('73/100', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RakshaCard(
                  isGlass: true,
                  padding: const EdgeInsets.all(12),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Risk Level', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text('Moderate', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(width: 4),
                          Icon(Icons.trending_up, color: Colors.white, size: 16),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCrisisAlert(BuildContext context) {
    final market = IdxService.getMarketOverview();
    if (!(market['is_crisis'] ?? false)) return const SizedBox.shrink();

    return RakshaCard(
      color: Colors.red.withOpacity(0.05),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MARKET CRISIS ALERT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.red)),
                Text('IHSG turun mendadak (-5.2%). Cek Playbook Krisis.', style: TextStyle(fontSize: 11, color: RakshaColors.textGray)),
              ],
            ),
          ),
          TextButton(
            onPressed: () => MainNavigation.of(context)?.setIndex(2),
            child: const Text('VIEW', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            label: 'AI Co-Pilot',
            icon: Icons.security_outlined,
            onTap: () => MainNavigation.of(context)?.setIndex(2),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _QuickActionButton(
            label: 'Truth Scanner',
            icon: Icons.analytics_outlined,
            onTap: () => MainNavigation.of(context)?.setIndex(1),
          ),
        ),
      ],
    );
  }

  Widget _buildInvestorInsights(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Investor Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: RakshaColors.textDark)),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewsListScreen()),
                );
              },
              child: const Text('See All', style: TextStyle(color: RakshaColors.primary)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: mockNews.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final news = mockNews[index];
              return _NewsHorizontalCard(news: news);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWatchlistInsights(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Your Watchlist Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: RakshaColors.textDark)),
            TextButton(
              onPressed: () {},
              child: const Text('See All', style: TextStyle(color: RakshaColors.primary)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _stocks.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final stock = _stocks[index];
            final isExpanded = _expandedIndex == index;
            return _ExpandableStockCard(
              stock: stock,
              isExpanded: isExpanded,
              onTap: () {
                setState(() {
                  _expandedIndex = isExpanded ? null : index;
                });
              },
            );
          },
        ),
      ],
    );
  }
}

class _WatchlistStock {
  final String symbol;
  final String name;
  final double riskScore;
  final String riskTag;
  final double priceChange;
  final String alertText;
  final String insight;
  final bool isHighRisk;

  _WatchlistStock({
    required this.symbol,
    required this.name,
    required this.riskScore,
    required this.riskTag,
    required this.priceChange,
    required this.alertText,
    required this.insight,
    required this.isHighRisk,
  });
}

class _ExpandableStockCard extends StatelessWidget {
  final _WatchlistStock stock;
  final bool isExpanded;
  final VoidCallback onTap;

  const _ExpandableStockCard({
    required this.stock,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final riskColor = stock.isHighRisk ? Colors.red : Colors.orange;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: RakshaCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.black12,
                        child: Text(stock.symbol[0], style: const TextStyle(color: RakshaColors.textDark, fontSize: 14)),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(stock.symbol, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: riskColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                                child: Text(stock.riskTag, style: TextStyle(color: riskColor, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          Text(stock.name, style: const TextStyle(color: RakshaColors.textGray, fontSize: 12)),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${stock.priceChange > 0 ? '+' : ''}${stock.priceChange}%',
                            style: TextStyle(color: stock.priceChange > 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Icon(isExpanded ? Icons.expand_less : Icons.expand_more, size: 20, color: RakshaColors.textLight),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Risk Level', style: TextStyle(color: RakshaColors.textGray, fontSize: 12)),
                      Text('${stock.riskScore.toInt()}/100', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: stock.riskScore / 100,
                    backgroundColor: Colors.black12,
                    color: riskColor,
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 6,
                  ),
                  const SizedBox(height: 12),
                  Text(stock.alertText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: RakshaColors.textDark)),
                  const SizedBox(height: 4),
                  const Text('Last updated: 2 min ago', style: TextStyle(color: RakshaColors.textLight, fontSize: 11)),
                ],
              ),
            ),
            if (isExpanded) ...[
              const Divider(height: 1, indent: 16, endIndent: 16),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stock.insight, style: const TextStyle(color: RakshaColors.textGray, fontSize: 13, height: 1.5)),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => MainNavigation.of(context)?.setIndex(
                          2,
                          initialMessage: 'Bisa jelaskan detail risiko untuk saham ${stock.symbol} (${stock.name})? Tadi saya lihat skor risikonya ${stock.riskScore.toInt()}/100.',
                        ),
                        icon: const Icon(Icons.chat_bubble_outline, size: 18),
                        label: const Text('Tanya AI Detailnya'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: RakshaColors.primary,
                          side: BorderSide(color: RakshaColors.primary.withOpacity(0.3)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (stock.isHighRisk)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.05),
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_outlined, color: Colors.red, size: 14),
                    SizedBox(width: 8),
                    Text('Risk Alert: Protective Recommendation Active', style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: RakshaCard(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: RakshaColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: RakshaColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
            const Icon(Icons.chevron_right, color: RakshaColors.textLight, size: 18),
          ],
        ),
      ),
    );
  }
}
class _NewsHorizontalCard extends StatelessWidget {
  final NewsItem news;
  const _NewsHorizontalCard({required this.news});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewsDetailScreen(news: news)),
        );
      },
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(news.imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: RakshaColors.primary, borderRadius: BorderRadius.circular(4)),
                child: Text(news.category, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Text(
                news.title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

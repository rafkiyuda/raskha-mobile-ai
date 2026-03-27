import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../models/news_item.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsItem news;

  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                news.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: RakshaColors.bgSlate,
                  child: const Icon(Icons.image_not_supported, color: RakshaColors.textLight),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: RakshaColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    news.category.toUpperCase(),
                    style: const TextStyle(
                      color: RakshaColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: RakshaColors.textDark,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 14, color: RakshaColors.textGray),
                    const SizedBox(width: 4),
                    Text(news.author, style: const TextStyle(color: RakshaColors.textGray, fontSize: 12)),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time, size: 14, color: RakshaColors.textGray),
                    const SizedBox(width: 4),
                    Text(
                      '${news.date.day}/${news.date.month}/${news.date.year}',
                      style: const TextStyle(color: RakshaColors.textGray, fontSize: 12),
                    ),
                  ],
                ),
                const Divider(height: 40),
                Text(
                  news.content,
                  style: const TextStyle(
                    fontSize: 16,
                    color: RakshaColors.textDark,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 40),
                _buildSafetyWarning(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyWarning() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_outlined, color: Colors.orange, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Raksha Literacy Note',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  'Informasi ini bertujuan untuk edukasi. Selalu verifikasi data dari sumber resmi OJK atau BEI sebelum mengambil keputusan finansial.',
                  style: TextStyle(color: RakshaColors.textGray, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

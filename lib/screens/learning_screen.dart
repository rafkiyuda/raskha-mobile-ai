import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../widgets/raksha_card.dart';
import '../models/news_item.dart';
import 'news_detail_screen.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Raksha Learning', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Berita'),
              Tab(text: 'Journey'),
              Tab(text: 'Video'),
            ],
            labelColor: RakshaColors.primary,
            unselectedLabelColor: RakshaColors.textGray,
            indicatorColor: RakshaColors.primary,
          ),
        ),
        body: const TabBarView(
          children: [
            _LearningNewsTab(),
            _LearningJourneyTab(),
            _LearningVideoTab(),
          ],
        ),
      ),
    );
  }
}

class _LearningNewsTab extends StatelessWidget {
  const _LearningNewsTab();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: mockNews.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final news = mockNews[index];
        return _buildNewsCard(context, news);
      },
    );
  }

  Widget _buildNewsCard(BuildContext context, NewsItem news) {
    return RakshaCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(news: news)));
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Image.asset(
                news.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(width: 100, height: 100, color: Colors.grey[200]),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.category.toUpperCase(),
                      style: const TextStyle(color: RakshaColors.primary, fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      news.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: RakshaColors.textDark),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${news.date.day}/${news.date.month}',
                      style: const TextStyle(color: RakshaColors.textLight, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LearningJourneyTab extends StatelessWidget {
  const _LearningJourneyTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildRankCard(),
          const SizedBox(height: 32),
          _buildAchievements(),
        ],
      ),
    );
  }

  Widget _buildRankCard() {
    return RakshaCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.emoji_events_outlined, color: Colors.green, size: 32),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CURRENT RANK', style: TextStyle(color: RakshaColors.textGray, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text('Risk Sentinel', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('XP Progress', style: TextStyle(color: RakshaColors.textGray, fontSize: 12)),
              const Text('1450 / 2000 XP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: 0.725, backgroundColor: Colors.black12, color: Colors.green, borderRadius: BorderRadius.circular(4), minHeight: 8),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('RECENT ACHIEVEMENTS', style: TextStyle(color: RakshaColors.textGray, fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.85,
          children: const [
            _AchievementCard(icon: Icons.shield_outlined, label: 'First Defense', sub: 'Ignored a High Risk Alert.', color: Colors.orange),
            _AchievementCard(icon: Icons.menu_book_outlined, label: 'Avid Reader', sub: 'Read 5 AI Explainer pop-ups.', color: Colors.blue),
            _AchievementCard(icon: Icons.bolt_outlined, label: 'Trend Setter', sub: 'Identify anomalies.', color: Colors.grey, locked: true),
            _AchievementCard(icon: Icons.stars_outlined, label: 'Master Analyst', sub: 'Reach Level 10.', color: Colors.grey, locked: true),
          ],
        ),
      ],
    );
  }
}

class _LearningVideoTab extends StatelessWidget {
  const _LearningVideoTab();

  @override
  Widget build(BuildContext context) {
    final videos = [
      {'title': 'Market Update: IHSG Hari Ini', 'thumb': 'assets/images/video_thumb_market.png', 'views': '1.2k'},
      {'title': '5 Tips Menabung Tanpa Ribet', 'thumb': 'assets/images/video_thumb_saving.png', 'views': '2.5k'},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.6,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return _buildVideoCard(video);
      },
    );
  }

  Widget _buildVideoCard(Map<String, String> video) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(video['thumb'] ?? ''),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.play_circle_outline, color: Colors.white, size: 32),
            const Spacer(),
            Text(
              video['title'] ?? 'Tiada Judul',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.remove_red_eye_outlined, color: Colors.white70, size: 12),
                const SizedBox(width: 4),
                Text(video['views'] ?? '0', style: const TextStyle(color: Colors.white70, fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final Color color;
  final bool locked;

  const _AchievementCard({required this.icon, required this.label, required this.sub, required this.color, this.locked = false});

  @override
  Widget build(BuildContext context) {
    return RakshaCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(sub, style: const TextStyle(color: RakshaColors.textGray, fontSize: 9), textAlign: TextAlign.center, maxLines: 2),
          if (locked) ...[
            const SizedBox(height: 4),
            const Icon(Icons.lock_outline, size: 12, color: Colors.black26),
          ],
        ],
      ),
    );
  }
}

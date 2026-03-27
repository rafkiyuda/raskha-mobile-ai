import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../widgets/raksha_card.dart';

import 'profile_detail_screens.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildUserHeader(context),
          const SizedBox(height: 24),
          _buildStatsRow(),
          const SizedBox(height: 32),
          _buildBadgesSection(),
          const SizedBox(height: 32),
          _buildSettingsList(context),
          const SizedBox(height: 32),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountInfoScreen()));
          },
          child: const CircleAvatar(
            radius: 50,
            backgroundColor: RakshaColors.primary,
            child: Text(
              'S',
              style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Sherine Utama',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: RakshaColors.textDark),
        ),
        const Text(
          'sherine.utama@example.com',
          style: TextStyle(fontSize: 14, color: RakshaColors.textGray),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: RakshaColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Premium Member',
            style: TextStyle(color: RakshaColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatItem('Rank', 'Sentinel', Icons.emoji_events_outlined),
        _buildStatItem('XP', '1,450', Icons.bolt_outlined),
        _buildStatItem('Badges', '12', Icons.stars_outlined),
      ],
    );
  }

  Widget _buildBadgesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ACHIEVEMENT BADGES', style: TextStyle(color: RakshaColors.textGray, fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        RakshaCard(
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            children: const [
              _BadgeItem(icon: Icons.shield, color: Colors.orange, label: 'Sentinel'),
              _BadgeItem(icon: Icons.menu_book, color: Colors.blue, label: 'Reader'),
              _BadgeItem(icon: Icons.verified, color: Colors.green, label: 'Verifier'),
              _BadgeItem(icon: Icons.auto_awesome, color: Colors.purple, label: 'Early Bird'),
              _BadgeItem(icon: Icons.bolt, color: Colors.grey, label: 'Speed', locked: true),
              _BadgeItem(icon: Icons.stars, color: Colors.grey, label: 'Master', locked: true),
              _BadgeItem(icon: Icons.workspace_premium, color: Colors.grey, label: 'Pro', locked: true),
              _BadgeItem(icon: Icons.diamond, color: Colors.grey, label: 'Elite', locked: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: RakshaColors.primary, size: 24),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(label, style: const TextStyle(color: RakshaColors.textGray, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return RakshaCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildSettingsTile(
            context,
            icon: Icons.person_outline,
            title: 'Account Information',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountInfoScreen()));
            },
          ),
          const Divider(height: 1, indent: 56),
          _buildSettingsTile(
            context,
            icon: Icons.security_outlined,
            title: 'Security & Privacy',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SecurityScreen()));
            },
          ),
          const Divider(height: 1, indent: 56),
          _buildSettingsTile(
            context,
            icon: Icons.notifications_none,
            title: 'Notification Settings',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()));
            },
          ),
          const Divider(height: 1, indent: 56),
          _buildSettingsTile(
            context,
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Help center is available 24/7 at support@raksha.ai')));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: RakshaColors.bgSlate,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: RakshaColors.textDark, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: RakshaColors.textLight),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
           showDialog(
             context: context,
             builder: (context) => AlertDialog(
               title: const Text('Logout'),
               content: const Text('Are you sure you want to exit Raksha AI?'),
               actions: [
                 TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                 TextButton(onPressed: () => Navigator.pop(context), child: const Text('Logout', style: TextStyle(color: Colors.red))),
               ],
             ),
           );
        },
        child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}
class _BadgeItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final bool locked;

  const _BadgeItem({required this.icon, required this.color, required this.label, this.locked = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: locked ? Colors.grey.withOpacity(0.1) : color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: locked ? Colors.black12 : color.withOpacity(0.3)),
              ),
              child: Icon(icon, color: locked ? Colors.black26 : color, size: 24),
            ),
            if (locked) const Icon(Icons.lock, size: 12, color: Colors.black45),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: locked ? RakshaColors.textLight : RakshaColors.textDark,
          ),
        ),
      ],
    );
  }
}

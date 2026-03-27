import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../widgets/raksha_card.dart';

class AccountInfoScreen extends StatelessWidget {
  const AccountInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Information', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: RakshaColors.textDark),
            ),
            const SizedBox(height: 16),
            RakshaCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildDetailTile('Full Name', 'Sherine Utama'),
                  const Divider(height: 1, indent: 20),
                  _buildDetailTile('Email Address', 'sherine.utama@example.com'),
                  const Divider(height: 1, indent: 20),
                  _buildDetailTile('Phone Number', '+62 812 3456 7890'),
                  const Divider(height: 1, indent: 20),
                  _buildDetailTile('Investor Type', 'Retail - Aggressive'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'KYC Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: RakshaColors.textDark),
            ),
            const SizedBox(height: 16),
            RakshaCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.verified_user, color: Colors.green, size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Verified', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Last verified: 12 Jan 2026', style: TextStyle(color: RakshaColors.textGray, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saving changes...')));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: RakshaColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(String label, String value) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      title: Text(label, style: const TextStyle(color: RakshaColors.textGray, fontSize: 13)),
      subtitle: Text(value, style: const TextStyle(color: RakshaColors.textDark, fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.edit_outlined, size: 18, color: RakshaColors.textLight),
      onTap: () {},
    );
  }
}

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security & Privacy')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildToggleTile('Biometric Auth', 'Login using Fingerprint/FaceID', true),
          const SizedBox(height: 12),
          _buildToggleTile('Two-Factor Auth', 'Secure your account with 2FA', false),
          const SizedBox(height: 24),
          RakshaCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              title: const Text('Change Account PIN'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTile(String title, String sub, bool val) {
    return RakshaCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(sub, style: const TextStyle(color: RakshaColors.textGray, fontSize: 12)),
            ],
          ),
          Switch(value: val, onChanged: (v) {}, activeColor: RakshaColors.primary),
        ],
      ),
    );
  }
}

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildToggleCard('Push Notifications', true),
          const SizedBox(height: 12),
          _buildToggleCard('Email Alerts', true),
          const SizedBox(height: 12),
          _buildToggleCard('WhatsApp Report', false),
          const SizedBox(height: 12),
          _buildToggleCard('Market Alerts', true),
        ],
      ),
    );
  }

  Widget _buildToggleCard(String title, bool val) {
    return RakshaCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          Switch(value: val, onChanged: (v) {}, activeColor: RakshaColors.primary),
        ],
      ),
    );
  }
}

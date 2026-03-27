import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../widgets/truth_dashboard_widget.dart';

class TruthDashboardScreen extends StatelessWidget {
  const TruthDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Financial Integrity',
          style: TextStyle(color: RakshaColors.textDark, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: RakshaColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const TruthDashboardWidget(),
    );
  }
}

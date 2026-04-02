import 'package:flutter/material.dart';
import 'core/colors.dart';
import 'core/theme.dart';
import 'screens/truth_selection_screen.dart';
import 'screens/crisis_playbook_screen.dart';
import 'screens/learning_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const RakshaApp());
}

class RakshaApp extends StatelessWidget {
  const RakshaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raksha AI',
      debugShowCheckedModeBanner: false,
      theme: RakshaTheme.lightTheme,
      home: MainNavigation(key: MainNavigation.navigationKey),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  static final GlobalKey<MainNavigationState> navigationKey = GlobalKey<MainNavigationState>();

  static MainNavigationState? of(BuildContext? context) {
    if (context != null) {
      final state = context.findAncestorStateOfType<MainNavigationState>();
      if (state != null) return state;
    }
    return navigationKey.currentState;
  }

  @override
  State<MainNavigation> createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  String? _initialChatMessage;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const LearningScreen(),
      const TruthSelectionScreen(),
      const CrisisPlaybookScreen(),
      const ProfileScreen(),
      ChatScreen(
        initialMessage: null,
        onMessageConsumed: _clearInitialMessage,
      ),
    ];
  }

  void setIndex(int index, {String? initialMessage, Map<String, dynamic>? stockContext}) {
    setState(() {
      if (index == 5) { // Chat
        _selectedIndex = 5;
      } else {
        _selectedIndex = index;
      }
      
      if (initialMessage != null || stockContext != null) {
        _initialChatMessage = initialMessage;
        _screens[5] = ChatScreen(
          initialMessage: _initialChatMessage,
          stockContext: stockContext,
          onMessageConsumed: _clearInitialMessage,
        );
      }
    });
  }

  void _clearInitialMessage() {
    _initialChatMessage = null;
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget? appBar;
    
    switch (_selectedIndex) {
      case 0:
        break;
      case 1:
        appBar = null; // LearningScreen has its own TabController and AppBar
        break;
      case 2:
        appBar = null; // TruthHub has its own AppBar
        break;
      case 3:
        appBar = AppBar(title: const Text('Crisis Playbook', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true);
        break;
      case 4:
        appBar = AppBar(title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true);
        break;
      case 5:
        appBar = AppBar(title: const Text('AI Co-Pilot', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true);
        break;
    }

    Widget body = IndexedStack(
      index: _selectedIndex,
      children: _screens,
    );

    return Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: _selectedIndex == 5 ? null : _buildBottomBar(),
      floatingActionButton: _selectedIndex == 5 ? null : FloatingActionButton(
        onPressed: () => setIndex(5),
        backgroundColor: RakshaColors.primary,
        child: const Icon(Icons.chat_bubble, color: Colors.white),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
                  _buildNavItem(1, Icons.emoji_events_outlined, Icons.emoji_events, 'Journey'),
                  const SizedBox(width: 60), // Space for Truth highlight
                  _buildNavItem(3, Icons.warning_amber_rounded, Icons.warning, 'Crisis'),
                  _buildNavItem(4, Icons.person_outline, Icons.person, 'Profile'),
                ],
              ),
            ),
            Positioned(
              top: -24,
              child: _buildTruthHighlight(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setIndex(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? RakshaColors.primary : RakshaColors.textGray,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? RakshaColors.primary : RakshaColors.textGray,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTruthHighlight() {
    final isSelected = _selectedIndex == 2;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => setIndex(2),
          child: AnimatedScale(
            scale: isSelected ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    RakshaColors.primary,
                    RakshaColors.primary.withAlpha(200),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: RakshaColors.primary.withOpacity(0.25),
                    blurRadius: 15,
                    spreadRadius: 1,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(color: Colors.white, width: 2.5),
              ),
              child: const Icon(Icons.analytics_rounded, color: Colors.white, size: 26),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Truth',
          style: TextStyle(
            color: isSelected ? RakshaColors.primary : RakshaColors.textGray,
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}



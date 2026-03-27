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
      if (index == 4) { // Chat
        _selectedIndex = 4;
      } else {
        _selectedIndex = index;
      }
      
      if (initialMessage != null || stockContext != null) {
        _initialChatMessage = initialMessage;
        _screens[4] = ChatScreen(
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
        appBar = null; // Truth Hub has its own AppBar
        break;
      case 2:
        appBar = AppBar(title: const Text('Crisis Playbook', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true);
        break;
      case 3:
        appBar = AppBar(title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true);
        break;
      case 4:
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
      bottomNavigationBar: _selectedIndex == 4 ? null : _buildBottomBar(),
      floatingActionButton: _selectedIndex == 4 ? null : FloatingActionButton(
        onPressed: () => setIndex(4),
        backgroundColor: RakshaColors.primary,
        child: const Icon(Icons.chat_bubble, color: Colors.white),
      ),
    );
  }

  Widget _buildBottomBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex == 4 ? 0 : _selectedIndex,
      onTap: (index) => setIndex(index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: RakshaColors.primary,
      unselectedItemColor: RakshaColors.textGray,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), activeIcon: Icon(Icons.analytics), label: 'Truth'),
        BottomNavigationBarItem(icon: Icon(Icons.warning_amber_rounded), activeIcon: Icon(Icons.warning), label: 'Crisis'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}



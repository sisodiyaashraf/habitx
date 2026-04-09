import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/habit_provider.dart';
import '../widgets/home/home_mobile_content.dart';
import '../widgets/shared/glass_bottom_nav.dart';
import '../widgets/shared/glass_background.dart';
import 'add_habit_screen.dart';
import 'stats_screen.dart';
import 'tracking_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Real-time page list
  final List<Widget> _pages = [
    const HomeMobileContent(), // Index 0: Daily Habits
    const StatsScreen(), // Index 1: Heatmap & Ranks
    const TrackingScreen(), // Index 2: Weekly Analytics
    const ProfileScreen(), // Index 3: User Identity
  ];

  @override
  Widget build(BuildContext context) {
    // Select only the userLevel to trigger targeted rebuilds of the AppBar chip
    final level = context.select<HabitProvider, int>((p) => p.userLevel);

    // Dynamic text color for dark mode support
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      extendBody: true, // Necessary for the GlassBottomNav blur effect
      extendBodyBehindAppBar: true,

      // FIX: Conditionally render the AppBar only when on the Home tab (Index 0)
      appBar: _currentIndex == 0
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
              title: Text(
                'HabitX',
                style: TextStyle(
                  color: textColor, // Adaptive text color
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                  letterSpacing: 1.9,
                ),
              ),
              actions: [_buildLevelChip(level)],
            )
          : null, // Passing null completely hides it on other tabs

      body: GlassBackground(
        child: SafeArea(
          bottom: false,
          // IndexedStack maintains the state of each page (scroll position, etc.)
          child: IndexedStack(index: _currentIndex, children: _pages),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: _buildFloatingGradientButton(context),
      bottomNavigationBar: GlassBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
            setState(() => _currentIndex = index);
          }
        },
      ),
    );
  }

  Widget _buildLevelChip(int level) {
    return Container(
      margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFAC5DED), Color(0xFF7B61FF)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAC5DED).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'LVL $level',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingGradientButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 100,
      ), // Adjusted to float above Glass Nav
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddHabitScreen()),
        ),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFAC5DED), Color(0xFF7B61FF)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFAC5DED).withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
        ),
      ),
    );
  }
}

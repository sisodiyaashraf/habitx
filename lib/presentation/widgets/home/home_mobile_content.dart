import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/habit_provider.dart';
import 'xp_header.dart';
import 'daily_progress_card.dart';
import 'habit_list_view.dart';
import 'glass_calendar.dart';
import 'empty_habit_state.dart'; // New Import

class HomeMobileContent extends StatelessWidget {
  const HomeMobileContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Access provider data for state-driven UI
    final provider = context.watch<HabitProvider>();
    final habits = provider.habits;

    return SingleChildScrollView(
      // Padding adjusted for the Floating Glass Navbar
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Level & XP Progress (Onyx standard)
          XpHeader(
            currentXp: provider.userXP,
            level: provider.userLevel,
            userName: provider.userName,
          ),

          const SizedBox(height: 24),

          // 2. The Horizontal Calendar
          // Wrapped in a RepaintBoundary to keep glass blur performance high
          const RepaintBoundary(child: GlassCalendar()),

          const SizedBox(height: 32),

          // 3. Daily Stats (Percentage & Level Progress)
          DailyProgressCard(progress: provider.todayProgress),

          const SizedBox(height: 32),

          // 4. Habit Header with Count
          _buildSectionHeader("TASKS FOR TODAY", habits.length),

          const SizedBox(height: 16),

          // 5. Dynamic Content Logic (List vs Empty State)
          habits.isEmpty ? const EmptyHabitState() : const HabitListView(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        if (count > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFAC5DED).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "$count active",
              style: const TextStyle(
                color: Color(0xFFAC5DED),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}

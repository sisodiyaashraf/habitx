import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/habit_provider.dart';
import 'empty_habit_state.dart';
import 'habit_tile.dart';

class HabitListView extends StatelessWidget {
  const HabitListView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();

    // Filter habits based on the date selected in the GlassCalendar
    final filteredHabits = provider.habits.where((habit) {
      return DateFormat('yMd').format(habit.createdAt) ==
          DateFormat('yMd').format(provider.selectedDate);
    }).toList();

    if (filteredHabits.isEmpty) {
      return const EmptyHabitState();
    }

    return ListView.separated(
      shrinkWrap: true,
      // Prevents scrolling conflicts within the SingleChildScrollView of HomeMobileContent
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredHabits.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final habit = filteredHabits[index];

        return Dismissible(
          key: Key(habit.id),
          direction: DismissDirection.endToStart,
          // iOS style swipe-to-delete confirmation
          onDismissed: (_) {
            provider.deleteHabit(habit.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${habit.name} deleted"),
                backgroundColor: Colors.redAccent.withOpacity(0.8),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          background: _buildDeleteBackground(),
          child: HabitTile(habit: habit),
        );
      },
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        // Using a soft red to match the glassmorphism palette
        color: Colors.redAccent.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(
        Icons.delete_outline_rounded,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}

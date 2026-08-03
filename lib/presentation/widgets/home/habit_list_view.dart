import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/habit_provider.dart';
import '../../../domain/models/habit.dart';
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

    // Topological sorting of stacked habits for hierarchical layout
    final parentToChildren = <String, List<Habit>>{};
    final roots = <Habit>[];
    
    for (final h in filteredHabits) {
      if (h.triggerHabitId == null || !filteredHabits.any((p) => p.id == h.triggerHabitId)) {
        roots.add(h);
      } else {
        parentToChildren.putIfAbsent(h.triggerHabitId!, () => []).add(h);
      }
    }

    final sortedHabits = <Habit>[];
    final indentMap = <String, int>{};

    void dfs(Habit current, int indentLevel) {
      sortedHabits.add(current);
      indentMap[current.id] = indentLevel;
      final children = parentToChildren[current.id];
      if (children != null) {
        for (final child in children) {
          dfs(child, indentLevel + 1);
        }
      }
    }

    for (final root in roots) {
      dfs(root, 0);
    }

    return ListView.separated(
      shrinkWrap: true,
      // Prevents scrolling conflicts within the SingleChildScrollView of HomeMobileContent
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedHabits.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final habit = sortedHabits[index];
        final indent = indentMap[habit.id] ?? 0;

        return Dismissible(
          key: Key(habit.id),
          direction: DismissDirection.endToStart,
          // iOS style swipe-to-delete confirmation
          onDismissed: (_) {
            provider.deleteHabit(habit.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${habit.name} deleted"),
                backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          background: _buildDeleteBackground(),
          child: HabitTile(
            habit: habit,
            indentLevel: indent,
          ),
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
        color: Colors.redAccent.withValues(alpha: 0.7),
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

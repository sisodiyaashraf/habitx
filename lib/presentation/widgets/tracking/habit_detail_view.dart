import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../domain/models/habit.dart';
import '../shared/glass_background.dart';
import 'completion_calendar_grid.dart';
import 'stats_cards_row.dart';
import 'detail_view_dialogs.dart';
import 'detail_progress_header.dart';
import 'detail_insight_card.dart';
import 'detail_row_card.dart';
import 'detail_action_button.dart';

class HabitDetailView extends StatelessWidget {
  final Habit habit;
  const HabitDetailView({super.key, required this.habit});

  Color _getDifficultyColor(HabitDifficulty diff) {
    switch (diff) {
      case HabitDifficulty.easy:
        return const Color(0xFF00E5FF);
      case HabitDifficulty.medium:
        return const Color(0xFFAC5DED);
      case HabitDifficulty.hard:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.redAccent,
            ),
            onPressed: () => DetailViewDialogs.showDeleteConfirmation(context, habit),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: GlassBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 120, 24, 40),
          child: Column(
            children: [
              // --- Visual Progress Header ---
              DetailProgressHeader(habit: habit, textColor: textColor),
              const SizedBox(height: 32),

              // --- Main Stat Grid ---
              StatsCardsRow(habit: habit, isDark: isDark, textColor: textColor),
              const SizedBox(height: 24),

              // --- Performance Insights Card ---
              DetailInsightCard(habit: habit, textColor: textColor, subTextColor: subTextColor, isDark: isDark),
              const SizedBox(height: 24),

              // --- Visual Weekly History ---
              CompletionCalendarGrid(habit: habit, textColor: textColor, subTextColor: subTextColor, isDark: isDark),
              const SizedBox(height: 24),

              // --- Detail Rows ---
              DetailRowCard(
                label: "DIFFICULTY",
                value: habit.difficulty.name.toUpperCase(),
                icon: FontAwesomeIcons.layerGroup,
                isDark: isDark,
                textColor: textColor,
                customValueWidget: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(habit.difficulty).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getDifficultyColor(habit.difficulty).withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    habit.difficulty.name.toUpperCase(),
                    style: TextStyle(
                      color: _getDifficultyColor(habit.difficulty),
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DetailRowCard(
                label: "CREATED ON",
                value: _formatDate(habit.createdAt),
                icon: FontAwesomeIcons.calendarCheck,
                isDark: isDark,
                textColor: textColor,
              ),

              if (habit.reminderTime != null) ...[
                const SizedBox(height: 12),
                DetailRowCard(
                  label: "REMINDER AT",
                  value: TimeOfDay.fromDateTime(habit.reminderTime!).format(context),
                  icon: FontAwesomeIcons.solidBell,
                  isDark: isDark,
                  textColor: textColor,
                ),
              ],

              const SizedBox(height: 48),

              // --- Action Button ---
              DetailActionButton(habit: habit, isDark: isDark),
            ],
          ),
        ),
      ),
    );
  }

  // --- Logic Helpers ---

  String _formatDate(DateTime date) => "${date.day}/${date.month}/${date.year}";
}

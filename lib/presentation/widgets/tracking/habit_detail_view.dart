import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/habit.dart';
import '../../../providers/habit_provider.dart';
import '../shared/glass_background.dart';

class HabitDetailView extends StatelessWidget {
  final Habit habit;
  const HabitDetailView({super.key, required this.habit});

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
            onPressed: () => _showDeleteConfirmation(context),
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
              _buildProgressHeader(textColor),
              const SizedBox(height: 32),

              // --- Main Stat Grid ---
              Row(
                children: [
                  _buildSmallStatCard(
                    "STREAK",
                    "${habit.streak}",
                    FontAwesomeIcons.fire,
                    isDark,
                    textColor,
                  ),
                  const SizedBox(width: 12),
                  _buildSmallStatCard(
                    "XP",
                    "${habit.xpValue}",
                    FontAwesomeIcons.bolt,
                    isDark,
                    textColor,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- Performance Insights Card ---
              _buildInsightCard(isDark, textColor, subTextColor),
              const SizedBox(height: 32),

              // --- Detail Rows ---
              _buildDetailRow(
                "DIFFICULTY",
                habit.difficulty.name.toUpperCase(),
                FontAwesomeIcons.layerGroup,
                isDark,
                textColor,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                "CREATED ON",
                _formatDate(habit.createdAt),
                FontAwesomeIcons.calendarCheck,
                isDark,
                textColor,
              ),

              const SizedBox(height: 48),

              // --- Action Button ---
              _buildActionToggleButton(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _buildProgressHeader(Color textColor) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: CircularProgressIndicator(
                value:
                    (habit.streak % 30) /
                    30, // Example: progress toward 30-day milestone
                strokeWidth: 8,
                backgroundColor: Colors.white10,
                color: const Color(0xFFAC5DED),
                strokeCap: StrokeCap.round,
              ),
            ),
            const FaIcon(
              FontAwesomeIcons.gem,
              color: Color(0xFFAC5DED),
              size: 40,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          habit.name.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        _buildBadge("ELITE STATUS"),
      ],
    );
  }

  Widget _buildSmallStatCard(
    String label,
    String value,
    dynamic icon,
    bool isDark,
    Color textColor,
  ) {
    return Expanded(
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 100,
        borderRadius: 25,
        blur: 20,
        alignment: Alignment.center,
        border: 1,
        linearGradient: LinearGradient(
          colors: [
            isDark ? Colors.white10 : Colors.white24,
            Colors.transparent,
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            const Color(0xFFAC5DED).withOpacity(0.5),
            Colors.transparent,
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, color: const Color(0xFFAC5DED), size: 18),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(bool isDark, Color textColor, Color subTextColor) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 120,
      borderRadius: 25,
      blur: 20,
      alignment: Alignment.center,
      border: 1,
      linearGradient: LinearGradient(
        colors: [const Color(0xFFAC5DED).withOpacity(0.1), Colors.transparent],
      ),
      borderGradient: const LinearGradient(
        colors: [Color(0xFFAC5DED), Colors.transparent],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFFAC5DED),
              child: Icon(
                Icons.auto_graph_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PERFORMANCE INSIGHT",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    habit.streak > 5
                        ? "Your consistency is above 90%. You're in the top 5% for this habit."
                        : "Establishing phase. Keep a 3-day streak to unlock momentum.",
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    dynamic icon,
    bool isDark,
    Color textColor,
  ) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 60,
      borderRadius: 20,
      blur: 20,
      alignment: Alignment.center,
      border: 0.5,
      linearGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.05), Colors.transparent],
      ),
      borderGradient: LinearGradient(
        colors: [isDark ? Colors.white10 : Colors.black12, Colors.transparent],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                FaIcon(icon, color: const Color(0xFFAC5DED), size: 14),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              value,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionToggleButton(BuildContext context, bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: habit.isCompleted
              ? Colors.grey.withOpacity(0.2)
              : const Color(0xFFAC5DED),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: () {
          context.read<HabitProvider>().toggleHabitCompletion(
            context,
            habit.id,
          );
          Navigator.pop(context);
        },
        child: Text(
          habit.isCompleted ? "MARK AS INCOMPLETE" : "COMPLETE TASK",
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFAC5DED).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFAC5DED).withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFAC5DED),
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // --- Logic Helpers ---

  String _formatDate(DateTime date) => "${date.day}/${date.month}/${date.year}";

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Delete Habit?",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "This action cannot be undone. All streak data will be lost.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              context.read<HabitProvider>().deleteHabit(habit.id);
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // return to tracking screen
            },
            child: const Text(
              "DELETE",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

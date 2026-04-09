import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../domain/models/habit.dart';
import '../../../providers/habit_provider.dart';
import '../../screens/habit_timer_screen.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;

  const HabitTile({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        // Long press for quick manual completion or deletion
        onLongPress: () => _showQuickActions(context),
        child: GlassmorphicContainer(
          width: double.infinity,
          height: 110,
          borderRadius: 24,
          blur: 20,
          alignment: Alignment.center,
          border: 1.5,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.28), // Optimized for Onyx visibility
              Colors.white.withOpacity(0.12),
            ],
          ),
          borderGradient: LinearGradient(
            colors: [
              const Color(0xFFAC5DED).withOpacity(0.4),
              Colors.white.withOpacity(0.3),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                _buildDifficultyIndicator(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _buildInfoBadge(
                            Icons.timer_outlined,
                            '${habit.timerDuration}m',
                            const Color(0xFFAC5DED).withOpacity(0.1),
                            const Color(0xFFAC5DED),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${habit.streak} 🔥',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('hh:mm a').format(habit.createdAt),
                            style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildActionButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyIndicator() {
    final Color color = _getDifficultyColor();
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Icon(Icons.bolt_rounded, color: color, size: 24),
    );
  }

  Widget _buildInfoBadge(IconData icon, String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 10, color: textCol),
          const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(
              color: textCol,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    if (habit.isCompleted) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF00E676).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_circle_rounded,
          color: Color(0xFF00E676),
          size: 32,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Color(0xFFAC5DED), Color(0xFF7B61FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAC5DED).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {
          // FIX: Passing both habit.id (String) and timerDuration (int)
          context.read<HabitProvider>().startTaskTimer(
            habit.id,
            habit.timerDuration,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HabitTimerScreen(
                habitName: habit.name,
                initialMinutes: habit.timerDuration,
              ),
            ),
          );
        },
        child: const Text(
          "START",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 11,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassmorphicContainer(
        width: double.infinity,
        height: 200,
        borderRadius: 30,
        blur: 20,
        alignment: Alignment.center,
        border: 2,
        linearGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        borderGradient: const LinearGradient(
          colors: [Color(0xFFAC5DED), Colors.transparent],
        ),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              ),
              title: const Text(
                "Toggle Completion",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                context.read<HabitProvider>().toggleHabitCompletion(
                  context,
                  habit.id,
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
              ),
              title: const Text(
                "Delete Habit",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                context.read<HabitProvider>().deleteHabit(habit.id);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor() {
    switch (habit.difficulty) {
      case HabitDifficulty.easy:
        return const Color(0xFF00B8D4);
      case HabitDifficulty.medium:
        return const Color(0xFFFF9100);
      case HabitDifficulty.hard:
        return const Color(0xFFFF1744);
    }
  }
}

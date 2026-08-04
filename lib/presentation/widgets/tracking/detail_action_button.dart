import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/habit.dart';
import '../../../providers/habit_provider.dart';
import '../../screens/habit_timer_screen.dart';
import 'detail_view_dialogs.dart';

class DetailActionButton extends StatelessWidget {
  final Habit habit;
  final bool isDark;

  const DetailActionButton({
    super.key,
    required this.habit,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = habit.isCompleted;
    final provider = context.watch<HabitProvider>();
    final canFreeze = provider.canFreezeHabit(habit);

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: isCompleted
                ? null
                : const LinearGradient(
                    colors: [Color(0xFFAC5DED), Color(0xFF7B61FF)],
                  ),
            boxShadow: isCompleted
                ? []
                : [
                    BoxShadow(
                      color: const Color(0xFFAC5DED).withValues(alpha: 0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isCompleted ? Colors.white.withValues(alpha: 0.08) : Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: isCompleted
                    ? BorderSide(color: Colors.white.withValues(alpha: 0.15), width: 1.5)
                    : BorderSide.none,
              ),
            ),
            onPressed: () {
              if (isCompleted) {
                context.read<HabitProvider>().toggleHabitCompletion(
                  context,
                  habit.id,
                );
                Navigator.pop(context);
              } else {
                context.read<HabitProvider>().startTaskTimer(
                  habit.id,
                  habit.timerDuration,
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HabitTimerScreen(
                      habitName: habit.name,
                      initialMinutes: habit.timerDuration,
                    ),
                  ),
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isCompleted ? Icons.undo_rounded : Icons.check_circle_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  isCompleted ? "MARK AS INCOMPLETE" : "COMPLETE HABIT TASK",
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (canFreeze) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E5FF).withValues(alpha: 0.2),
                foregroundColor: const Color(0xFF00E5FF),
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: const BorderSide(color: Color(0xFF00E5FF), width: 1.5),
                ),
              ),
              onPressed: () => DetailViewDialogs.showFreezeConfirmation(context, habit),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.ac_unit_rounded,
                    color: Color(0xFF00E5FF),
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "FREEZE TODAY'S STREAK",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      letterSpacing: 1.2,
                      color: Color(0xFF00E5FF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

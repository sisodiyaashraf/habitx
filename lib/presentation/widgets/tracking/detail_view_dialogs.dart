import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../domain/models/habit.dart';
import '../../../providers/habit_provider.dart';

class DetailViewDialogs {
  static void showFreezeConfirmation(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final dialogTextColor = isDark ? Colors.white : Colors.black;
        final dialogSubTextColor = isDark ? Colors.white70 : Colors.black54;

        return Center(
          child: Material(
            color: Colors.transparent,
            child: GlassmorphicContainer(
              width: MediaQuery.of(context).size.width * 0.85,
              height: 240,
              borderRadius: 30,
              blur: 20,
              alignment: Alignment.center,
              border: 2,
              linearGradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0.1),
                ],
              ),
              borderGradient: const LinearGradient(
                colors: [Color(0xFF00E5FF), Colors.white24],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.ac_unit_rounded,
                      color: Color(0xFF00E5FF),
                      size: 40,
                    ),
                    Text(
                      "STREAK FREEZE",
                      style: TextStyle(
                        color: dialogTextColor,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Use your streak freeze for today? This protects your streak without modifying completions.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: dialogSubTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: Text(
                            "CANCEL",
                            style: TextStyle(color: dialogSubTextColor),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00E5FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            context.read<HabitProvider>().useStreakFreeze(context, habit.id);
                            Navigator.pop(dialogContext); // close dialog
                            Navigator.pop(context); // return to tracking screen
                          },
                          child: const Text(
                            "FREEZE DAY",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void showDeleteConfirmation(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final dialogTextColor = isDark ? Colors.white : Colors.black;
        final dialogSubTextColor = isDark ? Colors.white70 : Colors.black54;

        return Center(
          child: Material(
            color: Colors.transparent,
            child: GlassmorphicContainer(
              width: MediaQuery.of(context).size.width * 0.85,
              height: 240,
              borderRadius: 30,
              blur: 20,
              alignment: Alignment.center,
              border: 2,
              linearGradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0.1),
                ],
              ),
              borderGradient: const LinearGradient(
                colors: [Colors.redAccent, Colors.white24],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.redAccent,
                      size: 40,
                    ),
                    Text(
                      "DELETE HABIT",
                      style: TextStyle(
                        color: dialogTextColor,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "This action cannot be undone. All streak and completion data will be permanently wiped.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: dialogSubTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: Text(
                            "CANCEL",
                            style: TextStyle(color: dialogSubTextColor),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            context.read<HabitProvider>().deleteHabit(habit.id);
                            Navigator.pop(dialogContext); // close dialog
                            Navigator.pop(context); // return to tracking screen
                          },
                          child: const Text(
                            "DELETE",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

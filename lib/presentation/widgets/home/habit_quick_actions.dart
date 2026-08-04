import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/habit.dart';
import '../../../providers/habit_provider.dart';
import '../../screens/add_habit_screen.dart';

class HabitQuickActions {
  static void show(BuildContext context, Habit habit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassmorphicContainer(
        width: double.infinity,
        height: 250,
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
          colors: [Color(0xFFAC5DED), Colors.transparent],
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                Icons.edit_outlined,
                color: Color(0xFFAC5DED),
              ),
              title: const Text(
                "Edit Mission",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddHabitScreen(habit: habit),
                  ),
                );
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
    ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/habit_provider.dart';

class LevelUpHandler extends StatelessWidget {
  final Widget child;
  const LevelUpHandler({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Selector<HabitProvider, int>(
      selector: (_, provider) => provider.userLevel,
      builder: (context, level, _) {
        // This is a post-frame callback to avoid building during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (level > 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("LEVEL UP! You are now Level $level 🚀"),
                backgroundColor: Colors.amber[800],
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        });
        return child;
      },
    );
  }
}

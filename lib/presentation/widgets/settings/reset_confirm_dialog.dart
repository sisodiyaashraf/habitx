import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/habit_provider.dart';

class ResetConfirmDialog extends StatelessWidget {
  const ResetConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      title: const Text(
        "RESET DATA?",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
      ),
      content: const Text(
        "This will wipe all progress, XP, and habits. You cannot undo this.",
        style: TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("CANCEL"),
        ),
        TextButton(
          onPressed: () {
            context.read<HabitProvider>().resetUserIdentity();
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: const Text("RESET", style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}

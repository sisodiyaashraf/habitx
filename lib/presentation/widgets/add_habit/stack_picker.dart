import 'package:flutter/material.dart';
import '../../../domain/models/habit.dart';
import '../../../providers/habit_provider.dart';

class StackPicker extends StatelessWidget {
  final Habit? habit;
  final String? selectedTriggerHabitId;
  final bool isDark;
  final Color textColor;
  final ValueChanged<String?> onChanged;
  final HabitProvider habitProvider;

  const StackPicker({
    super.key,
    required this.habit,
    required this.selectedTriggerHabitId,
    required this.isDark,
    required this.textColor,
    required this.onChanged,
    required this.habitProvider,
  });

  @override
  Widget build(BuildContext context) {
    final habits = habitProvider.allHabits;
    final currentId = habit?.id ?? '';

    // Filter candidates to avoid circular references and self-triggering
    final candidates = habits.where((h) {
      if (habit != null && h.id == currentId) return false;
      return !habitProvider.isCircularChain(currentId, h.id);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
          child: Text(
            "STACK AFTER (OPTIONAL)",
            style: TextStyle(
              color: const Color(0xFFAC5DED).withValues(alpha: 0.8),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ),
        DropdownButtonFormField<String?>(
          initialValue: selectedTriggerHabitId,
          dropdownColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          icon: const Icon(Icons.link_rounded, color: Color(0xFFAC5DED)),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: "Select cue habit...",
            hintStyle: TextStyle(color: textColor.withValues(alpha: 0.4)),
            filled: true,
            fillColor: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.04),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFFAC5DED), width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          items: [
            const DropdownMenuItem<String?>(
              value: null,
              child: Text("NONE (START OF CHAIN)"),
            ),
            ...candidates.map((h) => DropdownMenuItem<String?>(
              value: h.id,
              child: Text(h.name.toUpperCase()),
            )),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}

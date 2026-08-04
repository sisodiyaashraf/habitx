import 'package:flutter/material.dart';
import '../../../domain/models/habit.dart';

class DifficultySelector extends StatelessWidget {
  final HabitDifficulty selectedDifficulty;
  final ValueChanged<HabitDifficulty> onChanged;
  final bool isDark;
  final Color textColor;

  const DifficultySelector({
    super.key,
    required this.selectedDifficulty,
    required this.onChanged,
    required this.isDark,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<HabitDifficulty>(
      initialValue: selectedDifficulty,
      dropdownColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      icon: const Icon(Icons.expand_more_rounded, color: Color(0xFFAC5DED)),
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.04),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      items: HabitDifficulty.values
          .map(
            (d) =>
                DropdownMenuItem(value: d, child: Text(d.name.toUpperCase())),
          )
          .toList(),
      onChanged: (val) {
        if (val != null) {
          onChanged(val);
        }
      },
    );
  }
}

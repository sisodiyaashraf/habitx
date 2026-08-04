import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../providers/habit_provider.dart';

class GenderToneDialog extends StatelessWidget {
  final HabitProvider provider;

  const GenderToneDialog({super.key, required this.provider});

  static void show(BuildContext context, HabitProvider provider) {
    showDialog(
      context: context,
      builder: (context) => GenderToneDialog(provider: provider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogTextColor = isDark ? Colors.white : Colors.black;
    final dialogSubTextColor = isDark ? Colors.white70 : Colors.black54;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: GlassmorphicContainer(
          width: MediaQuery.of(context).size.width * 0.85,
          height: 280,
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
            colors: [Color(0xFFAC5DED), Colors.white24],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "GENDER TONE",
                  style: TextStyle(
                    color: dialogTextColor,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                _buildGenderBtn(context, provider, "Male", dialogTextColor),
                _buildGenderBtn(context, provider, "Female", dialogTextColor),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "CLOSE",
                    style: TextStyle(color: dialogSubTextColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderBtn(
    BuildContext context,
    HabitProvider provider,
    String gender,
    Color activeTextColor,
  ) {
    final bool isSelected = provider.userGender.toLowerCase() == gender.toLowerCase();

    return Container(
      width: double.infinity,
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: isSelected
              ? const Color(0xFFAC5DED).withValues(alpha: 0.2)
              : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: isSelected ? const Color(0xFFAC5DED) : Colors.white12,
            ),
          ),
        ),
        onPressed: () {
          provider.updateGender(gender);
          Navigator.pop(context);
        },
        child: Text(
          gender.toUpperCase(),
          style: TextStyle(
            color: isSelected ? const Color(0xFFAC5DED) : activeTextColor.withValues(alpha: 0.6),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

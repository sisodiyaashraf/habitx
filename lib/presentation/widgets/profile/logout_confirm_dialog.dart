import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../providers/habit_provider.dart';
import '../../screens/onboarding_screen.dart';

class LogoutConfirmDialog extends StatelessWidget {
  const LogoutConfirmDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LogoutConfirmDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<HabitProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogTextColor = isDark ? Colors.white : Colors.black;
    final dialogSubTextColor = isDark ? Colors.white70 : Colors.black54;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: GlassmorphicContainer(
          width: MediaQuery.of(context).size.width * 0.85,
          height: 220,
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
                  "FACTORY RESET",
                  style: TextStyle(
                    color: dialogTextColor,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "This will wipe your identity. Are you sure?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: dialogSubTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
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
                      onPressed: () async {
                        await provider.resetUserIdentity();

                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OnboardingScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      child: const Text(
                        "LOG OUT",
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
  }
}

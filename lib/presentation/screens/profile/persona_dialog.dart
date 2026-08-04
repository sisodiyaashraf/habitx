import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import '../../../providers/habit_provider.dart';
import '../../../core/constants/notification_messages.dart';

class PersonaDialog extends StatelessWidget {
  const PersonaDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogTextColor = isDark ? Colors.white : Colors.black;
    final dialogSubTextColor = isDark ? Colors.white70 : Colors.black54;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: GlassmorphicContainer(
          width: MediaQuery.of(context).size.width * 0.85,
          height: 380,
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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "CHOOSE PERSONA",
                    style: TextStyle(
                      color: dialogTextColor,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPersonaBtn(context, provider, "Professional", dialogTextColor),
                  _buildPersonaBtn(context, provider, "GenZ", dialogTextColor),
                  _buildPersonaBtn(context, provider, "SHELBY AI", dialogTextColor),
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
      ),
    );
  }

  Widget _buildPersonaBtn(
    BuildContext context,
    HabitProvider provider,
    String theme,
    Color activeTextColor,
  ) {
    final String currentPersona = provider.userPersona;
    bool isSelected = false;
    if (theme == "SHELBY AI") {
      isSelected = currentPersona == "SHELBY AI" ||
          currentPersona.toLowerCase() == "shelby" ||
          currentPersona.toLowerCase() == "overlord";
    } else {
      isSelected = currentPersona.toLowerCase() == theme.toLowerCase();
    }

    final IconData icon = NotificationMessages.getPersonaIcon(theme);
    final String subtitle = NotificationMessages.getPersonaSubtitle(theme);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            String savedTheme = theme;
            if (theme == "SHELBY AI") {
              savedTheme = "Overlord";
            }
            provider.updatePersona(savedTheme);
            Navigator.pop(context);
          },
          borderRadius: BorderRadius.circular(15),
          child: Ink(
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFFAC5DED), Color(0xFF7B61FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF00E5FF).withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.1),
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFFAC5DED).withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : [],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isSelected ? Colors.white : activeTextColor.withValues(alpha: 0.7),
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          theme,
                          style: TextStyle(
                            color: isSelected ? Colors.white : activeTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: isSelected ? Colors.white70 : activeTextColor.withValues(alpha: 0.5),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

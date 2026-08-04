import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../core/constants/habit_templates.dart';
import '../../../domain/models/habit_template.dart';

class TemplatesSheet extends StatelessWidget {
  final ValueChanged<HabitTemplate> onTemplateSelected;

  const TemplatesSheet({
    super.key,
    required this.onTemplateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;

    return GlassmorphicContainer(
      width: double.infinity,
      height: 380,
      borderRadius: 30,
      blur: 20,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        colors: [
          isDark ? Colors.black.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.8),
          isDark ? Colors.black.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.6),
        ],
      ),
      borderGradient: const LinearGradient(
        colors: [Color(0xFFAC5DED), Colors.white24],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "SELECT PRESET TEMPLATE",
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.w900,
                fontSize: 14,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Tapping will pre-fill this creation form",
              style: TextStyle(color: subtitleColor, fontSize: 10),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.3,
                ),
                itemCount: HabitTemplates.presets.length,
                itemBuilder: (context, index) {
                  final template = HabitTemplates.presets[index];
                  return InkWell(
                    onTap: () {
                      onTemplateSelected(template);
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            template.icon as FaIconData?,
                            size: 14,
                            color: const Color(0xFFAC5DED),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              template.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: titleColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

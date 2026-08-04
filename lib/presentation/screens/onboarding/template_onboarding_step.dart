import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/habit_templates.dart';
import 'onboarding_glass_card.dart';

class TemplateOnboardingStep extends StatelessWidget {
  final Set<String> selectedTemplateIds;
  final ValueChanged<String> onTemplateToggled;
  final bool linkWaterVitamins;
  final ValueChanged<bool?> onLinkWaterVitaminsChanged;
  final bool linkReadPlanning;
  final ValueChanged<bool?> onLinkReadPlanningChanged;

  const TemplateOnboardingStep({
    super.key,
    required this.selectedTemplateIds,
    required this.onTemplateToggled,
    required this.linkWaterVitamins,
    required this.onLinkWaterVitaminsChanged,
    required this.linkReadPlanning,
    required this.onLinkReadPlanningChanged,
  });

  @override
  Widget build(BuildContext context) {
    final descColor = Colors.white70;

    final hasWaterAndVitamins =
        selectedTemplateIds.contains('template_water') &&
        selectedTemplateIds.contains('template_vitamins');
    final hasReadAndPlanning =
        selectedTemplateIds.contains('template_read') &&
        selectedTemplateIds.contains('template_planning');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      child: Center(
        child: OnboardingGlassCard(
          borderColor: const Color(0xFFAC5DED),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "CHOOSE STARTER PROTOCOLS",
                  style: TextStyle(
                    color: Color(0xFFAC5DED),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Select 2-3 routines to pre-fill your discipline core",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: descColor, fontSize: 11),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 250,
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.3,
                    ),
                    itemCount: HabitTemplates.presets.length,
                    itemBuilder: (context, index) {
                      final template = HabitTemplates.presets[index];
                      final isSelected = selectedTemplateIds.contains(
                        template.id,
                      );
                      return GestureDetector(
                        onTap: () => onTemplateToggled(template.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: isSelected
                                ? const Color(
                                    0xFFAC5DED,
                                  ).withValues(alpha: 0.15)
                                : Colors.white.withValues(alpha: 0.05),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFAC5DED)
                                  : Colors.white.withValues(alpha: 0.1),
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                template.icon as FaIconData?,
                                size: 14,
                                color: isSelected
                                    ? const Color(0xFFAC5DED)
                                    : Colors.white60,
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
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white70,
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
                if (hasWaterAndVitamins || hasReadAndPlanning) ...[
                  const SizedBox(height: 10),
                  const Text(
                    "SUGGESTED CHAINS (OPT-IN)",
                    style: TextStyle(
                      color: Color(0xFF00E5FF),
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (hasWaterAndVitamins)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: linkWaterVitamins,
                          activeColor: const Color(0xFFAC5DED),
                          onChanged: onLinkWaterVitaminsChanged,
                        ),
                        const Flexible(
                          child: Text(
                            "Link 'Take Vitamins' after 'Drink Water'",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (hasReadAndPlanning)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: linkReadPlanning,
                          activeColor: const Color(0xFFAC5DED),
                          onChanged: onLinkReadPlanningChanged,
                        ),
                        const Flexible(
                          child: Text(
                            "Link 'Plan Tomorrow' after 'Read 10 Pages'",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}


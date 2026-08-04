import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../providers/habit_provider.dart';
import '../../../domain/models/habit.dart';
import '../../../core/constants/habit_templates.dart';
import '../home_screen.dart';

class OnboardingStartButton extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController ageController;
  final String selectedGender;
  final Set<String> selectedTemplateIds;
  final bool linkWaterVitamins;
  final bool linkReadPlanning;

  const OnboardingStartButton({
    super.key,
    required this.nameController,
    required this.ageController,
    required this.selectedGender,
    required this.selectedTemplateIds,
    required this.linkWaterVitamins,
    required this.linkReadPlanning,
  });

  @override
  Widget build(BuildContext context) {
    bool isValid = nameController.text.isNotEmpty && ageController.text.isNotEmpty;
    return GestureDetector(
      onTap: () => _onActivate(context, isValid),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: isValid
                ? [const Color(0xFFAC5DED), const Color(0xFF7B61FF)]
                : [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.white.withValues(alpha: 0.04),
                  ],
          ),
          border: Border.all(
            color: isValid ? Colors.transparent : Colors.white.withValues(alpha: 0.1),
            width: 1.0,
          ),
          boxShadow: isValid
              ? [
                  BoxShadow(
                    color: const Color(0xFFAC5DED).withValues(alpha: 0.4),
                    blurRadius: 25,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "ACTIVATE CORE",
              style: TextStyle(
                color: isValid ? Colors.white : Colors.white.withValues(alpha: 0.2),
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.bolt_rounded,
              color: isValid ? const Color(0xFF00E5FF) : Colors.white.withValues(alpha: 0.2),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onActivate(BuildContext context, bool isValid) async {
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complete all fields to proceed.")),
      );
      return;
    }

    HapticFeedback.heavyImpact();
    final provider = context.read<HabitProvider>();

    await provider.setupUser(
      name: nameController.text,
      age: int.tryParse(ageController.text) ?? 18,
      persona: "Professional",
      gender: selectedGender,
    );

    final habitsToAdd = _buildHabitsFromTemplates();
    if (habitsToAdd.isNotEmpty) provider.addHabits(habitsToAdd);

    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  List<Habit> _buildHabitsFromTemplates() {
    final Map<String, String> templateIdToRealId = {};

    for (final templateId in selectedTemplateIds) {
      templateIdToRealId[templateId] = "${DateTime.now().millisecondsSinceEpoch}_$templateId";
    }

    final List<Habit> habits = [];
    for (final templateId in selectedTemplateIds) {
      final template = HabitTemplates.presets.firstWhere((t) => t.id == templateId);

      String? parentHabitId;
      if (template.suggestedTriggerHabitId != null &&
          selectedTemplateIds.contains(template.suggestedTriggerHabitId)) {
        final bool linkThem =
            (template.id == 'template_vitamins' && linkWaterVitamins) ||
            (template.id == 'template_planning' && linkReadPlanning);
        if (linkThem) {
          parentHabitId = templateIdToRealId[template.suggestedTriggerHabitId];
        }
      }

      final now = DateTime.now();
      habits.add(Habit(
        id: templateIdToRealId[templateId]!,
        name: template.name,
        difficulty: HabitDifficulty.easy,
        timerDuration: 10,
        createdAt: now,
        reminderTime: DateTime(now.year, now.month, now.day,
            template.defaultReminderTime.hour, template.defaultReminderTime.minute),
        isCompleted: false,
        streak: 0,
        lastCompleted: now,
        triggerHabitId: parentHabitId,
      ));
    }
    return habits;
  }
}

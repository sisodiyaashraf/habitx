import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../domain/models/habit_template.dart';

class HabitTemplates {
  static const List<HabitTemplate> presets = [
    HabitTemplate(
      id: 'template_water',
      name: 'Drink Water',
      icon: FontAwesomeIcons.droplet,
      suggestedFrequency: 'daily',
      defaultReminderTime: TimeOfDay(hour: 7, minute: 30),
    ),
    HabitTemplate(
      id: 'template_vitamins',
      name: 'Take Vitamins',
      icon: FontAwesomeIcons.capsules,
      suggestedFrequency: 'daily',
      defaultReminderTime: TimeOfDay(hour: 8, minute: 0),
      suggestedTriggerHabitId: 'template_water', // Stacking link suggestion
    ),
    HabitTemplate(
      id: 'template_read',
      name: 'Read 10 Pages',
      icon: FontAwesomeIcons.bookOpen,
      suggestedFrequency: 'daily',
      defaultReminderTime: TimeOfDay(hour: 21, minute: 0),
    ),
    HabitTemplate(
      id: 'template_workout',
      name: 'Workout',
      icon: FontAwesomeIcons.dumbbell,
      suggestedFrequency: 'daily',
      defaultReminderTime: TimeOfDay(hour: 17, minute: 0),
    ),
    HabitTemplate(
      id: 'template_meditate',
      name: 'Meditate',
      icon: FontAwesomeIcons.brain,
      suggestedFrequency: 'daily',
      defaultReminderTime: TimeOfDay(hour: 7, minute: 0),
    ),
    HabitTemplate(
      id: 'template_sleep',
      name: 'Sleep on Time',
      icon: FontAwesomeIcons.moon,
      suggestedFrequency: 'daily',
      defaultReminderTime: TimeOfDay(hour: 22, minute: 30),
    ),
    HabitTemplate(
      id: 'template_journal',
      name: 'Daily Journal',
      icon: FontAwesomeIcons.penNib,
      suggestedFrequency: 'daily',
      defaultReminderTime: TimeOfDay(hour: 22, minute: 0),
    ),
    HabitTemplate(
      id: 'template_planning',
      name: 'Plan Tomorrow',
      icon: FontAwesomeIcons.calendarCheck,
      suggestedFrequency: 'daily',
      defaultReminderTime: TimeOfDay(hour: 21, minute: 30),
      suggestedTriggerHabitId: 'template_read', // Stacking link suggestion
    ),
    HabitTemplate(
      id: 'template_stretch',
      name: 'Morning Stretch',
      icon: FontAwesomeIcons.childReaching,
      suggestedFrequency: 'daily',
      defaultReminderTime: TimeOfDay(hour: 7, minute: 15),
    ),
    HabitTemplate(
      id: 'template_budget',
      name: 'Track Expenses',
      icon: FontAwesomeIcons.wallet,
      suggestedFrequency: 'daily',
      defaultReminderTime: TimeOfDay(hour: 20, minute: 0),
    ),
    HabitTemplate(
      id: 'template_weekly_review',
      name: 'Weekly Review',
      icon: FontAwesomeIcons.clipboardCheck,
      suggestedFrequency: 'weekly',
      defaultReminderTime: TimeOfDay(hour: 18, minute: 0),
    ),
  ];
}

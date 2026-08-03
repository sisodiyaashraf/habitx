import 'package:flutter/material.dart';

class HabitTemplate {
  final String id;
  final String name;
  final dynamic icon;
  final String suggestedFrequency;
  final TimeOfDay defaultReminderTime;
  final String? suggestedTriggerHabitId;

  const HabitTemplate({
    required this.id,
    required this.name,
    required this.icon,
    this.suggestedFrequency = 'daily',
    this.defaultReminderTime = const TimeOfDay(hour: 8, minute: 0),
    this.suggestedTriggerHabitId,
  });
}

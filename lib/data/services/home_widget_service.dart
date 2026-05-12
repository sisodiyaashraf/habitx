import 'dart:async';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

class HomeWidgetService {
  static const String _androidWidgetName = 'HabitWidgetProvider';
  static const String _androidWidgetPackage = 'com.shalcontech.habitx';
  static const String _groupId = 'habitx_glass_data';

  /// Initializes the Home Widget service.
  static Future<void> init() async {
    await HomeWidget.setAppGroupId(_groupId);
  }

  /// Updates the Home Widget with progress and mascot.
  static Future<void> updateWidget({
    double progress = 0.0,
    String? activeHabit,
    int completed = 0,
    int total = 0,
  }) async {
    try {
      // 1. Save Data for Native Side
      await HomeWidget.saveWidgetData('progress', progress);
      await HomeWidget.saveWidgetData('active_habit', activeHabit ?? "None");
      await HomeWidget.saveWidgetData('completed_text', "$completed/$total DONE");

      // 2. Calculate Mascot
      final now = DateTime.now();
      final epoch = DateTime(2025, 1, 1);
      final daysSinceEpoch = now.difference(epoch).inDays;
      final imageIndex = (daysSinceEpoch % 3) + 1;
      final String assetPath = 'assets/images/habitx$imageIndex.png';

      // 3. Render Mascot for Widget
      await HomeWidget.renderFlutterWidget(
        Image.asset(assetPath, fit: BoxFit.contain),
        key: 'mascot_image',
        logicalSize: const Size(400, 400),
      );

      // 4. Trigger Native Update
      await HomeWidget.updateWidget(
        name: _androidWidgetName,
        androidName: '$_androidWidgetPackage.$_androidWidgetName',
      );

      debugPrint("HabitX: Widget Updated [Progress: $progress, Habit: $activeHabit]");
    } catch (e) {
      debugPrint("HabitX Widget Error: $e");
    }
  }
}

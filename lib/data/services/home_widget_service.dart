import 'dart:async';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

class HomeWidgetService {
  // FIXED: Removed the package name prefix to prevent the ClassNotFound double-package error
  static const String _androidWidgetName = 'HabitWidgetProvider';
  static const String _groupId = 'habitx_glass_data';

  /// Initializes the Home Widget service.
  static Future<void> init() async {
    await HomeWidget.setAppGroupId(_groupId);
  }

  /// Updates the Home Widget with the optimized daily rotating image.
  static Future<void> updateWidget() async {
    try {
      final now = DateTime.now();

      // Calculate Daily Image Index (1, 2, or 3)
      final imageIndex = (now.day % 3) + 1;
      final String assetPath = 'assets/images/habitx$imageIndex.png';

      debugPrint("HabitX Neural Sync: Rotating daily artwork -> $assetPath");

      // FIXED: Dropped logicalSize to 100x100.
      // This is the "Safe Zone" for Android RemoteViews memory limits.
      await HomeWidget.renderFlutterWidget(
        Image.asset(assetPath, fit: BoxFit.contain),
        key: 'mascot_image',
        logicalSize: const Size(100, 100),
      );

      // FIXED: Using only the class name to prevent the package-doubling crash
      await HomeWidget.updateWidget(
        name: _androidWidgetName,
        androidName: _androidWidgetName,
      );

      debugPrint("HabitX: Home Widget Sync Complete.");
    } catch (e) {
      debugPrint("HabitX Widget Sync Error: $e");
    }
  }
}

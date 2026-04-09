import 'package:flutter/services.dart';

class HapticHelper {
  // Light tap for minor actions like switching tabs or opening a menu
  static void lightTap() {
    HapticFeedback.lightImpact();
  }

  // Soft click for simple button presses
  static void selection() {
    HapticFeedback.selectionClick();
  }

  // Success "double-tap" feel for completing a habit
  static void success() {
    // A rapid sequence feels more rewarding than a single thump
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 60), () {
      HapticFeedback.mediumImpact();
    });
  }

  // Heavy "Level Up" vibration - long and distinct
  static void levelUp() {
    HapticFeedback.vibrate();
    // For a really premium feel, follow it with a heavy impact
    Future.delayed(const Duration(milliseconds: 150), () {
      HapticFeedback.heavyImpact();
    });
  }
}

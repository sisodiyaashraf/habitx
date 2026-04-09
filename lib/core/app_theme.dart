import 'package:flutter/material.dart';

class AppTheme {
  static const Color brandPurple = Color(0xFFAC5DED);
  static const Color accentBlue = Color(0xFF7B61FF);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // 1. ColorScheme ensures buttons/indicators use brand colors
    colorScheme: ColorScheme.fromSeed(
      seedColor: brandPurple,
      primary: brandPurple,
      secondary: accentBlue,
      onSurface: Colors.black87, // Critical for UI visibility
    ),

    scaffoldBackgroundColor: Colors.transparent,

    // 2. Global Text Theme: High-contrast dark text for light glass
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54), // For streaks/XP text
    ),

    // 3. AppBar Theme: Ensures the title is visible over the orbs
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),
      iconTheme: IconThemeData(color: brandPurple),
    ),

    // 4. Glass-compatible Card Theme
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: brandPurple,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: Colors.transparent,
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.white.withOpacity(0.05)),
      ),
    ),
  );
}

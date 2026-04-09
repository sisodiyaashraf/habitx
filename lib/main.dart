import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:io';

// Core & Providers
import 'core/app_theme.dart';
import 'providers/habit_provider.dart';
import 'providers/theme_provider.dart';

// NEW: Pointing to your new notification_master.dart file
import 'data/services/notification_master.dart';

// Screens
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/onboarding_screen.dart';

void main() async {
  // 1. MUST be the first line
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Setup System UI (Glassmorphic Optimization)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarContrastEnforced: false,
    ),
  );

  // Enable Edge-to-Edge mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // 3. Initialize Services (Using the new HabitXNotificationManager)
  final notificationManager = HabitXNotificationManager();
  final habitProvider = HabitProvider();

  // Initialize providers and notification system in parallel
  await Future.wait([
    notificationManager.init(),
    habitProvider.init(),
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]);

  // 4. Handle Post-Init logic
  if (!habitProvider.isNewUser) {
    // Trigger the rotating daily status/motivation
    await notificationManager.triggerDailyMotivation();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: habitProvider),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const HabitXApp(),
    ),
  );
}

class HabitXApp extends StatelessWidget {
  const HabitXApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch providers for state-driven UI updates
    final habitProvider = context.watch<HabitProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'HabitX',
      debugShowCheckedModeBanner: false,

      // Navigation key for Global achievement dialogs
      navigatorKey: habitProvider.navigatorKey,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,

      // Prevent OS-level font scaling from breaking Glassmorphic containers
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },

      // Routing logic based on user status
      home: habitProvider.isNewUser
          ? const OnboardingScreen()
          : const HomeScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Core & Providers
import 'core/app_theme.dart';
import 'data/services/notifications/habit_x_notification_service.dart';
// 🚀 ADDED: Import your updated HomeWidgetService
import 'data/services/home_widget_service.dart';
import 'providers/habit_provider.dart';
import 'providers/theme_provider.dart';

// Screens
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/onboarding_screen.dart';

void main() async {
  // 1. Framework & Engine Initialization
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Tactical Resource Pre-Loading
  final habitProvider = HabitProvider();
  final notificationService = HabitXNotificationService();

  try {
    // 🛰️ HOME WIDGET INITIALIZATION
    // Registers the background interactivity callback for Quick Actions
    await HomeWidgetService.init();

    // Sequential initialization: Database (Hive) must load first
    await habitProvider.init();

    // Neural Engine init: Handles Timezones and Daily Briefing loops
    await notificationService.init();
  } catch (e) {
    debugPrint("HabitX Neural Init Failure: $e");
  }

  // Tactical Orientation Lock
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // 3. System UI - Edge-to-Edge Immersion
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // 4. Strategic Post-Init Briefing
  // If the system is already initialized, trigger a widget update to ensure
  // the home screen widget is perfectly synced with the latest app data.
  if (!habitProvider.isNewUser) {
    debugPrint("HabitX: Triggering Initial Neural Sync Notification...");
    notificationService.showInstantNotification(
      title: "Neural Sync Complete ⚡",
      body: "Overlord Engine is active. Local time: ${DateTime.now().hour}:${DateTime.now().minute}",
    );

    // Sync the current habit state to the Glassmorphic Widget
    HomeWidgetService.updateWidget();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<HabitProvider>.value(value: habitProvider),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        Provider<HabitXNotificationService>.value(value: notificationService),
        // Providing the HomeWidgetService as a static-style provider if needed
      ],
      child: const HabitXApp(),
    ),
  );
}

class HabitXApp extends StatelessWidget {
  const HabitXApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select((ThemeProvider p) => p.themeMode);
    final isNewUser = context.select((HabitProvider p) => p.isNewUser);
    final navigatorKey = context.read<HabitProvider>().navigatorKey;

    return MaterialApp(
      title: 'HabitX',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
      home: isNewUser ? const OnboardingScreen() : const HomeScreen(),
    );
  }
}

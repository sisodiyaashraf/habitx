import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Core & Providers
import 'core/app_theme.dart';
import 'data/services/notifications/habit_x_notification_service.dart';
import 'data/services/home_widget_service.dart';
import 'providers/habit_provider.dart';
import 'providers/theme_provider.dart';
import 'core/constants/notification_messages.dart';

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
    // Registers the background group ID for the daily image rotation
    await HomeWidgetService.init();

    // Sequential initialization: Database (SharedPreferences) must load first
    await habitProvider.init();
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

  // 4. Strategic Post-Init Sync
  if (!habitProvider.isNewUser) {
    debugPrint("HabitX: Triggering Initial Neural Sync Notification...");

    // Greet the user with a system status check
    notificationService.showInstantNotification(
      title: NotificationMessages.getStatusTitle(habitProvider.userPersona),
      body: NotificationMessages.getStatusBody(habitProvider.userPersona),
    );
    final int maxStreak = habitProvider.allHabits.isEmpty
        ? 0
        : habitProvider.allHabits.map((h) => h.streak).reduce((a, b) => a > b ? a : b);
    final int completedCount = habitProvider.allHabits.where((h) => h.isCompleted).length;
    final int totalCount = habitProvider.allHabits.length;

    HomeWidgetService.updateWidget(
      streak: maxStreak,
      level: habitProvider.userLevel,
      completedCount: completedCount,
      totalCount: totalCount,
    );
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<HabitProvider>.value(value: habitProvider),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        Provider<HabitXNotificationService>.value(value: notificationService),
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
          // Lock text scale to 1.0 to ensure the minimalist UI remains pixel-perfect
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

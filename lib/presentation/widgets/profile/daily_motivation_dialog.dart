import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../data/services/notifications/habit_x_notification_service.dart';
import '../../../providers/habit_provider.dart';
import '../../../core/constants/notification_messages.dart';

class DailyMotivationDialog extends StatelessWidget {
  const DailyMotivationDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const DailyMotivationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notificationService = context.read<HabitXNotificationService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogTextColor = isDark ? Colors.white : Colors.black;
    final dialogSubTextColor = isDark ? Colors.white70 : Colors.black54;

    return Center(
      child: SingleChildScrollView(
        child: Material(
          color: Colors.transparent,
          child: GlassmorphicContainer(
            width: MediaQuery.of(context).size.width * 0.85,
            height: 320,
            borderRadius: 30,
            blur: 20,
            alignment: Alignment.center,
            border: 2,
            linearGradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.2),
                Colors.white.withValues(alpha: 0.1),
              ],
            ),
            borderGradient: const LinearGradient(
              colors: [Color(0xFFAC5DED), Colors.white24],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.notifications_active_rounded,
                      color: Color(0xFFAC5DED),
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "DAILY MOTIVATION",
                      style: TextStyle(
                        color: dialogTextColor,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Receive high-performance reminders daily to keep you on track.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: dialogSubTextColor, fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Consumer<HabitProvider>(
                      builder: (context, provider, _) {
                        final isEnabled = provider.isDailyMotivationEnabled;
                        return Container(
                          decoration: BoxDecoration(
                            color: isEnabled
                                ? const Color(0xFFAC5DED).withValues(alpha: 0.1)
                                : Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isEnabled
                                  ? const Color(0xFFAC5DED).withValues(alpha: 0.3)
                                  : Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: SwitchListTile.adaptive(
                              title: Text(
                                "Daily Briefings",
                                style: TextStyle(
                                  color: dialogTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Text(
                                "Get morning updates",
                                style: TextStyle(
                                  color: dialogSubTextColor.withValues(alpha: 0.6),
                                  fontSize: 11,
                                ),
                              ),
                              value: isEnabled,
                              activeThumbColor: const Color(0xFFAC5DED),
                              activeTrackColor: const Color(0xFF00E5FF),
                              onChanged: (val) {
                                provider.toggleDailyMotivation(val);
                                if (val) {
                                  notificationService.showInstantNotification(
                                    title: NotificationMessages.getStatusTitle(provider.userPersona),
                                    body: NotificationMessages.getStatusBody(
                                      provider.userPersona,
                                      context: "motivation",
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "CLOSE",
                        style: TextStyle(
                          color: dialogSubTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

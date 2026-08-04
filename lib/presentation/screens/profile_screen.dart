import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/habit_provider.dart';
import '../widgets/shared/animated_level_avatar.dart';
import '../widgets/shared/glass_background.dart';
import 'profile/identity_dialog.dart';
import 'profile/avatar_dialog.dart';
import 'profile/persona_dialog.dart';
import 'profile/weekly_performance.dart';
import '../widgets/settings/settings_tile_components.dart';
import '../widgets/profile/daily_motivation_dialog.dart';
import '../widgets/profile/logout_confirm_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "PROFILE",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_rounded,
              color: textColor,
              size: 26,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: GlassBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + kToolbarHeight + 10.0,
            bottom: 110,
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.15),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withValues(alpha: 0.12),
                      width: 1.5,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 20.0),
                child: Column(
                  children: [
                    _buildLevelAvatar(provider),
                    const SizedBox(height: 20),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        provider.userName.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Elite Habit Builder",
                      style: TextStyle(
                        color: subTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    WeeklyPerformanceWidget(textColor: textColor, subTextColor: subTextColor, isDark: isDark),
                    const SizedBox(height: 20),
                    SettingsSectionHeader(title: "PERSONALIZATION", subTextColor: subTextColor),
                    SettingsGroup(
                      tiles: [
                        SettingsTile(
                          icon: Icons.person_outline_rounded,
                          title: "Edit Identity",
                          subtitle: "Name: ${provider.userName}, Age: ${provider.userAge}",
                          textColor: textColor,
                          subTextColor: subTextColor,
                          onTap: () => showDialog(context: context, builder: (_) => const IdentityDialog()),
                        ),
                        SettingsTile(
                          icon: Icons.face_rounded,
                          title: "Edit Avatar",
                          subtitle: "Preset: ${provider.userAvatarDisplayName}",
                          textColor: textColor,
                          subTextColor: subTextColor,
                          onTap: () => showDialog(context: context, builder: (_) => const AvatarDialog()),
                        ),
                        SettingsTile(
                          icon: Icons.psychology_outlined,
                          title: "Persona",
                          subtitle: "Style: ${provider.userPersona}",
                          textColor: textColor,
                          subTextColor: subTextColor,
                          onTap: () => showDialog(context: context, builder: (_) => const PersonaDialog()),
                        ),
                        SettingsTile(
                          icon: Icons.notifications_active_rounded,
                          title: "Reminders",
                          subtitle: "Configure daily alerts",
                          textColor: textColor,
                          subTextColor: subTextColor,
                          onTap: () => DailyMotivationDialog.show(context),
                        ),
                      ],
                      height: 288,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 32),
                    SettingsSectionHeader(title: "PREFERENCES", subTextColor: subTextColor),
                    SettingsGroup(
                      tiles: [
                        SwitchSettingsTile(
                          icon: Icons.vibration_rounded,
                          title: "Haptic Feedback",
                          subtitle: "Vibrate on habit completion",
                          value: provider.isHapticsEnabled,
                          textColor: textColor,
                          subTextColor: subTextColor,
                          onChanged: (val) {
                            context.read<HabitProvider>().toggleHaptics(val);
                          },
                        ),
                      ],
                      height: 72,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 40),
                    _buildLogoutButton(context, provider),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildLevelAvatar(HabitProvider provider) {
    return AnimatedLevelAvatar(provider: provider);
  }



  Widget _buildLogoutButton(BuildContext context, HabitProvider provider) {
    return TextButton(
      onPressed: () => LogoutConfirmDialog.show(context), // Triggers the wipe logic
      child: const Text(
        "LOG OUT",
        style: TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          fontSize: 12,
        ),
      ),
    );
  }
}

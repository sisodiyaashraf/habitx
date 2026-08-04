import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../providers/habit_provider.dart';
import '../../data/services/notifications/habit_x_notification_service.dart';
import '../../core/constants/notification_messages.dart';
import '../widgets/shared/glass_background.dart';
import '../widgets/shared/privacy_policy_dialog.dart';
import '../widgets/shared/terms_of_service_dialog.dart';
import '../widgets/settings/reset_confirm_dialog.dart';
import '../widgets/settings/shelby_mood_dialog.dart';
import '../widgets/settings/gender_tone_dialog.dart';
import '../widgets/settings/settings_tile_components.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  final String _appPackageName = "com.shalcontech.habitx";

  // --- Logic: Reset Identity ---
  void _handleReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ResetConfirmDialog(),
    );
  }

  // --- Logic: App Store/Share ---
  void _shareApp() {
    const String message =
        "I'm building elite discipline with HabitX. 🚀\n\nDownload here: https://play.google.com/store/apps/details?id=com.shalcontech.habitx";
    SharePlus.instance.share(
      ShareParams(
        text: message,
        subject: 'Join me on HabitX',
      ),
    );
  }

  Future<void> _rateApp(BuildContext context) async {
    final InAppReview inAppReview = InAppReview.instance;
    try {
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      } else {
        await inAppReview.openStoreListing();
      }
    } catch (e) {
      final Uri playStoreUri = Uri.parse(
        "https://play.google.com/store/apps/details?id=$_appPackageName",
      );
      if (await canLaunchUrl(playStoreUri)) {
        await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
      }
    }
  }

  // --- Support ---
  Future<void> _launchEmail() async {
    final Uri uri = Uri.parse(
      "mailto:ashrafsisodiya478@gmail.com?subject=HabitX%20Support%20Request",
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final provider = context.watch<HabitProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "SETTINGS",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
      ),
      body: GlassBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 120, 20, 40),
          children: [
            SettingsSectionHeader(title: "APPEARANCE", subTextColor: subTextColor),
            SettingsGroup(
              tiles: [ThemeSelector(textColor: textColor, subTextColor: subTextColor)],
              height: 130,
              isDark: isDark,
            ),

            const SizedBox(height: 32),

            SettingsSectionHeader(title: "PREFERENCES", subTextColor: subTextColor),
            SettingsGroup(
              tiles: [
                SwitchSettingsTile(
                  icon: FontAwesomeIcons.fingerprint,
                  title: "Tactile Feedback",
                  subtitle: "Enable haptic vibrations on screen interaction",
                  value: provider.isHapticsEnabled,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  onChanged: (val) {
                    provider.toggleHaptics(val);
                  },
                ),
                SwitchSettingsTile(
                  icon: FontAwesomeIcons.envelopeOpenText,
                  title: "Daily Motivations",
                  subtitle: "Receive routine briefings and check-ins",
                  value: provider.isDailyMotivationEnabled,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  onChanged: (val) {
                    provider.toggleDailyMotivation(val);
                  },
                ),
                SwitchSettingsTile(
                  icon: FontAwesomeIcons.circleHalfStroke,
                  title: "Reduce Motion & Effects",
                  subtitle: "Quiet animations, particles, and heavy rumble haptics",
                  value: provider.isReduceMotionActive,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  onChanged: (val) {
                    provider.toggleReduceMotion(val);
                  },
                ),
                SettingsTile(
                  icon: FontAwesomeIcons.bell,
                  title: "System Alerts Permission",
                  subtitle: "Ensure system notifications are fully authorized",
                  textColor: textColor,
                  subTextColor: subTextColor,
                  onTap: () async {
                    final granted = await HabitXNotificationService().requestPermissions();
                    if (!context.mounted) return;
                    if (granted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Protocol Authorized: Notifications Active ⚡"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Permissions Denied. Please check System Settings."),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                ),
                SettingsTile(
                  icon: FontAwesomeIcons.circleUser,
                  title: "Notification Theme",
                  subtitle: "Style: ${provider.userPersona}",
                  textColor: textColor,
                  subTextColor: subTextColor,
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => const ShelbyMoodDialog(),
                  ),
                ),
                SettingsTile(
                  icon: FontAwesomeIcons.venusMars,
                  title: "Gender Voice Tone",
                  subtitle: "Tone: ${provider.userGender}",
                  textColor: textColor,
                  subTextColor: subTextColor,
                  onTap: () => GenderToneDialog.show(context, provider),
                ),
                SettingsTile(
                  icon: FontAwesomeIcons.solidBell,
                  title: "Test Notification",
                  subtitle: "Send a test check-in notification immediately",
                  textColor: textColor,
                  subTextColor: subTextColor,
                  onTap: () async {
                    final String persona = provider.userPersona;
                    final String gender = provider.userGender;
                    final String randomPrompt = NotificationMessages.getRandomPrompt(persona, gender: gender);
                    await HabitXNotificationService().showInstantNotification(
                      title: NotificationMessages.getStatusTitle(persona),
                      body: randomPrompt,
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Test check-in notification dispatched! 🔔"),
                        backgroundColor: Color(0xFFAC5DED),
                      ),
                    );
                  },
                ),
              ],
              height: 504,
              isDark: isDark,
            ),

            const SizedBox(height: 32),

            SettingsSectionHeader(title: "SUPPORT & COMMUNITY", subTextColor: subTextColor),
            SettingsGroup(
              tiles: [
                SettingsTile(
                  icon: FontAwesomeIcons.shareNodes,
                  title: "Invite Friends",
                  subtitle: "Share the mission",
                  textColor: textColor,
                  subTextColor: subTextColor,
                  onTap: _shareApp,
                ),
                SettingsTile(
                  icon: FontAwesomeIcons.star,
                  title: "Rate HabitX",
                  subtitle: "Support us on Play Store",
                  textColor: textColor,
                  subTextColor: subTextColor,
                  onTap: () => _rateApp(context),
                ),
                SettingsTile(
                  icon: FontAwesomeIcons.envelope,
                  title: "Email Support",
                  subtitle: "Direct dev feedback",
                  textColor: textColor,
                  subTextColor: subTextColor,
                  onTap: _launchEmail,
                ),
              ],
              height: 216,
              isDark: isDark,
            ),

            const SizedBox(height: 32),

            SettingsSectionHeader(title: "DANGER ZONE", subTextColor: Colors.red.withValues(alpha: 0.7)),
            SettingsGroup(
              tiles: [
                SettingsTile(
                  icon: FontAwesomeIcons.trashCan,
                  title: "Reset Identity",
                  subtitle: "Wipe all local data",
                  textColor: Colors.redAccent,
                  subTextColor: subTextColor,
                  onTap: () => _handleReset(context),
                ),
              ],
              height: 72,
              isDark: isDark,
            ),

            const SizedBox(height: 32),

            SettingsSectionHeader(title: "LEGAL", subTextColor: subTextColor),
            SettingsGroup(
              tiles: [
                SettingsTile(
                  icon: FontAwesomeIcons.shieldHalved,
                  title: "Privacy Policy",
                  subtitle: "Data protocols",
                  textColor: textColor,
                  subTextColor: subTextColor,
                  onTap: () => PrivacyPolicyDialog.show(context),
                ),
                SettingsTile(
                  icon: FontAwesomeIcons.fileContract,
                  title: "Terms of Service",
                  subtitle: "Usage protocols",
                  textColor: textColor,
                  subTextColor: subTextColor,
                  onTap: () => TermsOfServiceDialog.show(context),
                ),
              ],
              height: 144,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

}

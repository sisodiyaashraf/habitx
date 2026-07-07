import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../providers/habit_provider.dart';
import '../../providers/theme_provider.dart';
import '../../data/services/notifications/habit_x_notification_service.dart';
import '../widgets/shared/glass_background.dart';
import '../widgets/shared/privacy_policy_dialog.dart';
import '../widgets/shared/terms_of_service_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  final String _appPackageName = "com.shalcontech.habitx";

  // --- Logic: Reset Identity ---
  void _handleReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          "RESET DATA?",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        content: const Text(
          "This will wipe all progress, XP, and habits. You cannot undo this.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL"),
          ),
          TextButton(
            onPressed: () {
              context.read<HabitProvider>().resetUserIdentity();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text("RESET", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
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


            _buildSectionHeader("APPEARANCE", subTextColor),
            _buildSettingsGroup(
              [_buildThemeSelector(context, textColor, subTextColor)],
              height: 130,
              isDark: isDark,
            ),

            const SizedBox(height: 32),

            _buildSectionHeader("PREFERENCES", subTextColor),
            _buildSettingsGroup(
              [
                _switchSettingsTile(
                  FontAwesomeIcons.fingerprint,
                  "Tactile Feedback",
                  "Enable haptic vibrations on screen interaction",
                  provider.isHapticsEnabled,
                  textColor,
                  subTextColor,
                  onChanged: (val) {
                    provider.toggleHaptics(val);
                  },
                ),
                _switchSettingsTile(
                  FontAwesomeIcons.envelopeOpenText,
                  "Daily Motivations",
                  "Receive routine briefings and check-ins",
                  provider.isDailyMotivationEnabled,
                  textColor,
                  subTextColor,
                  onChanged: (val) {
                    provider.toggleDailyMotivation(val);
                  },
                ),
                _settingsTile(
                  FontAwesomeIcons.bell,
                  "System Alerts Permission",
                  "Ensure system notifications are fully authorized",
                  textColor,
                  subTextColor,
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
                _settingsTile(
                  FontAwesomeIcons.circleUser,
                  "Notification Theme",
                  "Style: ${provider.userPersona}",
                  textColor,
                  subTextColor,
                  onTap: () => _showNotificationThemeDialog(context, provider),
                ),
              ],
              height: 288,
              isDark: isDark,
            ),

            const SizedBox(height: 32),

            _buildSectionHeader("SUPPORT & COMMUNITY", subTextColor),
            _buildSettingsGroup(
              [
                _settingsTile(
                  FontAwesomeIcons.shareNodes,
                  "Invite Friends",
                  "Share the mission",
                  textColor,
                  subTextColor,
                  onTap: _shareApp,
                ),
                _settingsTile(
                  FontAwesomeIcons.star,
                  "Rate HabitX",
                  "Support us on Play Store",
                  textColor,
                  subTextColor,
                  onTap: () => _rateApp(context),
                ),
                _settingsTile(
                  FontAwesomeIcons.envelope,
                  "Email Support",
                  "Direct dev feedback",
                  textColor,
                  subTextColor,
                  onTap: _launchEmail,
                ),
              ],
              height: 216,
              isDark: isDark,
            ),

            const SizedBox(height: 32),

            _buildSectionHeader("DANGER ZONE", Colors.red.withValues(alpha: 0.7)),
            _buildSettingsGroup(
              [
                _settingsTile(
                  FontAwesomeIcons.trashCan,
                  "Reset Identity",
                  "Wipe all local data",
                  Colors.redAccent,
                  subTextColor,
                  onTap: () => _handleReset(context),
                ),
              ],
              height: 72,
              isDark: isDark,
            ),

            const SizedBox(height: 32),

            _buildSectionHeader("LEGAL", subTextColor),
            _buildSettingsGroup(
              [
                _settingsTile(
                  FontAwesomeIcons.shieldHalved,
                  "Privacy Policy",
                  "Data protocols",
                  textColor,
                  subTextColor,
                  onTap: () => PrivacyPolicyDialog.show(context),
                ),
                _settingsTile(
                  FontAwesomeIcons.fileContract,
                  "Terms of Service",
                  "Usage protocols",
                  textColor,
                  subTextColor,
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

  // --- Reusable Components ---

  Widget _settingsTile(
    dynamic icon,
    String title,
    String subtitle,
    Color textColor,
    Color subTextColor, {
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFAC5DED).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: FaIcon(
          icon,
          color: title.contains("Reset")
              ? Colors.redAccent
              : const Color(0xFFAC5DED),
          size: 16,
        ),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 10, color: subTextColor),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: subTextColor.withValues(alpha: 0.3),
        size: 18,
      ),
    );
  }

  Widget _switchSettingsTile(
    dynamic icon,
    String title,
    String subtitle,
    bool value,
    Color textColor,
    Color subTextColor, {
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFAC5DED).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: FaIcon(
          icon,
          color: const Color(0xFFAC5DED),
          size: 16,
        ),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 10, color: subTextColor),
      ),
      trailing: Switch.adaptive(
        value: value,
        activeThumbColor: const Color(0xFFAC5DED),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color subTextColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: subTextColor,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(
    List<Widget> tiles, {
    required double height,
    required bool isDark,
  }) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: height,
      borderRadius: 25,
      blur: 20,
      alignment: Alignment.center,
      border: 1.0,
      linearGradient: LinearGradient(
        colors: [
          isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.2),
          isDark
              ? Colors.white.withValues(alpha: 0.02)
              : Colors.white.withValues(alpha: 0.05),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [Colors.white.withValues(alpha: 0.1), Colors.transparent],
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: tiles,
        ),
      ),
    );
  }

  Widget _buildThemeSelector(
    BuildContext context,
    Color textColor,
    Color subTextColor,
  ) {
    final themeProvider = context.watch<ThemeProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Theme Mode",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _themeOption(
                context,
                themeProvider,
                ThemeMode.system,
                Icons.settings_suggest_rounded,
                "System",
                textColor,
              ),
              const SizedBox(width: 8),
              _themeOption(
                context,
                themeProvider,
                ThemeMode.dark,
                Icons.dark_mode_rounded,
                "Dark",
                textColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _themeOption(
    BuildContext context,
    ThemeProvider provider,
    ThemeMode mode,
    IconData icon,
    String label,
    Color textColor,
  ) {
    final isSelected = provider.themeMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => provider.setTheme(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFAC5DED) : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFAC5DED)
                  : textColor.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : textColor.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : textColor.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationThemeDialog(
    BuildContext context,
    HabitProvider provider,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogTextColor = isDark ? Colors.white : Colors.black;
    final dialogSubTextColor = isDark ? Colors.white70 : Colors.black54;

    showDialog(
      context: context,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: GlassmorphicContainer(
            width: MediaQuery.of(context).size.width * 0.85,
            height: 380,
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
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "NOTIFICATION THEME",
                      style: TextStyle(
                        color: dialogTextColor,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildThemeOptionBtn(context, provider, "Professional", dialogTextColor),
                    _buildThemeOptionBtn(context, provider, "GenZ", dialogTextColor),
                    _buildThemeOptionBtn(context, provider, "SHELBY AI", dialogTextColor),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "CLOSE",
                        style: TextStyle(color: dialogSubTextColor),
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

  Widget _buildThemeOptionBtn(
    BuildContext context,
    HabitProvider provider,
    String theme,
    Color activeTextColor,
  ) {
    final String currentPersona = provider.userPersona;
    bool isSelected = false;
    if (theme == "SHELBY AI") {
      isSelected = currentPersona == "SHELBY AI" ||
          currentPersona.toLowerCase() == "shelby" ||
          currentPersona.toLowerCase() == "overlord";
    } else {
      isSelected = currentPersona.toLowerCase() == theme.toLowerCase();
    }

    IconData icon;
    String subtitle;
    switch (theme) {
      case "Professional":
        icon = Icons.work_rounded;
        subtitle = "Elite, disciplined reinforcement style";
        break;
      case "GenZ":
        icon = Icons.bolt_rounded;
        subtitle = "Informal, trendy, high-energy vibes";
        break;
      case "SHELBY AI":
      default:
        icon = Icons.psychology_rounded;
        subtitle = "Sarcastic, sentient AI Overlord protocol";
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            String savedTheme = theme;
            if (theme == "SHELBY AI") {
              savedTheme = "Overlord";
            }
            provider.updatePersona(savedTheme);
            Navigator.pop(context);
          },
          borderRadius: BorderRadius.circular(15),
          child: Ink(
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFFAC5DED), Color(0xFF7B61FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF00E5FF).withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.1),
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFFAC5DED).withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : [],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isSelected ? Colors.white : activeTextColor.withValues(alpha: 0.7),
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          theme,
                          style: TextStyle(
                            color: isSelected ? Colors.white : activeTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: isSelected ? Colors.white70 : activeTextColor.withValues(alpha: 0.5),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

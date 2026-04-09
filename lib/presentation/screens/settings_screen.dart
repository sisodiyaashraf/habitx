import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../providers/habit_provider.dart';
import '../../providers/theme_provider.dart';
import '../widgets/shared/glass_background.dart';
import '../widgets/settings/brand_vision_view.dart';
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
    Share.share(message, subject: 'Join me on HabitX');
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
      if (await canLaunchUrl(playStoreUri))
        await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
    }
  }

  // --- Support ---
  Future<void> _launchWhatsApp() async {
    const String phone = "919530273440";
    final Uri uri = Uri.parse(
      "https://wa.me/$phone?text=HabitX Support Request",
    );
    if (await canLaunchUrl(uri))
      await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

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

            _buildSectionHeader("DEVELOPER TOOLS", subTextColor),
            _buildSettingsGroup(
              [
                _settingsTile(
                  FontAwesomeIcons.bug,
                  "Test Notifications",
                  "Trigger a test alert (5s delay)",
                  textColor,
                  subTextColor,
                  onTap: () {
                    context.read<HabitProvider>().sendTestNotification();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Test alert scheduled...")),
                    );
                  },
                ),
              ],
              height: 72,
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
                  FontAwesomeIcons.whatsapp,
                  "WhatsApp Support",
                  "Direct dev chat",
                  textColor,
                  subTextColor,
                  onTap: _launchWhatsApp,
                ),
              ],
              height: 216,
              isDark: isDark,
            ),

            const SizedBox(height: 32),

            _buildSectionHeader("DANGER ZONE", Colors.red.withOpacity(0.7)),
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
          color: const Color(0xFFAC5DED).withOpacity(0.1),
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
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 10, color: subTextColor),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: subTextColor.withOpacity(0.3),
        size: 18,
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
              ? Colors.white.withOpacity(0.05)
              : Colors.white.withOpacity(0.2),
          isDark
              ? Colors.white.withOpacity(0.02)
              : Colors.white.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.1), Colors.transparent],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: tiles,
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
                ThemeMode.light,
                Icons.light_mode_rounded,
                "Light",
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
                  : textColor.withOpacity(0.1),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : textColor.withOpacity(0.5),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : textColor.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

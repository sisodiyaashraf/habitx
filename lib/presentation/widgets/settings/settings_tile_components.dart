import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class SettingsSectionHeader extends StatelessWidget {
  final String title;
  final Color subTextColor;

  const SettingsSectionHeader({
    super.key,
    required this.title,
    required this.subTextColor,
  });

  @override
  Widget build(BuildContext context) {
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
}

class SettingsGroup extends StatelessWidget {
  final List<Widget> tiles;
  final double height;
  final bool isDark;

  const SettingsGroup({
    super.key,
    required this.tiles,
    required this.height,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
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
}

class SettingsTile extends StatelessWidget {
  final dynamic icon;
  final String title;
  final String subtitle;
  final Color textColor;
  final Color subTextColor;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.textColor,
    required this.subTextColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFAC5DED).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: icon is IconData
            ? Icon(
                icon,
                color: title.contains("Reset")
                    ? Colors.redAccent
                    : const Color(0xFFAC5DED),
                size: 18,
              )
            : FaIcon(
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
}

class SwitchSettingsTile extends StatelessWidget {
  final dynamic icon;
  final String title;
  final String subtitle;
  final bool value;
  final Color textColor;
  final Color subTextColor;
  final ValueChanged<bool> onChanged;

  const SwitchSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.textColor,
    required this.subTextColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFAC5DED).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: icon is IconData
            ? Icon(icon, color: const Color(0xFFAC5DED), size: 18)
            : FaIcon(icon, color: const Color(0xFFAC5DED), size: 16),
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
}

class ThemeSelector extends StatelessWidget {
  final Color textColor;
  final Color subTextColor;

  const ThemeSelector({
    super.key,
    required this.textColor,
    required this.subTextColor,
  });

  @override
  Widget build(BuildContext context) {
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
                color: isSelected
                    ? Colors.white
                    : textColor.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Colors.white
                      : textColor.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

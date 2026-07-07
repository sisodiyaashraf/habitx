import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:habitx/presentation/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import '../../data/services/notifications/habit_x_notification_service.dart';
import '../../providers/habit_provider.dart';
import '../../core/constants/notification_messages.dart';
import '../widgets/shared/animated_level_avatar.dart';
import '../widgets/shared/glass_background.dart';
import 'onboarding_screen.dart'; // <--- IMPORTANT: Add this import

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
          padding: const EdgeInsets.fromLTRB(20, 120, 20, 110),
          child: Column(
            children: [
              _buildLevelAvatar(provider),
              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FittedBox(
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
              ),
              Text(
                "Elite Habit Builder",
                style: TextStyle(
                  color: subTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              _buildSectionHeader("PERSONALIZATION", subTextColor),
              _buildSettingsGroup([
                _settingsTile(
                  Icons.person_outline_rounded,
                  "Edit Identity",
                  "Name: ${provider.userName}, Age: ${provider.userAge}",
                  textColor,
                  subTextColor,
                  onTap: () => _showIdentityDialog(context, provider),
                ),
                _settingsTile(
                  Icons.psychology_outlined,
                  "Persona",
                  "Style: ${provider.userPersona}",
                  textColor,
                  subTextColor,
                  onTap: () => _showPersonaDialog(context, provider),
                ),
                _settingsTile(
                  Icons.notifications_active_rounded,
                  "Reminders",
                  "Configure daily alerts",
                  textColor,
                  subTextColor,
                  onTap: () => _showNotificationSettingsDialog(context),
                ),
              ], isDark),

              const SizedBox(height: 32),

              _buildSectionHeader("PREFERENCES", subTextColor),
              _buildSettingsGroup([
                _settingsSwitchTile(
                  Icons.vibration_rounded,
                  "Haptic Feedback",
                  "Vibrate on habit completion",
                  provider.isHapticsEnabled,
                  textColor,
                  subTextColor,
                  onChanged: (val) {
                    context.read<HabitProvider>().toggleHaptics(val);
                  },
                ),
              ], isDark),

              const SizedBox(height: 40),
              _buildLogoutButton(context, provider),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationSettingsDialog(BuildContext context) {
    final notificationService = context.read<HabitXNotificationService>();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
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
                                    activeColor: const Color(0xFF00E5FF),
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
        },
      ),
    );
  }

  void _showIdentityDialog(BuildContext context, HabitProvider provider) {
    final TextEditingController nameController = TextEditingController(
      text: provider.userName,
    );
    final TextEditingController ageController = TextEditingController(
      text: provider.userAge.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
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
                        Text(
                          "UPDATE IDENTITY",
                          style: TextStyle(
                            color: dialogTextColor,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Material(
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 6.0),
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                child: TextField(
                                  controller: nameController,
                                  style: TextStyle(
                                    color: dialogTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(
                                      Icons.person_rounded,
                                      color: const Color(0xFFAC5DED).withValues(alpha: 0.8),
                                    ),
                                    hintText: "Name",
                                    hintStyle: TextStyle(
                                      color: dialogSubTextColor.withValues(alpha: 0.4),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 6.0),
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                child: TextField(
                                  controller: ageController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  style: TextStyle(
                                    color: dialogTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(
                                      Icons.cake_rounded,
                                      color: const Color(0xFFAC5DED).withValues(alpha: 0.8),
                                    ),
                                    hintText: "Age",
                                    hintStyle: TextStyle(
                                      color: dialogSubTextColor.withValues(alpha: 0.4),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "CANCEL",
                                style: TextStyle(color: dialogSubTextColor),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFAC5DED),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                if (nameController.text.isNotEmpty &&
                                    ageController.text.isNotEmpty) {
                                  provider.setupUser(
                                    name: nameController.text,
                                    age: int.tryParse(ageController.text) ?? 18,
                                    persona: provider.userPersona,
                                  );
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text(
                                "UPDATE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPersonaDialog(BuildContext context, HabitProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final dialogTextColor = isDark ? Colors.white : Colors.black;
        final dialogSubTextColor = isDark ? Colors.white70 : Colors.black54;

        return Center(
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
                        "CHOOSE PERSONA",
                        style: TextStyle(
                          color: dialogTextColor,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildPersonaBtn(context, provider, "Professional", dialogTextColor),
                      _buildPersonaBtn(context, provider, "GenZ", dialogTextColor),
                      _buildPersonaBtn(context, provider, "SHELBY AI", dialogTextColor),
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
        );
      },
    );
  }

  Widget _buildPersonaBtn(
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

  void _showLogoutDialog(BuildContext context, HabitProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final dialogTextColor = isDark ? Colors.white : Colors.black;
        final dialogSubTextColor = isDark ? Colors.white70 : Colors.black54;

        return Center(
          child: Material(
            color: Colors.transparent,
            child: GlassmorphicContainer(
              width: MediaQuery.of(context).size.width * 0.85,
              height: 220,
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
                colors: [Colors.redAccent, Colors.white24],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.redAccent,
                      size: 40,
                    ),
                    Text(
                      "FACTORY RESET",
                      style: TextStyle(
                        color: dialogTextColor,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "This will wipe your identity. Are you sure?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: dialogSubTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "CANCEL",
                            style: TextStyle(color: dialogSubTextColor),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () async {
                            await provider.resetUserIdentity();

                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const OnboardingScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                          child: const Text(
                            "LOG OUT",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLevelAvatar(HabitProvider provider) {
    return AnimatedLevelAvatar(provider: provider);
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> tiles, bool isDark) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: (tiles.length * 72).toDouble(),
      borderRadius: 25,
      blur: 20,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        colors: [
          isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.2),
          isDark
              ? Colors.white.withValues(alpha: 0.02)
              : Colors.white.withValues(alpha: 0.1),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.2),
          Colors.transparent,
        ],
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

  Widget _settingsTile(
    IconData icon,
    String title,
    String subtitle,
    Color textColor,
    Color subTextColor, {
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: const Color(0xFFAC5DED)),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: textColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12, color: subTextColor),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: subTextColor.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _settingsSwitchTile(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    Color textColor,
    Color subTextColor, {
    required ValueChanged<bool> onChanged,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFAC5DED)),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: textColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12, color: subTextColor),
        ),
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeThumbColor: const Color(0xFFAC5DED),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, HabitProvider provider) {
    return TextButton(
      onPressed: () =>
          _showLogoutDialog(context, provider), // Triggers the wipe logic
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

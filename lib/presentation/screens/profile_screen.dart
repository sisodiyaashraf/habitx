import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:habitx/presentation/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import '../../data/services/notification_master.dart';
import '../../providers/habit_provider.dart';
import '../widgets/shared/AnimatedLevelAvatar.dart';
import '../widgets/shared/glass_background.dart';
import 'onboarding_screen.dart'; // <--- IMPORTANT: Add this import

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _dailyRemindersEnabled = true;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "PROFILE",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // NEW: Settings Icon in the top right
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_rounded,
              color: Colors.black,
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

              Text(
                provider.userName.toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const Text(
                "Elite Habit Builder",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              _buildSectionHeader("PERSONALIZATION"),
              _buildSettingsGroup([
                _settingsTile(
                  Icons.person_outline_rounded,
                  "Edit Name",
                  "Change how we call you",
                  onTap: () => _showRenameDialog(context, provider),
                ),
                _settingsTile(
                  Icons.notifications_active_rounded,
                  "Reminders",
                  "Configure daily alerts",
                  onTap: () => _showNotificationSettingsDialog(context),
                ),
              ]),

              const SizedBox(height: 32),

              _buildSectionHeader("PREFERENCES"),
              _buildSettingsGroup([
                // Keeping Haptics as the core preference
                _settingsSwitchTile(
                  Icons.vibration_rounded,
                  "Haptic Feedback",
                  "Vibrate on habit completion",
                  provider.isHapticsEnabled,
                  onChanged: (val) {
                    context.read<HabitProvider>().toggleHaptics(val);
                  },
                ),
              ]),

              const SizedBox(height: 40),
              _buildLogoutButton(context, provider),
            ],
          ),
        ),
      ),
    );
  }

  // --- Dialogs ---
  void _showNotificationSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return Center(
            child: SingleChildScrollView(
              child: GlassmorphicContainer(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 280, // Slightly increased to prevent text overflow
                borderRadius: 30,
                blur: 20,
                alignment: Alignment.center,
                border: 2,
                linearGradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                borderGradient: const LinearGradient(
                  colors: [Color(0xFFAC5DED), Colors.white24],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(
                        Icons.notifications_active_rounded,
                        color: Color(0xFFAC5DED),
                        size: 40,
                      ),
                      const Text(
                        "DAILY MOTIVATION",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        "Receive high-performance reminders daily to keep you on track.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: SwitchListTile.adaptive(
                          title: const Text(
                            "Enable Alerts",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          value: _dailyRemindersEnabled,
                          activeColor: const Color(0xFFAC5DED),
                          onChanged: (val) {
                            setStateDialog(() => _dailyRemindersEnabled = val);
                            setState(() => _dailyRemindersEnabled = val);

                            if (val) {
                              // NEW: Calling the trigger from HabitXNotificationManager
                              HabitXNotificationManager()
                                  .triggerDailyMotivation();
                            } else {
                              // Add logic here if you want to clear specific channels
                            }
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "CLOSE",
                          style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showRenameDialog(BuildContext context, HabitProvider provider) {
    final TextEditingController nameController = TextEditingController(
      text: provider.userName,
    );

    showDialog(
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: GlassmorphicContainer(
            width: MediaQuery.of(context).size.width * 0.85,
            height: 240,
            borderRadius: 30,
            blur: 20,
            alignment: Alignment.center,
            border: 2,
            linearGradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.1),
              ],
            ),
            borderGradient: const LinearGradient(
              colors: [Color(0xFFAC5DED), Colors.white24],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "RENAME IDENTITY",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      fontSize: 12,
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: TextField(
                      controller: nameController,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter name...",
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "CANCEL",
                          style: TextStyle(color: Colors.black45),
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
                          if (nameController.text.isNotEmpty) {
                            provider.updateName(nameController.text);
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
    );
  }

  // NEW: Logout / Reset Confirmation Dialog
  void _showLogoutDialog(BuildContext context, HabitProvider provider) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: GlassmorphicContainer(
          width: MediaQuery.of(context).size.width * 0.85,
          height: 220,
          borderRadius: 30,
          blur: 20,
          alignment: Alignment.center,
          border: 2,
          linearGradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.2),
              Colors.white.withOpacity(0.1),
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
                const Text(
                  "FACTORY RESET",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    fontSize: 14,
                  ),
                ),
                const Text(
                  "This will wipe your identity. Are you sure?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "CANCEL",
                        style: TextStyle(color: Colors.black45),
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
                        // 1. Wipe Data in Provider
                        await provider.resetUserIdentity();

                        // 2. Restart App to Onboarding
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OnboardingScreen(),
                            ),
                            (route) =>
                                false, // Clears the entire navigation stack
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
  }

  // --- Building Blocks ---
  Widget _buildLevelAvatar(HabitProvider provider) {
    return AnimatedLevelAvatar(provider: provider);
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black45,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> tiles) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: (tiles.length * 72).toDouble(),
      borderRadius: 25,
      blur: 20,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
      ),
      borderGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.2), Colors.transparent],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: tiles,
      ),
    );
  }

  Widget _settingsTile(
    IconData icon,
    String title,
    String subtitle, {
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: const Color(0xFFAC5DED)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.black45),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Colors.black26,
        ),
      ),
    );
  }

  Widget _settingsSwitchTile(
    IconData icon,
    String title,
    String subtitle,
    bool value, {
    required ValueChanged<bool> onChanged,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFAC5DED)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.black45),
        ),
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFAC5DED),
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

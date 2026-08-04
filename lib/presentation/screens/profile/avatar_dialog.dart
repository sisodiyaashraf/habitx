import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import '../../../providers/habit_provider.dart';
import '../../../core/constants/avatar_constants.dart';

class AvatarDialog extends StatelessWidget {
  const AvatarDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogTextColor = isDark ? Colors.white : Colors.black;
    final dialogSubTextColor = isDark ? Colors.white70 : Colors.black54;

    final presets = AvatarConstants.allAvatars;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: GlassmorphicContainer(
          width: MediaQuery.of(context).size.width * 0.85,
          height: 480,
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
            child: Column(
              children: [
                Text(
                  "SELECT AVATAR PRESET",
                  style: TextStyle(
                    color: dialogTextColor,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: presets.length,
                    itemBuilder: (context, index) {
                      final item = presets[index];
                      final name = item.name;
                      final displayName = item.displayName;
                      final desc = item.desc;
                      final path = item.path;
                      final isSelected = provider.userAvatar == name ||
                          (provider.userAvatar == "Neon Runner" && name == "fox.svg") ||
                          (provider.userAvatar == "Cyborg Sentinel" && name == "bear.svg") ||
                          (provider.userAvatar == "Zen Architect" && name == "panda.svg") ||
                          (provider.userAvatar == "Data Scribe" && name == "penguin.svg") ||
                          (provider.userAvatar == "Solar Pioneer" && name == "lion.svg") ||
                          (provider.userAvatar == "Quantum Druid" && name == "cat.svg");

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              provider.updateAvatar(name);
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
                                    Container(
                                      width: 44,
                                      height: 44,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: isSelected ? Colors.white.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                                        shape: BoxShape.circle,
                                      ),
                                      child: ClipOval(
                                        child: SvgPicture.asset(
                                          path,
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            displayName,
                                            style: TextStyle(
                                              color: isSelected ? Colors.white : dialogTextColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            desc,
                                            style: TextStyle(
                                              color: isSelected ? Colors.white70 : dialogSubTextColor.withValues(alpha: 0.6),
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
                    },
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "CANCEL",
                    style: TextStyle(color: dialogSubTextColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

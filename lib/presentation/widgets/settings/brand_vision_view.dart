import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../shared/glass_background.dart';

class BrandVisionView extends StatelessWidget {
  const BrandVisionView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GlassBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.rocket,
                color: Color(0xFFAC5DED),
                size: 60,
              ),
              const SizedBox(height: 30),
              Text(
                "SHALCONTECH\nSTUDIO",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "ENGINEERING ELITE HABITS",
                style: TextStyle(
                  color: const Color(0xFFAC5DED),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Shalcontech Studio is a boutique development lab dedicated to building tools for high-performers. We believe that privacy is a right, and focus is a superpower.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor.withOpacity(0.7),
                  fontSize: 14,
                  height: 1.8,
                ),
              ),
              const SizedBox(height: 40),
              _buildCoreValue(
                "100% Serverless",
                FontAwesomeIcons.shieldHalved,
                textColor,
              ),
              _buildCoreValue(
                "Community Driven",
                FontAwesomeIcons.users,
                textColor,
              ),
              _buildCoreValue(
                "Elite Performance",
                FontAwesomeIcons.bolt,
                textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoreValue(String title, dynamic icon, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          FaIcon(icon, color: const Color(0xFFAC5DED), size: 16),
          const SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

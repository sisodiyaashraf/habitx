import 'package:flutter/material.dart';

class XpPopup extends StatelessWidget {
  final int xpAmount;
  const XpPopup({super.key, required this.xpAmount});

  static void show(BuildContext context, int xp) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.greenAccent[700],
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(blurRadius: 10, color: Colors.black26),
              ],
            ),
            child: Text(
              "+$xp XP EARNED! ✨",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Animated thinking dots for Shelby AI responses.
class ThinkingIndicator extends StatefulWidget {
  const ThinkingIndicator({super.key});

  @override
  State<ThinkingIndicator> createState() => _ThinkingIndicatorState();
}

class _ThinkingIndicatorState extends State<ThinkingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: -6).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    _startAnimations();
  }

  void _startAnimations() async {
    for (int i = 0; i < 3; i++) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      _controllers[i].repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animations[index].value),
              child: Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                decoration: const BoxDecoration(
                  color: Color(0xFFAC5DED),
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

/// Small Shelby AI avatar icon reused across chat rows.
class ShelbyAvatarIcon extends StatelessWidget {
  const ShelbyAvatarIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.only(bottom: 6.0),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFAC5DED).withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFAC5DED).withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: ClipOval(
        child: SvgPicture.asset(
          'assets/svg_icons/robot-svgrepo-com.svg',
          width: 24,
          height: 24,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/services/notifications/habit_x_notification_service.dart';
import '../../providers/habit_provider.dart';
import '../widgets/shared/glass_background.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  int _currentPage = 0;
  String _selectedPersona = "Professional";

  late AnimationController _glowController;
  late AnimationController _typingController;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "ESTABLISH DOMINANCE",
      "subtitle":
          "Stop drifting. Start executing. HabitX is your tactical interface for elite discipline.",
      "icon": FontAwesomeIcons.shieldHalved,
      "color": Color(0xFFAC5DED),
    },
    {
      "title": "NEURAL PROGRESSION",
      "subtitle":
          "Earn XP, level up, and unlock achievements as you conquer your daily objectives.",
      "icon": FontAwesomeIcons.bolt,
      "color": Color(0xFF00E5FF),
    },
    {
      "title": "SHELBY AI COACHING",
      "subtitle":
          "Receive strategic briefings and motivation tailored to your unique persona.",
      "icon": FontAwesomeIcons.brain,
      "color": Color(0xFFFFD700),
    },
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    // Listeners to update the "ACTIVATE CORE" button dynamically
    _nameController.addListener(() => setState(() {}));
    _ageController.addListener(() => setState(() {}));

    // 🚀 REQUEST PERMISSIONS ON LAUNCH
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HabitXNotificationService>().requestPermissions();
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    _typingController.dispose();
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutQuint,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GlassBackground(
        child: Stack(
          children: [
            // --- Background Neural Grid Effect ---
            Positioned.fill(child: _buildNeuralGrid()),

            Column(
              children: [
                const SizedBox(height: 60),
                _buildProgressBar(),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() {
                      _currentPage = index;
                      _typingController.reset();
                      _typingController.forward();
                    }),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      ..._onboardingData.map(
                        (data) => _buildFeatureSlide(data),
                      ),
                      _buildIdentityForm(),
                    ],
                  ),
                ),
                _buildBottomControls(),
                const SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNeuralGrid() {
    return Opacity(
      opacity: 0.1,
      child: CustomPaint(painter: GridPainter(color: const Color(0xFFAC5DED))),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: List.generate(4, (index) {
          bool isActive = index <= _currentPage;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                gradient: isActive
                    ? const LinearGradient(
                        colors: [Color(0xFFAC5DED), Color(0xFF7B61FF)],
                      )
                    : LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                borderRadius: BorderRadius.circular(3),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: const Color(0xFFAC5DED).withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFeatureSlide(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: _buildGlassCard(
            borderColor: data['color'],
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAnimatedIcon(data['icon'], data['color']),
                  const SizedBox(height: 30),
                  FadeTransition(
                    opacity: _typingController,
                    child: Text(
                      data['title'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _typingController,
                    child: Text(
                      data['subtitle'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 14,
                        fontFamily: 'monospace',
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(dynamic icon, Color color) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.15 * _glowController.value),
                blurRadius: 50,
                spreadRadius: 20,
              ),
            ],
            border: Border.all(color: color.withOpacity(0.2), width: 1.5),
          ),
          child: Center(child: FaIcon(icon, size: 60, color: color)),
        );
      },
    );
  }

  Widget _buildIdentityForm() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: _buildGlassCard(
          borderColor: const Color(0xFFAC5DED),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "NEURAL LINK",
                  style: TextStyle(
                    color: Color(0xFFAC5DED),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Configure Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 30),
                _buildInputLabel("USER_DESIGNATION"),
                _buildTextInput(_nameController, "ENTER NAME"),
                const SizedBox(height: 20),
                _buildInputLabel("USER_AGE"),
                _buildTextInput(_ageController, "ENTER AGE", isNumber: true),
                const SizedBox(height: 20),
                _buildInputLabel("TACTICAL_PERSONA"),
                _buildPersonaSelector(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 8),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFFAC5DED),
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput(
    TextEditingController controller,
    String hint, {
    bool isNumber = false,
  }) {
    return _buildGlassCard(
      borderColor: const Color(0xFFAC5DED),
      borderRadius: 16,
      blur: 20,
      child: SizedBox(
        height: 56,
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          inputFormatters: isNumber
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.2),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonaSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildPersonaOption("Professional", FontAwesomeIcons.userTie),
        ),
        const SizedBox(width: 15),
        Expanded(child: _buildPersonaOption("GenZ", FontAwesomeIcons.bolt)),
      ],
    );
  }

  Widget _buildPersonaOption(String label, dynamic icon) {
    bool isSelected = _selectedPersona == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedPersona = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 100,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFAC5DED).withOpacity(0.15)
              : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFAC5DED)
                : Colors.white.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFAC5DED).withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              color: isSelected ? const Color(0xFFAC5DED) : Colors.white24,
              size: 24,
            ),
            const SizedBox(height: 10),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white38,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: _currentPage == 3 ? _buildStartButton() : _buildNextButton(),
    );
  }

  Widget _buildNextButton() {
    return GestureDetector(
      onTap: _nextPage,
      child: _buildGlassCard(
        borderColor: const Color(0xFFAC5DED),
        borderRadius: 16,
        blur: 15,
        child: Container(
          width: double.infinity,
          height: 56,
          alignment: Alignment.center,
          child: const Text(
            "CONTINUE PROTOCOL",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    bool isValid =
        _nameController.text.isNotEmpty && _ageController.text.isNotEmpty;
    return GestureDetector(
      onTap: () async {
        if (isValid) {
          HapticFeedback.heavyImpact();
          await context.read<HabitProvider>().setupUser(
            name: _nameController.text,
            age: int.tryParse(_ageController.text) ?? 18,
            persona: _selectedPersona,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Complete all neural fields to proceed."),
            ),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: isValid
                ? [const Color(0xFFAC5DED), const Color(0xFF7B61FF)]
                : [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.04),
                  ],
          ),
          border: Border.all(
            color: isValid ? Colors.transparent : Colors.white.withOpacity(0.1),
            width: 1.0,
          ),
          boxShadow: isValid
              ? [
                  BoxShadow(
                    color: const Color(0xFFAC5DED).withOpacity(0.4),
                    blurRadius: 25,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "ACTIVATE CORE",
              style: TextStyle(
                color: isValid ? Colors.white : Colors.white.withOpacity(0.2),
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.bolt_rounded,
              color: isValid
                  ? const Color(0xFF00E5FF)
                  : Colors.white.withOpacity(0.2),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassCard({
    required Widget child,
    required Color borderColor,
    double borderRadius = 30,
    double blur = 25,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor.withOpacity(0.3), width: 1.5),
          ),
          child: child,
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final Color color;
  GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.2)
      ..strokeWidth = 0.5;

    for (double i = 0; i <= size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i <= size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

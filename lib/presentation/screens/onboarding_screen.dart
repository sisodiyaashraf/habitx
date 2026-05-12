import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/services/notifications/habit_x_notification_service.dart';
import '../../providers/habit_provider.dart';
import '../widgets/shared/glass_background.dart';
import 'home_screen.dart';

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
      "subtitle": "Stop drifting. Start executing. HabitX is your tactical interface for elite discipline.",
      "icon": FontAwesomeIcons.shieldHalved,
      "color": Color(0xFFAC5DED),
    },
    {
      "title": "NEURAL PROGRESSION",
      "subtitle": "Earn XP, level up, and unlock achievements as you conquer your daily objectives.",
      "icon": FontAwesomeIcons.bolt,
      "color": Color(0xFF00E5FF),
    },
    {
      "title": "SHELBY AI COACHING",
      "subtitle": "Receive strategic briefings and motivation tailored to your unique persona.",
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
                      ..._onboardingData.map((data) => _buildFeatureSlide(data)),
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
      child: CustomPaint(
        painter: GridPainter(color: const Color(0xFFAC5DED)),
      ),
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
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isActive 
                  ? const Color(0xFFAC5DED) 
                  : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2),
                boxShadow: isActive ? [
                  BoxShadow(
                    color: const Color(0xFFAC5DED).withOpacity(0.5),
                    blurRadius: 10,
                  )
                ] : [],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFeatureSlide(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAnimatedIcon(data['icon'], data['color']),
          const SizedBox(height: 50),
          FadeTransition(
            opacity: _typingController,
            child: Text(
              data['title'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 20),
          FadeTransition(
            opacity: _typingController,
            child: Text(
              data['subtitle'],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
                fontFamily: 'monospace',
                height: 1.5,
              ),
            ),
          ),
        ],
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
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Center(
            child: FaIcon(icon, size: 60, color: color),
          ),
        );
      },
    );
  }

  Widget _buildIdentityForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
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
          const SizedBox(height: 12),
          const Text(
            "Configure Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 40),
          _buildInputLabel("USER_DESIGNATION"),
          _buildTextInput(_nameController, "ENTER NAME"),
          const SizedBox(height: 25),
          _buildInputLabel("USER_AGE"),
          _buildTextInput(_ageController, "ENTER AGE", isNumber: true),
          const SizedBox(height: 25),
          _buildInputLabel("TACTICAL_PERSONA"),
          _buildPersonaSelector(),
        ],
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

  Widget _buildTextInput(TextEditingController controller, String hint, {bool isNumber = false}) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 60,
      borderRadius: 20,
      blur: 20,
      alignment: Alignment.center,
      border: 1.0,
      linearGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)],
      ),
      borderGradient: LinearGradient(
        colors: [const Color(0xFFAC5DED).withOpacity(0.5), Colors.transparent],
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.1), fontSize: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPersonaSelector() {
    return Row(
      children: [
        Expanded(child: _buildPersonaOption("Professional", FontAwesomeIcons.userTie)),
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
          color: isSelected ? const Color(0xFFAC5DED).withOpacity(0.1) : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFAC5DED) : Colors.white.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, color: isSelected ? const Color(0xFFAC5DED) : Colors.white24, size: 24),
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
      child: _currentPage == 3 
        ? _buildStartButton()
        : _buildNextButton(),
    );
  }

  Widget _buildNextButton() {
    return GestureDetector(
      onTap: _nextPage,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFAC5DED).withOpacity(0.5)),
          color: const Color(0xFFAC5DED).withOpacity(0.05),
        ),
        alignment: Alignment.center,
        child: const Text(
          "CONTINUE PROTOCOL",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    bool isValid = _nameController.text.isNotEmpty && _ageController.text.isNotEmpty;
    return GestureDetector(
      onTap: () async {
        if (isValid) {
          HapticFeedback.heavyImpact();
          await context.read<HabitProvider>().setupUser(
            name: _nameController.text,
            age: int.tryParse(_ageController.text) ?? 18,
            persona: _selectedPersona,
          );
          // The HabitXApp home property uses context.select((HabitProvider p) => p.isNewUser)
          // which will re-trigger and show HomeScreen when setupUser calls notifyListeners().
          // But we can also push manually for safety.
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Complete all neural fields to proceed.")),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: isValid 
              ? [const Color(0xFFAC5DED), const Color(0xFF7B61FF)]
              : [Colors.white10, Colors.white10],
          ),
          boxShadow: isValid ? [
            BoxShadow(
              color: const Color(0xFFAC5DED).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ] : [],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "ACTIVATE CORE",
              style: TextStyle(
                color: isValid ? Colors.white : Colors.white24,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.bolt, color: isValid ? const Color(0xFF00E5FF) : Colors.white10, size: 20),
          ],
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

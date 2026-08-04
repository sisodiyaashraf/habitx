import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/services/notifications/habit_x_notification_service.dart';
import '../widgets/shared/glass_background.dart';
import 'onboarding/onboarding_glass_card.dart';
import 'onboarding/onboarding_feature_slide.dart';
import 'onboarding/onboarding_start_button.dart';
import 'onboarding/identity_onboarding_step.dart';
import 'onboarding/template_onboarding_step.dart';

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
  String _selectedGender = "Male";
  final Set<String> _selectedTemplateIds = {};
  bool _linkWaterVitamins = true;
  bool _linkReadPlanning = true;

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
    if (_currentPage == 3) {
      final isValid =
          _nameController.text.isNotEmpty && _ageController.text.isNotEmpty;
      if (!isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Complete all neural fields to proceed."),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
    }
    if (_currentPage < 4) {
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
                        (data) => OnboardingFeatureSlide(
                          data: data,
                          glowController: _glowController,
                          typingController: _typingController,
                        ),
                      ),
                      IdentityOnboardingStep(
                        nameController: _nameController,
                        ageController: _ageController,
                        selectedGender: _selectedGender,
                        onGenderChanged: (gender) {
                          setState(() => _selectedGender = gender);
                        },
                      ),
                      TemplateOnboardingStep(
                        selectedTemplateIds: _selectedTemplateIds,
                        onTemplateToggled: (templateId) {
                          setState(() {
                            if (_selectedTemplateIds.contains(templateId)) {
                              _selectedTemplateIds.remove(templateId);
                            } else {
                              _selectedTemplateIds.add(templateId);
                            }
                          });
                        },
                        linkWaterVitamins: _linkWaterVitamins,
                        onLinkWaterVitaminsChanged: (val) {
                          setState(() => _linkWaterVitamins = val ?? true);
                        },
                        linkReadPlanning: _linkReadPlanning,
                        onLinkReadPlanningChanged: (val) {
                          setState(() => _linkReadPlanning = val ?? true);
                        },
                      ),
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
        children: List.generate(5, (index) {
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
                          Colors.white.withValues(alpha: 0.1),
                          Colors.white.withValues(alpha: 0.1),
                        ],
                      ),
                borderRadius: BorderRadius.circular(3),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: const Color(0xFFAC5DED).withValues(alpha: 0.4),
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

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: _currentPage == 4
          ? OnboardingStartButton(
              nameController: _nameController,
              ageController: _ageController,
              selectedGender: _selectedGender,
              selectedTemplateIds: _selectedTemplateIds,
              linkWaterVitamins: _linkWaterVitamins,
              linkReadPlanning: _linkReadPlanning,
            )
          : _buildNextButton(),
    );
  }

  Widget _buildNextButton() {
    return GestureDetector(
      onTap: _nextPage,
      child: OnboardingGlassCard(
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
}

class GridPainter extends CustomPainter {
  final Color color;
  GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.2)
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import '../../../providers/habit_provider.dart';

class IdentityDialog extends StatefulWidget {
  const IdentityDialog({super.key});

  @override
  State<IdentityDialog> createState() => _IdentityDialogState();
}

class _IdentityDialogState extends State<IdentityDialog> {
  late final TextEditingController nameController;
  late final TextEditingController ageController;
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode ageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final provider = context.read<HabitProvider>();
    nameController = TextEditingController(text: provider.userName);
    ageController = TextEditingController(text: provider.userAge.toString());

    nameFocusNode.addListener(_onFocusChange);
    ageFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    nameFocusNode.dispose();
    ageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogTextColor = isDark ? Colors.white : Colors.black;
    final dialogSubTextColor = isDark ? Colors.white70 : Colors.black54;

    return StatefulBuilder(
      builder: (context, setStateDialog) {
        return Center(
          child: SingleChildScrollView(
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
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                  color: nameFocusNode.hasFocus
                                      ? const Color(0xFFAC5DED).withValues(alpha: 0.1)
                                      : Colors.white.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: nameFocusNode.hasFocus
                                        ? const Color(0xFFAC5DED)
                                        : Colors.white.withValues(alpha: 0.1),
                                    width: 1.5,
                                  ),
                                  boxShadow: nameFocusNode.hasFocus
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFFAC5DED).withValues(alpha: 0.3),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          )
                                        ]
                                      : [],
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person_rounded,
                                      color: nameFocusNode.hasFocus ? const Color(0xFFAC5DED) : dialogTextColor.withValues(alpha: 0.7),
                                      size: 24,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "USER NAME",
                                            style: TextStyle(
                                              color: nameFocusNode.hasFocus ? const Color(0xFFAC5DED) : dialogSubTextColor.withValues(alpha: 0.6),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          TextField(
                                            controller: nameController,
                                            focusNode: nameFocusNode,
                                            style: TextStyle(
                                              color: dialogTextColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 6.0),
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                  color: ageFocusNode.hasFocus
                                      ? const Color(0xFFAC5DED).withValues(alpha: 0.1)
                                      : Colors.white.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: ageFocusNode.hasFocus
                                        ? const Color(0xFFAC5DED)
                                        : Colors.white.withValues(alpha: 0.1),
                                    width: 1.5,
                                  ),
                                  boxShadow: ageFocusNode.hasFocus
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFFAC5DED).withValues(alpha: 0.3),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          )
                                        ]
                                      : [],
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.cake_rounded,
                                      color: ageFocusNode.hasFocus ? const Color(0xFFAC5DED) : dialogTextColor.withValues(alpha: 0.7),
                                      size: 24,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "USER AGE",
                                            style: TextStyle(
                                              color: ageFocusNode.hasFocus ? const Color(0xFFAC5DED) : dialogSubTextColor.withValues(alpha: 0.6),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          TextField(
                                            controller: ageController,
                                            focusNode: ageFocusNode,
                                            keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                            style: TextStyle(
                                              color: dialogTextColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
                              onPressed: () {
                                Navigator.pop(context);
                              },
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
                                    gender: provider.userGender,
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
}

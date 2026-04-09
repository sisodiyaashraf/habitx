import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PrivacyPolicyDialog extends StatelessWidget {
  const PrivacyPolicyDialog({super.key});

  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Privacy",
      barrierColor: Colors.black.withOpacity(0.9),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => const Center(
        child: SingleChildScrollView(child: PrivacyPolicyDialog()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const docColor = Color(0xFFFAFAFA);

    return Container(
      width: MediaQuery.of(context).size.width * 0.92,
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: docColor,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: Colors.black12, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // 1. SUBTLE BACKGROUND WATERMARK
          const Positioned(
            left: -40,
            top: 250,
            child: Opacity(
              opacity: 0.02,
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  "HABITX / INTERNAL / COMPLIANCE",
                  style: TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              24.0,
              40.0,
              24.0,
              24.0,
            ), // Optimized padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOfficialHeader(),
                const SizedBox(height: 12),
                const Text(
                  "VERSION: 2026.04.1.TX  |  HASH: 8A7F2D  |  STATUS: ACTIVE",
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.black54,
                    fontFamily: 'Courier',
                  ),
                ),
                const Divider(
                  thickness: 1.5,
                  color: Colors.black87,
                  height: 25,
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryBox(),
                        const SizedBox(height: 24),

                        _legalArticleHeader("ARTICLE I", "DATA SOVEREIGNTY"),
                        _legalSection(
                          "Section 1.01 | Local Execution",
                          "By utilizing HabitX, the User acknowledges that all progression telemetry and habit logs are strictly localized to the hardware. No data transmission to Shalcontech servers occurs.",
                        ),

                        _legalArticleHeader(
                          "ARTICLE II",
                          "ZERO TELEMETRY POLICY",
                        ),
                        _legalSection(
                          "Section 2.01 | Behavioral Tracking",
                          "Shalcontech enforces a hard-coded zero-telemetry environment. Behavioral profiling and usage aggregation are excluded from the binary core.",
                        ),

                        _legalArticleHeader("ARTICLE III", "SYSTEM SCHEDULING"),
                        _legalSection(
                          "Section 3.01 | Alert Logic",
                          "Routine notifications are dispatched via the local OS scheduling engine. External polling is not utilized for notification triggers.",
                        ),

                        const SizedBox(height: 20),
                        _buildDigitalStampAndAcceptance(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildAcknowledgeButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfficialHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "SHALCONTECH STUDIO / HABITX",
                style: TextStyle(
                  color: Color(0xFFAC5DED),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "PRIVACY PROTOCOL",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        const Opacity(
          opacity: 0.1,
          child: Icon(Icons.bolt_rounded, size: 40, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildSummaryBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.03),
        border: Border.all(color: Colors.black12),
      ),
      child: const Text(
        "EXECUTABLE SUMMARY: This software operates on a 100% telemetry-free model. All habit logs and identity settings are retained locally. No aggregation occurs.",
        style: TextStyle(
          color: Colors.black87,
          fontSize: 12,
          height: 1.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _legalArticleHeader(String article, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$article: $title",
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.black,
              fontSize: 13,
            ),
          ),
          const Divider(thickness: 1, color: Colors.black12),
        ],
      ),
    );
  }

  Widget _legalSection(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDigitalStampAndAcceptance() {
    return Row(
      children: [
        // FIXED: Using Flexible to prevent overflow
        Flexible(
          flex: 2,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Opacity(
                opacity: 0.1,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: FaIcon(FontAwesomeIcons.stamp, size: 50),
                ),
              ),
              Transform.rotate(
                angle: -0.15,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFAC5DED).withOpacity(0.6),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "HABITX / VERIFIED",
                    style: TextStyle(
                      color: Color(0xFFAC5DED),
                      fontWeight: FontWeight.w900,
                      fontSize: 9,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        // FIXED: Constraining the QR section
        Flexible(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "COMPLIANCE HASH",
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              QrImageView(
                data: "HabitX_Protocol_8A7F2D",
                size: 45,
                foregroundColor: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAcknowledgeButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.black, width: 2),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        onPressed: () => Navigator.pop(context),
        child: const Text(
          "ACKNOWLEDGE PROTOCOL",
          style: TextStyle(
            color: Colors.black,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}

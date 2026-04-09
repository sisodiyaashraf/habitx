import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TermsOfServiceDialog extends StatelessWidget {
  const TermsOfServiceDialog({super.key});

  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Terms",
      barrierColor: Colors.black.withOpacity(0.9),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => const Center(
        child: SingleChildScrollView(child: TermsOfServiceDialog()),
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
          // 1. BACKGROUND WATERMARK
          const Positioned(
            right: -30,
            top: 150,
            child: Opacity(
              opacity: 0.02,
              child: RotatedBox(
                quarterTurns: 1,
                child: Text(
                  "HABITX / TERMS / CORE-01",
                  style: TextStyle(
                    fontSize: 110,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOfficialHeader(),
                const SizedBox(height: 12),
                const Text(
                  "REF: TOS-2026-B  |  LICENSE: INDIVIDUAL_USE  |  STATUS: BINDING",
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
                        _legalArticleHeader(
                          "ARTICLE I",
                          "ACCEPTABLE UTILIZATION",
                        ),
                        _legalSection(
                          "1.01 | Purpose",
                          "The HabitX platform is licensed for personal growth and mission-based habit tracking. Commercial exploitation or unauthorized logic extraction is strictly prohibited.",
                        ),

                        _legalArticleHeader(
                          "ARTICLE II",
                          "VIRTUAL ASSETS & XP",
                        ),
                        _legalSection(
                          "2.01 | Asset Status",
                          "Experience Points (XP), Levels, and Achievement badges are virtual motivational markers. They possess zero monetary valuation and are non-transferable.",
                        ),

                        _legalArticleHeader(
                          "ARTICLE III",
                          "LIABILITY & CONTINUITY",
                        ),
                        _legalSection(
                          "3.01 | Data Persistence",
                          "User acknowledges that HabitX is a localized binary. Data loss due to system hardware failure or OS-level cache purging is the sole responsibility of the User.",
                        ),
                        _legalSection(
                          "3.02 | Health Disclaimer",
                          "Suggestions provided within the protocol are informational. Consult a medical professional before engaging in high-intensity habit modifications.",
                        ),

                        _legalArticleHeader(
                          "ARTICLE IV",
                          "PROTOCOL MODIFICATIONS",
                        ),
                        _legalSection(
                          "4.01 | Right to Update",
                          "Shalcontech Studio reserves the right to modify these Mission Protocols to align with new security patches or feature deployments.",
                        ),

                        const SizedBox(height: 20),
                        _buildLegalFooter(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildActionButtons(context),
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
                "SHALCONTECH STUDIO / LEGAL",
                style: TextStyle(
                  color: Color(0xFFAC5DED),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "MISSION PROTOCOLS",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Text(
                "End-User License Agreement & Terms of Service",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const Opacity(
          opacity: 0.1,
          child: Icon(Icons.description_rounded, size: 40, color: Colors.black),
        ),
      ],
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

  Widget _buildLegalFooter() {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "AUTHORIZED SIGNATORY",
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "SHALCONTECH STUDIO",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Flexible(
          flex: 1,
          child: QrImageView(
            data: "HabitX_TOS_CORE_2026",
            size: 45,
            foregroundColor: Colors.black.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "DECLINE",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 50,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black, width: 2),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                backgroundColor: Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "ACCEPT MISSION",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

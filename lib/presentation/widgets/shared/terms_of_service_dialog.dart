import 'package:flutter/material.dart';
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
                        _bodyText("Last updated: July 02, 2026"),
                        _bodyText("Please read these terms and conditions carefully before using Our Service."),
                        
                        _h2("Interpretation and Definitions"),
                        _h3("Interpretation"),
                        _bodyText(
                          "The words whose initial letters are capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.",
                        ),
                        _h3("Definitions"),
                        _bodyText("For the purposes of these Terms and Conditions:"),
                        _bulletPoint("Application", "means the software program provided by the Company downloaded by You on any electronic device, named habitx"),
                        _bulletPoint("Application Store", "means the digital distribution service operated and developed by Apple Inc. (Apple App Store) or Google Inc. (Google Play Store) in which the Application has been downloaded."),
                        _bulletPoint("Affiliate", "means an entity that controls, is controlled by, or is under common control with a party, where \"control\" means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority."),
                        _bulletPoint("Country", "refers to: Rajasthan, India"),
                        _bulletPoint("Company", "(referred to as either \"the Company\", \"We\", \"Us\" or \"Our\" in these Terms and Conditions) refers to habitx."),
                        _bulletPoint("Device", "means any device that can access the Service such as a computer, a cell phone or a digital tablet."),
                        _bulletPoint("Service", "refers to the Application."),
                        _bulletPoint(
                          "Terms and Conditions",
                          "(also referred to as \"Terms\") means these Terms and Conditions, including any documents expressly incorporated by reference, which govern Your access to and use of the Service and form the entire agreement between You and the Company regarding the Service. These Terms and Conditions have been created with the help of the Terms and Conditions Generator.",
                        ),
                        _bulletPoint(
                          "Third-Party Social Media Service",
                          "means any services or content (including data, information, products or services) provided by a third party that is displayed, included, made available, or linked to through the Service.",
                        ),
                        _bulletPoint("You", "means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable."),
                        
                        _h2("Acknowledgment"),
                        _bodyText(
                          "These are the Terms and Conditions governing the use of this Service and the agreement between You and the Company. These Terms and Conditions set out the rights and obligations of all users regarding the use of the Service.",
                        ),
                        _bodyText(
                          "Your access to and use of the Service is conditioned on Your acceptance of and compliance with these Terms and Conditions. These Terms and Conditions apply to all visitors, users and others who access or use the Service.",
                        ),
                        _bodyText(
                          "By accessing or using the Service You agree to be bound by these Terms and Conditions. If You disagree with any part of these Terms and Conditions then You may not access the Service.",
                        ),
                        _bodyText("You represent that you are over the age of 18. The Company does not permit those under 18 to use the Service."),
                        _bodyText(
                          "Your access to and use of the Service is also subject to Our Privacy Policy, which describes how We collect, use, and disclose personal information. Please read Our Privacy Policy carefully before using Our Service.",
                        ),
                        
                        _h2("Links to Other Websites"),
                        _bodyText(
                          "Our Service may contain links to third-party websites or services that are not owned or controlled by the Company.",
                        ),
                        _bodyText(
                          "The Company has no control over, and assumes no responsibility for, the content, privacy policies, or practices of any third-party websites or services. You further acknowledge and agree that the Company shall not be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with the use of or reliance on any such content, goods or services available on or through any such websites or services.",
                        ),
                        _bodyText(
                          "We strongly advise You to read the terms and conditions and privacy policies of any third-party websites or services that You visit.",
                        ),
                        _h3("Links from a Third-Party Social Media Service"),
                        _bodyText(
                          "The Service may display, include, make available, or link to content or services provided by a Third-Party Social Media Service. A Third-Party Social Media Service is not owned or controlled by the Company, and the Company does not endorse or assume responsibility for any Third-Party Social Media Service.",
                        ),
                        _bodyText(
                          "You acknowledge and agree that the Company shall not be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with Your access to or use of any Third-Party Social Media Service, including any content, goods, or services made available through them. Your use of any Third-Party Social Media Service is governed by that Third-Party Social Media Service's terms and privacy policies.",
                        ),
                        
                        _h2("Termination"),
                        _bodyText(
                          "We may terminate or suspend Your access immediately, without prior notice or liability, for any reason whatsoever, including without limitation if You breach these Terms and Conditions.",
                        ),
                        _bodyText("Upon termination, Your right to use the Service will cease immediately."),
                        
                        _h2("Limitation of Liability"),
                        _bodyText(
                          "Notwithstanding any damages that You might incur, the entire liability of the Company and any of its suppliers under any provision of these Terms and Your exclusive remedy for all of the foregoing shall be limited to the amount actually paid by You through the Service or 100 USD if You haven't purchased anything through the Service.",
                        ),
                        _bodyText(
                          "To the maximum extent permitted by applicable law, in no event shall the Company or its suppliers be liable for any special, incidental, indirect, or consequential damages whatsoever (including, but not limited to, damages for loss of profits, loss of data or other information, for business interruption, for personal injury, loss of privacy arising out of or in any way related to the use of or inability to use the Service, third-party software and/or third-party hardware used with the Service, or otherwise in connection with any provision of these Terms), even if the Company or any supplier has been advised of the possibility of such damages and even if the remedy fails of its essential purpose.",
                        ),
                        _bodyText(
                          "Some states do not allow the exclusion of implied warranties or limitation of liability for incidental or consequential damages, which means that some of the above limitations may not apply. In these states, each party's liability will be limited to the greatest extent permitted by law.",
                        ),
                        
                        _h2("\"AS IS\" and \"AS AVAILABLE\" Disclaimer"),
                        _bodyText(
                          "The Service is provided to You \"AS IS\" and \"AS AVAILABLE\" and with all faults and defects without warranty of any kind. To the maximum extent permitted under applicable law, the Company, on its own behalf and on behalf of its Affiliates and its and their respective licensors and service providers, expressly disclaims all warranties, whether express, implied, statutory or otherwise, with respect to the Service, including all implied warranties of merchantability, fitness for a particular purpose, title and non-infringement, and warranties that may arise out of course of dealing, course of performance, usage or trade practice. Without limitation to the foregoing, the Company provides no warranty or undertaking, and makes no representation of any kind that the Service will meet Your requirements, achieve any intended results, be compatible or work with any other software, applications, systems or services, operate without interruption, meet any performance or reliability standards or be error free or that any errors or defects can or will be corrected.",
                        ),
                        _bodyText(
                          "Without limiting the foregoing, neither the Company nor any of the company's provider makes any representation or warranty of any kind, express or implied: (i) as to the operation or availability of the Service, or the information, content, and materials or products included thereon; (ii) that the Service will be uninterrupted or error-free; (iii) as to the accuracy, reliability, or currency of any information or content provided through the Service; or (iv) that the Service, its servers, the content, or e-mails sent from or on behalf of the Company are free of viruses, scripts, trojan horses, worms, malware, timebombs or other harmful components.",
                        ),
                        _bodyText(
                          "Some jurisdictions do not allow the exclusion of certain types of warranties or limitations on applicable statutory rights of a consumer, so some or all of the above exclusions and limitations may not apply to You. But in such a case the exclusions and limitations set forth in this section shall be applied to the greatest extent enforceable under applicable law.",
                        ),
                        
                        _h2("Governing Law"),
                        _bodyText(
                          "The laws of the Country, excluding its conflicts of law rules, shall govern these Terms and Your use of the Service. Your use of the Application may also be subject to other local, state, national, or international laws.",
                        ),
                        
                        _h2("Disputes Resolution"),
                        _bodyText(
                          "If You have any concern or dispute about the Service, You agree to first try to resolve the dispute informally by contacting the Company.",
                        ),
                        
                        _h2("For European Union (EU) Users"),
                        _bodyText(
                          "If You are a European Union consumer, you will benefit from any mandatory provisions of the law of the country in which You are resident.",
                        ),
                        
                        _h2("United States Legal Compliance"),
                        _bodyText(
                          "You represent and warrant that (i) You are not located in a country that is subject to the United States government embargo, or that has been designated by the United States government as a \"terrorist supporting\" country, and (ii) You are not listed on any United States government list of prohibited or restricted parties.",
                        ),
                        
                        _h2("Severability and Waiver"),
                        _h3("Severability"),
                        _bodyText(
                          "If any provision of these Terms is held to be unenforceable or invalid, such provision will be changed and interpreted to accomplish the objectives of such provision to the greatest extent possible under applicable law and the remaining provisions will continue in full force and effect.",
                        ),
                        _h3("Waiver"),
                        _bodyText(
                          "Except as provided herein, the failure to exercise a right or to require performance of an obligation under these Terms shall not affect a party's ability to exercise such right or require such performance at any time thereafter nor shall the waiver of a breach constitute a waiver of any subsequent breach.",
                        ),
                        
                        _h2("Translation Interpretation"),
                        _bodyText(
                          "These Terms and Conditions may have been translated if We have made them available to You on our Service. You agree that the original English text shall prevail in the case of a dispute.",
                        ),
                        
                        _h2("Changes to These Terms and Conditions"),
                        _bodyText(
                          "We reserve the right, at Our sole discretion, to modify or replace these Terms at any time. If a revision is material We will make reasonable efforts to provide at least 30 days' notice prior to any new terms taking effect. What constitutes a material change will be determined at Our sole discretion.",
                        ),
                        _bodyText(
                          "By continuing to access or use Our Service after those revisions become effective, You agree to be bound by the revised terms. If You do not agree to the new terms, in whole or in part, please stop using the Service.",
                        ),
                        
                        _h2("Contact Us"),
                        _bodyText("If you have any questions about these Terms and Conditions, You can contact us:"),
                        _bulletPoint("By email", "ashrafsisodiya478@gmail.com"),
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

  Widget _h2(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          color: Colors.black,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _h3(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _bodyText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 11,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _bulletPoint(String boldText, String normalText) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 11, height: 1.5),
                children: [
                  TextSpan(
                    text: "$boldText: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: normalText),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

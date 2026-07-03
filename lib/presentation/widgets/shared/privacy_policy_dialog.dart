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
      barrierColor: Colors.black.withValues(alpha: 0.9),
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
            color: Colors.black.withValues(alpha: 0.4),
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
                        _bodyText("Last updated: July 02, 2026"),
                        _bodyText(
                          "This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.",
                        ),
                        _bodyText(
                          "We use Your Personal Data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy. This Privacy Policy has been created with the help of the TermsFeed Privacy Policy Generator.",
                        ),
                        
                        _h2("Interpretation and Definitions"),
                        _h3("Interpretation"),
                        _bodyText(
                          "The words whose initial letters are capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.",
                        ),
                        _h3("Definitions"),
                        _bodyText("For the purposes of this Privacy Policy:"),
                        _bulletPoint("Account", "means a unique account created for You to access our Service or parts of our Service."),
                        _bulletPoint("Affiliate", "means an entity that controls, is controlled by, or is under common control with a party, where \"control\" means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority."),
                        _bulletPoint("Application", "refers to habitx, the software program provided by the Company."),
                        _bulletPoint("Company", "(referred to as either \"the Company\", \"We\", \"Us\" or \"Our\" in this Privacy Policy) refers to habitx."),
                        _bulletPoint("Country", "refers to: Rajasthan, India"),
                        _bulletPoint("Device", "means any device that can access the Service such as a computer, a cell phone or a digital tablet."),
                        _bulletPoint("Personal Data", "is any information that relates to an identified or identifiable individual. We use \"Personal Data\" and \"Personal Information\" interchangeably unless a law uses a specific term."),
                        _bulletPoint("Service", "refers to the Application."),
                        _bulletPoint("Service Provider", "means any natural or legal person who processes the data on behalf of the Company. It refers to third-party companies or individuals employed by the Company to facilitate the Service, to provide the Service on behalf of the Company, to perform services related to the Service or to assist the Company in analyzing how the Service is used."),
                        _bulletPoint("Usage Data", "refers to data collected automatically, either generated by the use of the Service or from the Service infrastructure itself (for example, the duration of a page visit)."),
                        _bulletPoint("You", "means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable."),
                        
                        _h2("Collecting and Using Your Personal Data"),
                        _h3("Types of Data Collected"),
                        _h3("Personal Data"),
                        _bodyText(
                          "While using Our Service, We may ask You to provide Us with certain personally identifiable information that can be used to contact or identify You. Personally identifiable information may include, but is not limited to:",
                        ),
                        _h3("Usage Data"),
                        _bodyText("Usage Data is collected automatically when using the Service."),
                        _bodyText(
                          "Usage Data may include information such as Your Device's Internet Protocol address (e.g. IP address), browser type, browser version, the pages of our Service that You visit, the time and date of Your visit, the time spent on those pages, unique device identifiers and other diagnostic data.",
                        ),
                        _bodyText(
                          "When You access the Service by or through a mobile device, We may collect certain information automatically, including, but not limited to, the type of mobile device You use, Your mobile device's unique ID, the IP address of Your mobile device, Your mobile operating system, the type of mobile Internet browser You use, unique device identifiers and other diagnostic data.",
                        ),
                        _bodyText(
                          "We may also collect information that Your browser sends whenever You visit Our Service or when You access the Service by or through a mobile device.",
                        ),
                        
                        _h3("Use of Your Personal Data"),
                        _bodyText("The Company may use Personal Data for the following purposes:"),
                        _bulletPoint("To provide and maintain our Service", "including to monitor the usage of our Service."),
                        _bulletPoint("To manage Your Account", "to manage Your registration as a user of the Service. The Personal Data You provide can give You access to different functionalities of the Service that are available to You as a registered user."),
                        _bulletPoint("For the performance of a contract", "the development, compliance and undertaking of the purchase contract for the products, items or services You have purchased or of any other contract with Us through the Service."),
                        _bulletPoint("To contact You", "To contact You by email, telephone calls, SMS, or other equivalent forms of electronic communication, such as a mobile application's push notifications regarding updates or informative communications related to the functionalities, products or contracted services, including the security updates, when necessary or reasonable for their implementation."),
                        _bulletPoint("To provide You", "with news, special offers, and general information about other goods, services and events which We offer that are similar to those that you have already purchased or inquired about unless You have opted not to receive such information."),
                        _bulletPoint("To manage Your requests", "To attend and manage Your requests to Us."),
                        _bulletPoint("For business transfers", "We may use Your Personal Data to evaluate or conduct a merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of some or all of Our assets, whether as a going concern or as part of bankruptcy, liquidation, or similar proceeding, in which Personal Data held by Us about our Service users is among the assets transferred."),
                        _bulletPoint("For other purposes", "We may use Your information for other purposes, such as data analysis, identifying usage trends, determining the effectiveness of our promotional campaigns and to evaluate and improve our Service, products, services, marketing and your experience."),
                        
                        _bodyText("We may share Your Personal Data in the following situations:"),
                        _bulletPoint("With Service Providers", "We may share Your Personal Data with Service Providers to monitor and analyze the use of our Service, to contact You."),
                        _bulletPoint("For business transfers", "We may share or transfer Your Personal Data in connection with, or during negotiations of, any merger, sale of Company assets, financing, or acquisition of all or a portion of Our business to another company."),
                        _bulletPoint("With Affiliates", "We may share Your Personal Data with Our affiliates, in which case we will require those affiliates to honor this Privacy Policy. Affiliates include Our parent company and any other subsidiaries, joint venture partners or other companies that We control or that are under common control with Us."),
                        _bulletPoint("With business partners", "We may share Your Personal Data with Our business partners to offer You certain products, services or promotions."),
                        _bulletPoint("With other users", "If Our Service offers public areas, when You share Personal Data or otherwise interact in the public areas with other users, such information may be viewed by all users and may be publicly distributed outside."),
                        _bulletPoint("With Your consent", "We may disclose Your Personal Data for any other purpose with Your consent."),
                        
                        _h3("Retention of Your Personal Data"),
                        _bodyText(
                          "The Company will retain Your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy. We will retain and use Your Personal Data to the extent necessary to comply with our legal obligations (for example, if We are required to retain Your data to comply with applicable laws), resolve disputes, and enforce our legal agreements and policies.",
                        ),
                        _bodyText(
                          "Where possible, We apply shorter retention periods and/or reduce identifiability by deleting, aggregating, or anonymizing data. Unless otherwise stated, the retention periods below are maximum periods (\"up to\") and We may delete or anonymize data sooner when it is no longer needed for the relevant purpose. We apply different retention periods to different categories of Personal Data based on the purpose of processing and legal obligations:",
                        ),
                        _bulletPoint("Account Information", "User Accounts: retained for the duration of your account relationship plus up to 24 months after account closure to handle any post-termination issues or resolve disputes."),
                        _bulletPoint("Usage Data - Application usage statistics", "up to 24 months to understand feature adoption and service improvements."),
                        _bulletPoint("Usage Data - Server logs (IP addresses, access times)", "up to 24 months for security monitoring and troubleshooting purposes."),
                        _bodyText(
                          "Usage Data is retained in accordance with the retention periods described above, and may be retained longer only where necessary for security, fraud prevention, or legal compliance.",
                        ),
                        _bodyText("We may retain Personal Data beyond the periods stated above for different reasons:"),
                        _bulletPoint("Legal obligation", "We are required by law to retain specific data (e.g., financial records for tax authorities)."),
                        _bulletPoint("Legal claims", "Data is necessary to establish, exercise, or defend legal claims."),
                        _bulletPoint("Your explicit request", "You ask Us to retain specific information."),
                        _bulletPoint("Technical limitations", "Data exists in backup systems that are scheduled for routine deletion."),
                        _bodyText("You may request information about how long We will retain Your Personal Data by contacting Us."),
                        _bodyText("When retention periods expire, We securely delete or anonymize Personal Data according to the following procedures:"),
                        _bulletPoint("Deletion", "Personal Data is removed from Our systems and no longer actively processed."),
                        _bulletPoint("Backup retention", "Residual copies may remain in encrypted backups for a limited period consistent with our backup retention schedule and are not restored except where necessary for security, disaster recovery, or legal compliance."),
                        _bulletPoint("Anonymization", "In some cases, We convert Personal Data into anonymous statistical data that cannot be linked back to You. This anonymized data may be retained indefinitely for research and analytics."),
                        
                        _h3("Transfer of Your Personal Data"),
                        _bodyText(
                          "Your information, including Personal Data, is processed at the Company's operating offices and in any other places where the parties involved in the processing are located. It means that this information may be transferred to — and maintained on — computers located outside of Your state, province, country or other governmental jurisdiction where the data protection laws may differ from those from Your jurisdiction.",
                        ),
                        _bodyText(
                          "Where required by applicable law, We will ensure that international transfers of Your Personal Data are subject to appropriate safeguards and supplementary measures where appropriate. The Company will take all steps reasonably necessary to ensure that Your data is treated securely and in accordance with this Privacy Policy and no transfer of Your Personal Data will take place to an organization or a country unless there are adequate controls in place including the security of Your data and other personal information.",
                        ),
                        
                        _h3("Delete Your Personal Data"),
                        _bodyText(
                          "You have the right to delete or request that We assist in deleting the Personal Data that We have collected about You.",
                        ),
                        _bodyText("Our Service may give You the ability to delete certain information about You from within the Service."),
                        _bodyText(
                          "You may update, amend, or delete Your information at any time by signing in to Your Account, if you have one, and visiting the account settings section that allows you to manage Your personal information. You may also contact Us to request access to, correct, or delete any Personal Data that You have provided to Us.",
                        ),
                        _bodyText(
                          "Please note, however, that We may need to retain certain information when we have a legal obligation or lawful basis to do so.",
                        ),
                        
                        _h3("Disclosure of Your Personal Data"),
                        _h3("Business Transactions"),
                        _bodyText(
                          "If the Company is involved in a merger, acquisition or asset sale, Your Personal Data may be transferred. We will provide notice before Your Personal Data is transferred and becomes subject to a different Privacy Policy.",
                        ),
                        _h3("Law enforcement"),
                        _bodyText(
                          "Under certain circumstances, the Company may be required to disclose Your Personal Data if required to do so by law or in response to valid requests by public authorities (e.g. a court or a government agency).",
                        ),
                        _h3("Other legal requirements"),
                        _bodyText("The Company may disclose Your Personal Data in the good faith belief that such action is necessary to:"),
                        _bulletPoint("Comply", "with a legal obligation"),
                        _bulletPoint("Protect", "and defend the rights or property of the Company"),
                        _bulletPoint("Prevent", "or investigate possible wrongdoing in connection with the Service"),
                        _bulletPoint("Protect", "the personal safety of Users of the Service or the public"),
                        _bulletPoint("Protect", "against legal liability"),
                        
                        _h3("Security of Your Personal Data"),
                        _bodyText(
                          "The security of Your Personal Data is important to Us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While We strive to use commercially reasonable means to protect Your Personal Data, We cannot guarantee its absolute security.",
                        ),
                        
                        _h2("Children's Privacy"),
                        _bodyText(
                          "Our Service does not address anyone under the age of 16. We do not knowingly collect personally identifiable information from anyone under the age of 16. If You are a parent or guardian and You are aware that Your child has provided Us with Personal Data, please contact Us. If We become aware that We have collected Personal Data from anyone under the age of 16 without verification of parental consent, We take steps to remove that information from Our servers.",
                        ),
                        _bodyText(
                          "If We need to rely on consent as a legal basis for processing Your information and Your country requires consent from a parent, We may require Your parent's consent before We collect and use that information.",
                        ),
                        
                        _h2("Links to Other Websites"),
                        _bodyText(
                          "Our Service may contain links to other websites that are not operated by Us. If You click on a third party link, You will be directed to that third party's site. We strongly advise You to review the Privacy Policy of every site You visit.",
                        ),
                        _bodyText(
                          "We have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services.",
                        ),
                        
                        _h2("Changes to this Privacy Policy"),
                        _bodyText("We may update Our Privacy Policy from time to time. We will notify You of any changes by posting the new Privacy Policy on this page."),
                        _bodyText(
                          "We will let You know via email and/or a prominent notice on Our Service, prior to the change becoming effective and update the \"Last updated\" date at the top of this Privacy Policy.",
                        ),
                        _bodyText(
                          "You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.",
                        ),
                        
                        _h2("Contact Us"),
                        _bodyText("If you have any questions about this Privacy Policy, You can contact us:"),
                        _bulletPoint("By email", "ashrafsisodiya478@gmail.com"),
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
        color: Colors.black.withValues(alpha: 0.03),
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
                      color: const Color(0xFFAC5DED).withValues(alpha: 0.6),
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
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Colors.black.withValues(alpha: 0.5),
                ),
                dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Colors.black.withValues(alpha: 0.5),
                ),
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

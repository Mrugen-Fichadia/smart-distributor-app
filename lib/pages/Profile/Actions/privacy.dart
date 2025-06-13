import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/common/utils/colors.dart';
import 'package:smart_distributor_app/pages/Profile/Actions/profile_actions_widgets.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            buildHeaderSection(
              'Privacy Policy',
              'Your privacy matters to us. Learn how we collect, use, and protect your personal information.',
              Icons.privacy_tip_rounded,
              context,
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  buildWelcomeCard(
                    context,
                    'Your Data Protection',
                    'This Privacy Policy explains how Ignito Corporation collects, uses, stores, and discloses your personal information when you use our Smart Distributor App for LPG distribution management.',
                    Icons.shield_rounded,
                  ),
                  const SizedBox(height: 24),
                  buildLastUpdatedSection('Effective Date', '10 June 2025'),
                  const SizedBox(height: 32),
                  _buildPrivacySection(),
                  const SizedBox(height: 32),
                  buildContactSection(
                    'Privacy Questions?',
                    'If you have any questions about this Privacy Policy or your data, please contact us:',
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection() {
    final List<Map<String, dynamic>> privacySections = [
      {
        'title': 'Information We Collect',
        'icon': Icons.data_usage_rounded,
        'content':
            'We collect personal information (name, phone, email), technical data (IP address, device info, usage logs), payment information (transaction IDs via Razorpay), and session cookies for login state and analytics.',
        'color': secondary,
      },
      {
        'title': 'How We Use Your Information',
        'icon': Icons.settings_applications_rounded,
        'content':
            'Your information is used to create and manage accounts, process payments and subscriptions, provide technical support, improve app performance and security, and comply with legal obligations.',
        'color': primary.withOpacity(0.7),
      },
      {
        'title': 'Legal Basis for Processing',
        'icon': Icons.gavel_rounded,
        'content':
            'We process your data based on contractual necessity for accounts and payments, legal obligations for compliance, legitimate interest in service improvement, and your consent for optional features.',
        'color': secondary,
      },
      {
        'title': 'Data Sharing & Disclosure',
        'icon': Icons.share_rounded,
        'content':
            'We do not sell or rent your data. We only share information with payment gateways (Razorpay) for transactions, legal authorities when required by Indian law, and internal staff under confidentiality.',
        'color': primary.withOpacity(0.8),
      },
      {
        'title': 'Data Security',
        'icon': Icons.security_rounded,
        'content':
            'We implement end-to-end encryption for sensitive data, secure servers with restricted access, and regular system audits. However, no system is completely secure, so users should follow good security practices.',
        'color': secondary,
      },
      {
        'title': 'Data Retention',
        'icon': Icons.storage_rounded,
        'content':
            'We retain your data as long as your account is active, as required by legal and regulatory standards, and until a verified deletion request is received and processed.',
        'color': primary.withOpacity(0.6),
      },
      {
        'title': 'Your Rights',
        'icon': Icons.account_balance_rounded,
        'content':
            'You have the right to access and update your personal data, request deletion of your data (subject to verification and law), withdraw consent for non-essential services, and contact us with concerns.',
        'color': secondary,
      },
      {
        'title': 'Children\'s Privacy',
        'icon': Icons.child_care_rounded,
        'content':
            'Our App is not designed for individuals under 18 years. We do not knowingly collect data from minors. If discovered, such data will be immediately deleted.',
        'color': primary.withOpacity(0.7),
      },
      {
        'title': 'Policy Changes',
        'icon': Icons.update_rounded,
        'content':
            'We may update this Privacy Policy occasionally. Changes will be communicated via app notifications or email. Continued use of the App means acceptance of the updated policy.',
        'color': secondary,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionHeader('Privacy Details', Icons.policy_rounded),
        const SizedBox(height: 24),
        ...privacySections.map((section) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: buildContentItem(
              section['title'],
              section['content'],
              section['icon'],
              section['color'],
            ),
          );
        }),
      ],
    );
  }
}

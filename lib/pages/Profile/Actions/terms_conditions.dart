import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/common/utils/colors.dart';
import 'package:smart_distributor_app/pages/Profile/Actions/profile_actions_widgets.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

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
          'Terms & Conditions',
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
              'Terms & Conditions',
              'Please read our terms and conditions carefully before using our services.',
              Icons.description_rounded,
              context,
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  buildWelcomeCard(
                    context,
                    'Agreement & Terms',
                    'By accessing and using the Smart Distributor App, you agree to be bound by these terms and conditions and all applicable laws and regulations.',
                    Icons.handshake_rounded,
                  ),
                  const SizedBox(height: 24),
                  buildLastUpdatedSection('Last Updated', 'December 2024'),
                  const SizedBox(height: 32),
                  _buildTermsSection(),
                  const SizedBox(height: 32),
                  buildContactSection(
                    'Questions?',
                    'If you have any questions about these Terms and Conditions, please contact us:',
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

  Widget _buildTermsSection() {
    final List<Map<String, dynamic>> termsSections = [
      {
        'title': 'Acceptance of Terms',
        'icon': Icons.check_circle_outline_rounded,
        'content':
            'By downloading, installing, or using the Smart Distributor App, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use our service.',
        'color': secondary,
      },
      {
        'title': 'Service Description',
        'icon': Icons.apps_rounded,
        'content':
            'Smart Distributor App is a business management platform designed for distributors, managers, and workers to streamline operations, manage inventory, track sales, and coordinate business activities efficiently.',
        'color': primary.withOpacity(0.7),
      },
      {
        'title': 'User Eligibility',
        'icon': Icons.person_outline_rounded,
        'content':
            'You must be at least 18 years old and have the legal capacity to enter into agreements. You are responsible for ensuring your use of the service complies with all applicable local, state, and national laws.',
        'color': secondary,
      },
      {
        'title': 'Account Registration',
        'icon': Icons.account_circle_outlined,
        'content':
            'You must provide accurate, current, and complete information during registration. You are responsible for maintaining the security of your account credentials and all activities that occur under your account.',
        'color': primary.withOpacity(0.8),
      },
      {
        'title': 'Subscription & Payment',
        'icon': Icons.payment_rounded,
        'content':
            'Premium features require a valid subscription. Payments are processed securely through our payment partners. Subscriptions automatically renew unless cancelled. Refunds are subject to our refund policy.',
        'color': secondary,
      },
      {
        'title': 'User Conduct',
        'icon': Icons.rule_rounded,
        'content':
            'Users must not engage in illegal activities, harassment, spam, or any behavior that violates others\' rights. We reserve the right to suspend or terminate accounts that violate these guidelines.',
        'color': primary.withOpacity(0.6),
      },
      {
        'title': 'Data & Privacy',
        'icon': Icons.security_rounded,
        'content':
            'We collect and process data as outlined in our Privacy Policy. Users retain ownership of their business data. We implement security measures to protect user information but cannot guarantee absolute security.',
        'color': secondary,
      },
      {
        'title': 'Intellectual Property',
        'icon': Icons.copyright_rounded,
        'content':
            'The app, its content, features, and functionality are owned by Ignito Corporation. Users may not copy, modify, distribute, or reverse engineer any part of the service without permission.',
        'color': primary.withOpacity(0.7),
      },
      {
        'title': 'Service Availability',
        'icon': Icons.cloud_outlined,
        'content':
            'We strive to maintain service availability but cannot guarantee uninterrupted access. We may perform maintenance, updates, or modifications that temporarily affect service availability.',
        'color': secondary,
      },
      {
        'title': 'Limitation of Liability',
        'icon': Icons.info_outline_rounded,
        'content':
            'Our liability is limited to the maximum extent permitted by law. We are not liable for indirect, incidental, or consequential damages arising from your use of the service.',
        'color': primary.withOpacity(0.8),
      },
      {
        'title': 'Termination',
        'icon': Icons.exit_to_app_rounded,
        'content':
            'Either party may terminate the agreement at any time. Upon termination, your access to the service will cease, and you must stop using the application. Data retention follows our Privacy Policy.',
        'color': secondary,
      },
      {
        'title': 'Governing Law',
        'icon': Icons.gavel_rounded,
        'content':
            'These terms are governed by the laws of India. Any disputes will be resolved through arbitration in Indore, Madhya Pradesh, India, in accordance with Indian arbitration laws.',
        'color': primary.withOpacity(0.6),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionHeader('Terms Details', Icons.article_rounded),
        const SizedBox(height: 24),
        ...termsSections.map((section) {
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

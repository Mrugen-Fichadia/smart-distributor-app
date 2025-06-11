import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/common/utils/colors.dart';
import 'package:smart_distributor_app/pages/Profile/Actions/profile_actions_widgets.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

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
          'About Us',
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
              'About Ignito Corporation',
              'Empowering Business with Digital Intelligence',
              Icons.business_rounded,
              context,
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  buildWelcomeCard(
                    context,
                    'Our Mission',
                    'Ignito Corporation is a pioneering IT solutions provider focused on empowering local businesses, distributors, and MSMEs through cutting-edge mobile and web technology.',
                    Icons.rocket_launch_rounded,
                  ),
                  const SizedBox(height: 24),
                  buildLastUpdatedSection('Founded', '2024'),
                  const SizedBox(height: 32),
                  _buildAboutSection(),
                  const SizedBox(height: 32),
                  _buildLeadershipSection(),
                  const SizedBox(height: 32),
                  buildContactSection(
                    'Get In Touch',
                    'Have questions or want a live demo? Contact us today:',
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

  Widget _buildAboutSection() {
    final List<Map<String, dynamic>> aboutSections = [
      {
        'title': 'Our Company',
        'icon': Icons.apartment_rounded,
        'content':
            'Founded as a sole proprietorship by Poonam Kale, we specialize in building practical, easy-to-use, and scalable digital tools tailored for the Indian market. We transform how businesses operate through intelligent and accessible digital solutions.',
        'color': secondary,
      },
      {
        'title': 'Smart Distributor App',
        'icon': Icons.mobile_screen_share_rounded,
        'content':
            'Our flagship product designed especially for LPG gas agencies and cylinder distributors. It simplifies your entire business workflow from stock and delivery management to hawker tracking, payment updates, and summary report generation.',
        'color': primary.withOpacity(0.7),
      },
      {
        'title': 'Key Features',
        'icon': Icons.star_rounded,
        'content':
            'Real-time cylinder stock tracking, digital customer and hawker management, secure delivery logs, automated PDF reports, clean UI with Hindi and English support, and flexible pricing options.',
        'color': secondary,
      },
      {
        'title': 'Industries We Serve',
        'icon': Icons.domain_rounded,
        'content':
            'We serve logistics & supply chain management, petroleum & energy distribution, retail & inventory businesses, dealer networks, warehousing operations, and service-based MSMEs across India.',
        'color': primary.withOpacity(0.8),
      },
      {
        'title': 'Our Solutions',
        'icon': Icons.build_rounded,
        'content':
            'We design digital tools to streamline workflows, automate operations, and enhance decision-making. Our solutions improve operational efficiency, reduce manual workload, and provide real-time business insights.',
        'color': secondary,
      },
      {
        'title': 'Target Audience',
        'icon': Icons.group_rounded,
        'content':
            'Our solutions are ideal for small businesses, logistics firms, distributors, and MSMEs looking to digitize and automate their operations with minimal technical knowledge required.',
        'color': primary.withOpacity(0.6),
      },
      {
        'title': 'Technology Approach',
        'icon': Icons.engineering_rounded,
        'content':
            'We combine innovation, simplicity, and scalability to help local distributors modernize their operations effectively. Our technology is affordable, intuitive, and results-driven for businesses of all sizes.',
        'color': secondary,
      },
      {
        'title': 'Multi-Sector Expertise',
        'icon': Icons.hub_rounded,
        'content':
            'Beyond LPG distribution, we develop smart, scalable software for MSMEs and large enterprises across multiple sectors including retail, warehouse management, and field operations.',
        'color': primary.withOpacity(0.7),
      },
      {
        'title': 'User Experience',
        'icon': Icons.verified_user_rounded,
        'content':
            'The app supports multiple access levels (owner, manager, worker) and is optimized for real-world delivery operations with clean, intuitive interfaces that require minimal training.',
        'color': secondary,
      },
      {
        'title': 'Business Growth',
        'icon': Icons.trending_up_rounded,
        'content':
            'Whether you\'re running a gas distribution agency, warehousing network, or multi-location retail operation, Ignito Corporation delivers scalable, secure, and user-friendly technology to help your business grow faster and smarter.',
        'color': primary.withOpacity(0.8),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionHeader('Company Overview', Icons.info_rounded),
        const SizedBox(height: 24),
        ...aboutSections.map((section) {
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

  Widget _buildLeadershipSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionHeader('Leadership', Icons.person_pin_rounded),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primary.withOpacity(0.85), secondary.withOpacity(0.9)],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_pin_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      'Chief Executive Officer',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.25),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Shrilaxmi Duddalwar',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Under her guidance, Ignito Corporation continues to build scalable and intelligent solutions for MSMEs and large enterprises across India. Our technology vision and leadership drive innovation in digital business solutions.',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.7,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

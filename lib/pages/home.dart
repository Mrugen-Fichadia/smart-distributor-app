import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'deliveries_screen.dart';
import 'customer_orders_screen.dart';
import 'new_delivery_screen.dart';
import 'add_load_screen.dart';
import 'enhanced_language_selection_screen.dart';
import 'package:smart_distributor_app/localized_text.dart';
import 'package:smart_distributor_app/language_controller.dart';
import 'package:smart_distributor_app/app_colours.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildWelcomeSection(),
              _buildQuickActions(),
              _buildStockSummary(),
              _buildRecentDeliveries(),
              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: AppColors.cardBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const LocalizedText(
            text: 'Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryMaroon,
              fontFamily: 'Poppins',
            ),
          ),
          Row(
            children: [
              GetX<LanguageController>(
                builder: (languageController) {
                  final languageInfo = languageController.getLanguageInfo(
                    languageController.currentLanguage,
                  );

                  return GestureDetector(
                    onTap: () {
                      Get.to(() => const EnhancedLanguageSelectionScreen(
                        isFromSettings: true,
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.offWhite,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.lightMaroon.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            languageInfo['flag']!,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            languageInfo['code']!.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryMaroon,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              Stack(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_outlined,
                      size: 28,
                      color: AppColors.darkGray,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.lightMaroon,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: AppColors.cardBackground,
      child: const LocalizedText(
        text: 'Welcome, John Doe!',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkGray,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LocalizedText(
            text: 'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryMaroon,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickActionItem(
                icon: Icons.local_shipping_outlined,
                label: 'New Delivery',
                color: AppColors.offWhite,
                iconColor: AppColors.primaryMaroon,
                onTap: () {
                  Get.to(() => const NewDeliveryScreen());
                },
              ),
              _buildQuickActionItem(
                icon: Icons.person_add_outlined,
                label: 'Add Customer',
                color: AppColors.offWhite,
                iconColor: AppColors.primaryMaroon,
                onTap: () {
                  Get.to(() => const CustomerOrdersScreen());
                },
              ),
              _buildQuickActionItem(
                icon: Icons.inventory_outlined,
                label: 'Add Stock',
                color: AppColors.offWhite,
                iconColor: AppColors.primaryMaroon,
                onTap: () {
                  Get.to(() => const AddLoadScreen());
                },
              ),
              _buildQuickActionItem(
                icon: Icons.add,
                label: 'More',
                color: AppColors.primaryMaroon,
                iconColor: Colors.white,
                isHighlighted: true,
                onTap: () {
                  _showMoreActionsBottomSheet();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
    bool isHighlighted = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: isHighlighted
                  ? [
                BoxShadow(
                  color: AppColors.primaryMaroon.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
                  : [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          LocalizedText(
            text: label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.darkGray,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const LocalizedText(
                text: 'Stock Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryMaroon,
                  fontFamily: 'Poppins',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const AddLoadScreen());
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.offWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.lightMaroon.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.add,
                        size: 16,
                        color: AppColors.primaryMaroon,
                      ),
                      const SizedBox(width: 4),
                      const LocalizedText(
                        text: 'Add Load',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryMaroon,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const LocalizedText(
            text: 'Available Cylinders',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.darkGray,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStockItem('230', '14.2 KG', AppColors.darkGray),
              _buildStockItem('75', '5 KG', AppColors.darkGray),
              _buildStockItem('30', '19 KG', AppColors.darkGray),
              _buildStockItem('230', 'Filled', AppColors.lightMaroon),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const LocalizedText(
                text: 'Capacity Utilization',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGray,
                  fontFamily: 'Poppins',
                ),
              ),
              const Text(
                '69%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightMaroon,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.69,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.lightMaroon),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }

  Widget _buildStockItem(String count, String type, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 4),
        LocalizedText(
          text: type,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.darkGray,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildRecentDeliveries() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const LocalizedText(
                text: 'Recent Deliveries',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryMaroon,
                  fontFamily: 'Poppins',
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => const DeliveriesScreen());
                },
                child: const LocalizedText(
                  text: 'View All',
                  style: TextStyle(
                    color: AppColors.lightMaroon,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDeliveryItem(
            name: 'Amit Patel',
            date: '12 Jan',
            cylinders: '1 cylinders',
            amount: '₹950',
            status: 'Pending',
            statusColor: Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildDeliveryItem(
            name: 'Street Food Corner',
            date: '11 Jan',
            cylinders: '2 cylinders',
            amount: '₹1,100',
            status: 'Unpaid',
            statusColor: AppColors.lightMaroon,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryItem({
    required String name,
    required String date,
    required String cylinders,
    required String amount,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGray,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$date • $cylinders',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.darkGray.withOpacity(0.7),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: LocalizedText(
                    text: status,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: statusColor,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const LocalizedText(
                text: 'Amount',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.darkGray,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryMaroon,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),
              Icon(
                Icons.chevron_right,
                color: AppColors.darkGray.withOpacity(0.5),
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Navigate to different screens based on index
          switch (index) {
            case 0:
            // Already on home
              break;
            case 1:
              Get.to(() => const DeliveriesScreen());
              break;
            case 2:
              Get.to(() => const AddLoadScreen());
              break;
            case 3:
              Get.snackbar(
                'Info',
                'Profile screen coming soon!',
                backgroundColor: AppColors.primaryMaroon,
                colorText: Colors.white,
              );
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.cardBackground,
        selectedItemColor: AppColors.primaryMaroon,
        unselectedItemColor: AppColors.darkGray.withOpacity(0.6),
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping_outlined),
            activeIcon: Icon(Icons.local_shipping),
            label: 'Deliveries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_outlined),
            activeIcon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _showMoreActionsBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.darkGray.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const LocalizedText(
              text: 'More Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryMaroon,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),
            _buildBottomSheetItem(
              icon: Icons.people,
              title: 'Customer Orders',
              onTap: () {
                Get.back();
                Get.to(() => const CustomerOrdersScreen());
              },
            ),
            _buildBottomSheetItem(
              icon: Icons.inventory_2,
              title: 'Add Load',
              onTap: () {
                Get.back();
                Get.to(() => const AddLoadScreen());
              },
            ),
            _buildBottomSheetItem(
              icon: Icons.translate,
              title: 'Change Language',
              onTap: () {
                Get.back();
                Get.to(() => const EnhancedLanguageSelectionScreen(
                  isFromSettings: true,
                ));
              },
            ),
            _buildBottomSheetItem(
              icon: Icons.analytics,
              title: 'Reports',
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Info',
                  'Reports feature coming soon!',
                  backgroundColor: AppColors.primaryMaroon,
                  colorText: Colors.white,
                );
              },
            ),
            _buildBottomSheetItem(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Info',
                  'Settings feature coming soon!',
                  backgroundColor: AppColors.primaryMaroon,
                  colorText: Colors.white,
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppColors.primaryMaroon,
          size: 20,
        ),
      ),
      title: LocalizedText(
        text: title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          color: AppColors.darkGray,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppColors.darkGray.withOpacity(0.5),
        size: 20,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}




//------ dummy page for my navigation ease -----

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/pages/customer/customer_list_entry_page.dart';
import 'package:smart_distributor_app/pages/distribution%20center/distribution_list_page.dart';
import 'package:smart_distributor_app/pages/drp_in_out/drp_entry_page.dart';
import 'package:smart_distributor_app/pages/hawker/hawker_list_page.dart';
import 'package:smart_distributor_app/pages/hosepipe_in_out/hosepipe_entry_screen.dart';
import 'package:smart_distributor_app/pages/hotplate_in_out/hotplate_entry_screen.dart';
import 'package:smart_distributor_app/pages/notifications/notifications_screen.dart';


//------ dummy page for  navigation ease -----
class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBar(
      //   title: 'Dummy Page',
      //   centerTitle: true,
      //   onLeadingPressed: () {
      //     Get.back();
      //   },
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
      //     onPressed: () => Get.back(),
      //   ),
      // ),
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'DummyPage',
          style: GoogleFonts.poppins(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 18),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                childAspectRatio: 1.0,
                children: [
                   PrimaryButtonWithIcon(
                    text: 'Hose Pipe In Out',
                    icon: Icons.line_weight,
                    onPressed: () {
                      Get.to(() =>  HosePipeEntryScreen());
                    },
                  ),
                  PrimaryButtonWithIcon(
                    text: 'Hot Plate In Out',
                    icon: Icons.fireplace,
                    onPressed: () {
                      Get.to(() => HotplateEntryScreen());
                    },
                  ),
                  PrimaryButtonWithIcon(
                    text: 'DRP In Out',
                    icon: Icons.fireplace,
                    onPressed: () {
                      Get.to(() => DrpEntryScreen());
                    },
                  ),
                  PrimaryButtonWithIcon(
                    text: 'Add Manager',
                    icon: Icons.person_add,
                    onPressed: () {
                      // Get.to(() => const AddManagerScreen());
                    },
                  ),
                  PrimaryButtonWithIcon(
                    text: 'Add Hawker',
                    icon: Icons.directions_bike_outlined,
                    onPressed: () {
                      Get.to(() => HawkerListPage());
                    },
                  ),
                  PrimaryButtonWithIcon(
                    text: 'Add Customer',
                    icon: Icons.person_add,
                    onPressed: () {
                      Get.to(() => const CustomerListPage());
                    },
                  ),
                  PrimaryButtonWithIcon(
                    text: 'Notifications',
                    icon: Icons.info,
                    onPressed: () {
                      Get.to(() => const NotificationsPage());
                    },
                  ),
                  PrimaryButtonWithIcon(
                    text: 'Add Load',
                    icon: Icons.propane_tank_rounded,
                    onPressed: () {
                      // Get.to(() => Screen());
                    },
                  ),
                  PrimaryButtonWithIcon(
                    text: 'Add Stock',
                    icon: Icons.add_box,
                    onPressed: () {
                      // Get.to(() => Screen());
                    },
                  ),
                  PrimaryButtonWithIcon(
                    text: 'Query Customer',
                    icon: Icons.help_outline,
                    onPressed: () {
                      // Get.to(() => Screen());
                    },
                  ),
                  PrimaryButtonWithIcon(
                    text: 'Dispatch/Return Log',
                    icon: Icons.description,
                    onPressed: () {
                      // Get.to(() => Screen());
                    },
                  ),
                  PrimaryButtonWithIcon(
                    text: 'Customer Report',
                    icon: Icons.access_time,
                    onPressed: () {
                      // Get.to(() => Screen());
                    },
                  ),

                  PrimaryButtonWithIcon(
                    text: 'Add Distribute Centre',
                    icon: Icons.location_on,
                    onPressed: () {
                      Get.to(() => DistributionCenterListPage());
                    },
                  ),

                  PrimaryButtonWithIcon(
                    text: 'Payment Status',
                    icon: Icons.currency_rupee,
                    onPressed: () {
                      // Get.to(() => Screen());
                    },
                  ),
                  PrimaryButtonWithIcon(
                    text: 'Cylinder Drop In Out',
                    icon: Icons.swap_vert,
                    onPressed: () {
                      // Get.to(() => Screen());
                    },
                  ),
                 
                  PrimaryButtonWithIcon(
                    text: 'Terminate Connection',
                    icon: Icons.cancel_outlined,
                    onPressed: () {
                      // Get.to(
                      // () => const TerminateConnectionScreen(),
                      // );
                    },
                  ),
                  PrimaryButtonWithIcon(
                    text: 'Add Regulator Delivery',
                    icon: Icons.directions_bike_outlined,
                    onPressed: () {
                      // Get.to(() => Screen());
                    },
                  ),
                  
                ],
              ),
            ),

       
          ],
        ),
      ),
    );
  }
}

class PrimaryButtonWithIcon extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const PrimaryButtonWithIcon({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.blue[800]),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

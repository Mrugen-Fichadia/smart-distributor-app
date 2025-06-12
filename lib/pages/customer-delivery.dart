// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/common/utils/colors.dart';

// --- Controller ---
class CustomerDeliveryController extends GetxController {
  var deliveries = [
    {
      "name": "Ramesh Patel",
      "time": "10:30 AM",
      "amount": 1200,
      "status": "Dispatched",
      "receiver": "Ramji",
      "location": "Railways",
      "cylinders": [
        {"type": "Domestic (19kg)", "out": "2", "in": "1"},
        {"type": "Commercial (14kg)", "out": "3", "in": "3"},
      ],
    },
    {
      "name": "Anita Shah",
      "time": "04:15 PM",
      "amount": 1800,
      "status": "Not Dispatched",
      "receiver": "Premraj",
      "location": "Ratlam",
      "cylinders": [
        {"type": "Commercial (14kg)", "out": "5", "in": "5"},
      ],
    },
    {
      "name": "Suresh Verma",
      "time": "02:45 PM",
      "amount": 1500,
      "status": "Dispatched",
      "receiver": "Mahesh",
      "location": "Depot",
      "cylinders": [
        {"type": "Industrial (12kg)", "out": "1", "in": "0"},
        {"type": "Domestic (19kg)", "out": "1", "in": "1"},
        {"type": "Commercial (14kg)", "out": "2", "in": "2"},
      ],
    },
    {
      "name": "Pooja Singh",
      "time": "11:00 AM",
      "amount": 1100,
      "status": "Not Dispatched",
      "receiver": "Ravi",
      "location": "Central Depot",
      "cylinders": [
        {"type": "Industrial (12kg)", "out": "1", "in": "1"},
      ],
    },
  ].obs;
}

// --- UI Page ---
class CustomerDeliveryPage extends StatelessWidget {
  final CustomerDeliveryController controller = Get.put(
    CustomerDeliveryController(),
  );

  // Extract only kg value from cylinder type string like "Domestic (19kg)" -> "19kg"
  String extractKg(String type) {
    final regExp = RegExp(r'\((.*?)\)');
    final match = regExp.firstMatch(type);
    if (match != null) {
      return match.group(1)!; // e.g. "19kg"
    }
    return type; // fallback
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Dispatched":
        return Colors.green.shade700;
      case "Not Dispatched":
        return Colors.red.shade700;
      default:
        return gray;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offwhite,
      appBar: AppBar(
        backgroundColor: primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: offwhite),
          onPressed: Get.back,
        ),
        title: Text(
          'Customer Deliveries',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: offwhite,
          ),
        ),
      ),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: controller.deliveries.length,
          itemBuilder: (context, index) {
            final data = controller.deliveries[index];
            final status = data['status'] as String;
            final color = getStatusColor(status);
            final cylinders = data['cylinders'] as List?;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT SIDE: Name, Cylinders (conditional), Location
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Cylinders display with kg only
                        if (cylinders != null && cylinders.isNotEmpty) ...[
                          for (var cyl in cylinders)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                children: [
                                  Text(
                                    "${extractKg(cyl['type'])} OUT: ",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    cyl['out'].toString(),
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "IN: ",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    cyl['in'].toString(),
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                        ],
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              data['location'] as String,
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // RIGHT SIDE: Amount on top, then time, status, receiver
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "₹${data['amount']}",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data['time'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            status,
                            style: GoogleFonts.poppins(
                              color: color,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.person_outline, size: 16),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                data['receiver'] as String,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

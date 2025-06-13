import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/common/utils/colors.dart';

// --- 1. GetX Controller ---
class DeliveryScreenController extends GetxController {
  var deliveries = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDeliveries();
  }

  void fetchDeliveries() {
    deliveries.assignAll([
      {
        'name': 'Ramesh Patel',
        'time': '10:30 AM',
        'outInfo': '19 KG - 2',
        'inInfo': '19 KG - 2',
        'location': 'Railways, Anand',
        'amount': 1200,
        'paidBy': 'Cash',
        'hawkerName': 'Mohan', // Only hawkerName
        'isConfirmed': true,
      },
      {
        'name': 'Anita Shah',
        'time': '04:15 PM',
        'outInfo': '14 KG - 3',
        'inInfo': '14 KG - 3',
        'location': 'Ratlam, MP',
        'amount': 1800,
        'paidBy': 'Cash',
        'hawkerName': 'Raju', // Only hawkerName
        'isConfirmed': false,
      },
      {
        'name': 'Suresh Desai',
        'time': '09:00 AM',
        'outInfo': '25 KG - 1',
        'inInfo': '25 KG - 1',
        'location': 'Satellite, Ahmedabad',
        'amount': 2500,
        'paidBy': 'Online',
        'hawkerName': 'Amit', // Only hawkerName
        'isConfirmed': true,
      },
      {
        'name': 'Priya Sharma',
        'time': '01:45 PM',
        'outInfo': '10 KG - 4',
        'inInfo': '10 KG - 4',
        'location': 'Vapi, Gujarat',
        'amount': 1000,
        'paidBy': 'Cash',
        'hawkerName': 'Vijay', // Only hawkerName
        'isConfirmed': false,
      },
      {
        'name': 'Rajesh Kumar',
        'time': '06:00 PM',
        'outInfo': '5 KG - 1',
        'inInfo': '5 KG - 1',
        'location': 'Gandhinagar, Gujarat',
        'amount': 500,
        'paidBy': 'Online',
        'hawkerName': 'Sunil', // Only hawkerName
        'isConfirmed': false,
      },
      {
        'name': 'Heena Mehta',
        'time': '11:00 AM',
        'outInfo': '20 KG - 2',
        'inInfo': '20 KG - 2',
        'location': 'Vadodara, Gujarat',
        'amount': 2000,
        'paidBy': 'Cash',
        'hawkerName': 'Prakash', // Only hawkerName
        'isConfirmed': true,
      },
      {
        'name': 'Mohanlal Hawker',
        'time': '12:30 PM',
        'outInfo': '15 KG - 2',
        'inInfo': '15 KG - 2',
        'location': 'Maninagar, Ahmedabad',
        'amount': 1500,
        'paidBy': 'Cash',
        'hawkerName': 'Mohanlal', // Only hawkerName
        'isConfirmed': false,
      },
      {
        'name': 'Jignesh Bhai',
        'time': '09:45 AM',
        'outInfo': '14 KG - 1',
        'inInfo': '14 KG - 1',
        'location': 'Paldi, Ahmedabad',
        'amount': 850,
        'paidBy': 'Cash',
        'hawkerName': 'Gopal', // Only hawkerName
        'isConfirmed': true,
      },
      {
        'name': 'Seema Devi',
        'time': '02:00 PM',
        'outInfo': '5 KG - 2',
        'inInfo': '5 KG - 2',
        'location': 'Adajan, Surat',
        'amount': 1100,
        'paidBy': 'Online',
        'hawkerName': 'Deepak', // Only hawkerName
        'isConfirmed': false,
      },
      {
        'name': 'Arjun Singh',
        'time': '07:30 AM',
        'outInfo': '19 KG - 1',
        'inInfo': '19 KG - 1',
        'location': 'Satellite, Rajkot',
        'amount': 950,
        'paidBy': 'Cash',
        'hawkerName': 'Rahul', // Only hawkerName
        'isConfirmed': true,
      },
      {
        'name': 'Poonam Gupta',
        'time': '05:00 PM',
        'outInfo': '14 KG - 2',
        'inInfo': '14 KG - 2',
        'location': 'Navrangpura, Ahmedabad',
        'amount': 1700,
        'paidBy': 'Online',
        'hawkerName': 'Sandeep', // Only hawkerName
        'isConfirmed': false,
      },
    ]);
  }

  void confirmDelivery(int index) {
    if (index < 0 || index >= deliveries.length) return;
    deliveries[index]['isConfirmed'] = true;
    deliveries.refresh();
  }
}

// --- 2. RecentDeliveriesPage (Main View) ---
class PaymentStatus extends StatelessWidget {
  PaymentStatus({super.key});

  final DeliveryScreenController controller = Get.put(
    DeliveryScreenController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Get.back,
        ),
        title: Text(
          'Payment Status',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Payments',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.deliveries.length,
                  itemBuilder: (context, index) {
                    final delivery = controller.deliveries[index];
                    final isConfirmed = delivery['isConfirmed'];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name & Amount
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  delivery['name'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '₹${delivery['amount']}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              delivery['time'],
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                            const SizedBox(height: 12),

                            // Delivery Info - Directly Inlined
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                    child: Text(
                                      'OUT:',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    delivery['outInfo'],
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                    child: Text(
                                      'IN:',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    delivery['inInfo'],
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  // No label, so no fixed width SizedBox
                                  Text(
                                    delivery['location'],
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8), // Reduced spacing
                            // Hawker Name (moved here)
                            Row(
                              children: [
                                Text(
                                  'Hawker: ',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  delivery['hawkerName'],
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ), // Added spacing below hawker name
                            // Footer Row (Payment and Status)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Payment & Status
                                Row(
                                  children: [
                                    Text(
                                      '${delivery['paidBy']} ',
                                      style: GoogleFonts.poppins(),
                                    ),
                                    isConfirmed
                                        ? // Inlined Status Badge for Confirmed
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green.withOpacity(
                                                0.15,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              'Confirmed',
                                              style: GoogleFonts.poppins(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        : Row(
                                            children: [
                                              // Inlined Status Badge for Unconfirmed
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.red.withOpacity(
                                                    0.15,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  'Unconfirmed',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              SizedBox(
                                                height: 28,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Get.dialog(
                                                      AlertDialog(
                                                        backgroundColor:
                                                            offwhite,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                16,
                                                              ),
                                                        ),
                                                        title: Text(
                                                          "Confirm Payment",
                                                          style:
                                                              GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                        content: Text(
                                                          "Are you sure you want to confirm the payment for ${delivery['name']}?",
                                                          style:
                                                              GoogleFonts.poppins(),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            style: TextButton.styleFrom(
                                                              backgroundColor:
                                                                  primary,
                                                              foregroundColor:
                                                                  offwhite,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              controller
                                                                  .confirmDelivery(
                                                                    index,
                                                                  );
                                                              Get.back();
                                                              Get.snackbar(
                                                                "Payment Confirmed",
                                                                "${controller.deliveries[index]['name']}'s payment has been confirmed successfully.",
                                                                snackPosition:
                                                                    SnackPosition
                                                                        .BOTTOM,
                                                                backgroundColor:
                                                                    primary,
                                                                colorText:
                                                                    Colors
                                                                        .white,
                                                                icon: const Icon(
                                                                  Icons
                                                                      .check_circle,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                margin:
                                                                    const EdgeInsets.all(
                                                                      10,
                                                                    ),
                                                                duration:
                                                                    const Duration(
                                                                      seconds:
                                                                          5,
                                                                    ),
                                                              );
                                                            },
                                                            child: const Text(
                                                              "Yes",
                                                            ),
                                                          ),
                                                          TextButton(
                                                            style: TextButton.styleFrom(
                                                              backgroundColor:
                                                                  primary,
                                                              foregroundColor:
                                                                  offwhite,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            child: const Text(
                                                              "No",
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    foregroundColor: offwhite,
                                                    backgroundColor: primary,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                        ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Confirm',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

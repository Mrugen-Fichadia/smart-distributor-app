import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/common/utils/colors.dart';
import 'package:smart_distributor_app/pages/hosepipe_in_out/hosepipe_controller.dart';
import 'package:smart_distributor_app/pages/hosepipe_in_out/hosepipe_in_screen.dart';
import 'package:smart_distributor_app/pages/hosepipe_in_out/house_pipe_out_screen.dart'; // Ensure this import is correct

class HosePipeEntryScreen extends StatefulWidget {
  const HosePipeEntryScreen({super.key});

  @override
  State<HosePipeEntryScreen> createState() => _HosePipeEntryScreenState();
}

class _HosePipeEntryScreenState extends State<HosePipeEntryScreen> {

  final HosePipeController controller = Get.put(HosePipeController());

  String? _selectedConnectionOption; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'HosePipe Entry',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HosePipe In/Out',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    RadioListTile<String>(
                      title: Text(
                        'Hose Pipe In',
                        style: GoogleFonts.poppins(
                          color: Colors.black),
                      ),
                      value: 'in',
                      activeColor: primary,

                      groupValue: _selectedConnectionOption,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedConnectionOption = value;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text(
                        'Hose Pipe Out',
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                      activeColor: primary,
                      value: 'out',
                      groupValue: _selectedConnectionOption,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedConnectionOption = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (_selectedConnectionOption == 'in') {
                            Get.to(
                              () => const HosePipeInScreen(),
                            )?.then((_) => controller.fetchStockData());
                          } else if (_selectedConnectionOption == 'out') {
                            Get.to(
                              () => const HosePipeOutScreen(),
                            )?.then((_) => controller.fetchStockData());
                          } else {
                            Get.snackbar(
                              'Selection Required',
                              'Please select an option (In or Out)',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                        child: Text(
                          'Submit',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: offwhite,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ------------ stock data ----------------
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Obx(
                  () => controller.isLoadingStock.value
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Stock:',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${controller.currentStock.value} units',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const Divider(height: 30, thickness: 1),
                            Text(
                              'Defective Parts:',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${controller.defectiveParts.value} units',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

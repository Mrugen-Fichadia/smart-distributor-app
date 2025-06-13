// ignore_for_file: file_names, deprecated_member_use
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/common/utils/colors.dart';

class NewConnectionController extends GetxController {
  final formKey = GlobalKey<FormState>(); // Corrected type for GlobalKey

  final nameController = TextEditingController();
  final consumerNumberController = TextEditingController();
  final amountController = TextEditingController();

  var isLoading = false.obs;

  var domesticCount = 0.obs;
  var commercialCount = 0.obs;
  var industrialCount = 0.obs;

  int get totalQuantity =>
      domesticCount.value + commercialCount.value + industrialCount.value;

  void increment(RxInt counter) => counter.value++;
  void decrement(RxInt counter) {
    if (counter.value > 0) counter.value--;
  }

  Future<void> saveForm() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      Get.snackbar(
        'Success',
        'Form saved successfully!',
        backgroundColor: primary,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      clearForm();
    }
  }

  void clearForm() {
    nameController.clear();
    consumerNumberController.clear();
    amountController.clear();
    domesticCount.value = 0;
    commercialCount.value = 0;
    industrialCount.value = 0;
    isLoading.value = false;
  }

  String? validateRequired(String? value) =>
      (value == null || value.trim().isEmpty) ? 'This field is required' : null;

  String? validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    final number = num.tryParse(value);
    if (number == null || number <= 0) return 'Enter a valid number';
    return null;
  }
}

class NewConnectionPage extends StatelessWidget {
  const NewConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewConnectionController());

    // Local TextEditingControllers for quantity fields, managed within build
    final domesticQuantityTextController = TextEditingController(
      text: controller.domesticCount.value.toString(),
    );
    final commercialQuantityTextController = TextEditingController(
      text: controller.commercialCount.value.toString(),
    );
    final industrialQuantityTextController = TextEditingController(
      text: controller.industrialCount.value.toString(),
    );

    // Using `ever` to keep text controllers in sync with RxInt values
    ever(controller.domesticCount, (int newCount) {
      if (newCount.toString() != domesticQuantityTextController.text) {
        domesticQuantityTextController.text = newCount.toString();
      }
    });
    ever(controller.commercialCount, (int newCount) {
      if (newCount.toString() != commercialQuantityTextController.text) {
        commercialQuantityTextController.text = newCount.toString();
      }
    });
    ever(controller.industrialCount, (int newCount) {
      if (newCount.toString() != industrialQuantityTextController.text) {
        industrialQuantityTextController.text = newCount.toString();
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'New connection',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: controller.formKey,
          child: Obx(
            () => ListView(
              children: [
                const SizedBox(height: 10),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: controller.nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          validator: controller.validateRequired,
                          style: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: controller.consumerNumberController,
                          decoration: const InputDecoration(
                            labelText: 'Consumer number',
                            prefixIcon: Icon(Icons.numbers),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: controller.validateRequired,
                          style: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Cylinder Type',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Domestic Cylinder Quantity Control
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Domestic (14 kg)',
                                style: GoogleFonts.poppins(fontSize: 15),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 60,
                                    height: 40,
                                    child: TextFormField(
                                      controller:
                                          domesticQuantityTextController,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(fontSize: 16),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (val) {
                                        final parsed = int.tryParse(val);
                                        if (parsed != null && parsed >= 0) {
                                          controller.domesticCount.value =
                                              parsed;
                                        }
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle,
                                      size: 28,
                                      color: primary,
                                    ),
                                    onPressed: () => controller.increment(
                                      controller.domesticCount,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      size: 28,
                                      color: primary,
                                    ),
                                    onPressed: () => controller.decrement(
                                      controller.domesticCount,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(color: Colors.grey[300]),

                        // Commercial Cylinder Quantity Control
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Commercial (5 kg)',
                                style: GoogleFonts.poppins(fontSize: 15),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 60,
                                    height: 40,
                                    child: TextFormField(
                                      controller:
                                          commercialQuantityTextController,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(fontSize: 16),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (val) {
                                        final parsed = int.tryParse(val);
                                        if (parsed != null && parsed >= 0) {
                                          controller.commercialCount.value =
                                              parsed;
                                        }
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle,
                                      size: 28,
                                      color: primary,
                                    ),
                                    onPressed: () => controller.increment(
                                      controller.commercialCount,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      size: 28,
                                      color: primary,
                                    ),
                                    onPressed: () => controller.decrement(
                                      controller.commercialCount,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(color: Colors.grey[300]),

                        // Industrial Cylinder Quantity Control
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Industrial (19 kg)',
                                style: GoogleFonts.poppins(fontSize: 15),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 60,
                                    height: 40,
                                    child: TextFormField(
                                      controller:
                                          industrialQuantityTextController,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(fontSize: 16),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (val) {
                                        final parsed = int.tryParse(val);
                                        if (parsed != null && parsed >= 0) {
                                          controller.industrialCount.value =
                                              parsed;
                                        }
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle,
                                      size: 28,
                                      color: primary,
                                    ),
                                    onPressed: () => controller.increment(
                                      controller.industrialCount,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      size: 28,
                                      color: primary,
                                    ),
                                    onPressed: () => controller.decrement(
                                      controller.industrialCount,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Total Quantity: ${controller.totalQuantity}',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: controller.amountController,
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            prefixIcon: Icon(Icons.currency_rupee),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: controller.validateNumber,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.saveForm,
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Save',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use, unused_local_variable, duplicate_ignore, unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/common/utils/colors.dart'; // Assuming 'primary' color is defined here

class TerminateConnectionForm extends StatefulWidget {
  const TerminateConnectionForm({super.key});

  @override
  State<TerminateConnectionForm> createState() =>
      _TerminateConnectionFormState();
}

class _TerminateConnectionFormState extends State<TerminateConnectionForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController consumerNumberController =
      TextEditingController();
  final TextEditingController amountController = TextEditingController();

  // --- Cylinder Quantity States ---
  final TextEditingController domesticController = TextEditingController(
    text: '0',
  );
  final TextEditingController commercialController = TextEditingController(
    text: '0',
  );
  final TextEditingController industrialController = TextEditingController(
    text: '0',
  );

  // RxInt for internal calculations and reactive updates
  final RxInt domesticCount = 0.obs;
  final RxInt commercialCount = 0.obs;
  final RxInt industrialCount = 0.obs;

  // Computed total quantity
  int get totalQuantity =>
      domesticCount.value + commercialCount.value + industrialCount.value;
  // --- End Cylinder Quantity States ---

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize RxInt values from controller text
    domesticCount.value = int.tryParse(domesticController.text) ?? 0;
    commercialCount.value = int.tryParse(commercialController.text) ?? 0;
    industrialCount.value = int.tryParse(industrialController.text) ?? 0;

    // Listen for changes in text controllers to update RxInt values
    domesticController.addListener(_updateDomesticQuantity);
    commercialController.addListener(_updateCommercialQuantity);
    industrialController.addListener(_updateIndustrialQuantity);
  }

  void _updateDomesticQuantity() {
    domesticCount.value = int.tryParse(domesticController.text) ?? 0;
  }

  void _updateCommercialQuantity() {
    commercialCount.value = int.tryParse(commercialController.text) ?? 0;
  }

  void _updateIndustrialQuantity() {
    industrialCount.value = int.tryParse(industrialController.text) ?? 0;
  }

  @override
  void dispose() {
    nameController.dispose();
    consumerNumberController.dispose();
    amountController.dispose();
    domesticController.dispose();
    commercialController.dispose();
    industrialController.dispose();
    super.dispose();
  }

  // --- Cylinder Quantity Methods ---
  void _increment(RxInt counter, TextEditingController textController) {
    counter.value++;
    textController.text = counter.value.toString();
  }

  void _decrement(RxInt counter, TextEditingController textController) {
    if (counter.value > 0) {
      counter.value--;
      textController.text = counter.value.toString();
    }
  }

  void _clearForm() {
    nameController.clear();
    consumerNumberController.clear();
    amountController.clear();
    domesticCount.value = 0;
    commercialCount.value = 0;
    industrialCount.value = 0;
    domesticController.text = '0';
    commercialController.text = '0';
    industrialController.text = '0';
    setState(() {
      _isLoading = false;
    });
  }
  // --- End Cylinder Quantity Methods ---

  String? _validateRequired(String? value) =>
      (value == null || value.trim().isEmpty) ? 'This field is required' : null;

  String? _validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    final number = num.tryParse(value);
    if (number == null || number <= 0) return 'Enter a valid number';
    return null;
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      if (totalQuantity == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please add at least one cylinder',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        final name = nameController.text.trim();
        final consumerNumber = consumerNumberController.text.trim();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Connection terminated for: $name, $consumerNumber',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: primary,
          ),
        );

        _clearForm();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Terminate Connection',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: ListView(
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
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) => _validateRequired(value),
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: consumerNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Consumer Number',
                          prefixIcon: Icon(Icons.numbers),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => _validateRequired(value),
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                      const SizedBox(height: 25),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Cylinder Quantity',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

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
                                    controller: domesticController,
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
                                        domesticCount.value = parsed;
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
                                  onPressed: () => _increment(
                                    domesticCount,
                                    domesticController,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    size: 28,
                                    color: primary,
                                  ),
                                  onPressed: () => _decrement(
                                    domesticCount,
                                    domesticController,
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
                                    controller: commercialController,
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
                                        commercialCount.value = parsed;
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
                                  onPressed: () => _increment(
                                    commercialCount,
                                    commercialController,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    size: 28,
                                    color: primary,
                                  ),
                                  onPressed: () => _decrement(
                                    commercialCount,
                                    commercialController,
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
                                    controller: industrialController,
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
                                        industrialCount.value = parsed;
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
                                  onPressed: () => _increment(
                                    industrialCount,
                                    industrialController,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    size: 28,
                                    color: primary,
                                  ),
                                  onPressed: () => _decrement(
                                    industrialCount,
                                    industrialController,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      Obx(
                        () => Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Total Quantity: ${totalQuantity}',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: amountController,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          prefixIcon: Icon(Icons.currency_rupee),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) => _validateNumber(value),
                        style: GoogleFonts.poppins(color: Colors.black),
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
                ),
                onPressed: _isLoading ? null : _saveForm,
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Terminate Connection',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

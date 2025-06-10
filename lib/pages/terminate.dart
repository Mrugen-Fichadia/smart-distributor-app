// ignore_for_file: deprecated_member_use, unused_local_variable, duplicate_ignore, unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/common/utils/colors.dart';
import 'package:smart_distributor_app/pages/tv-in-out.dart'; // Assuming you want to navigate back to TvInOutPage

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
  final TextEditingController cylinderQuantityController =
      TextEditingController();
  final TextEditingController amountController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    consumerNumberController.dispose();
    cylinderQuantityController.dispose();
    amountController.dispose();
    super.dispose();
  }

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validateNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final number = num.tryParse(value);
    if (number == null) {
      return '$fieldName must be a valid number';
    }
    if (number <= 0) {
      return '$fieldName must be greater than zero';
    }
    return null;
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      // Simulate a network request or heavy operation
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // Form is valid, proceed with saving or further logic
        final name = nameController.text.trim();
        final consumerNumber = consumerNumberController.text.trim();
        final cylinderQuantity = cylinderQuantityController.text.trim();
        // ignore: unused_local_variable
        final amount = amountController.text.trim();

        // For demonstration, just show a snackbar with the info
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Connection terminated for: $name, $consumerNumber',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: primary,
          ),
        );
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
        // Optionally clear fields after successful submission
        nameController.clear();
        consumerNumberController.clear();
        cylinderQuantityController.clear();
        amountController.clear();
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
              // Name Field
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
                          prefixIcon: Icon(Icons.person), // Added icon
                        ),
                        validator: (value) => _validateNotEmpty(value, 'Name'),
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                      const SizedBox(height: 15),

                      // Consumer number Field
                      TextFormField(
                        controller: consumerNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Consumer number',
                          prefixIcon: Icon(Icons.numbers), // Added icon
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            _validateNumber(value, 'Consumer number'),
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                      const SizedBox(height: 15),

                      // Cylinder quantity Field
                      TextFormField(
                        controller: cylinderQuantityController,
                        decoration: const InputDecoration(
                          labelText: 'Cylinder quantity',
                          prefixIcon: Icon(Icons.propane_tank), // Added icon
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            _validateNumber(value, 'Cylinder quantity'),
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                      const SizedBox(height: 15),

                      // Amount Field
                      TextFormField(
                        controller: amountController,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          prefixIcon: Icon(Icons.currency_rupee), // Added icon
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) => _validateNumber(value, 'Amount'),
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Save button
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : _saveForm, // Disable button if loading
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Terminate Connection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

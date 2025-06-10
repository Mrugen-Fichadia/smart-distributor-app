// ignore_for_file: file_names, deprecated_member_use
import 'package:get/get.dart';
import 'package:smart_distributor_app/common/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/pages/tv-in-out.dart';

class NewConnectionPage extends StatefulWidget {
  const NewConnectionPage({super.key});

  @override
  State<NewConnectionPage> createState() => _NewConnectionPageState();
}

class _NewConnectionPageState extends State<NewConnectionPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _consumerNumberController = TextEditingController();
  final _cylinderTypeController = TextEditingController();
  final _cylinderQuantityController = TextEditingController();
  final _amountController = TextEditingController();

  bool _isLoading = false; // For loading indicator on button

  @override
  void dispose() {
    _nameController.dispose();
    _consumerNumberController.dispose();
    _cylinderTypeController.dispose();
    _cylinderQuantityController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      // Simulate a network request or heavy operation
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Form saved successfully!',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: primary,
          ),
        );
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
        // Optionally clear fields or navigate
        _nameController.clear();
        _consumerNumberController.clear();
        _cylinderTypeController.clear();
        _cylinderQuantityController.clear();
        _amountController.clear();
      }
    }
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    final number = num.tryParse(value);
    if (number == null) {
      return 'Enter a valid number';
    }
    if (number <= 0) {
      return 'Enter a number greater than zero';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'New connection',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22),
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
                // Card for visual grouping
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
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person), // Added icon
                        ),
                        validator: _validateRequired,
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _consumerNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Consumer number',
                          prefixIcon: Icon(Icons.numbers), // Added icon
                        ),
                        keyboardType: TextInputType.number,
                        validator: _validateRequired,
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _cylinderTypeController,
                        decoration: const InputDecoration(
                          labelText: 'Cylinder type',
                          prefixIcon: Icon(Icons.propane_tank), // Added icon
                        ),
                        validator: _validateRequired,
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _cylinderQuantityController,
                        decoration: const InputDecoration(
                          labelText: 'Cylinder quantity',
                          prefixIcon: Icon(
                            Icons.add_shopping_cart,
                          ), // Added icon
                        ),
                        keyboardType: TextInputType.number,
                        validator: _validateNumber,
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _amountController,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          prefixIcon: Icon(Icons.currency_rupee), // Added icon
                        ),
                        keyboardType: TextInputType.number,
                        validator: _validateNumber,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : _saveForm, // Disable button while loading
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

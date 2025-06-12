import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/imports.dart';
import 'package:smart_distributor_app/pages/customer/customer_modle.dart';

class EditCustomerPage extends StatefulWidget {
  final Customer customer;

  const EditCustomerPage({super.key, required this.customer});

  @override
  State<EditCustomerPage> createState() => _EditCustomerPageState();
}

class _EditCustomerPageState extends State<EditCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController phoneNumberController;
  late TextEditingController addressController;
  // final bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    idController = TextEditingController(text: widget.customer.id);
    nameController = TextEditingController(text: widget.customer.name);
    phoneNumberController = TextEditingController(
      text: widget.customer.phoneNumber,
    );
    addressController = TextEditingController(text: widget.customer.address);
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _updateCustomer() {
    if (_formKey.currentState!.validate()) {
      final updatedCustomer = Customer(
        id: idController.text,
        name: nameController.text,
        phoneNumber: phoneNumberController.text,
        address: addressController.text,
      );

      print('Updating Customer: ${updatedCustomer.toMap()}');
      Get.back(result: updatedCustomer);
    }
  }

  void _deleteCustomerInfo() {
    bool deleteSuccess = true;

    if (deleteSuccess) {
      Get.back(result: 'deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: _deleteCustomerInfo,
          ),
        ],
        title: Text(
          'Edit Customer',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: idController,
                      decoration: const InputDecoration(
                        labelText: 'Customer ID',
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Customer ID cannot be empty';
                        }
                        return null;
                      },
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name cannot be empty';
                        }
                        return null;
                      },
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: phoneNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Enter Phone Number',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number cannot be empty';
                        }
                        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'Phone number must be exactly 10 digits';
                        }
                        return null;
                      },
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        hintText: 'Enter Address',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Address cannot be empty';
                        }
                        return null;
                      },
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      text: "Update Customer",
                      onPressed: _updateCustomer,
                      // backgroundColor: const Color(0xFFDC2626),
                      textColor: Colors.white,
                      borderRadius: 12.0,
                      height: 46.0,
                    ),
                    //      ElevatedButton(
                    //   style: ElevatedButton.styleFrom(backgroundColor: primary),
                    //   onPressed: _isLoading ? null : _updateCustomer,
                    //   child: _isLoading
                    //       ? const SizedBox(
                    //           width: 24,
                    //           height: 24,
                    //           child: CircularProgressIndicator(
                    //             color: Colors.white,
                    //             strokeWidth: 2,
                    //           ),
                    //         )
                    //       : const Text(
                    //           'Save',
                    //           style: TextStyle(color: Colors.white),
                    //         ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
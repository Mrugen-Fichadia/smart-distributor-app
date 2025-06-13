import 'package:flutter/material.dart';
import 'package:smart_distributor_app/imports.dart';
import 'package:get/get.dart';

class AddHawkerPage extends StatefulWidget {
  const AddHawkerPage({super.key});

  @override
  State<AddHawkerPage> createState() => _AddHawkerPageState();
}

class _AddHawkerPageState extends State<AddHawkerPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController phoneNumberController;
  late TextEditingController areaController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneNumberController = TextEditingController();
    areaController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    areaController.dispose();
    super.dispose();
  }

  void _saveHawker() {
    if (_formKey.currentState!.validate()) {
      final newHawker = Hawker(
        name: nameController.text,
        phoneNumber: phoneNumberController.text,
        area: areaController.text,
      );

      print('Saving New Hawker: ${newHawker.toMap()}');
      Get.back(result: true);
    } else {
      //-- message to user - all fields needed -------
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all fields properly',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Add New Hawker",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Card(
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
                    CustomTextFormField(
                      label: 'Name',
                      hintText: 'Enter Hawker Name',
                      prefixIcon: Icons.person_outline,
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      label: 'Phone Number',
                      hintText: 'Enter Phone Number',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      controller: phoneNumberController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Phone number cannot be empty';
                        }
                        if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) {
                          return 'Phone number must be exactly 10 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      label: 'Area',
                      hintText: 'Enter Area',
                      prefixIcon: Icons.location_on_outlined,
                      controller: areaController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Area cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      text: "Add Hawker",
                      onPressed: _saveHawker,
                      backgroundColor: primary,
                      textColor: offwhite,
                      borderRadius: 12.0,
                      height: 46.0,
                    ),
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

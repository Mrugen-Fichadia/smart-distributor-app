import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/imports.dart';
import 'package:smart_distributor_app/models/distributioncenter_model.dart';

class AddDistributionCenterPage extends StatefulWidget {
  const AddDistributionCenterPage({super.key});

  @override
  State<AddDistributionCenterPage> createState() =>
      _AddDistributionCenterPageState();
}

class _AddDistributionCenterPageState extends State<AddDistributionCenterPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _saveDistributionCenter() {
    if (_formKey.currentState!.validate()) {
      final newDistributionCenter = DistributionCenter(
        name: nameController.text,
      );

      print('Saving New Distribution Center: ${newDistributionCenter.toMap()}');
      Get.back(result: newDistributionCenter);

      CustomSnackBar.show(
        title: 'Success',
        message: 'Distribution Center added successfully!',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        icon: const Icon(Icons.check, color: Colors.white),
      );
    } else {
      CustomSnackBar.show(
        title: 'Error',
        message: 'Please fill all fields properly',
        backgroundColor: Colors.red,
        textColor: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ------- app color palete background -------------//
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Add New Distribution Center',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Card(
            // ------------ container color from color palete----------//
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
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Distribution Center Name',
                        hintText: 'Enter Distribution Center Name',
                        prefixIcon: Icon(Icons.location_city_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Distribution Center Name cannot be empty';
                        }
                        return null;
                      },
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      text: "Add Distribution Center",
                      onPressed: _saveDistributionCenter,
                      backgroundColor: const Color(0xFFDC2626),
                      textColor: Colors.white,
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

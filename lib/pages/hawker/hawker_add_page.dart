import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/imports.dart';

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
      Get.back(result: newHawker);
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
          'Add New Hawker',
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
                        labelText: 'Person Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a name';
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
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Phone number cannot be empty';
                        }
                        if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) {
                          return 'Phone number must be exactly 10 digits';
                        }
                        return null;
                      },
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: areaController,
                      decoration: const InputDecoration(
                        labelText: 'Area',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Area cannot be empty';
                        }
                        return null;
                      },
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      text: "Add Hawker",
                      onPressed: _saveHawker,
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

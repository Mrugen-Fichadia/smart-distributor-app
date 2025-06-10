import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/imports.dart';

class EditHawkerPage extends StatefulWidget {
  final Hawker hawker;

  const EditHawkerPage({super.key, required this.hawker});

  @override
  State<EditHawkerPage> createState() => _EditHawkerPageState();
}

class _EditHawkerPageState extends State<EditHawkerPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController phoneNumberController;
  late TextEditingController areaController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.hawker.name);
    phoneNumberController = TextEditingController(
      text: widget.hawker.phoneNumber,
    );
    areaController = TextEditingController(text: widget.hawker.area);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    areaController.dispose();
    super.dispose();
  }

  void _updateHawker() {
    if (_formKey.currentState!.validate()) {
      final updatedHawker = Hawker(
        name: nameController.text,
        phoneNumber: phoneNumberController.text,
        area: areaController.text,
      );

      print('Updating Hawker: ${updatedHawker.toMap()}');
      Get.back(result: updatedHawker);
    }
  }

  void _deleteHawkerInfo() {
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: _deleteHawkerInfo,
          ),
        ],
        title: Text(
          'Edit Hawker',
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
                      controller: areaController,
                      decoration: const InputDecoration(
                        labelText: 'Area',
                        hintText: 'Enter Area',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Area cannot be empty';
                        }
                        return null;
                      },
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      text: "Update Hawker",
                      onPressed: _updateHawker,
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

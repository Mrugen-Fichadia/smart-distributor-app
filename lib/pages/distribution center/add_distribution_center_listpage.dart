import 'package:flutter/material.dart';
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
      Get.back(result: true);

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
      backgroundColor: Color(0xFFF8FAFC),
      appBar: CustomAppBar(
        title: 'Add New Distribution Center',
        centerTitle: true,
        onLeadingPressed: () => Get.back(),
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
                    CustomTextFormField(
                      label: 'Distribution Center Name',
                      hintText: 'Enter Distribution Center Name',
                      prefixIcon: Icons.location_city_outlined,
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Distribution Center Name cannot be empty';
                        }
                        return null;
                      },
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


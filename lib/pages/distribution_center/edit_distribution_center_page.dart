import 'package:flutter/material.dart';
import 'package:smart_distributor_app/imports.dart';
import 'package:smart_distributor_app/models/distributioncenter_model.dart'; // Ensure this path is correct
import 'package:get/get.dart';

class EditDistributionCenterPage extends StatefulWidget {
  final DistributionCenter center;

  const EditDistributionCenterPage({super.key, required this.center});

  @override
  State<EditDistributionCenterPage> createState() =>
      _EditDistributionCenterPageState();
}

class _EditDistributionCenterPageState
    extends State<EditDistributionCenterPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.center.name);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _updateDistributionCenter() {
    if (_formKey.currentState!.validate()) {
      final updatedCenter = DistributionCenter(name: nameController.text);

      print('Updating Distribution Center: ${updatedCenter.toMap()}');
      Get.back(result: 'updated');
    }
  }

  void _deleteDistributionCenter() {
    bool deleteSuccess = true;

    if (deleteSuccess) {
      Get.back(result: 'deleted');
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
          "Edit Distribution Center",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: primary),
            onPressed: _deleteDistributionCenter,
          ),
        ],
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
                      text: "Update Distribution Center",
                      onPressed: _updateDistributionCenter,
                      backgroundColor: primary,
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

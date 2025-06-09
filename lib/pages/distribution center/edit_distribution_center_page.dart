import 'package:flutter/material.dart';
import 'package:smart_distributor_app/imports.dart';
import 'package:smart_distributor_app/models/distributioncenter_model.dart';

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
      Get.back(result: updatedCenter);
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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomAppBar(
        title: 'Edit Distribution Center',
        centerTitle: true,
        onLeadingPressed: () {
          Get.back();
        },
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: _deleteDistributionCenter,
          ),
        ],
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
                      backgroundColor: const Color(0xFFDC2626),
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

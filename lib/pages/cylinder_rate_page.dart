// ignore_for_file: unused_field, deprecated_member_use
import 'package:get/get.dart';
import 'package:smart_distributor_app/common/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CylinderRatePage extends StatefulWidget {
  const CylinderRatePage({super.key});

  @override
  State<CylinderRatePage> createState() => _CylinderRatePageState();
}

class _CylinderRatePageState extends State<CylinderRatePage> {
  final _formKey = GlobalKey<FormState>();

  final _rate14kgController = TextEditingController();
  final _rate19kgController = TextEditingController();
  final _rate5kgController = TextEditingController();

  static const Color cardBackgroundColor = Color(0xFFF5F5F5);
  static const Color accentColor = Color(0xFFFFB300);

  bool _isLoading = false;

  @override
  void dispose() {
    _rate14kgController.dispose();
    _rate19kgController.dispose();
    _rate5kgController.dispose();
    super.dispose();
  }

  Future<void> _saveRates() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate a network request or heavy operation
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        final rate14 = _rate14kgController.text;
        final rate19 = _rate19kgController.text;
        final rate5 = _rate5kgController.text;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Rates saved: ₹$rate14 (14kg), ₹$rate19 (19kg), ₹$rate5 (5kg)", // More descriptive message
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: primary,
            duration: const Duration(seconds: 3), // Longer duration
            behavior: SnackBarBehavior.floating, // Make it floating
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ), // Rounded corners
            margin: const EdgeInsets.all(15), // Margin from edges
          ),
        );
        setState(() {
          _isLoading = false;
        });
        _rate14kgController.clear();
        _rate19kgController.clear();
        _rate5kgController.clear();
      }
    }
  }

  InputDecoration _buildRateInputDecoration({
    required String labelText,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon, color: Colors.black.withOpacity(0.7)), // Subtle icon color
      hintText: 'e.g., 999.00', // Added hint text
    );
  }

  Widget _buildRateInputField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Visually appealing header for each input field
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.black, size: 20), // Icon next to the label
              const SizedBox(width: 8),
              Text(
                labelText,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600, // Make it bold
                ),
              ),
            ],
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ), // Allow decimal input
          decoration: _buildRateInputDecoration(
            labelText: 'Enter Rate',
            icon: Icons.currency_rupee,
          ), // Simplified label, icon handled in header
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 16),
          validator: validator,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Cylinder Rate Change',
          style: GoogleFonts.poppins(
            fontSize: 24, // Slightly larger title
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Modern back icon
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Use SingleChildScrollView for better responsiveness
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Stretch children horizontally
              children: [
                Card(
                  elevation: 8, // More pronounced card elevation
                  color: cardBackgroundColor, // Apply card background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      20,
                    ), // More rounded corners for the card
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(
                      24.0,
                    ), // Increased padding inside the card
                    child: Column(
                      children: [
                        _buildRateInputField(
                          controller: _rate14kgController,
                          labelText: '14 KG Cylinder Rate',
                          icon: Icons
                              .propane_tank_outlined, // Specific icon for cylinder
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter 14 KG rate';
                            }
                            if (double.tryParse(value) == null ||
                                double.parse(value) <= 0) {
                              return 'Enter a valid positive number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 25), // Adjusted spacing
                        _buildRateInputField(
                          controller: _rate19kgController,
                          labelText: '19 KG Cylinder Rate',
                          icon: Icons.propane_tank_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter 19 KG rate';
                            }
                            if (double.tryParse(value) == null ||
                                double.parse(value) <= 0) {
                              return 'Enter a valid positive number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 25),
                        _buildRateInputField(
                          controller: _rate5kgController,
                          labelText: '5 KG Cylinder Rate',
                          icon: Icons.propane_tank_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter 5 KG rate';
                            }
                            if (double.tryParse(value) == null ||
                                double.parse(value) <= 0) {
                              return 'Enter a valid positive number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 35),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _saveRates,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              foregroundColor: offwhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Save',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

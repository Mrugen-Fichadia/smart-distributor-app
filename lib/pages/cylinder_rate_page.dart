// ignore_for_file: unused_field, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const CylinderRateApp());
}

class CylinderRateApp extends StatelessWidget {
  const CylinderRateApp({super.key});

  // Updated Color Palette
  static const Color primaryColor = Color(0xFF800000); // Maroon
  static const Color backgroundColor = Color(0xFFFFFFFF); // White
  static const Color textColor = Color(
    0xFF003366,
  ); // Dark Blue for text/headers
  static const Color cardBackgroundColor = Color(
    0xFFF5F5F5,
  ); // Light Gray for cards
  static const Color accentColor = Color(
    0xFFFFB300,
  ); // Amber/Orange for accents

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cylinder Rate Change',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primaryColor,
          secondary: accentColor, // Using accentColor for secondary
          onPrimary: Colors.white, // Text on primary color
          onSurface: textColor, // Text on surfaces like card background
          surface: cardBackgroundColor, // Surface color for cards
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
          ), // Slightly bolder label
          hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
          floatingLabelStyle: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ), // Bolder focused label
          filled: true,
          fillColor: Colors.white, // Input field background
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: textColor.withOpacity(0.3),
              width: 1.0,
            ), // Finer, subtle border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: primaryColor,
              width: 2.5,
            ), // More prominent focus border
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.5,
            ), // Clearer error border
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ), // Slightly more padding
          errorStyle: GoogleFonts.poppins(
            color: Colors.red,
            fontSize: 13,
            height: 1.2,
          ), // Error text style
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700, // Make button text bolder
            ),
            minimumSize: const Size.fromHeight(55), // Slightly taller button
            elevation: 7, // More pronounced elevation
            shadowColor: primaryColor.withOpacity(0.6), // Stronger shadow
          ),
        ),
      ),
      home: const CylinderRatePage(),
    );
  }
}

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

  static const Color _primaryColor = CylinderRateApp.primaryColor;
  static const Color _textColor = CylinderRateApp.textColor;
  static const Color _cardBackgroundColor = CylinderRateApp.cardBackgroundColor;

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
            backgroundColor: _primaryColor,
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
      prefixIcon: Icon(
        icon,
        color: _textColor.withOpacity(0.7),
      ), // Subtle icon color
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
              Icon(icon, color: _textColor, size: 20), // Icon next to the label
              const SizedBox(width: 8),
              Text(
                labelText,
                style: GoogleFonts.poppins(
                  color: _textColor,
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
          style: GoogleFonts.poppins(color: _textColor, fontSize: 16),
          validator: validator,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Cylinder Rate Change',
          style: GoogleFonts.poppins(
            fontSize: 24, // Slightly larger title
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Modern back icon
          onPressed: () {
            Navigator.pop(context);
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
                  color: _cardBackgroundColor, // Apply card background color
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
                              backgroundColor: _primaryColor, // Primary color
                              foregroundColor:
                                  CylinderRateApp.backgroundColor, // White text
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

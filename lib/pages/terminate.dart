// ignore_for_file: deprecated_member_use, unused_local_variable, duplicate_ignore, unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/pages/tv-in-out.dart'; // Assuming you want to navigate back to TvInOutPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Define the colors based on the image theme
  static const Color primaryColor = Color(
    0xFFE64A19,
  ); // Approx. Primary from image
  static const Color secondaryColor = Color(
    0xFFFF8A65,
  ); // A complementary color
  static const Color backgroundColor = Color(
    0xFFF5F5DC,
  ); // Approx. Background from image
  static const Color textColor = Color(0xFF1E4E5A); // Approx. Text from image

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terminate Connection Form',
      theme: ThemeData(
        // Apply Poppins font globally
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        // Define color scheme
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primaryColor,
          secondary: secondaryColor,
          onPrimary: Colors.white, // Text/icon color on primary background
          onSurface: textColor, // Default text color on surfaces
          surface: Colors.white, // Card/surface background color
        ),
        // Set scaffold background color globally
        scaffoldBackgroundColor: backgroundColor,

        // Style for TextFormFields
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: textColor), // Label text color
          hintStyle: TextStyle(
            // ignore: deprecated_member_use
            color: textColor.withOpacity(0.6),
          ), // Hint text color
          floatingLabelStyle: TextStyle(
            color: primaryColor,
          ), // Floating label color
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: textColor.withOpacity(0.5),
            ), // Default border color
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor,
              width: 2,
            ), // Focused border color
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.redAccent,
            ), // Error border color
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.redAccent,
              width: 2,
            ), // Focused error border color
            borderRadius: BorderRadius.circular(8),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),

        // Style for ElevatedButton
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor, // Button background color
            foregroundColor: Colors.white, // Button text/icon color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8,
              ), // Rounded corners for buttons
            ),
            textStyle: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            minimumSize: const Size.fromHeight(
              50,
            ), // Standard height for buttons
            elevation: 5, // Added elevation
            shadowColor: primaryColor.withOpacity(0.4), // Added shadow color
          ),
        ),
        // No need for primarySwatch as we are defining explicit colors
        // primarySwatch: Colors.blue, // REMOVED as custom colors are now defined
      ),
      home: const TerminateConnectionForm(),
    );
  }
}

class TerminateConnectionForm extends StatefulWidget {
  const TerminateConnectionForm({super.key});

  @override
  State<TerminateConnectionForm> createState() =>
      _TerminateConnectionFormState();
}

class _TerminateConnectionFormState extends State<TerminateConnectionForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController consumerNumberController =
      TextEditingController();
  final TextEditingController cylinderQuantityController =
      TextEditingController();
  final TextEditingController amountController = TextEditingController();

  // Access colors from the MyApp class directly for consistency
  static const Color _primaryColor = MyApp.primaryColor;
  static const Color _backgroundColor = MyApp.backgroundColor;
  static const Color _textColor = MyApp.textColor;

  bool _isLoading = false; // State variable for loading indicator

  @override
  void dispose() {
    nameController.dispose();
    consumerNumberController.dispose();
    cylinderQuantityController.dispose();
    amountController.dispose();
    super.dispose();
  }

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validateNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final number = num.tryParse(value);
    if (number == null) {
      return '$fieldName must be a valid number';
    }
    if (number <= 0) {
      return '$fieldName must be greater than zero';
    }
    return null;
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      // Simulate a network request or heavy operation
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // Form is valid, proceed with saving or further logic
        final name = nameController.text.trim();
        final consumerNumber = consumerNumberController.text.trim();
        final cylinderQuantity = cylinderQuantityController.text.trim();
        // ignore: unused_local_variable
        final amount = amountController.text.trim();

        // For demonstration, just show a snackbar with the info
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Connection terminated for: $name, $consumerNumber',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: _primaryColor,
          ),
        );
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
        // Optionally clear fields after successful submission
        nameController.clear();
        consumerNumberController.clear();
        cylinderQuantityController.clear();
        amountController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terminate Connection',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: _primaryColor,
        foregroundColor: _backgroundColor, // Set text/icon color for AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
      ),
      backgroundColor: _backgroundColor, // Apply background color to scaffold
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 10),
              // Name Field
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person), // Added icon
                        ),
                        validator: (value) => _validateNotEmpty(value, 'Name'),
                        style: GoogleFonts.poppins(color: _textColor),
                      ),
                      const SizedBox(height: 15),

                      // Consumer number Field
                      TextFormField(
                        controller: consumerNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Consumer number',
                          prefixIcon: Icon(Icons.numbers), // Added icon
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            _validateNumber(value, 'Consumer number'),
                        style: GoogleFonts.poppins(color: _textColor),
                      ),
                      const SizedBox(height: 15),

                      // Cylinder quantity Field
                      TextFormField(
                        controller: cylinderQuantityController,
                        decoration: const InputDecoration(
                          labelText: 'Cylinder quantity',
                          prefixIcon: Icon(Icons.propane_tank), // Added icon
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            _validateNumber(value, 'Cylinder quantity'),
                        style: GoogleFonts.poppins(color: _textColor),
                      ),
                      const SizedBox(height: 15),

                      // Amount Field
                      TextFormField(
                        controller: amountController,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          prefixIcon: Icon(Icons.currency_rupee), // Added icon
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) => _validateNumber(value, 'Amount'),
                        style: GoogleFonts.poppins(color: _textColor),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Save button
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : _saveForm, // Disable button if loading
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Terminate Connection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

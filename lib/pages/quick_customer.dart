import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuickCustomerForm extends StatefulWidget {
  const QuickCustomerForm({super.key});

  @override
  State<QuickCustomerForm> createState() => _QuickCustomerFormState();
}

class _QuickCustomerFormState extends State<QuickCustomerForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();

  static const Color primaryColor = Color(
    0xFFE64A19,
  ); // Primary from image (Orange/Red)
  static const Color backgroundColor = Color(
    0xFFF5F5DC,
  ); // Background from image (Light Beige)
  static const Color textColor = Color(0xFF1E4E5A);

  // Reference the theme colors for direct use within this state
  static const Color _primaryColor = primaryColor;
  // ignore: unused_field
  static const Color _backgroundColor = backgroundColor;
  static const Color _textColor = textColor;

  bool _isLoading = false; // State to manage loading indicator

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      // Simulate a network request or heavy operation
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Customer saved successfully!",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: _primaryColor,
            duration: const Duration(seconds: 2),
          ),
        );
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
        // Clear the form fields after successful submission
        _nameController.clear();
        _mobileController.clear();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _primaryColor, // Use theme primary color for AppBar
        elevation: 0, // No shadow for a flat, modern look
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Quick Customer',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold, // Make title bolder
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 4, // Subtle elevation for the card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  15,
                ), // Rounded corners for the card
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person), // Added person icon
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                        style: GoogleFonts.poppins(color: _textColor),
                      ),
                      const SizedBox(height: 20), // Increased spacing
                      TextFormField(
                        controller: _mobileController,
                        decoration: const InputDecoration(
                          labelText: 'Mobile Number',
                          prefixIcon: Icon(Icons.phone), // Added phone icon
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter mobile number';
                          } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                            return 'Enter a valid 10-digit mobile number';
                          }
                          return null;
                        },
                        style: GoogleFonts.poppins(color: _textColor),
                      ),
                      const SizedBox(height: 30), // Increased spacing
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : _saveForm, // Disable button when loading
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Save Customer',
                              ), // Changed button text
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

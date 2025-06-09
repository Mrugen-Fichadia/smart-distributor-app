// ignore_for_file: unused_field, file_names, use_super_parameters

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/pages/new-connection.dart';
import 'package:smart_distributor_app/pages/terminate.dart';

class TvInOutPage extends StatefulWidget {
  const TvInOutPage({Key? key}) : super(key: key);

  @override
  State<TvInOutPage> createState() => _TvInOutPageState();
}

class _TvInOutPageState extends State<TvInOutPage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedOption;

  // Define the colors based on the image theme
  static const Color _primaryColor = Color(
    0xFFE64A19,
  ); // Approx. Primary from image
  static const Color _secondaryColor = Color(
    0xFFFF8A65,
  ); // Approx. Secondary from image
  static const Color _backgroundColor = Color(
    0xFFF5F5DC,
  ); // Approx. Background from image
  static const Color _textColor = Color(0xFF1E4E5A); // Approx. Text from image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tv In/Out',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: _primaryColor, // Apply background color to app bar
        foregroundColor:
            _backgroundColor, // Apply text color to app bar title and icons
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // <-- This navigates back to TvInOutPage
          },
        ),
      ),
      backgroundColor: _backgroundColor, // Apply background color to scaffold
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tv In/Out',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: _textColor, // Apply text color
                    ),
                  ),
                  const SizedBox(height: 24),
                  RadioListTile<String>(
                    title: Text(
                      'New connection',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: _textColor,
                      ), // Apply text color
                    ),
                    value: 'new_connection',
                    groupValue: _selectedOption,
                    onChanged: (val) {
                      setState(() {
                        _selectedOption = val;
                      });
                    },
                    activeColor:
                        _primaryColor, // Use primary color for active radio button
                  ),
                  RadioListTile<String>(
                    title: Text(
                      'Terminate connection',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: _textColor,
                      ), // Apply text color
                    ),
                    value: 'terminate_connection',
                    groupValue: _selectedOption,
                    onChanged: (val) {
                      setState(() {
                        _selectedOption = val;
                      });
                    },
                    activeColor:
                        _primaryColor,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedOption == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please select an option.',
                              style: GoogleFonts.poppins(),
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      } else {
                        // Navigate based on the selected option
                        if (_selectedOption == 'new_connection') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewConnectionApp(),
                            ),
                          );
                        } else if (_selectedOption == 'terminate_connection') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TerminateConnectionForm(),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(45),
                      backgroundColor:
                          _primaryColor, // Apply primary color from image
                      foregroundColor:
                          Colors.white, // Text color for the button
                    ),
                    child: Text(
                      'Submit',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

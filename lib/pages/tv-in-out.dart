// ignore_for_file: unused_field, file_names, use_super_parameters
import 'package:smart_distributor_app/common/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/pages/new-connection.dart';
import 'package:smart_distributor_app/pages/terminate.dart';
import 'package:get/get.dart';

class TvInOutPage extends StatefulWidget {
  const TvInOutPage({Key? key}) : super(key: key);

  @override
  State<TvInOutPage> createState() => _TvInOutPageState();
}

class _TvInOutPageState extends State<TvInOutPage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Tv In/Out',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
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
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  RadioListTile<String>(
                    title: Text(
                      'New connection',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black,
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
                        primary,
                  ),
                  RadioListTile<String>(
                    title: Text(
                      'Terminate connection',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black,
                      ), // Apply text color
                    ),
                    value: 'terminate_connection',
                    groupValue: _selectedOption,
                    onChanged: (val) {
                      setState(() {
                        _selectedOption = val;
                      });
                    },
                    activeColor: primary,
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
                              builder: (context) => NewConnectionPage(),
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
                          primary, // Apply primary color from image
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

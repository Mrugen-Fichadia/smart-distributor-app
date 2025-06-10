import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/pages/drp_in_out/drp_controller.dart';

class DrpOutScreen extends StatefulWidget {
  const DrpOutScreen({super.key});

  @override
  State<DrpOutScreen> createState() => _DrpOutScreenState();
}

class _DrpOutScreenState extends State<DrpOutScreen> {
  final _formKey = GlobalKey<FormState>();

  final DrpController controller = Get.find();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _selectedPaymentMode;
  String? _selectedHawker;

  bool _isLoading = false;

  final Color primary = Color(0xFF8B0000);
  final Color offwhite = Colors.white;

  final List<String> _paymentModes = ['Cash', 'Advanced'];

  final List<String> _hawkers = [
    'Arun',
    'Keshav',
    'Chakra',
    'Shailesh',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _costController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final quantity = int.parse(_quantityController.text);
      controller.removeStock(quantity);

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      Get.back();
      Get.snackbar(
        'Success',
        'Details saved successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'DRP Out',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: offwhite,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
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
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),


                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _quantityController,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          prefixIcon: Icon(Icons.numbers),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter quantity';
                          }
                          if (int.tryParse(value) == null ||
                              int.parse(value) <= 0) {
                            return 'Please enter a valid quantity';
                          }
                          return null;
                        },
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: DropdownButtonFormField<String>(
                          value: _selectedHawker,
                          decoration: const InputDecoration(
                            labelText: 'Hawker',
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(),
                          ),
                          items: _hawkers.map((String hawker) {
                            return DropdownMenuItem<String>(
                              value: hawker,
                              child: Text(
                                hawker,
                                style: GoogleFonts.poppins(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedHawker = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a hawker';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _costController,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter amount';
                          }
                          if (double.tryParse(value) == null ||
                              double.parse(value) <= 0) {
                            return 'Please enter a valid amount';
                          }
                          return null;
                        },
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter an address';
                          }
                          return null;
                        },
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: DropdownButtonFormField<String>(
                          value: _selectedPaymentMode,
                          decoration: const InputDecoration(
                            labelText: 'Payment Mode',
                            prefixIcon: Icon(Icons.payment),
                            border: OutlineInputBorder(),
                          ),
                          items: _paymentModes.map((String mode) {
                            return DropdownMenuItem<String>(
                              value: mode,
                              child: Text(
                                mode,
                                style: GoogleFonts.poppins(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedPaymentMode = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a payment mode';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                        ),
                        onPressed: _isLoading ? null : _saveForm,
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
                                'Save',
                                style: TextStyle(color: Colors.white),
                              ),
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

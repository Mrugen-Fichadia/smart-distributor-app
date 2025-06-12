import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/imports.dart';
import 'package:smart_distributor_app/pages/customer/customer_modle.dart';

class CustomerDelivery extends StatefulWidget {
  const CustomerDelivery({super.key});

  @override
  State<CustomerDelivery> createState() => _CustomerDeliveryState();
}

class _CustomerDeliveryState extends State<CustomerDelivery> {
  final _formKey = GlobalKey<FormState>();

  Customer? _selectedCustomer;

  //----------- Dummy list of customers
  final List<Customer> _customers = [
    Customer(
      id: '001',
      name: 'alsdd',
      phoneNumber: '9876543210',
      address: 'mumbari',
    ),
    Customer(
      id: '002',
      name: 'Bishu',
      phoneNumber: '8765432109',
      address: 'nehru marg',
    ),
    Customer(
      id: '003',
      name: 'Chunnu',
      phoneNumber: '7654321098',
      address: 'khatima',
    ),
  ];

  late TextEditingController phoneNumberController;
  late TextEditingController addressController;
  late TextEditingController cylinderType1Controller;
  late TextEditingController cylinderType2Controller;
  late TextEditingController cylinderType3Controller;
  late TextEditingController drpQuantityController;
  late TextEditingController hosepipeQuantityController;
  late TextEditingController hotplateQuantityController;
  late TextEditingController paymentAmountController;

  bool _isDrpExpanded = false;
  bool _isHosepipeExpanded = false;
  bool _isHotplateExpanded = false;

  @override
  void initState() {
    super.initState();
    phoneNumberController = TextEditingController();
    addressController = TextEditingController();
    cylinderType1Controller = TextEditingController();
    cylinderType2Controller = TextEditingController();
    cylinderType3Controller = TextEditingController();
    drpQuantityController = TextEditingController();
    hosepipeQuantityController = TextEditingController();
    hotplateQuantityController = TextEditingController();
    paymentAmountController = TextEditingController();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    addressController.dispose();
    cylinderType1Controller.dispose();
    cylinderType2Controller.dispose();
    cylinderType3Controller.dispose();
    drpQuantityController.dispose();
    hosepipeQuantityController.dispose();
    hotplateQuantityController.dispose();
    paymentAmountController.dispose();
    super.dispose();
  }

  void _onCustomerSelected(Customer? customer) {
    setState(() {
      _selectedCustomer = customer;
      if (customer != null) {
        phoneNumberController.text = customer.phoneNumber;
        addressController.text = customer.address;
      } else {
        phoneNumberController.clear();
        addressController.clear();
      }
    });
  }

  void _clearForm() {
    setState(() {
      _selectedCustomer = null;
      phoneNumberController.clear();
      addressController.clear();
      cylinderType1Controller.clear();
      cylinderType2Controller.clear();
      cylinderType3Controller.clear();
      drpQuantityController.clear();
      hosepipeQuantityController.clear();
      hotplateQuantityController.clear();
      paymentAmountController.clear();
      _isDrpExpanded = false;
      _isHosepipeExpanded = false;
      _isHotplateExpanded = false;
    });
  }

  void _addOrder() {
    if (_formKey.currentState!.validate()) {
      final bool hasCylinderQuantity =
          cylinderType1Controller.text.isNotEmpty ||
          cylinderType2Controller.text.isNotEmpty ||
          cylinderType3Controller.text.isNotEmpty;

      final bool hasAccessoryQuantity =
          drpQuantityController.text.isNotEmpty ||
          hosepipeQuantityController.text.isNotEmpty ||
          hotplateQuantityController.text.isNotEmpty;

      // ----  Validate if at least one cylinder quantity or one accessory quantity is filled
      if (!hasCylinderQuantity && !hasAccessoryQuantity) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please fill at least one cylinder quantity or one accessory quantity.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // print('Selected Customer: ${_selectedCustomer?.name}');
      // print('Cylinder 1 Qty: ${cylinderType1Controller.text}');
      // print('Cylinder 2 Qty: ${cylinderType2Controller.text}');
      // print('Cylinder 3 Qty: ${cylinderType3Controller.text}');
      // print('DRP Qty: ${drpQuantityController.text}');
      // print('Hosepipe Qty: ${hosepipeQuantityController.text}');
      // print('Hotplate Qty: ${hotplateQuantityController.text}');
      // print('Payment Amount: ${paymentAmountController.text}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            'Order Added Successfully!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );

      // ------- Clear the form after successful submission ---------
      _clearForm();

      // ---- navigate back or not after order made
      Get.back();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all fields properly',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Add New Order',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    _addCustomerSelection(),
                    
                    _cylinderQuantitySelection(),
                    
                    _accessoryQuantitySelection(),
                    
                    
                    const SizedBox(height: 24),

                    TextFormField(
                      controller: paymentAmountController,
                      decoration: const InputDecoration(
                        labelText: 'Payment Amount',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.currency_rupee),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Payment amount is required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter a valid amount';
                        }
                        return null;
                      },
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                    const SizedBox(height: 20),

                    PrimaryButton(
                      text: "Add Order",
                      onPressed: _addOrder,
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




  Widget _addCustomerSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Customer:',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<Customer>(
          value: _selectedCustomer,
          decoration: InputDecoration(
            labelText: 'Customer Name',
            labelStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person_outline),
          ),
          items: _customers.map((customer) {
            return DropdownMenuItem<Customer>(
              value: customer,
              child: Text(customer.name),
            );
          }).toList(),
          onChanged: _onCustomerSelected,
          validator: (value) {
            if (value == null) {
              return 'Please select a customer';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: phoneNumberController,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            labelStyle: TextStyle(color: Colors.grey.shade500),
            prefixIcon: Icon(Icons.phone_outlined),
            enabled: false, // -------- no editing available
          ),
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: addressController,
          decoration: InputDecoration(
            labelText: 'Address',
            labelStyle: TextStyle(color: Colors.grey.shade500),
            prefixIcon: Icon(Icons.location_on_outlined),
            enabled: false, // -------- no editing available
          ),
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        const SizedBox(height: 24),
      ],
    );
  }



  Widget _cylinderQuantitySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cylinder Quantities:',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        TextFormField(
          controller: cylinderType1Controller,
          decoration: const InputDecoration(
            labelText: ' 19 Kg Cylinder',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.propane_tank),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value != null &&
                value.isNotEmpty &&
                int.tryParse(value) == null) {
              return 'Enter a valid number';
            }
            return null;
          },
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: cylinderType2Controller,
          decoration: const InputDecoration(
            labelText: ' 14 Kg Cylinder',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.propane_tank),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value != null &&
                value.isNotEmpty &&
                int.tryParse(value) == null) {
              return 'Enter a valid number';
            }
            return null;
          },
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: cylinderType3Controller,
          decoration: const InputDecoration(
            labelText: ' 5 Kg Cylinder ',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.propane_tank),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value != null &&
                value.isNotEmpty &&
                int.tryParse(value) == null) {
              return 'Enter a valid number';
            }
            return null;
          },
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _accessoryQuantitySelection() {
    return Column(
      children: [
        ExpansionTile(
          title: Text(
            'DRP Quantity',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const Icon(Icons.add_circle_outline),
          initiallyExpanded: _isDrpExpanded,
          onExpansionChanged: (bool expanded) {
            setState(() {
              _isDrpExpanded = expanded;
            });
          },
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: TextFormField(
                controller: drpQuantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                autofocus: false,
                validator: (value) {
                  if (_isDrpExpanded &&
                      value != null &&
                      value.isNotEmpty &&
                      int.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
                style: GoogleFonts.poppins(color: Colors.black),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        ExpansionTile(
          title: Text(
            'Hosepipe Quantity',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const Icon(Icons.add_circle_outline),
          initiallyExpanded: _isHosepipeExpanded,
          onExpansionChanged: (bool expanded) {
            setState(() {
              _isHosepipeExpanded = expanded;
            });
          },
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: TextFormField(
                controller: hosepipeQuantityController,
                autofocus: false,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (_isHosepipeExpanded &&
                      value != null &&
                      value.isNotEmpty &&
                      int.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
                style: GoogleFonts.poppins(color: Colors.black),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        ExpansionTile(
          title: Text(
            'Hotplate Quantity',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const Icon(Icons.add_circle_outline),
          initiallyExpanded: _isHotplateExpanded,
          onExpansionChanged: (bool expanded) {
            setState(() {
              _isHotplateExpanded = expanded;
            });
          },
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: TextFormField(
                controller: hotplateQuantityController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (_isHotplateExpanded &&
                      value != null &&
                      value.isNotEmpty &&
                      int.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
                style: GoogleFonts.poppins(color: Colors.black),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
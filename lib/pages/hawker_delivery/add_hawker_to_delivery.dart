import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/imports.dart';
import 'package:smart_distributor_app/pages/hawker_delivery/delivery_modal.dart';

class AddHawkerToDelivery extends StatefulWidget {
  Delivery delivery;
  AddHawkerToDelivery({super.key, required this.delivery});

  @override
  State<AddHawkerToDelivery> createState() => _AddHawkerToDeliveryState();
}

class _AddHawkerToDeliveryState extends State<AddHawkerToDelivery> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController cylinderType1Controller;
  late TextEditingController cylinderType2Controller;
  late TextEditingController cylinderType3Controller;
  late TextEditingController amountPaidController;

  final hawkerNameList = ["Sakku", "Ramji", "Shyam", "Santosh"];
  final paymentModeList = ["Cash", "Online", "Monthly", "Advanced"];

  String? selectedHawkerName;
  String? selectedPaymentMode;

  @override
  void initState() {
    super.initState();
    cylinderType1Controller = TextEditingController();
    cylinderType2Controller = TextEditingController();
    cylinderType3Controller = TextEditingController();
    amountPaidController = TextEditingController();
  }

  @override
  void dispose() {
    cylinderType1Controller.dispose();
    cylinderType2Controller.dispose();
    cylinderType3Controller.dispose();
    amountPaidController.dispose();
    super.dispose();
  }

  void _updateDelivery() {
    if (_formKey.currentState!.validate()) {
      final updatedDelivery = Delivery(
        customerId: widget.delivery.customerId,
        customerName: widget.delivery.customerName,
        phoneNumber: widget.delivery.phoneNumber,
        address: widget.delivery.address,
        cylinderType1: widget.delivery.cylinderType1,
        cylinderType2: widget.delivery.cylinderType2,
        cylinderType3: widget.delivery.cylinderType3,
        drpQuantity: widget.delivery.drpQuantity,
        hosepipeQuantity: widget.delivery.hosepipeQuantity,
        hotplateQuantity: widget.delivery.hotplateQuantity,
        amount: widget.delivery.amount,
        amountPaid: amountPaidController.text,
        paymentMode: selectedPaymentMode!,
        hawkerName: selectedHawkerName!,
        returnType1: cylinderType1Controller.text,
        returnType2: cylinderType2Controller.text,
        returnType3: cylinderType3Controller.text,
      );

      print('Updating Delivery: ${updatedDelivery.toMap()}');
      Get.back(result: updatedDelivery);
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
          'Add Delivery Info',
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
                    Text(widget.delivery.customerName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    SizedBox(height: 10),
                    Text(widget.delivery.address,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Hawker Name',
                        border:
                            OutlineInputBorder(),
                      ),
                      value:
                          selectedHawkerName,
                      items: hawkerNameList.map((name) {
                        return DropdownMenuItem<String>(
                          value: name,
                          child: Text(name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedHawkerName = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a hawker name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('14 Kg given - ${widget.delivery.cylinderType1}'),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.42,
                          child: TextFormField(
                            controller: cylinderType1Controller,
                            decoration: const InputDecoration(
                              labelText: '14 Kg returned',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return null;
                              }
                              final number = int.tryParse(value.trim());
                              if (number == null || number < 0) {
                                return 'Value must be a number 0 or greater';
                              }
                              return null;
                            },
                            style: GoogleFonts.poppins(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('19 Kg given - ${widget.delivery.cylinderType2}'),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.42,
                          child: TextFormField(
                            controller: cylinderType2Controller,
                            decoration: const InputDecoration(
                              labelText: '19 Kg returned',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return null;
                              }
                              final number = int.tryParse(value.trim());
                              if (number == null || number < 0) {
                                return 'Value must be a number 0 or greater';
                              }
                              return null;
                            },
                            style: GoogleFonts.poppins(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('5 Kg given - ${widget.delivery.cylinderType3}'),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.42,
                          child: TextFormField(
                            controller: cylinderType3Controller,
                            decoration: const InputDecoration(
                              labelText: '5 Kg returned',
                            ),
                            keyboardType:
                                TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                // Allow empty value
                                return null;
                              }
                              final number = int.tryParse(value.trim());
                              if (number == null || number < 0) {
                                return 'Value must be a number 0 or greater';
                              }
                              return null;
                            },
                            style: GoogleFonts.poppins(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text("Amount -   ₹ ${widget.delivery.amount}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Payment Mode',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedPaymentMode,
                      items: paymentModeList.map((mode) {
                        return DropdownMenuItem<String>(
                          value: mode,
                          child: Text(mode),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMode = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a payment mode';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    selectedPaymentMode == "Cash" ||
                            selectedPaymentMode == "Online"
                        ? TextFormField(
                            controller: amountPaidController,
                            decoration: const InputDecoration(
                              labelText: 'Amount Paid',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return null;
                              }
                              final number = int.tryParse(value.trim());
                              if (number == null || number < 0) {
                                return 'Value must be a number 0 or greater';
                              }
                              return null;
                            },
                            style: GoogleFonts.poppins(color: Colors.black),
                          )
                        : Text(
                            'Amount Paid input is disabled for the selected payment mode.',
                            style: GoogleFonts.poppins(color: primary),
                          ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      text: "Update Delivery",
                      onPressed: _updateDelivery,
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
}

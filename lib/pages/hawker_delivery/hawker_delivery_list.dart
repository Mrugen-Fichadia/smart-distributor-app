import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/imports.dart';
import 'package:smart_distributor_app/pages/customer/customer_add_page.dart';
import 'package:smart_distributor_app/pages/customer/customer_edit_page.dart';
import 'package:smart_distributor_app/pages/customer/customer_modle.dart';
import 'package:smart_distributor_app/pages/hawker_delivery/add_hawker_to_delivery.dart';
import 'package:smart_distributor_app/pages/hawker_delivery/delivery_modal.dart';

class HawkerDeliveryList extends StatefulWidget {
  const HawkerDeliveryList({super.key});

  @override
  State<HawkerDeliveryList> createState() => _HawkerDeliveryListState();
}

class _HawkerDeliveryListState extends State<HawkerDeliveryList> {
  final List<Delivery> dummyDeliveries = [
    Delivery(
      customerId: '1',
      customerName: 'Customer1',
      phoneNumber: '9858794585',
      address: 'Railways',
      cylinderType1: '2',
      cylinderType2: '3',
      cylinderType3: '4',
      drpQuantity: '5',
      hosepipeQuantity: '1',
      hotplateQuantity: '1',
      amount: '1000',
      amountPaid: '',
      paymentMode: '',
      hawkerName: '',
      returnType1: '',
      returnType2: '',
      returnType3: '',
    ),
    Delivery(
      customerId: '2',
      customerName: 'Customer2',
      phoneNumber: '9876543211',
      address: 'Ratlam',
      cylinderType1: '1',
      cylinderType2: '2',
      cylinderType3: '3',
      drpQuantity: '4',
      hosepipeQuantity: '2',
      hotplateQuantity: '1',
      amount: '1200',
      amountPaid: '',
      paymentMode: '',
      hawkerName: '',
      returnType1: '',
      returnType2: '',
      returnType3: '',
    ),
    Delivery(
      customerId: '3',
      customerName: 'Customer3',
      phoneNumber: '9876543212',
      address: 'Gandhinagar',
      cylinderType1: '3',
      cylinderType2: '4',
      cylinderType3: '5',
      drpQuantity: '6',
      hosepipeQuantity: '1',
      hotplateQuantity: '2',
      amount: '1400',
      amountPaid: '',
      paymentMode: '',
      hawkerName: '',
      returnType1: '',
      returnType2: '',
      returnType3: '',
    ),
    Delivery(
      customerId: '4',
      customerName: 'Customer4',
      phoneNumber: '9876543213',
      address: 'Ahmedabad',
      cylinderType1: '2',
      cylinderType2: '3',
      cylinderType3: '4',
      drpQuantity: '5',
      hosepipeQuantity: '2',
      hotplateQuantity: '1',
      amount: '1600',
      amountPaid: '',
      paymentMode: '',
      hawkerName: '',
      returnType1: '',
      returnType2: '',
      returnType3: '',
    ),
    Delivery(
      customerId: '5',
      customerName: 'Customer5',
      phoneNumber: '9876543214',
      address: 'Indore',
      cylinderType1: '1',
      cylinderType2: '2',
      cylinderType3: '3',
      drpQuantity: '4',
      hosepipeQuantity: '1',
      hotplateQuantity: '2',
      amount: '1800',
      amountPaid: '',
      paymentMode: '',
      hawkerName: '',
      returnType1: '',
      returnType2: '',
      returnType3: '',
    ),
    Delivery(
      customerId: '6',
      customerName: 'Customer6',
      phoneNumber: '9876543215',
      address: 'Bhopal',
      cylinderType1: '2',
      cylinderType2: '3',
      cylinderType3: '4',
      drpQuantity: '5',
      hosepipeQuantity: '2',
      hotplateQuantity: '1',
      amount: '2000',
      amountPaid: '',
      paymentMode: '',
      hawkerName: '',
      returnType1: '',
      returnType2: '',
      returnType3: '',
    ),
    Delivery(
      customerId: '7',
      customerName: 'Customer7',
      phoneNumber: '9876543216',
      address: 'Ujjain',
      cylinderType1: '1',
      cylinderType2: '2',
      cylinderType3: '3',
      drpQuantity: '4',
      hosepipeQuantity: '1',
      hotplateQuantity: '1',
      amount: '2200',
      amountPaid: '',
      paymentMode: '',
      hawkerName: '',
      returnType1: '',
      returnType2: '',
      returnType3: '',
    ),
  ];

  void _fetchDeliveries() {
    setState(() {});
  }

  void _navigateToAddHawkerToDelivery(Delivery deliveryToEdit) async {
    final originalId = deliveryToEdit.customerId;

    final result = await Get.to(
      () => AddHawkerToDelivery(delivery: deliveryToEdit),
    );
    if (result != null) {
      if (result is Delivery) {
        setState(() {
          int index = dummyDeliveries.indexWhere((c) => c.customerId == originalId);
          if (index != -1) {
            dummyDeliveries[index] = result;
          }
        });
        CustomSnackBar.show(
          title: 'Success',
          message: 'Delivery updated successfully!',
          backgroundColor: Colors.green,
          textColor: Colors.white,
          icon: const Icon(Icons.check, color: Colors.white),
        );
      }
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
          'Pending Deliveries',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _fetchDeliveries(),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                itemCount: dummyDeliveries.length,
                itemBuilder: (context, index) {
                  Delivery delivery = dummyDeliveries[index];
                  return GestureDetector(
                    onTap: () {
                      _navigateToAddHawkerToDelivery(delivery);
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  delivery.customerName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (delivery.cylinderType1 != '')
                                          Text(
                                            "14 Kg - ${delivery.cylinderType1}",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        if (delivery.cylinderType2 != '')
                                          Text(
                                            "19 Kg - ${delivery.cylinderType2}",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        if (delivery.cylinderType3 != '')
                                          Text(
                                            "5 Kg - ${delivery.cylinderType3}",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                      ],
                                    ),
                                    SizedBox(width: 25),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (delivery.drpQuantity != '')
                                          Text(
                                            "DRP - ${delivery.drpQuantity}",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        if (delivery.hosepipeQuantity != '')
                                          Text(
                                            "Hose Pipe - ${delivery.hosepipeQuantity}",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        if (delivery.hotplateQuantity != '')
                                          Text(
                                            "Hot Plate - ${delivery.hotplateQuantity}",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '₹ ${delivery.amount}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(delivery.address),
                                SizedBox(height: 5),
                                if (delivery.hawkerName != "")
                                Text(delivery.hawkerName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

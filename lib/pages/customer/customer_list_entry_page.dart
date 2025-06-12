import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/imports.dart';
import 'package:smart_distributor_app/pages/customer/customer_add_page.dart';
import 'package:smart_distributor_app/pages/customer/customer_edit_page.dart';
import 'package:smart_distributor_app/pages/customer/customer_modle.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  List<Customer> customers = [
    Customer(
      id: '1',
      name: 'al',
      phoneNumber: '9800000000',
      address: 'N',
    ),
    Customer(
      id: '2',
      name: 'Al',
      phoneNumber: '9876543211',
      address: 'Ca',
    ),
    Customer(
      id: '3',
      name: 'Bo',
      phoneNumber: '9876543212',
      address: 'Ts',
    ),
    Customer(
      id: '4',
      name: 'Cl',
      phoneNumber: '9876543213',
      address: 'Fl',
    ),
  ];

  void _fetchCustomers() {
    setState(() {});
  }

  void _navigateToAddCustomer() async {
    final result = await Get.to(() => const AddCustomerPage());
    if (result != null && result is Customer) {
      setState(() {
        customers.add(result);
      });
      CustomSnackBar.show(
        title: 'Success',
        message: 'Customer added successfully!',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        icon: const Icon(Icons.check, color: Colors.white),
      );
    }
  }

  void _navigateToEditCustomer(Customer customerToEdit) async {
    final originalId = customerToEdit.id;

    final result = await Get.to(
      () => EditCustomerPage(customer: customerToEdit),
    );
    if (result != null) {
      if (result is Customer) {
        setState(() {
          int index = customers.indexWhere((c) => c.id == originalId);
          if (index != -1) {
            customers[index] = result;
          }
        });
        CustomSnackBar.show(
          title: 'Success',
          message: 'Customer updated successfully!',
          backgroundColor: Colors.green,
          textColor: Colors.white,
          icon: const Icon(Icons.check, color: Colors.white),
        );
      } else if (result == 'deleted') {
        setState(() {
          customers.removeWhere((c) => c.id == originalId);
        });
        CustomSnackBar.show(
          title: 'Success',
          message: 'Customer deleted successfully!',
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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: primary,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
           color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Customers',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _fetchCustomers(),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  final customer = customers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      title: Text(
                        customer.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('Phone: ${customer.phoneNumber}'),
                          Text('Address: ${customer.address}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () => _navigateToEditCustomer(customer),
                      ),
                      onTap: () => _navigateToEditCustomer(customer),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: PrimaryButton(
              text: "Add New Customer",
              onPressed: _navigateToAddCustomer,
              isFullWidth: true,
              borderRadius: 12.0,
              // backgroundColor: const Color(0xFFDC2626),
            ),
          ),
        ],
      ),
    );
  }
}

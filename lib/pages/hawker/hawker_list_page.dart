import 'package:flutter/material.dart';
import 'package:smart_distributor_app/imports.dart';

class HawkerListPage extends StatefulWidget {
  const HawkerListPage({super.key});

  @override
  State<HawkerListPage> createState() => _HawkerListPageState();
}

class _HawkerListPageState extends State<HawkerListPage> {
  List<Hawker> hawkers = [
    Hawker(name: 'Ram Bist', phoneNumber: '9841000001', area: 'indore'),
    Hawker(name: 'Shyam Kumar', phoneNumber: '9841000002', area: 'delhi'),
    Hawker(name: 'Rahul', phoneNumber: '9841000003', area: 'gudgaon'),
    Hawker(name: 'Sita', phoneNumber: '9841000004', area: 'bus park'),
    Hawker(name: 'Gita', phoneNumber: '9841000005', area: 'khatima'),
    Hawker(name: 'Hari', phoneNumber: '9841000006', area: 'Boud'),
  ];

  void _fetchHawkers() {
    setState(() {});
  }

  void _navigateToAddHawker() async {
    final result = await Get.to(() => const AddHawkerPage());
    if (result != null && result is Hawker) {
      setState(() {
        hawkers.add(result);
      });
      CustomSnackBar.show(
        title: 'Success',
        message: 'Hawker added successfully!',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        icon: const Icon(Icons.check, color: Colors.white),
      );
    }
  }

  void _navigateToEditHawker(Hawker hawkerToEdit) async {
    final originalPhoneNumber = hawkerToEdit.phoneNumber;
    final originalArea = hawkerToEdit.area;

    final result = await Get.to(() => EditHawkerPage(hawker: hawkerToEdit));
    if (result != null) {
      if (result is Hawker) {
        setState(() {
          int index = hawkers.indexWhere(
            (hawker) =>
                hawker.phoneNumber == originalPhoneNumber &&
                hawker.area == originalArea,
          );
          if (index != -1) {
            hawkers[index] = result;
          }
        });
        CustomSnackBar.show(
          title: 'Success',
          message: 'Hawker updated successfully!',
          backgroundColor: Colors.green,
          textColor: Colors.white,
          icon: const Icon(Icons.check, color: Colors.white),
        );
      } else if (result == 'deleted') {
        setState(() {
          hawkers.removeWhere(
            (hawker) =>
                hawker.phoneNumber == originalPhoneNumber &&
                hawker.area == originalArea,
          );
        });
        CustomSnackBar.show(
          title: 'Success',
          message: 'Hawker deleted successfully!',
          backgroundColor: Colors.green,
          textColor: Colors.white,
          icon: const Icon(Icons.check, color: Colors.white),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomAppBar(
        title: 'Hawkers',
        centerTitle: true,
        onLeadingPressed: () {
          Get.back();
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _fetchHawkers();
              },
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                itemCount: hawkers.length,
                itemBuilder: (context, index) {
                  final hawker = hawkers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      title: Text(
                        hawker.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('Phone: ${hawker.phoneNumber}'),
                          Text('Area: ${hawker.area}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () => _navigateToEditHawker(hawker),
                      ),
                      onTap: () {
                        _navigateToEditHawker(hawker);
                      },
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
              text: "Add New Hawker",
              onPressed: _navigateToAddHawker,
              isFullWidth: true,
              borderRadius: 12.0,
              backgroundColor: const Color(0xFFDC2626),
            ),
          ),
        ],
      ),
    );
  }
}

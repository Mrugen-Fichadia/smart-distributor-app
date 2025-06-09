import 'package:flutter/material.dart';
import 'package:smart_distributor_app/imports.dart';
import 'package:smart_distributor_app/pages/distribution%20center/add_distribution_center_listpage.dart';
import 'package:smart_distributor_app/pages/distribution%20center/edit_distribution_center_page.dart';
import 'package:smart_distributor_app/models/distributioncenter_model.dart';

class DistributionCenterListPage extends StatefulWidget {
  const DistributionCenterListPage({super.key});

  @override
  State<DistributionCenterListPage> createState() =>
      _DistributionCenterListPageState();
}

class _DistributionCenterListPageState
    extends State<DistributionCenterListPage> {
  List<DistributionCenter> distributionCenters = [
    DistributionCenter(name: 'Center 1'),
    DistributionCenter(name: 'Center 2'),
    DistributionCenter(name: 'Center 3'),
    DistributionCenter(name: 'Center 4'),
    DistributionCenter(name: 'Center 5'),
  ];

  void _fetchDistributionCenters() {
    setState(() {});
  }

  void _navigateToAddDistributionCenter() async {
    final result = await Get.to(() => const AddDistributionCenterPage());
    if (result != null && result is DistributionCenter) {
      setState(() {
        distributionCenters.add(result);
      });
      CustomSnackBar.show(
        title: 'Success',
        message: 'Distribution Center added successfully!',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        icon: const Icon(Icons.check, color: Colors.white),
      );
    }
  }

  void _navigateToEditDistributionCenter(
    DistributionCenter centerToEdit,
  ) async {
    final originalName = centerToEdit.name;
    final result = await Get.to(
      () => EditDistributionCenterPage(center: centerToEdit),
    );

    if (result != null) {
      if (result is DistributionCenter) {
        setState(() {
          int index = distributionCenters.indexWhere(
            (center) => center.name == originalName,
          );
          if (index != -1) {
            distributionCenters[index] = result;
          }
        });
        CustomSnackBar.show(
          title: 'Success',
          message: 'Distribution Center updated successfully!',
          backgroundColor: Colors.green,
          textColor: Colors.white,
          icon: const Icon(Icons.check, color: Colors.white),
        );
      } else if (result == 'deleted') {
        setState(() {
          distributionCenters.removeWhere(
            (center) => center.name == originalName,
          );
        });
        CustomSnackBar.show(
          title: 'Success',
          message: 'Distribution Center deleted successfully!',
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
     // ------- app color palete background -------------//
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomAppBar(
        title: 'Distribution Centers',
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
                _fetchDistributionCenters();
              },
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                itemCount: distributionCenters.length,
                itemBuilder: (context, index) {
                  final center = distributionCenters[index];
                  return Card(
      // ------------ container color from color palete----------//
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      title: Text(
                        center.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () =>
                            _navigateToEditDistributionCenter(center),
                      ),
                      onTap: () {
                        _navigateToEditDistributionCenter(center);
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
              text: "Add New Distribution Center",
              onPressed: _navigateToAddDistributionCenter,
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

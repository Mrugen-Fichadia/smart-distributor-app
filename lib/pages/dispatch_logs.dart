import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_distributor_app/common/utils/colors.dart';

class DispatchReturnController extends GetxController {
  final formKey = GlobalKey<FormState>();
  var selectedVehicle = ''.obs;
  var selectedType = ''.obs;

  final vehicles = <String>['Tata Ace', 'Bolero', 'Mahindra Pickup'].obs;
  final types = ['Dispatch', 'Return'];

  final domesticCtrl = TextEditingController(text: '0');
  final commercialCtrl = TextEditingController(text: '0');
  final industrialCtrl = TextEditingController(text: '0');

  final domesticEmptyCtrl = TextEditingController(text: '0');
  final domesticFilledCtrl = TextEditingController(text: '0');
  final commercialEmptyCtrl = TextEditingController(text: '0');
  final commercialFilledCtrl = TextEditingController(text: '0');
  final industrialEmptyCtrl = TextEditingController(text: '0');
  final industrialFilledCtrl = TextEditingController(text: '0');

  var entries = <Map<String, dynamic>>[].obs;

  void addEntries() {
    if (selectedType.value == 'Dispatch') {
      int d = int.tryParse(domesticCtrl.text) ?? 0;
      int c = int.tryParse(commercialCtrl.text) ?? 0;
      int i = int.tryParse(industrialCtrl.text) ?? 0;

      if (d > 0)
        entries.add({
          'type': 'Domestic (14kg)',
          'count': d,
          'action': 'Dispatch',
        });
      if (c > 0)
        entries.add({
          'type': 'Commercial (19kg)',
          'count': c,
          'action': 'Dispatch',
        });
      if (i > 0)
        entries.add({
          'type': 'Industrial (5kg)',
          'count': i,
          'action': 'Dispatch',
        });

      domesticCtrl.text = commercialCtrl.text = industrialCtrl.text = '0';
    } else {
      int de = int.tryParse(domesticEmptyCtrl.text) ?? 0;
      int df = int.tryParse(domesticFilledCtrl.text) ?? 0;
      int ce = int.tryParse(commercialEmptyCtrl.text) ?? 0;
      int cf = int.tryParse(commercialFilledCtrl.text) ?? 0;
      int ie = int.tryParse(industrialEmptyCtrl.text) ?? 0;
      int ifl = int.tryParse(industrialFilledCtrl.text) ?? 0;

      if (de > 0)
        entries.add({
          'type': 'Domestic (14kg)',
          'count': de,
          'action': 'Return',
          'status': 'Empty',
        });
      if (df > 0)
        entries.add({
          'type': 'Domestic (14kg)',
          'count': df,
          'action': 'Return',
          'status': 'Filled',
        });
      if (ce > 0)
        entries.add({
          'type': 'Commercial (19kg)',
          'count': ce,
          'action': 'Return',
          'status': 'Empty',
        });
      if (cf > 0)
        entries.add({
          'type': 'Commercial (19kg)',
          'count': cf,
          'action': 'Return',
          'status': 'Filled',
        });
      if (ie > 0)
        entries.add({
          'type': 'Industrial (5kg)',
          'count': ie,
          'action': 'Return',
          'status': 'Empty',
        });
      if (ifl > 0)
        entries.add({
          'type': 'Industrial (5kg)',
          'count': ifl,
          'action': 'Return',
          'status': 'Filled',
        });

      domesticEmptyCtrl.text = domesticFilledCtrl.text =
          commercialEmptyCtrl.text = commercialFilledCtrl.text =
              industrialEmptyCtrl.text = industrialFilledCtrl.text = '0';
    }
  }
}

class DispatchReturnPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.put(DispatchReturnController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Dispatch/Return Logs',
          style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: BackButton(color: Colors.black),
      ),
      body: Form(
        key: c.formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            final dispatchEntries = c.entries
                .where((e) => e['action'] == 'Dispatch')
                .toList();
            final returnEntries = c.entries
                .where((e) => e['action'] == 'Return')
                .toList();

            final totalDispatch = dispatchEntries.fold<int>(
              0,
              (sum, item) => sum + (item['count'] as int),
            );
            final totalReturnEmpty = returnEntries
                .where((e) => e['status'] == 'Empty')
                .fold<int>(0, (sum, item) => sum + (item['count'] as int));
            final totalReturnFilled = returnEntries
                .where((e) => e['status'] == 'Filled')
                .fold<int>(0, (sum, item) => sum + (item['count'] as int));

            return SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Vehicle',
                      border: OutlineInputBorder(),
                    ),
                    value: c.selectedVehicle.value.isEmpty
                        ? null
                        : c.selectedVehicle.value,
                    items: [
                      ...c.vehicles.map(
                        (v) => DropdownMenuItem(value: v, child: Text(v)),
                      ),
                      const DropdownMenuItem(
                        value: 'Add New',
                        child: Text('Add New Vehicle'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val == 'Add New') {
                        final addCtrl = TextEditingController();
                        Get.defaultDialog(
                          title: "Add Vehicle",
                          content: TextField(
                            controller: addCtrl,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          confirm: ElevatedButton(
                            onPressed: () {
                              if (addCtrl.text.trim().isNotEmpty) {
                                c.vehicles.add(addCtrl.text.trim());
                                c.selectedVehicle.value = addCtrl.text.trim();
                                Get.back();
                              }
                            },
                            child: const Text('Add'),
                          ),
                        );
                      } else {
                        c.selectedVehicle.value = val ?? '';
                      }
                    },
                    validator: (val) => val == null || val.isEmpty
                        ? 'Please select vehicle'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Type',
                      border: OutlineInputBorder(),
                    ),
                    value: c.selectedType.value.isEmpty
                        ? null
                        : c.selectedType.value,
                    items: c.types
                        .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                        .toList(),
                    onChanged: (val) => c.selectedType.value = val ?? '',
                    validator: (val) => val == null || val.isEmpty
                        ? 'Please select type'
                        : null,
                  ),
                  const SizedBox(height: 24),

                  // Dispatch Fields
                  if (c.selectedType.value == 'Dispatch') ...[
                    TextFormField(
                      controller: c.domesticCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Domestic (14kg)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: c.commercialCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Commercial (19kg)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: c.industrialCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Industrial (5kg)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ] else if (c.selectedType.value == 'Return') ...[
                    Row(
                      children: const [
                        Expanded(
                          child: Center(
                            child: Text(
                              'Empty',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Filled',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: c.domesticEmptyCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Domestic (14kg)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: c.domesticFilledCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Domestic (14kg)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: c.commercialEmptyCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Commercial (19kg)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: c.commercialFilledCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Commercial (19kg)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: c.industrialEmptyCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Industrial (5kg)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: c.industrialFilledCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Industrial (5kg)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  if (c.selectedVehicle.value.isNotEmpty &&
                      c.selectedType.value.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: c.addEntries,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 24,
                        ),
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(color: offwhite, fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  if (dispatchEntries.isNotEmpty) ...[
                    Text(
                      'Dispatch Summary',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    ...dispatchEntries.map(
                      (e) => ListTile(
                        title: Text(e['type']),
                        trailing: Text('${e['count']}'),
                      ),
                    ),
                    ListTile(
                      title: const Text('Total Dispatch'),
                      trailing: Text('$totalDispatch'),
                    ),
                    const Divider(),
                  ],
                  if (returnEntries.isNotEmpty) ...[
                    Text(
                      'Return Summary',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    ...returnEntries.map(
                      (e) => ListTile(
                        title: Text('${e['type']} - ${e['status']}'),
                        trailing: Text('${e['count']}'),
                      ),
                    ),
                    ListTile(
                      title: const Text('Total Empty'),
                      trailing: Text('$totalReturnEmpty'),
                    ),
                    ListTile(
                      title: const Text('Total Filled'),
                      trailing: Text('$totalReturnFilled'),
                    ),
                    const Divider(),
                  ],

                  if (c.entries.isNotEmpty)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: primary, shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)), padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20)),
                      onPressed: () {
                        Get.snackbar(
                          'Saved',
                          'Entries saved successfully',
                          backgroundColor: primary,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: const Text('Save All', style: TextStyle(color: offwhite, fontSize: 20),),
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

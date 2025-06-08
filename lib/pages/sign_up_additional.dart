import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdditionalSignUpPage extends StatefulWidget {
  const AdditionalSignUpPage({super.key});

  @override
  State<AdditionalSignUpPage> createState() => _AdditionalSignUpPageState();
}

class _AdditionalSignUpPageState extends State<AdditionalSignUpPage> {
  String? _selectedCompany;
  final _agencyNameController = TextEditingController();
  final _distributorNumberController = TextEditingController();
  final _vehicleController = TextEditingController();

  final List<Map<String, dynamic>> _managerControllers = [];
  final List<Map<String, dynamic>> _workerControllers = [];
  final List<Map<String, dynamic>> _distributionCenters = [];

  bool _showVehicleField = false;
  bool _vehicleSaved = false;

  @override
  void dispose() {
    _agencyNameController.dispose();
    _distributorNumberController.dispose();
    _vehicleController.dispose();

    for (var m in _managerControllers) {
      m['name'].dispose();
      m['email'].dispose();
      m['mobile'].dispose();
    }

    for (var w in _workerControllers) {
      w['name'].dispose();
      w['email'].dispose();
      w['mobile'].dispose();
    }

    for (var d in _distributionCenters) {
      d['controller'].dispose();
    }

    super.dispose();
  }

  void _addManagerField() {
    _managerControllers.add({
      'name': TextEditingController(),
      'email': TextEditingController(),
      'mobile': TextEditingController(),
      'isSaved': false,
    });
    setState(() {});
  }

  void _addWorkerField() {
    _workerControllers.add({
      'name': TextEditingController(),
      'email': TextEditingController(),
      'mobile': TextEditingController(),
      'isSaved': false,
    });
    setState(() {});
  }

  void _addDistributionCenter() {
    _distributionCenters.add({
      'controller': TextEditingController(),
      'isSaved': false,
    });
    setState(() {});
  }

  void _savePerson(List<Map<String, dynamic>> list, int index) {
    final person = list[index];
    final name = person['name'].text.trim();
    final email = person['email'].text.trim();
    final mobile = person['mobile'].text.trim();

    if (name.isNotEmpty && email.isNotEmpty && mobile.isNotEmpty) {
      person['isSaved'] = true;
      setState(() {});
      _showSnackBar("Saved successfully!");
    } else {
      _showSnackBar("Please fill all fields.");
    }
  }

  void _saveDistributionCenter(int index) {
    final dc = _distributionCenters[index];
    final name = dc['controller'].text.trim();
    if (name.isNotEmpty) {
      dc['isSaved'] = true;
      setState(() {});
      _showSnackBar("Distribution Center Saved");
    } else {
      _showSnackBar("Enter name first");
    }
  }

  void _toggleVehicleField() {
    setState(() {
      _showVehicleField = !_showVehicleField;
      _vehicleSaved = false;
    });
  }

  void _saveVehicle() {
    if (_vehicleController.text.trim().isNotEmpty) {
      setState(() {
        _vehicleSaved = true;
      });
      _showSnackBar("Vehicle Saved");
    } else {
      _showSnackBar("Enter vehicle name");
    }
  }

  Future<void> _submitDataToFirestore() async {
    try {
      final managers = _managerControllers
          .map(
            (m) => {
              'name': m['name'].text.trim(),
              'email': m['email'].text.trim(),
              'mobile': m['mobile'].text.trim(),
            },
          )
          .toList();

      final workers = _workerControllers
          .map(
            (w) => {
              'name': w['name'].text.trim(),
              'email': w['email'].text.trim(),
              'mobile': w['mobile'].text.trim(),
            },
          )
          .toList();

      final distributionCenters = _distributionCenters
          .map((d) => d['controller'].text.trim())
          .toList();

      final data = {
        'company': _selectedCompany,
        'agencyName': _agencyNameController.text.trim(),
        'distributorNumber': _distributorNumberController.text.trim(),
        'vehicle': _vehicleController.text.trim(),
        'managers': managers,
        'workers': workers,
        'distributionCenters': distributionCenters,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('signups').add(data);
      _showSnackBar("Data submitted successfully!");
    } catch (e) {
      _showSnackBar("Error: $e");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Additional Signup")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Select Company"),
            value: _selectedCompany,
            items: [
              'Indian Oil Corporation Ltd. (Indane)',
              'Bharat Petroleum Corporation Ltd.',
              'Hindustan Petroleum Corporation Ltd.',
              'Reliance Petroleum Ltd.',
              'Total Energies SE',
              'Shell',
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) => setState(() => _selectedCompany = val),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _agencyNameController,
            decoration: const InputDecoration(labelText: "Agency Name"),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _distributorNumberController,
            decoration: const InputDecoration(labelText: "Distributor Number"),
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 24),
          _buildExpandableSection(
            title: "Add Manager",
            controllers: _managerControllers,
            onAdd: _addManagerField,
            onSave: (i) => _savePerson(_managerControllers, i),
            label: "Manager",
          ),
          _buildExpandableSection(
            title: "Add Worker",
            controllers: _workerControllers,
            onAdd: _addWorkerField,
            onSave: (i) => _savePerson(_workerControllers, i),
            label: "Worker",
          ),
          _buildDistributionCenterSection(),
          _buildVehicleSection(),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitDataToFirestore,
            child: const Text("Submit to Firebase"),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required List<Map<String, dynamic>> controllers,
    required VoidCallback onAdd,
    required void Function(int index) onSave,
    required String label,
  }) {
    return Card(
      child: ExpansionTile(
        title: Text(title),
        children: [
          for (int i = 0; i < controllers.length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: controllers[i]['name'],
                    decoration: InputDecoration(labelText: "$label Name"),
                  ),
                  TextFormField(
                    controller: controllers[i]['email'],
                    decoration: InputDecoration(labelText: "$label Email"),
                  ),
                  TextFormField(
                    controller: controllers[i]['mobile'],
                    decoration: InputDecoration(labelText: "$label Mobile"),
                  ),
                  ElevatedButton(
                    onPressed: () => onSave(i),
                    child: Text("Save $label"),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          _buildAddButton(onAdd, "Add $label"),
        ],
      ),
    );
  }

  Widget _buildDistributionCenterSection() {
    return Card(
      child: ExpansionTile(
        title: const Text("Add Distribution Center"),
        children: [
          for (int i = 0; i < _distributionCenters.length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _distributionCenters[i]['controller'],
                    decoration: const InputDecoration(
                      labelText: "Distribution Center Name",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _saveDistributionCenter(i),
                    child: const Text("Save Center"),
                  ),
                ],
              ),
            ),
          _buildAddButton(_addDistributionCenter, "Add Center"),
        ],
      ),
    );
  }

  Widget _buildVehicleSection() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text("Add Vehicle"),
            trailing: Icon(Icons.add),
            onTap: _toggleVehicleField,
          ),
          if (_showVehicleField && !_vehicleSaved)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _vehicleController,
                    decoration: const InputDecoration(
                      labelText: "Vehicle Name",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _saveVehicle,
                    child: const Text("Save Vehicle"),
                  ),
                ],
              ),
            ),
          if (_vehicleSaved)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "Saved Vehicle: ${_vehicleController.text}",
                style: const TextStyle(color: Colors.green),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddButton(VoidCallback onPressed, String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton.icon(
        icon: const Icon(Icons.add),
        label: Text(label),
        onPressed: onPressed,
      ),
    );
  }
}

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

  // ignore: prefer_final_fields
  List<Map<String, dynamic>> _managerControllers = [];
  // ignore: prefer_final_fields
  List<Map<String, dynamic>> _workerControllers = [];
  // ignore: prefer_final_fields
  List<Map<String, dynamic>> _distributionCenters = [];

  bool _showVehicleField = false;
  final _vehicleController = TextEditingController();
  bool _vehicleSaved = false;

  @override
  void dispose() {
    _agencyNameController.dispose();
    _distributorNumberController.dispose();

    for (var m in _managerControllers) {
      m['name']?.dispose();
      m['email']?.dispose();
      m['mobile']?.dispose();
    }

    for (var w in _workerControllers) {
      w['name']?.dispose();
      w['email']?.dispose();
      w['mobile']?.dispose();
    }

    for (var d in _distributionCenters) {
      d['controller'].dispose();
    }

    _vehicleController.dispose();
    super.dispose();
  }

  void _addManagerField() {
    setState(() {
      _managerControllers.add({
        'name': TextEditingController(),
        'email': TextEditingController(),
        'mobile': TextEditingController(),
        'isSaved': false,
      });
    });
  }

  void _saveManager(int index) {
    final manager = _managerControllers[index];
    final name = manager['name']!.text.trim();
    final email = manager['email']!.text.trim();
    final mobile = manager['mobile']!.text.trim();

    if (name.isNotEmpty && email.isNotEmpty && mobile.isNotEmpty) {
      setState(() {
        manager['isSaved'] = true;
      });
      _showSnackBar("Manager Saved");
    } else {
      _showSnackBar("Please fill all fields before saving");
    }
  }

  void _addWorkerField() {
    setState(() {
      _workerControllers.add({
        'name': TextEditingController(),
        'email': TextEditingController(),
        'mobile': TextEditingController(),
        'isSaved': false,
      });
    });
  }

  void _saveWorker(int index) {
    final worker = _workerControllers[index];
    final name = worker['name']!.text.trim();
    final email = worker['email']!.text.trim();
    final mobile = worker['mobile']!.text.trim();

    if (name.isNotEmpty && email.isNotEmpty && mobile.isNotEmpty) {
      setState(() {
        worker['isSaved'] = true;
      });
      _showSnackBar("Worker Saved");
    } else {
      _showSnackBar("Please fill all fields before saving");
    }
  }

  void _addDistributionCenter() {
    setState(() {
      _distributionCenters.add({
        'controller': TextEditingController(),
        'isSaved': false,
      });
    });
  }

  void _saveDistributionCenter(int index) {
    final dc = _distributionCenters[index];
    final name = dc['controller'].text.trim();
    if (name.isNotEmpty) {
      setState(() {
        dc['isSaved'] = true;
      });
      _showSnackBar("Distribution Center Saved");
    } else {
      _showSnackBar("Please enter a name before saving");
    }
  }

  void _toggleVehicleField() {
    setState(() {
      _showVehicleField = !_showVehicleField;
      _vehicleSaved = false;
    });
  }

  void _saveVehicle() {
    final vehicle = _vehicleController.text.trim();
    if (vehicle.isNotEmpty) {
      setState(() {
        _vehicleSaved = true;
      });
      _showSnackBar("Vehicle Saved");
    } else {
      _showSnackBar("Please enter a vehicle name");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Additional Details"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Select Company',
              border: OutlineInputBorder(),
            ),
            value: _selectedCompany,
            items:
                [
                  'Indian Oil Corporation Ltd. (Indane)',
                  'Bharat Petroleum Corporation Ltd.',
                  'Hindustan Petroleum Corporation Ltd.',
                  'Reliance Petroleum Ltd.',
                  'Total Energies SE',
                  'Shell',
                ].map((company) {
                  return DropdownMenuItem(
                    value: company,
                    child: Text(company, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
            onChanged: (value) => setState(() => _selectedCompany = value),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _agencyNameController,
            decoration: const InputDecoration(labelText: 'Agency Name'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _distributorNumberController,
            decoration: const InputDecoration(labelText: 'Distributor Number'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          const Text(
            'Additional Options',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildManagerSection(),
          _buildWorkerSection(),
          _buildDistributionCenterSection(),
          _buildVehicleSection(),
          const SizedBox(height: 24),
          // Sign Up Button Added Here
          ElevatedButton(
            onPressed: () {
              _showSnackBar("Sign Up button pressed");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Sign Up",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagerSection() {
    return _buildExpandableListTile(
      title: 'Add Manager',
      icon: Icons.add,
      children: [
        ..._managerControllers.asMap().entries.map((entry) {
          final index = entry.key;
          final manager = entry.value;
          return _buildPersonForm(manager, index, _saveManager, 'Manager');
        }),
        if (_managerControllers.isEmpty || _managerControllers.last['isSaved'])
          _buildAddButton(
            _addManagerField,
            'Add More Manager',
            Icons.person_add,
          ),
      ],
    );
  }

  Widget _buildWorkerSection() {
    return _buildExpandableListTile(
      title: 'Add Worker',
      icon: Icons.add,
      children: [
        ..._workerControllers.asMap().entries.map((entry) {
          final index = entry.key;
          final worker = entry.value;
          return _buildPersonForm(worker, index, _saveWorker, 'Worker');
        }),
        if (_workerControllers.isEmpty || _workerControllers.last['isSaved'])
          _buildAddButton(_addWorkerField, 'Add More Worker', Icons.person_add),
      ],
    );
  }

  Widget _buildPersonForm(
    Map<String, dynamic> person,
    int index,
    void Function(int) onSave,
    String role,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Divider(),
          TextFormField(
            controller: person['name'],
            decoration: InputDecoration(labelText: '$role Name'),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: person['email'],
            decoration: InputDecoration(labelText: '$role Email'),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: person['mobile'],
            decoration: InputDecoration(labelText: '$role Mobile'),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => onSave(index),
            icon: const Icon(Icons.check),
            label: Text("Save $role"),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildAddButton(VoidCallback onPressed, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }

  Widget _buildDistributionCenterSection() {
    return _buildExpandableListTile(
      title: 'Add Distribution Center',
      icon: Icons.add,
      children: [
        ..._distributionCenters.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [
                TextFormField(
                  controller: item['controller'],
                  decoration: const InputDecoration(
                    labelText: 'Distribution Center Name',
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _saveDistributionCenter(index),
                  icon: const Icon(Icons.save),
                  label: const Text("Save Distribution Center"),
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
        }),
        _buildAddButton(
          _addDistributionCenter,
          'Add More Distribution Center',
          Icons.add_location_alt,
        ),
      ],
    );
  }

  Widget _buildVehicleSection() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          ListTile(
            title: const Text(
              'Add Vehicle',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Icon(Icons.add, color: Colors.blue[600]),
            onTap: _toggleVehicleField,
          ),
          if (_showVehicleField && !_vehicleSaved)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _vehicleController,
                    decoration: const InputDecoration(
                      labelText: 'Vehicle Name',
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _saveVehicle,
                    icon: const Icon(Icons.save),
                    label: const Text("Save Vehicle"),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          if (_vehicleSaved)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                "Vehicle Saved: ${_vehicleController.text}",
                style: const TextStyle(color: Colors.green),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExpandableListTile({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Icon(icon, color: Colors.blue),
        children: children,
      ),
    );
  }
}

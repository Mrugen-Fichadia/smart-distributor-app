import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_distributor_app/common/utils/colors.dart';
import 'package:smart_distributor_app/pages/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_distributor_app/pages/home.dart';
import 'package:smart_distributor_app/pages/tools.dart';

// Enum for the two main views
enum AuthMode { signIn, signUp }

// Enum for the user roles
enum UserRole { distributor, manager, worker }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // State variables
  AuthMode _authMode = AuthMode.signIn;
  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers for text fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _agencyNameController = TextEditingController();
  final _distributorNumberController = TextEditingController();

  String? _selectedCompany;
  UserRole _selectedRole = UserRole.distributor;

  // --- STATE & METHODS FOR DYNAMIC FORMS ---

  final List<Map<String, dynamic>> _managerControllers = [];
  final List<Map<String, dynamic>> _workerControllers = [];
  final List<Map<String, dynamic>> _distributionCenterControllers = [];
  final List<Map<String, dynamic>> _vehicleControllers = [];

  bool _isManagerExpanded = false;
  bool _isWorkerExpanded = false;
  bool _isDistributionCenterExpanded = false;
  bool _isVehicleExpanded = false;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // --- Firebase Submit Logic ---
  Future<void> _submit() async {
    final prefs = await SharedPreferences.getInstance();

    final isValid = _authMode == AuthMode.signIn
        ? _signInFormKey.currentState!.validate()
        : _signUpFormKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential authResult;

      if (_authMode == AuthMode.signUp) {
        // --- SIGN UP LOGIC (FOR DISTRIBUTORS ONLY) ---
        authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        final List<Map<String, String>> managers = _managerControllers
            .where((m) => m['isSaved'] == true)
            .map<Map<String, String>>(
              (m) => {
                'name': m['name']!.text,
                'email': m['email']!.text,
                'mobile': m['mobile']!.text,
              },
            )
            .toList();

        final List<Map<String, String>> workers = _workerControllers
            .where((w) => w['isSaved'] == true)
            .map<Map<String, String>>(
              (w) => {
                'name': w['name']!.text,
                'email': w['email']!.text,
                'mobile': w['mobile']!.text,
              },
            )
            .toList();

        final List<String> distributionCenters = _distributionCenterControllers
            .where((dc) => dc['isSaved'] == true)
            .map<String>((dc) => dc['name']!.text)
            .toList();

        final List<String> vehicles = _vehicleControllers
            .where((v) => v['isSaved'] == true)
            .map<String>((v) => v['name']!.text)
            .toList();

        await prefs.setString('role', _selectedRole.toString());

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
              'fullName': _fullNameController.text.trim(),
              'email': _emailController.text.trim(),
              'company': _selectedCompany,
              'agencyName': _agencyNameController.text.trim(),
              'distributorNumber': _distributorNumberController.text.trim(),
              'role': 'distributor',
              'managers': managers,
              'workers': workers,
              'distributionCenters': distributionCenters,
              'vehicles': vehicles,
              'createdAt': Timestamp.now(),
            });

        prefs.setString('role', 'distributor');

        // After signing up, navigate to distributor home
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const Dashboard()),
          );
        }
      } else {
        // --- SIGN IN LOGIC (FOR ALL ROLES) ---
        authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Fetch user role from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .get();

        if (!userDoc.exists) {
          _showSnackBar('No user data found. Please contact support.');
          return;
        }

        final userRole = userDoc.data()?['role'];

        if (!mounted) return;

        prefs.setString('role', userRole);
        // Navigate based on role
        switch (userRole) {
          case 'distributor':
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => const MyHomePage()),
            );
            break;
          case 'manager':
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => const MyHomePage()),
            );
            break;
          case 'worker':
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => const Tools()),
            );
            break;
          default:
            _showSnackBar('Unknown role. Cannot log in.');
            await FirebaseAuth.instance
                .signOut(); // Sign out user with unknown role
        }
      }
    } on FirebaseAuthException catch (err) {
      var message = 'An error occurred, please check your credentials!';
      if (err.message != null) {
        message = err.message!;
      }
      _showSnackBar(message);
    } catch (err) {
      print("Error details: $err");
      _showSnackBar('An unexpected error occurred. Check debug console.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // --- Manager Methods ---
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Manager Saved"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      _showSnackBar("Please fill all manager fields before saving");
    }
  }

  void _editManager(int index) {
    setState(() {
      _managerControllers[index]['isSaved'] = false;
    });
  }

  // --- Worker Methods ---
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Worker Saved"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      _showSnackBar("Please fill all worker fields before saving");
    }
  }

  void _editWorker(int index) {
    setState(() {
      _workerControllers[index]['isSaved'] = false;
    });
  }

  // --- Distribution Center Methods ---
  void _addDistributionCenterField() {
    setState(() {
      _distributionCenterControllers.add({
        'name': TextEditingController(),
        'isSaved': false,
      });
    });
  }

  void _saveDistributionCenter(int index) {
    final dc = _distributionCenterControllers[index];
    final name = dc['name']!.text.trim();
    if (name.isNotEmpty) {
      setState(() {
        dc['isSaved'] = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Distribution Center Saved"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      _showSnackBar("Please enter a name before saving");
    }
  }

  void _editDistributionCenter(int index) {
    setState(() {
      _distributionCenterControllers[index]['isSaved'] = false;
    });
  }

  // --- Vehicle Methods ---
  void _addVehicleField() {
    setState(() {
      _vehicleControllers.add({
        'name': TextEditingController(),
        'isSaved': false,
      });
    });
  }

  void _saveVehicle(int index) {
    final vehicle = _vehicleControllers[index];
    final name = vehicle['name']!.text.trim();
    if (name.isNotEmpty) {
      setState(() {
        vehicle['isSaved'] = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vehicle Saved"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      _showSnackBar("Please enter a name before saving");
    }
  }

  void _editVehicle(int index) {
    setState(() {
      _vehicleControllers[index]['isSaved'] = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
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
    for (var d in _distributionCenterControllers) {
      d['name']?.dispose();
    }
    for (var v in _vehicleControllers) {
      v['name']?.dispose();
    }
    super.dispose();
  }

  void _switchAuthMode(AuthMode mode) {
    setState(() {
      _authMode = mode;
    });
  }

  // --- WIDGETS ---

  Widget _buildSignInForm() {
    return Form(
      key: _signInFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Welcome back",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                !value!.contains('@') ? 'Please enter a valid email.' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password (or Mobile No. for Staff)',
            ),
            obscureText: true,
            validator: (value) =>
                value!.length < 6 ? 'Password must be 6+ characters.' : null,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Select Role",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _RoleSquareCard(
                label: 'Distributor',
                imagePath: 'assets/images/boss.png',
                selected: _selectedRole == UserRole.distributor,
                onTap: () {
                  setState(() => _selectedRole = UserRole.distributor);
                },
              ),
              _RoleSquareCard(
                label: 'Manager',
                imagePath: 'assets/images/manager.png',
                selected: _selectedRole == UserRole.manager,
                onTap: () {
                  setState(() => _selectedRole = UserRole.manager);
                },
              ),
              _RoleSquareCard(
                label: 'Worker',
                imagePath: 'assets/images/editor.png',
                selected: _selectedRole == UserRole.worker,
                onTap: () {
                  setState(() => _selectedRole = UserRole.worker);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _signUpFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Create an account",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _fullNameController,
            decoration: const InputDecoration(labelText: 'Full Name'),
            validator: (value) =>
                value!.isEmpty ? 'Please enter your full name.' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                !value!.contains('@') ? 'Please enter a valid email.' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) =>
                value!.length < 6 ? 'Password must be 6+ characters.' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            isExpanded: true,
            value: _selectedCompany,
            decoration: const InputDecoration(labelText: 'Select Company'),
            items:
                [
                      'Indian Oil Corporation Ltd. (Indane)',
                      'Bharat Petroleum Corporation Ltd.',
                      'Hindustan Petroleum Corporation Ltd.',
                      'Reliance Petroleum Ltd.',
                      'Total Energies SE',
                      'Shell',
                    ]
                    .map(
                      (company) => DropdownMenuItem(
                        value: company,
                        child: Text(company, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
            onChanged: (value) => setState(() => _selectedCompany = value),
            validator: (value) =>
                value == null ? 'Please select a company.' : null,
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
          _buildAdditionalOptionsSection(),
        ],
      ),
    );
  }

  Widget _buildAdditionalOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Options',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildManagerSection(),
        _buildWorkerSection(),
        _buildDistributionCenterSection(),
        _buildVehicleSection(),
      ],
    );
  }

  Widget _buildManagerSection() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        title: const Text(
          'Add Manager',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          _isManagerExpanded ? Icons.remove : Icons.add,
          color: primary,
        ),
        onExpansionChanged: (isExpanded) {
          setState(() {
            _isManagerExpanded = isExpanded;
          });
        },
        children: [
          ..._managerControllers.asMap().entries.map((entry) {
            final index = entry.key;
            final manager = entry.value;
            return _buildPersonForm(
              person: manager,
              index: index,
              onSave: _saveManager,
              onEdit: _editManager,
              role: 'Manager',
            );
          }),
          if (_managerControllers.isEmpty ||
              _managerControllers.last['isSaved'])
            _buildAddButton(
              _addManagerField,
              'Add More Managers',
              Icons.person_add,
            ),
        ],
      ),
    );
  }

  Widget _buildWorkerSection() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        title: const Text(
          'Add Worker',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          _isWorkerExpanded ? Icons.remove : Icons.add,
          color: primary,
        ),
        onExpansionChanged: (isExpanded) {
          setState(() {
            _isWorkerExpanded = isExpanded;
          });
        },
        children: [
          ..._workerControllers.asMap().entries.map((entry) {
            final index = entry.key;
            final worker = entry.value;
            return _buildPersonForm(
              person: worker,
              index: index,
              onSave: _saveWorker,
              onEdit: _editWorker,
              role: 'Worker',
            );
          }),
          if (_workerControllers.isEmpty || _workerControllers.last['isSaved'])
            _buildAddButton(
              _addWorkerField,
              'Add More Workers',
              Icons.person_add,
            ),
        ],
      ),
    );
  }

  Widget _buildDistributionCenterSection() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        title: const Text(
          'Add Distribution Center',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          _isDistributionCenterExpanded ? Icons.remove : Icons.add,
          color: primary,
        ),
        onExpansionChanged: (isExpanded) {
          setState(() {
            _isDistributionCenterExpanded = isExpanded;
          });
        },
        children: [
          ..._distributionCenterControllers.asMap().entries.map((entry) {
            final index = entry.key;
            final dc = entry.value;
            return _buildSingleFieldForm(
              item: dc,
              index: index,
              onSave: _saveDistributionCenter,
              onEdit: _editDistributionCenter,
              label: 'Distribution Center Name',
              role: 'Center',
            );
          }),
          if (_distributionCenterControllers.isEmpty ||
              _distributionCenterControllers.last['isSaved'])
            _buildAddButton(
              _addDistributionCenterField,
              'Add More Centers',
              Icons.add_location_alt,
            ),
        ],
      ),
    );
  }

  Widget _buildVehicleSection() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        title: const Text(
          'Add Vehicle',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          _isVehicleExpanded ? Icons.remove : Icons.add,
          color: primary,
        ),
        onExpansionChanged: (isExpanded) {
          setState(() {
            _isVehicleExpanded = isExpanded;
          });
        },
        children: [
          ..._vehicleControllers.asMap().entries.map((entry) {
            final index = entry.key;
            final vehicle = entry.value;
            return _buildSingleFieldForm(
              item: vehicle,
              index: index,
              onSave: _saveVehicle,
              onEdit: _editVehicle,
              label: 'Vehicle Name',
              role: 'Vehicle',
            );
          }),
          if (_vehicleControllers.isEmpty ||
              _vehicleControllers.last['isSaved'])
            _buildAddButton(
              _addVehicleField,
              'Add More Vehicles',
              Icons.directions_car,
            ),
        ],
      ),
    );
  }

  Widget _buildPersonForm({
    required Map<String, dynamic> person,
    required int index,
    required void Function(int) onSave,
    required void Function(int) onEdit,
    required String role,
  }) {
    final bool isSaved = person['isSaved'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Divider(),
          TextFormField(
            controller: person['name'],
            decoration: InputDecoration(labelText: '$role Name'),
            enabled: !isSaved,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: person['email'],
            decoration: InputDecoration(labelText: '$role Email'),
            keyboardType: TextInputType.emailAddress,
            enabled: !isSaved,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: person['mobile'],
            decoration: InputDecoration(labelText: '$role Mobile'),
            keyboardType: TextInputType.phone,
            enabled: !isSaved,
          ),
          const SizedBox(height: 12),
          if (!isSaved)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: offwhite,
              ),
              onPressed: () => onSave(index),
              icon: const Icon(Icons.check),
              label: Text("Save $role"),
            ),
          if (isSaved)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$role Saved!",
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 30,
                  child: OutlinedButton.icon(
                    onPressed: () => onEdit(index),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      side: BorderSide(color: primary),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSingleFieldForm({
    required Map<String, dynamic> item,
    required int index,
    required void Function(int) onSave,
    required void Function(int) onEdit,
    required String label,
    required String role,
  }) {
    final bool isSaved = item['isSaved'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Divider(),
          TextFormField(
            controller: item['name'],
            decoration: InputDecoration(labelText: label),
            enabled: !isSaved,
          ),
          const SizedBox(height: 12),
          if (!isSaved)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: offwhite,
              ),
              onPressed: () => onSave(index),
              icon: const Icon(Icons.check),
              label: Text("Save $role"),
            ),
          if (isSaved)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$role Saved!",
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 30,
                  child: OutlinedButton.icon(
                    onPressed: () => onEdit(index),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      side: BorderSide(color: primary),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildAddButton(VoidCallback onPressed, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/app_icon.png'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome to our LPG distribution service!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  _CustomToggle(
                    selectedIndex: _authMode.index,
                    labels: const ['Sign In', 'Sign Up'],
                    onTap: (index) {
                      _switchAuthMode(AuthMode.values[index]);
                    },
                  ),
                  const SizedBox(height: 30),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    child: _authMode == AuthMode.signIn
                        ? _buildSignInForm()
                        : _buildSignUpForm(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _AuthButton(
                      label: _authMode == AuthMode.signIn
                          ? 'Sign In'
                          : 'Sign Up',
                      onPressed: _submit,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomToggle extends StatelessWidget {
  final int selectedIndex;
  final List<String> labels;
  final Function(int) onTap;

  const _CustomToggle({
    required this.selectedIndex,
    required this.labels,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isSelected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? offwhite : Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _AuthButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: offwhite,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        child: Text(label),
      ),
    );
  }
}

class _RoleSquareCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool selected;
  final VoidCallback onTap;

  const _RoleSquareCard({
    required this.label,
    required this.imagePath,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 100,
        decoration: BoxDecoration(
          color: selected ? Colors.blue.shade50 : Colors.white,
          border: Border.all(
            color: selected ? Colors.blue : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 40, height: 40),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected ? Colors.blue : Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- PLACEHOLDER HOME SCREENS ---
// In a real app, these would be in their own files.

class DistributorHomeScreen extends StatelessWidget {
  const DistributorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Distributor Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => const AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: const Center(child: Text('Welcome, Distributor!')),
    );
  }
}

class ManagerHomeScreen extends StatelessWidget {
  const ManagerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => const AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: const Center(child: Text('Welcome, Manager!')),
    );
  }
}

class WorkerHomeScreen extends StatelessWidget {
  const WorkerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => const AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: const Center(child: Text('Welcome, Worker!')),
    );
  }
}

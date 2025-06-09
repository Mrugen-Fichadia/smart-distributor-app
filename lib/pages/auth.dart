import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart'; // Import your home.dart file
import 'forgotpass.dart';

// Enum for the two main views
enum AuthMode { signIn, signUp }

// Enum for the user roles
enum UserRole { distributor, manager, worker }

class AuthScreen extends StatefulWidget {
  // Initialize static color variables to prevent null errors
  static const Color darkGray = Color(0xFF666666);
  static const Color lightMaroon = Color(0xFFB22222);
  static const Color primaryMaroon = Color(0xFF8B0000);
  static const Color offWhite = Color(0xFFFAF9F6);

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

  // Color scheme (kept for reference, but static variables in AuthScreen are used)
  static const Color primaryMaroon = Color(0xFF8B0000);
  static const Color lightMaroon = Color(0xFFB22222);
  static const Color offWhite = Color(0xFFFAF9F6);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color darkGray = Color(0xFF666666);

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
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: primaryMaroon,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // --- Firebase Submit Logic ---
  Future<void> _submit() async {
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

        final userId = authResult.user!.uid;
        final userDocRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId);

        // Save user document with basic fields
        await userDocRef.set({
          'fullName': _fullNameController.text.trim(),
          'email': _emailController.text.trim(),
          'company': _selectedCompany,
          'agencyName': _agencyNameController.text.trim(),
          'distributorNumber': _distributorNumberController.text.trim(),
          'role': 'distributor',
          'createdAt': Timestamp.now(),
        });

        // Save managers to subcollection
        final managersCollection = userDocRef.collection('managers');
        for (var manager in _managerControllers.where(
          (m) => m['isSaved'] == true,
        )) {
          await managersCollection.add({
            'name': manager['name']!.text.trim(),
            'email': manager['email']!.text.trim(),
            'mobile': manager['mobile']!.text.trim(),
            'createdAt': Timestamp.now(),
          });
        }

        // Save workers to subcollection
        final workersCollection = userDocRef.collection('workers');
        for (var worker in _workerControllers.where(
          (w) => w['isSaved'] == true,
        )) {
          await workersCollection.add({
            'name': worker['name']!.text.trim(),
            'email': worker['email']!.text.trim(),
            'mobile': worker['mobile']!.text.trim(),
            'createdAt': Timestamp.now(),
          });
        }

        // Save distribution centers to subcollection
        final distributionCentersCollection = userDocRef.collection(
          'distributionCenters',
        );
        for (var dc in _distributionCenterControllers.where(
          (dc) => dc['isSaved'] == true,
        )) {
          await distributionCentersCollection.add({
            'name': dc['name']!.text.trim(),
            'createdAt': Timestamp.now(),
          });
        }

        // Save vehicles to subcollection
        final vehiclesCollection = userDocRef.collection('vehicles');
        for (var vehicle in _vehicleControllers.where(
          (v) => v['isSaved'] == true,
        )) {
          await vehiclesCollection.add({
            'name': vehicle['name']!.text.trim(),
            'createdAt': Timestamp.now(),
          });
        }

        // After signing up, navigate to home.dart
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const MyHomePage(title: '')),
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

        // Navigate to home.dart regardless of role
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const MyHomePage(title: '')),
        );
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
        SnackBar(
          content: Text(
            "Manager Saved Successfully!",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
        SnackBar(
          content: Text(
            "Worker Saved Successfully!",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
        SnackBar(
          content: Text(
            "Distribution Center Saved Successfully!",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
        SnackBar(
          content: Text(
            "Vehicle Saved Successfully!",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
          Text(
            "Welcome Back",
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AuthScreen.primaryMaroon,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Sign in to your LPG distribution account",
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AuthScreen.darkGray,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 32),
          _buildStyledTextField(
            controller: _emailController,
            label: 'Email Address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                !value!.contains('@') ? 'Please enter a valid email.' : null,
          ),
          const SizedBox(height: 20),
          _buildStyledTextField(
            controller: _passwordController,
            label: 'Password (or Mobile No. for Staff)',
            icon: Icons.lock_outline,
            obscureText: true,
            validator: (value) =>
                value!.length < 6 ? 'Password must be 6+ characters.' : null,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ForgotPasswordScreen(),
                  ),
                );
              },
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.poppins(
                  color: AuthScreen.primaryMaroon,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            "Select Your Role",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: AuthScreen.primaryMaroon,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: _RoleSquareCard(
                  label: 'Distributor',
                  imagePath: 'assets/images/boss.png',
                  selected: _selectedRole == UserRole.distributor,
                  onTap: () {
                    setState(() => _selectedRole = UserRole.distributor);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: _RoleSquareCard(
                  label: 'Manager',
                  imagePath: 'assets/images/manager.png',
                  selected: _selectedRole == UserRole.manager,
                  onTap: () {
                    setState(() => _selectedRole = UserRole.manager);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: _RoleSquareCard(
                  label: 'Worker',
                  imagePath: 'assets/images/editor.png',
                  selected: _selectedRole == UserRole.worker,
                  onTap: () {
                    setState(() => _selectedRole = UserRole.worker);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return SingleChildScrollView(
      child: Form(
        key: _signUpFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create Account",
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AuthScreen.primaryMaroon,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Join our LPG distribution network",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AuthScreen.darkGray,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 32),
            _buildStyledTextField(
              controller: _fullNameController,
              label: 'Full Name',
              icon: Icons.person_outline,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your full name.' : null,
            ),
            const SizedBox(height: 20),
            _buildStyledTextField(
              controller: _emailController,
              label: 'Email Address',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) =>
                  !value!.contains('@') ? 'Please enter a valid email.' : null,
            ),
            const SizedBox(height: 20),
            _buildStyledTextField(
              controller: _passwordController,
              label: 'Password',
              icon: Icons.lock_outline,
              obscureText: true,
              validator: (value) =>
                  value!.length < 6 ? 'Password must be 6+ characters.' : null,
            ),
            const SizedBox(height: 20),
            _buildStyledDropdown(),
            const SizedBox(height: 20),
            _buildStyledTextField(
              controller: _agencyNameController,
              label: 'Agency Name',
              icon: Icons.business_outlined,
            ),
            const SizedBox(height: 20),
            _buildStyledTextField(
              controller: _distributorNumberController,
              label: 'Distributor Number',
              icon: Icons.numbers_outlined,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            _buildAdditionalOptionsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AuthScreen.offWhite,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            color: AuthScreen.darkGray,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, color: AuthScreen.primaryMaroon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: AuthScreen.primaryMaroon,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          filled: true,
          fillColor: AuthScreen.offWhite,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildStyledDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: AuthScreen.offWhite,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: _selectedCompany,
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          labelText: 'Select Company',
          labelStyle: GoogleFonts.poppins(
            color: AuthScreen.darkGray,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: const Icon(
            Icons.business,
            color: AuthScreen.primaryMaroon,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: AuthScreen.primaryMaroon,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: AuthScreen.offWhite,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
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
                    child: Text(
                      company,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                )
                .toList(),
        onChanged: (value) => setState(() => _selectedCompany = value),
        validator: (value) => value == null ? 'Please select a company.' : null,
      ),
    );
  }

  Widget _buildAdditionalOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AuthScreen.primaryMaroon.withOpacity(0.1),
                AuthScreen.lightMaroon.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AuthScreen.primaryMaroon.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.add_business,
                    color: AuthScreen.primaryMaroon,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Additional Setup',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AuthScreen.primaryMaroon,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Configure your team and resources (Optional)',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AuthScreen.darkGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildManagerSection(),
        _buildWorkerSection(),
        _buildDistributionCenterSection(),
        _buildVehicleSection(),
      ],
    );
  }

  Widget _buildManagerSection() {
    return _buildExpandableSection(
      title: 'Add Managers',
      icon: Icons.supervisor_account,
      isExpanded: _isManagerExpanded,
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
        if (_managerControllers.isEmpty || _managerControllers.last['isSaved'])
          _buildAddButton(_addManagerField, 'Add Manager', Icons.person_add),
      ],
    );
  }

  Widget _buildWorkerSection() {
    return _buildExpandableSection(
      title: 'Add Workers',
      icon: Icons.engineering,
      isExpanded: _isWorkerExpanded,
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
          _buildAddButton(_addWorkerField, 'Add Worker', Icons.person_add),
      ],
    );
  }

  Widget _buildDistributionCenterSection() {
    return _buildExpandableSection(
      title: 'Add Distribution Centers',
      icon: Icons.warehouse,
      isExpanded: _isDistributionCenterExpanded,
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
            icon: Icons.location_on,
          );
        }),
        if (_distributionCenterControllers.isEmpty ||
            _distributionCenterControllers.last['isSaved'])
          _buildAddButton(
            _addDistributionCenterField,
            'Add Distribution Center',
            Icons.add_location_alt,
          ),
      ],
    );
  }

  Widget _buildVehicleSection() {
    return _buildExpandableSection(
      title: 'Add Vehicles',
      icon: Icons.local_shipping,
      isExpanded: _isVehicleExpanded,
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
            label: 'Vehicle Name/Number',
            role: 'Vehicle',
            icon: Icons.directions_car,
          );
        }),
        if (_vehicleControllers.isEmpty || _vehicleControllers.last['isSaved'])
          _buildAddButton(
            _addVehicleField,
            'Add Vehicle',
            Icons.directions_car,
          ),
      ],
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required Function(bool) onExpansionChanged,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: lightGray),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AuthScreen.primaryMaroon.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AuthScreen.primaryMaroon, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AuthScreen.primaryMaroon,
                ),
              ),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AuthScreen.primaryMaroon.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              isExpanded ? Icons.remove : Icons.add,
              color: AuthScreen.primaryMaroon,
              size: 20,
            ),
          ),
          onExpansionChanged: onExpansionChanged,
          children: children,
        ),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSaved ? Colors.green.withOpacity(0.05) : AuthScreen.offWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSaved ? Colors.green.withOpacity(0.3) : lightGray,
        ),
      ),
      child: Column(
        children: [
          _buildStyledTextField(
            controller: person['name'],
            label: '$role Name',
            icon: Icons.person,
          ),
          const SizedBox(height: 12),
          _buildStyledTextField(
            controller: person['email'],
            label: '$role Email',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          _buildStyledTextField(
            controller: person['mobile'],
            label: '$role Mobile',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          if (!isSaved)
            _buildActionButton(
              onPressed: () => onSave(index),
              label: "Save $role",
              icon: Icons.check,
              isPrimary: true,
            ),
          if (isSaved)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text(
                  "$role Saved Successfully!",
                  style: GoogleFonts.poppins(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 16),
                _buildActionButton(
                  onPressed: () => onEdit(index),
                  label: 'Edit',
                  icon: Icons.edit,
                  isPrimary: false,
                ),
              ],
            ),
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
    required IconData icon,
  }) {
    final bool isSaved = item['isSaved'];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSaved ? Colors.green.withOpacity(0.05) : AuthScreen.offWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSaved ? Colors.green.withOpacity(0.3) : lightGray,
        ),
      ),
      child: Column(
        children: [
          _buildStyledTextField(
            controller: item['name'],
            label: label,
            icon: icon,
          ),
          const SizedBox(height: 16),
          if (!isSaved)
            _buildActionButton(
              onPressed: () => onSave(index),
              label: "Save $role",
              icon: Icons.check,
              isPrimary: true,
            ),
          if (isSaved)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text(
                  "$role Saved Successfully!",
                  style: GoogleFonts.poppins(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 16),
                _buildActionButton(
                  onPressed: () => onEdit(index),
                  label: 'Edit',
                  icon: Icons.edit,
                  isPrimary: false,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    required bool isPrimary,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? AuthScreen.primaryMaroon : Colors.white,
        foregroundColor: isPrimary ? Colors.white : AuthScreen.primaryMaroon,
        side: isPrimary
            ? null
            : const BorderSide(color: AuthScreen.primaryMaroon),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildAddButton(VoidCallback onPressed, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: AuthScreen.primaryMaroon),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            color: AuthScreen.primaryMaroon,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AuthScreen.primaryMaroon, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthScreen.offWhite,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // App Logo and Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AuthScreen.primaryMaroon,
                            AuthScreen.lightMaroon,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AuthScreen.primaryMaroon.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.asset(
                              'assets/images/app_icon.png',
                              height: 60,
                              width: 60,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'LPG Distribution Hub',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Streamline your gas distribution operations',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _CustomToggle(
                      selectedIndex: _authMode.index,
                      labels: const ['Sign In', 'Sign Up'],
                      onTap: (index) {
                        _switchAuthMode(AuthMode.values[index]);
                      },
                    ),
                    const SizedBox(height: 32),
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
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: _isLoading
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            color: AuthScreen.primaryMaroon,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Processing...',
                            style: GoogleFonts.poppins(
                              color: AuthScreen.primaryMaroon,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _AuthButton(
                      label: _authMode == AuthMode.signIn
                          ? 'Sign In'
                          : 'Create Account',
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
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isSelected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            AuthScreen.primaryMaroon,
                            AuthScreen.lightMaroon,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AuthScreen.primaryMaroon.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    labels[index],
                    style: GoogleFonts.poppins(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w600,
                      color: isSelected ? Colors.white : AuthScreen.darkGray,
                      fontSize: 16,
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
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AuthScreen.primaryMaroon, AuthScreen.lightMaroon],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AuthScreen.primaryMaroon.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        height: 120,
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  colors: [
                    AuthScreen.primaryMaroon.withOpacity(0.1),
                    AuthScreen.lightMaroon.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: selected ? null : Colors.white,
          border: Border.all(
            color: selected ? Colors.green : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? Colors.green.withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.green.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                imagePath,
                width: 32,
                height: 32,
                color: selected ? Colors.green : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: selected ? Colors.green : AuthScreen.darkGray,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

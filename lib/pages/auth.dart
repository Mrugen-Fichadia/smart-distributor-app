import 'package:flutter/material.dart';

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

  // Controllers for text fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _otpController = TextEditingController();
  final _agencyNameController = TextEditingController();
  final _distributorNumberController = TextEditingController();

  String? _selectedCompany;
  UserRole _selectedRole = UserRole.distributor;

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _otpController.dispose();
    _agencyNameController.dispose();
    _distributorNumberController.dispose();
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
            decoration: const InputDecoration(labelText: 'Password'),
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
                    color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _CustomToggle(
            selectedIndex: _selectedRole.index,
            labels: const ['Distributor', 'Manager', 'Worker'],
            onTap: (index) {
              setState(() {
                _selectedRole = UserRole.values[index];
              });
            },
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
          // OTP Field with Send Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _otpController,
                  decoration: const InputDecoration(labelText: 'OTP'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.length < 6 ? 'Enter a valid OTP.' : null,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('OTP Sent!')),
                    );
                  },
                  child: const Text('Send OTP'),
                ),
              ),
            ],
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
            value: _selectedCompany,
            decoration: const InputDecoration(labelText: 'Select Company'),
            items: ['Company 1', 'Company 2', 'Company 3', 'Company 4']
                .map((company) =>
                    DropdownMenuItem(value: company, child: Text(company)))
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
        _buildOptionTile('Add Manager'),
        _buildOptionTile('Add Worker'),
        _buildOptionTile('Add Distribution Center'),
        _buildOptionTile('Add Vehicle'),
      ],
    );
  }

  Widget _buildOptionTile(String title) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.add, color: Colors.blue[600]),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tapped on $title')),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // The main layout is now a Column.
        child: Column(
          children: [
            // The Expanded widget makes the scrolling area take up all available space.
            Expanded(
              // Using a ListView is more robust for complex scrolling forms
              // and helps prevent overflow errors when the keyboard appears.
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'LPG Distribution App',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Welcome to our LPG distribution service!',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
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
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: _authMode == AuthMode.signIn
                        ? _buildSignInForm()
                        : _buildSignUpForm(),
                  ),
                  // Add some padding at the very bottom of the scroll view
                  const SizedBox(height: 20),
                ],
              ),
            ),
            // This button is now outside the scroll view and at the bottom
            // of the main Column, making it "sticky".
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: _AuthButton(
                label: _authMode == AuthMode.signIn ? 'Sign In' : 'Sign Up',
                onPressed: () {
                  // TODO: Handle sign in or sign up logic
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom widget for the toggle buttons (Sign In/Up and Roles)
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
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                          )
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.black : Colors.black54,
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

// Custom widget for the main authentication button
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
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'sign_up_additional.dart';

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
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
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
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('OTP Sent!')));
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
          TextFormField(
            decoration: const InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
            validator: (value) {
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
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
                  // Logo at center
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(
                        'assets/images/app_icon.png', // <-- Replace with your logo asset
                      ), // <-- Replace with your logo asset
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
                label: _authMode == AuthMode.signIn ? 'Sign In' : 'Continue',
                authMode: _authMode,
                signInFormKey: _signInFormKey,
                signUpFormKey: _signUpFormKey,
                onSignUpContinue: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdditionalSignUpPage(),
                    ),
                  );
                },
                onSignIn: () {
                  // Handle sign in logic here (e.g., call API or navigate to home)
                },
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
                            // ignore: deprecated_member_use
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
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
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
  final AuthMode authMode;
  final GlobalKey<FormState> signInFormKey;
  final GlobalKey<FormState> signUpFormKey;
  final VoidCallback onSignUpContinue;
  final VoidCallback onSignIn;

  const _AuthButton({
    required this.label,
    required this.authMode,
    required this.signInFormKey,
    required this.signUpFormKey,
    required this.onSignUpContinue,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (authMode == AuthMode.signUp &&
              signUpFormKey.currentState!.validate()) {
            onSignUpContinue();
          } else if (authMode == AuthMode.signIn &&
              signInFormKey.currentState!.validate()) {
            onSignIn();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
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

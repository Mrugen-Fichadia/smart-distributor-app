import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_distributor_app/common/utils/colors.dart';
import 'package:smart_distributor_app/pages/authentication/widgets/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // -------------- Email validation --------------
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // ------------------sncakbar and submit action---------
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Get.showSnackbar(
        GetSnackBar(
          title: 'OTP Sent',
          message: 'OTP is being sent to your email',
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          // colorText: Colors.white,
          borderRadius: 8,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          animationDuration: const Duration(milliseconds: 300),
          isDismissible: true,
          forwardAnimationCurve: Curves.easeOutQuint,
          reverseAnimationCurve: Curves.easeInQuint,
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        // Get.offAllNamed('/login'); // required navigation sdcreen
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),

          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ForgotHeader(),
                ForgotActions(
                  emailController: _emailController,
                  validateEmail: _validateEmail,
                  onSubmit: _submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotHeader extends StatelessWidget {
  const ForgotHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 18),

        // ---------- image -------
        Image.asset(
          'assets/images/lock_icon.png',
          width: 100,
          height: 100,
          fit: BoxFit.contain,
        ),

        const SizedBox(height: 18),

        const Text(
          'Reset Password',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        const Text(
          'Enter your email to receive a Password Reset Link',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}

class ForgotActions extends StatelessWidget {
  final TextEditingController emailController;
  final String? Function(String?) validateEmail;
  final VoidCallback onSubmit;

  const ForgotActions({
    super.key,
    required this.emailController,
    required this.validateEmail,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 44),
        // ---------Input Field with validation
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            floatingLabelStyle: TextStyle(color: AppColors.kBlue),
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.kBlue),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: validateEmail,
          autovalidateMode: AutovalidateMode.disabled,
        ),
        const SizedBox(height: 52),
        // Send Reset Link button
        PrimaryButton(
          text: 'Send Reset Link',
          onPressed: onSubmit,
          backgroundColor: AppColors.kBlue,
          textColor: Colors.white,
          borderRadius: 12.0,
          height: 46.0,
        ),
      ],
    );
  }
}

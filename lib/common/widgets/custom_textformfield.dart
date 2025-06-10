// import 'package:flutter/material.dart';

// class CustomTextFormField extends StatelessWidget {
//   final String? label;
//   final String? hintText;
//   final IconData? prefixIcon;
//   final TextInputType? keyboardType;
//   final TextEditingController? controller;
//   final String? Function(String?)? validator;
//   final AutovalidateMode? autovalidateMode;

//   const CustomTextFormField({
//     super.key,
//     this.label,
//     this.hintText,
//     this.prefixIcon,
//     this.keyboardType,
//     this.controller,
//     this.validator,
//     this.autovalidateMode = AutovalidateMode.disabled,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         floatingLabelStyle: const TextStyle(color: Colors.grey),
//         prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.grey),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.grey),
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           vertical: 16,
//           horizontal: 16,
//         ),
//         hintText: hintText,
//       ),
//       keyboardType: keyboardType,
//       validator: validator,
//       autovalidateMode: autovalidateMode,
//     );
//   }
// }

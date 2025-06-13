import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_distributor_app/common/utils/colors.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onLeadingPressed;
  final List<Widget>?
  actions; 
  final bool centerTitle;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onLeadingPressed,
    this.actions,
    this.centerTitle = false,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      leading:
          leading ??
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: onLeadingPressed ?? () => Get.back(),
          ),

  // ------ if action widget present ( Optional ) ------------
      actions: actions, 
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

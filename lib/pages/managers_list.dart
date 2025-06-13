import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/profile_widgets.dart';

class ManagerPage extends StatelessWidget {
  final controller = Get.put(PersonController(maxLimit: 3));

  ManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PersonPage(
      title: 'Managers',
      emptyTitle: 'No Managers Yet',
      emptySubtitle:
          'Add your first manager to get started\n(Maximum 3 managers allowed)',
      addButtonText: 'Add Manager',
      controller: controller,
    );
  }
}

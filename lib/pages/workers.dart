import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_distributor_app/widgets/profile_widgets.dart';

class WorkerPage extends StatelessWidget {
  final controller = Get.put(PersonController());

  WorkerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PersonPage(
      title: 'Workers',
      emptyTitle: 'No Workers Yet',
      emptySubtitle: 'Add your first worker to get started',
      addButtonText: 'Add Worker',
      controller: controller,
    );
  }
}

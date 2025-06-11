// ignore_for_file: file_names

import 'package:get/get.dart';

final ProfileController profileController = Get.put(ProfileController());

class ProfileController extends GetxController {
  var userName = 'Kartik Kale'.obs;
  final String userEmail = 'kartik@gmail.com';
  String role = "distributor";
}

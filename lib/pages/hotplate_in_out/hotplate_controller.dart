import 'package:get/get.dart';

class HotplateController extends GetxController {
  RxInt currentStock = 200.obs;
  RxInt defectiveParts = 10.obs;
  RxBool isLoadingStock = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStockData();
  }

  Future<void> fetchStockData() async {
    isLoadingStock.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoadingStock.value = false;
  }

  void addStock(int quantity) {
    currentStock.value += quantity;
  }

  void removeStock(int quantity) {
    currentStock.value -= quantity;
  }
}

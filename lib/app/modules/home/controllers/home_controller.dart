import 'package:get/get.dart';

class HomeController extends GetxController {

  /// 🔥 Index Bottom Navigation
  var bottomNavIndex = 0.obs;

  /// Optional counter (kalau masih mau dipakai)
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
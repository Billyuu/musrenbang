import 'package:get/get.dart';

class AdminController extends GetxController {

  /// 🔥 STATUS AKTIF
  var selectedStatus = "diproses".obs;

  /// 🔥 GANTI STATUS
  void changeStatus(String status) {
    selectedStatus.value = status;
  }

  /// 🔥 LOGOUT
  void logout() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Yakin ingin logout?",
      textConfirm: "Ya",
      textCancel: "Batal",
      onConfirm: () {
        Get.back(); // tutup dialog
        Get.offAllNamed('/login');
      },
    );
  }
}
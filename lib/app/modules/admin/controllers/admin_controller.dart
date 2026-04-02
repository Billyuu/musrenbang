import 'package:get/get.dart';

class AdminController extends GetxController {
  

  var selectedStatus = "diproses".obs;

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
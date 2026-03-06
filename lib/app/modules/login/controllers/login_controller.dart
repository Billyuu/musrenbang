import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musrenbang/app/routes/app_pages.dart';
import 'package:musrenbang/services/api_service.dart';
import 'package:musrenbang/app/modules/profil/controllers/profil_controller.dart';

class LoginController extends GetxController {
  final nikController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    final nik = nikController.text.trim();
    final password = passwordController.text.trim();

    // ✅ Validasi kosong
    if (nik.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "NIK dan Password wajib diisi",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final result = await ApiService.login(nik: nik, password: password);
      print("=== RESPONSE LOGIN ===");
      print(result["body"]);

      print("STATUS: ${result["statusCode"]}");
      print("BODY: ${result["body"]}");

      if (result["statusCode"] == 200) {
        final body = result["body"];

        // ✅ Pastikan ada data user dari API
        if (body != null && body["data"] != null) {
          final user = body["data"];

          final profilController = Get.put(ProfilController(), permanent: true);

          profilController.setUserData(user);
        }

        Get.snackbar(
          "Berhasil",
          "Login sukses",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar(
          "Gagal",
          result["body"]?["message"] ?? "Login gagal",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("ERROR DEV: $e");

      Get.snackbar(
        "Error",
        "Tidak dapat terhubung ke server",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

 @override
void onClose() {
  super.onClose();
}
}

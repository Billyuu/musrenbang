import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musrenbang/app/routes/app_pages.dart';
import 'package:musrenbang/services/api_service.dart';
import 'package:musrenbang/app/modules/profil/controllers/profil_controller.dart';
import 'package:get_storage/get_storage.dart';

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
        if (body != null && body["data"] != null) {
          final user = body["data"];
          print("DATA USER LOGIN: $user");
          print("USER ID LOGIN: ${user["id"]}");
          final box = GetStorage();
          await box.erase();

          box.write("user_id", user["id"]);

          print("USER ID TERSIMPAN: ${box.read("user_id")}");
          box.write("nama", user["nama"]);

          print("USER LOGIN ID: ${box.read("user_id")}");

          final profilController = Get.put(ProfilController(), permanent: true);

          profilController.setUserData(user);

          // 🔥 LOAD FOTO PROFILE DARI SERVER
          await profilController.loadProfile();
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

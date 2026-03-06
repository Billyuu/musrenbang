import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musrenbang/app/modules/login/controllers/login_controller.dart';
import 'package:musrenbang/services/api_service.dart';

class RegistrasiController extends GetxController {

  final namaController = TextEditingController();
  final nikController = TextEditingController();
  final alamatController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var selectedGender = "Laki-laki".obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }
  Future<void> register() async {
  if (passwordController.text != confirmPasswordController.text) {
    Get.snackbar("Error", "Password tidak sama");
    return;
  }

  try {
    isLoading.value = true;

    final result = await ApiService.register(
      nama: namaController.text,
      nik: nikController.text,
      alamat: alamatController.text,
      jenisKelamin:
          selectedGender.value == "Laki-laki" ? "L" : "P",
      nomorTelepon: phoneController.text,
      password: passwordController.text,
    );

    final statusCode = result["statusCode"];
final body = result["body"];

if (statusCode == 201) {
  Get.snackbar("Sukses", body["message"]);

  // 🔥 Hapus LoginController lama jika ada
  if (Get.isRegistered<LoginController>()) {
    Get.delete<LoginController>();
  }

  // 🔥 Pindah ke halaman login
  Get.offAllNamed('/login');

} else {
  Get.snackbar("Error", body["message"] ?? "Terjadi kesalahan");
}

  } catch (e) {
    Get.snackbar("Error", e.toString());
  } finally {
    isLoading.value = false;
  }

}
}

  

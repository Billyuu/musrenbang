import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musrenbang/services/api_service.dart';
import 'package:musrenbang/app/routes/app_pages.dart';

class AdminLoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  final box = GetStorage();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void showMessage({
    required String title,
    required String message,
    bool isSuccess = false,
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: isSuccess
          ? const Color(0xFF1565C0).withOpacity(0.92)
          : const Color(0xFFE53935).withOpacity(0.92),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      duration: const Duration(seconds: 3),
      titleText: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      messageText: Text(
        message,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  bool validateForm() {
    if (emailController.text.trim().isEmpty) {
      showMessage(
        title: "Email belum diisi",
        message: "Silakan masukkan email admin terlebih dahulu.",
      );
      return false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      showMessage(
        title: "Email tidak valid",
        message: "Gunakan format email yang benar.",
      );
      return false;
    }

    if (passwordController.text.trim().isEmpty) {
      showMessage(
        title: "Password belum diisi",
        message: "Silakan masukkan password admin.",
      );
      return false;
    }

    return true;
  }

  Future<void> loginAdmin() async {
    if (!validateForm()) return;

    try {
      isLoading.value = true;

      final result = await ApiService.loginAdmin(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final statusCode = result["statusCode"];
      final body = result["body"];

      print("ADMIN LOGIN RESPONSE: $body");

      if (statusCode == 200 && body["success"] == true) {
        final admin = body["data"];

        await box.erase();

        box.write("isAdminLogin", true);
        box.write("role", "admin");
        box.write("admin_id", admin["id"]);
        box.write("admin_name", admin["name"]);
        box.write("admin_email", admin["email"]);

        showMessage(
          title: "Login Berhasil",
          message: "Selamat datang, Admin Desa.",
          isSuccess: true,
        );

        Get.offAllNamed(Routes.ADMIN);
      } else {
        showMessage(
          title: "Login Gagal",
          message: body["message"] ?? "Email atau password admin salah.",
        );
      }
    } catch (e) {
      print("ERROR ADMIN LOGIN: $e");

      showMessage(
        title: "Terjadi Kesalahan",
        message: "Koneksi atau server bermasalah. Silakan coba lagi.",
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
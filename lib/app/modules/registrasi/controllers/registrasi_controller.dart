import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:musrenbang/app/modules/login/controllers/login_controller.dart';
import 'package:musrenbang/services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musrenbang/app/routes/app_pages.dart';

class RegistrasiController extends GetxController {
  final namaController = TextEditingController();
  final emailController = TextEditingController();
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
    if (namaController.text.trim().isEmpty) {
      showMessage(
        title: "Nama belum diisi",
        message: "Silakan masukkan nama lengkap terlebih dahulu.",
      );
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      showMessage(
        title: "Email belum diisi",
        message: "Silakan masukkan alamat email aktif.",
      );
      return false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      showMessage(
        title: "Email tidak valid",
        message: "Gunakan format email yang benar, contoh: nama@email.com.",
      );
      return false;
    }

    if (nikController.text.trim().isEmpty) {
      showMessage(
        title: "NIK belum diisi",
        message: "Silakan masukkan NIK sesuai data kependudukan.",
      );
      return false;
    }

    if (nikController.text.trim().length < 16) {
      showMessage(
        title: "NIK tidak valid",
        message: "NIK harus berisi 16 digit angka.",
      );
      return false;
    }

    if (alamatController.text.trim().isEmpty) {
      showMessage(
        title: "Alamat belum diisi",
        message: "Silakan masukkan alamat lengkap Anda.",
      );
      return false;
    }

    if (phoneController.text.trim().isEmpty) {
      showMessage(
        title: "Nomor telepon belum diisi",
        message: "Silakan masukkan nomor telepon aktif.",
      );
      return false;
    }

    if (passwordController.text.trim().isEmpty) {
      showMessage(
        title: "Password belum diisi",
        message: "Silakan buat password untuk akun Anda.",
      );
      return false;
    }

    if (passwordController.text.trim().length < 8) {
      showMessage(
        title: "Password Lemah",
        message: "Password minimal terdiri dari 8 karakter.",
      );
      return false;
    }

    if (confirmPasswordController.text.trim().isEmpty) {
      showMessage(
        title: "Konfirmasi password belum diisi",
        message: "Silakan ulangi password Anda.",
      );
      return false;
    }

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      showMessage(
        title: "Password tidak sama",
        message: "Password dan konfirmasi password harus sama.",
      );
      return false;
    }

    return true;
  }

  Future<void> register() async {
    if (!validateForm()) return;

    UserCredential? userCredential;

    try {
      isLoading.value = true;

      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      String firebaseUid = userCredential.user!.uid;

      final result = await ApiService.register(
        nama: namaController.text.trim(),
        email: emailController.text.trim(),
        firebaseUid: firebaseUid,
        nik: nikController.text.trim(),
        alamat: alamatController.text.trim(),
        jenisKelamin: selectedGender.value == "Laki-laki" ? "L" : "P",
        nomorTelepon: phoneController.text.trim(),
      );

      final statusCode = result["statusCode"];
      final body = result["body"];

      if (statusCode == 201) {
        showMessage(
          title: "Registrasi Berhasil",
          message:
              "Akun Anda berhasil dibuat. Silakan login untuk melanjutkan.",
          isSuccess: true,
        );

        if (Get.isRegistered<LoginController>()) {
          Get.delete<LoginController>();
        }

        Get.offNamed(Routes.LOGIN);
      } else {
        await userCredential.user?.delete();

        String errorMessage =
            body["message"] ?? "Data belum berhasil disimpan.";

        if (errorMessage.toLowerCase().contains("email") &&
            errorMessage.toLowerCase().contains("taken")) {
          errorMessage =
              "Email ini sudah terdaftar. Silakan gunakan email lain.";
        }

        showMessage(title: "Registrasi Gagal", message: errorMessage);
      }
    } on FirebaseAuthException catch (e) {
      String message = "Registrasi belum berhasil. Silakan coba lagi.";

      if (e.code == 'email-already-in-use') {
        message = "Email ini sudah terdaftar. Silakan gunakan email lain.";
      } else if (e.code == 'weak-password') {
        message = "Password terlalu lemah. Gunakan minimal 6 karakter.";
      } else if (e.code == 'invalid-email') {
        message = "Format email tidak valid.";
      }

      showMessage(title: "Registrasi Gagal", message: message);
    } catch (e) {
      await userCredential?.user?.delete();

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
    namaController.dispose();
    emailController.dispose();
    nikController.dispose();
    alamatController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}

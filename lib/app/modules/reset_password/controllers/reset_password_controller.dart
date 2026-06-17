import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordController extends GetxController {
  final emailController = TextEditingController();

  var isLoading = false.obs;

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
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showMessage(
        title: "Email belum diisi",
        message: "Silakan masukkan email akun Anda terlebih dahulu.",
      );
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      showMessage(
        title: "Email tidak valid",
        message: "Gunakan format email yang benar, contoh: nama@email.com.",
      );
      return false;
    }

    return true;
  }

 Future<void> sendResetPasswordEmail() async {
  if (!validateForm()) return;

  try {
    isLoading.value = true;

    final email = emailController.text.trim();

    await FirebaseAuth.instance.setLanguageCode('id');

    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
    );

    print("RESET PASSWORD EMAIL BERHASIL DIKIRIM KE: $email");

    showMessage(
      title: "Email Reset Terkirim",
      message:
          "Silakan cek email Anda. Periksa juga folder Spam, Promosi, atau Sosial.",
      isSuccess: true,
    );

    await Future.delayed(const Duration(seconds: 1));
    Get.back();
  } on FirebaseAuthException catch (e) {
    print("RESET PASSWORD ERROR CODE: ${e.code}");
    print("RESET PASSWORD ERROR MESSAGE: ${e.message}");

    String message = "Gagal mengirim email reset password.";

    if (e.code == 'invalid-email') {
      message = "Format email tidak valid.";
    } else if (e.code == 'user-not-found') {
      message = "Email belum terdaftar di Firebase Authentication.";
    } else if (e.code == 'too-many-requests') {
      message = "Terlalu banyak permintaan. Coba lagi beberapa saat.";
    } else if (e.code == 'network-request-failed') {
      message = "Koneksi internet bermasalah. Silakan coba lagi.";
    } else if (e.code == 'missing-android-pkg-name') {
      message = "Package name Android belum sesuai di Firebase.";
    } else if (e.code == 'unauthorized-continue-uri') {
      message = "Domain reset password belum diizinkan di Firebase.";
    } else if (e.code == 'invalid-continue-uri') {
      message = "Link reset password tidak valid.";
    }

    showMessage(
      title: "Reset Password Gagal",
      message: "$message\n\nKode: ${e.code}",
    );
  } catch (e) {
    print("ERROR RESET PASSWORD UMUM: $e");

    showMessage(
      title: "Terjadi Kesalahan",
      message: "Koneksi atau Firebase bermasalah. Silakan coba lagi.",
    );
  } finally {
    isLoading.value = false;
  }
}
  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}

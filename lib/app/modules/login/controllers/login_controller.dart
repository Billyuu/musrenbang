import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musrenbang/app/routes/app_pages.dart';
import 'package:musrenbang/app/modules/profil/controllers/profil_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:musrenbang/services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  Timer? adminLoginTimer;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Kalau sudah tidak pakai halaman admin login tersembunyi,
  // bagian ini boleh dibiarkan dulu atau nanti dihapus.
  void startAdminLoginTimer() {
    adminLoginTimer?.cancel();
    adminLoginTimer = Timer(const Duration(seconds: 3), () {
      Get.toNamed(Routes.ADMIN_LOGIN);
    });
  }

  void cancelAdminLoginTimer() {
    adminLoginTimer?.cancel();
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
        message: "Silakan masukkan alamat email terlebih dahulu.",
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

    if (passwordController.text.trim().isEmpty) {
      showMessage(
        title: "Password belum diisi",
        message: "Silakan masukkan password akun Anda.",
      );
      return false;
    }

    return true;
  }

  /// LOGIN UTAMA
  /// Admin dan user memakai form yang sama.
  Future<void> login() async {
  if (!validateForm()) return;

  try {
    isLoading.value = true;

    final adminBerhasil = await _cobaLoginAdmin();

    if (adminBerhasil) {
      return;
    }

    await _loginUserFirebase();
  } finally {
    isLoading.value = false;
  }
}

  /// CEK LOGIN ADMIN LARAVEL DULU
  Future<bool> _cobaLoginAdmin() async {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  try {
    final result = await ApiService.loginAdmin(
      email: email,
      password: password,
    );

    final statusCode = result["statusCode"];
    final body = result["body"];

    print("CEK ADMIN LOGIN RESPONSE: $body");

    if (statusCode == 200 && body["success"] == true) {
      final admin = body["data"];
      final box = GetStorage();

      await box.erase();

      box.write("role", "admin");
      box.write("isAdminLogin", true);
      box.write("isUserLogin", false);
      box.write("admin_id", admin["id"]);
      box.write("admin_name", admin["name"]);
      box.write("admin_email", admin["email"]);

      showMessage(
        title: "Login Berhasil",
        message: "Selamat datang, Admin Desa.",
        isSuccess: true,
      );

      Get.offAllNamed(Routes.ADMIN);
      return true;
    }

    return false;
  } catch (e) {
    print("ADMIN LOGIN CHECK FAILED: $e");
    return false;
  }
}

  /// LOGIN USER FIREBASE
  Future<void> _loginUserFirebase() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user == null) {
        showMessage(
          title: "Login Gagal",
          message: "Akun Firebase tidak ditemukan. Silakan coba lagi.",
        );
        return;
      }

      final result = await ApiService.loginFirebase(
        firebaseUid: user.uid,
      );

      final statusCode = result["statusCode"];
      final body = result["body"];

      print("LOGIN USER RESPONSE: $body");

      if (statusCode == 200 && body["data"] != null) {
        final dataUser = body["data"];
        final box = GetStorage();

        await box.erase();

        box.write("role", "user");
        box.write("isUserLogin", true);
        box.write("isAdminLogin", false);
        box.write("user_id", dataUser["id"] ?? "");
        box.write("firebase_uid", dataUser["firebase_uid"] ?? user.uid);
        box.write("email", dataUser["email"] ?? user.email);
        box.write("nama", dataUser["nama"] ?? "");

        final profilController = Get.put(
          ProfilController(),
          permanent: true,
        );

        await profilController.loadProfile();

        showMessage(
          title: "Login Berhasil",
          message: "Selamat datang kembali di Musrenbang Desa Sukorejo.",
          isSuccess: true,
        );

        Get.offAllNamed(Routes.HOME);
      } else {
        String errorMessage =
            body["message"] ?? "Akun belum terhubung dengan data warga.";

        if (errorMessage.toLowerCase().contains("not found")) {
          errorMessage = "Data akun belum ditemukan di sistem.";
        }

        showMessage(
          title: "Login Gagal",
          message: errorMessage,
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "Email atau password yang Anda masukkan salah.";

      if (e.code == 'user-not-found') {
        message = "Email belum terdaftar. Silakan daftar terlebih dahulu.";
      } else if (e.code == 'wrong-password') {
        message = "Password yang Anda masukkan salah.";
      } else if (e.code == 'invalid-email') {
        message = "Format email tidak valid.";
      } else if (e.code == 'invalid-credential') {
        message = "Email atau password yang Anda masukkan salah.";
      } else if (e.code == 'too-many-requests') {
        message = "Terlalu banyak percobaan login. Coba lagi beberapa saat.";
      }

      showMessage(
        title: "Login Gagal",
        message: message,
      );
    } catch (e) {
      print("ERROR LOGIN USER: $e");

      showMessage(
        title: "Terjadi Kesalahan",
        message: "Koneksi atau server bermasalah. Silakan coba lagi.",
      );
    }
  }

  @override
  void onClose() {
    adminLoginTimer?.cancel();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
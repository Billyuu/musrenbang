import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musrenbang/services/api_service.dart';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilController extends GetxController {
  final box = GetStorage();
  var isUploadFotoLoading = false.obs;
  var isLoading = false.obs;
  var bottomNavIndex = 2.obs; // karena ini halaman profil

  // 🔥 Data user (kosong dulu, akan diisi saat login)
  var nama = "".obs;
  var email = "".obs;
  var nik = "".obs;
  var alamat = "".obs;
  var noHp = "".obs;
  var jenisKelamin = "".obs;

  /// 🔥 Method untuk menerima data dari LoginController
  // void setUserData(Map<String, dynamic> user) {
  //   nama.value = user["nama"] ?? "";
  //   nik.value = user["nik"] ?? "";
  //   alamat.value = user["alamat"] ?? "";
  //   noHp.value = user["nomor_telepon"] ?? "";

  //   // Konversi jenis kelamin
  //   if (user["jenis_kelamin"] == "L") {
  //     jenisKelamin.value = "Laki-laki";
  //   } else if (user["jenis_kelamin"] == "P") {
  //     jenisKelamin.value = "Perempuan";
  //   } else {
  //     jenisKelamin.value = user["jenis_kelamin"] ?? "";
  //   }
  // }

  // upload foto
  Future<void> uploadFotoKeServer() async {
    if (selectedImage.value == null) return;

    try {
      isUploadFotoLoading.value = true;

      String? url = await ApiService.uploadFoto(selectedImage.value!);

      if (url != null) {
        imageUrl.value = url;

        await loadProfile();

        Get.snackbar(
          "Foto Berhasil Diperbarui",
          "Foto profil Anda sudah berhasil diganti.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF1565C0).withOpacity(0.92),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
          margin: const EdgeInsets.all(16),
          borderRadius: 16,
          duration: const Duration(seconds: 2),
          titleText: Text(
            "Foto Berhasil Diperbarui",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          messageText: Text(
            "Foto profil Anda sudah berhasil diganti.",
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
          ),
        );
      } else {
        Get.snackbar(
          "Upload Gagal",
          "Foto belum berhasil diunggah. Silakan coba lagi.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFE53935).withOpacity(0.92),
          colorText: Colors.white,
          icon: const Icon(Icons.error_rounded, color: Colors.white),
          margin: const EdgeInsets.all(16),
          borderRadius: 16,
          duration: const Duration(seconds: 3),
          titleText: Text(
            "Upload Gagal",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          messageText: Text(
            "Foto belum berhasil diunggah. Silakan coba lagi.",
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
          ),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Koneksi atau server bermasalah. Silakan coba lagi.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFE53935).withOpacity(0.92),
        colorText: Colors.white,
        icon: const Icon(Icons.wifi_off_rounded, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
        duration: const Duration(seconds: 3),
        titleText: Text(
          "Terjadi Kesalahan",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        messageText: Text(
          "Koneksi atau server bermasalah. Silakan coba lagi.",
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
        ),
      );
    } finally {
      isUploadFotoLoading.value = false;
    }
  }

  //load profil
  Future<void> loadProfile() async {
    try {
      final userId = box.read("user_id");

      if (userId == null) return;

      isLoading(true);

      final result = await ApiService.getProfile(userId);

      print("PROFILE RESPONSE: ${result["body"]}");

      if (result["statusCode"] == 200) {
        final data = result["body"]["data"];

        nama.value = data["nama"] ?? "";
        email.value = data["email"] ?? ""; // 👈 WAJIB
        nik.value = data["nik"] ?? "";
        alamat.value = data["alamat"] ?? "";
        noHp.value = data["nomor_telepon"] ?? "";

        jenisKelamin.value = data["jenis_kelamin"] == "L"
            ? "Laki-laki"
            : "Perempuan";

        imageUrl.value = data["foto_url"] ?? "";
      }
    } catch (e) {
      print("ERROR PROFILE: $e");
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();

    if (box.hasData("user_id")) {
      loadProfile();
    }
  }

  var imageUrl = "".obs; // URL dari server
  final ImagePicker picker = ImagePicker(); // Untuk pilih gambar
  var selectedImage = Rx<File?>(null); // File gambar yang dipilih

  // ===== Fungsi edit foto =====
  void editFoto() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 5,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            Text(
              "Ganti Foto Profil",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF003E79),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Pilih sumber foto yang ingin digunakan",
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 22),

            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              tileColor: const Color(0xFFF5F9FF),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE3F2FD),
                child: Icon(Icons.camera_alt_rounded, color: Color(0xFF003E79)),
              ),
              title: Text(
                "Ambil dari Kamera",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              onTap: () async {
                Get.back();

                try {
                  isUploadFotoLoading.value = true;

                  final XFile? image = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 70,
                  );

                  if (image != null) {
                    selectedImage.value = File(image.path);
                    await uploadFotoKeServer();
                  }
                } finally {
                  isUploadFotoLoading.value = false;
                }
              },
            ),

            const SizedBox(height: 12),

            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              tileColor: const Color(0xFFF5F9FF),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE3F2FD),
                child: Icon(Icons.photo_rounded, color: Color(0xFF003E79)),
              ),
              title: Text(
                "Pilih dari Galeri",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () async {
                Get.back();

                try {
                  isUploadFotoLoading.value = true;

                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 70,
                  );

                  if (image != null) {
                    selectedImage.value = File(image.path);
                    await uploadFotoKeServer();
                  }
                } finally {
                  isUploadFotoLoading.value = false;
                }
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // alamat
  void editAlamat() {
    TextEditingController alamatController = TextEditingController(
      text: alamat.value,
    );

    Get.bottomSheet(
      Obx(
        () => Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 5,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              Text(
                "Edit Alamat",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF003E79),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Perbarui alamat lengkap tempat tinggal Anda.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 22),

              TextField(
                controller: alamatController,
                maxLines: 3,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Masukkan alamat lengkap",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey,
                  ),

                  filled: true,
                  fillColor: const Color(0xFFF5F9FF),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading.value
                      ? null
                      : () async {
                          if (alamatController.text.trim().isEmpty) {
                            Get.snackbar(
                              "Alamat belum diisi",
                              "Silakan masukkan alamat lengkap terlebih dahulu.",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: const Color(
                                0xFFE53935,
                              ).withOpacity(0.92),
                              colorText: Colors.white,
                              icon: const Icon(
                                Icons.error_outline_rounded,
                                color: Colors.white,
                              ),
                              margin: const EdgeInsets.all(16),
                              borderRadius: 16,
                              titleText: Text(
                                "Alamat belum diisi",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              messageText: Text(
                                "Silakan masukkan alamat lengkap terlebih dahulu.",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            );
                            return;
                          }

                          try {
                            isLoading.value = true;

                            alamat.value = alamatController.text.trim();

                            bool success = await ApiService.updateAlamat(
                              alamat.value,
                            );

                            if (success) {
                              Get.back();

                              Get.snackbar(
                                "Alamat Berhasil Diperbarui",
                                "Alamat Anda sudah berhasil disimpan.",
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: const Color(
                                  0xFF1565C0,
                                ).withOpacity(0.92),
                                colorText: Colors.white,
                                icon: const Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.white,
                                ),
                                margin: const EdgeInsets.all(16),
                                borderRadius: 16,
                                duration: const Duration(seconds: 2),
                                titleText: Text(
                                  "Alamat Berhasil Diperbarui",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                messageText: Text(
                                  "Alamat Anda sudah berhasil disimpan.",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              );
                            } else {
                              Get.snackbar(
                                "Update Gagal",
                                "Alamat belum berhasil diperbarui. Silakan coba lagi.",
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: const Color(
                                  0xFFE53935,
                                ).withOpacity(0.92),
                                colorText: Colors.white,
                                icon: const Icon(
                                  Icons.error_rounded,
                                  color: Colors.white,
                                ),
                                margin: const EdgeInsets.all(16),
                                borderRadius: 16,
                                titleText: Text(
                                  "Update Gagal",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                messageText: Text(
                                  "Alamat belum berhasil diperbarui. Silakan coba lagi.",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            Get.snackbar(
                              "Terjadi Kesalahan",
                              "Koneksi atau server bermasalah. Silakan coba lagi.",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: const Color(
                                0xFFE53935,
                              ).withOpacity(0.92),
                              colorText: Colors.white,
                              icon: const Icon(
                                Icons.wifi_off_rounded,
                                color: Colors.white,
                              ),
                              margin: const EdgeInsets.all(16),
                              borderRadius: 16,
                              titleText: Text(
                                "Terjadi Kesalahan",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              messageText: Text(
                                "Koneksi atau server bermasalah. Silakan coba lagi.",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            );
                          } finally {
                            isLoading.value = false;
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003E79),
                    disabledBackgroundColor: const Color(0xFF003E79),
                    disabledForegroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: isLoading.value
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "Simpan Alamat",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // No HP
  void editNoHp() {
    final TextEditingController noHpController = TextEditingController(
      text: noHp.value,
    );

    Get.bottomSheet(
      Obx(
        () => ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: Container(
            color: Colors.white,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 14,
                  bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 24,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// DRAG HANDLE
                      Container(
                        width: 42,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      /// TITLE
                      Text(
                        "Edit Nomor Telepon",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF003E79),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Perbarui nomor telepon aktif Anda.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 22),

                      /// INPUT
                      TextField(
                        controller: noHpController,
                        keyboardType: TextInputType.phone,
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "81234567890",
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey,
                          ),

                          prefixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 14),

                              const Icon(
                                Icons.phone_rounded,
                                color: Color(0xFF003E79),
                              ),

                              const SizedBox(width: 8),

                              Text(
                                "+62",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF003E79),
                                ),
                              ),

                              const SizedBox(width: 10),

                              Container(
                                width: 1,
                                height: 22,
                                color: Colors.grey.shade300,
                              ),

                              const SizedBox(width: 10),
                            ],
                          ),

                          filled: true,
                          fillColor: const Color(0xFFF5F9FF),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      /// BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isLoading.value
                              ? null
                              : () async {
                                  if (noHpController.text.trim().isEmpty) {
                                    Get.snackbar(
                                      "Nomor belum diisi",
                                      "Silakan masukkan nomor telepon terlebih dahulu.",
                                      snackPosition: SnackPosition.TOP,
                                      backgroundColor: const Color(
                                        0xFFE53935,
                                      ).withOpacity(0.92),
                                      colorText: Colors.white,
                                      icon: const Icon(
                                        Icons.error_outline_rounded,
                                        color: Colors.white,
                                      ),
                                      margin: const EdgeInsets.all(16),
                                      borderRadius: 16,
                                      titleText: Text(
                                        "Nomor belum diisi",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      messageText: Text(
                                        "Silakan masukkan nomor telepon terlebih dahulu.",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  try {
                                    isLoading.value = true;

                                    noHp.value = noHpController.text.trim();

                                    bool success = await ApiService.updateNoHp(
                                      noHp.value,
                                    );

                                    if (success) {
                                      Get.back();

                                      Get.snackbar(
                                        "Nomor Berhasil Diperbarui",
                                        "Nomor telepon Anda sudah berhasil disimpan.",
                                        snackPosition: SnackPosition.TOP,
                                        backgroundColor: const Color(
                                          0xFF1565C0,
                                        ).withOpacity(0.92),
                                        colorText: Colors.white,
                                        icon: const Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.white,
                                        ),
                                        margin: const EdgeInsets.all(16),
                                        borderRadius: 16,
                                        duration: const Duration(seconds: 2),

                                        titleText: Text(
                                          "Nomor Berhasil Diperbarui",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        messageText: Text(
                                          "Nomor telepon Anda sudah berhasil disimpan.",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      );
                                    } else {
                                      Get.snackbar(
                                        "Update Gagal",
                                        "Nomor telepon belum berhasil diperbarui.",
                                        snackPosition: SnackPosition.TOP,
                                        backgroundColor: const Color(
                                          0xFFE53935,
                                        ).withOpacity(0.92),
                                        colorText: Colors.white,
                                        icon: const Icon(
                                          Icons.error_rounded,
                                          color: Colors.white,
                                        ),
                                        margin: const EdgeInsets.all(16),
                                        borderRadius: 16,
                                        titleText: Text(
                                          "Update Gagal",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        messageText: Text(
                                          "Nomor telepon belum berhasil diperbarui.",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    Get.snackbar(
                                      "Terjadi Kesalahan",
                                      "Koneksi atau server bermasalah. Silakan coba lagi.",
                                      snackPosition: SnackPosition.TOP,
                                      backgroundColor: const Color(
                                        0xFFE53935,
                                      ).withOpacity(0.92),
                                      colorText: Colors.white,
                                      icon: const Icon(
                                        Icons.wifi_off_rounded,
                                        color: Colors.white,
                                      ),
                                      margin: const EdgeInsets.all(16),
                                      borderRadius: 16,
                                      titleText: Text(
                                        "Terjadi Kesalahan",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      messageText: Text(
                                        "Koneksi atau server bermasalah. Silakan coba lagi.",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                    );
                                  } finally {
                                    isLoading.value = false;
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF003E79),
                            disabledBackgroundColor: const Color(0xFF003E79),
                            disabledForegroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: isLoading.value
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  "Simpan Nomor",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  // logout
  void logout() {
    Get.bottomSheet(
      Obx(
        () => Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 5,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  size: 34,
                  color: Color(0xFF003E79),
                ),
              ),

              const SizedBox(height: 18),

              Text(
                "Keluar dari Akun?",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF003E79),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Anda akan keluar dari akun Musrenbang Desa Sukorejo.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  height: 1.5,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: isLoading.value ? null : () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isLoading.value
                                ? Colors.grey.shade200
                                : Colors.grey.shade300,
                          ),
                          backgroundColor: isLoading.value
                              ? Colors.grey.shade100
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: isLoading.value
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.grey.shade500,
                                ),
                              )
                            : Text(
                                "Batal",
                                style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading.value
                            ? null
                            : () async {
                                try {
                                  isLoading.value = true;

                                  imageUrl.value = "";
                                  nama.value = "";
                                  nik.value = "";
                                  alamat.value = "";
                                  noHp.value = "";
                                  jenisKelamin.value = "";

                                  await box.erase();

                                  Get.back();

                                  Get.offAllNamed('/login');
                                } finally {
                                  isLoading.value = false;
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003E79),
                          disabledBackgroundColor: const Color(0xFF003E79),
                          disabledForegroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: isLoading.value
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "Logout",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }
}

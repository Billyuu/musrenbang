import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musrenbang/services/api_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfilController extends GetxController {
  var isLoading = false.obs;
  var bottomNavIndex = 2.obs; // karena ini halaman profil

  // 🔥 Data user (kosong dulu, akan diisi saat login)
  var nama = "".obs;
  var nik = "".obs;
  var alamat = "".obs;
  var noHp = "".obs;
  var jenisKelamin = "".obs;

  /// 🔥 Method untuk menerima data dari LoginController
  void setUserData(Map<String, dynamic> user) {
    nama.value = user["nama"] ?? "";
    nik.value = user["nik"] ?? "";
    alamat.value = user["alamat"] ?? "";
    noHp.value = user["nomor_telepon"] ?? "";

    // Konversi jenis kelamin
    if (user["jenis_kelamin"] == "L") {
      jenisKelamin.value = "Laki-laki";
    } else if (user["jenis_kelamin"] == "P") {
      jenisKelamin.value = "Perempuan";
    } else {
      jenisKelamin.value = user["jenis_kelamin"] ?? "";
    }
  }

  //uploud foto
  Future<void> uploadFotoKeServer() async {
    if (selectedImage.value == null) return;

    try {
      isLoading(true);

      String? url = await ApiService.uploadFoto(selectedImage.value!);

      if (url != null) {
        imageUrl.value = url;
        Get.snackbar("Sukses", "Foto berhasil diupload");
      } else {
        Get.snackbar("Error", "Upload gagal");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadProfile() async {
    try {
      String? url = await ApiService.getProfileFoto();

      if (url != null) {
        imageUrl.value = url;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  var imageUrl = "".obs; // URL dari server
  final ImagePicker picker = ImagePicker(); // Untuk pilih gambar
  var selectedImage = Rx<File?>(null); // File gambar yang dipilih

  // ===== Fungsi edit foto =====
  void editFoto() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const Text(
              "Pilih Foto",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // 📸 Ambil dari Kamera
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Kamera"),
              onTap: () async {
                Get.back();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 70,
                );
                if (image != null) {
                  selectedImage.value = File(image.path);

                  await uploadFotoKeServer();
                }
              },
            ),

            // 🖼 Ambil dari Galeri
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Galeri"),
              onTap: () async {
                Get.back();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 70,
                );
                if (image != null) {
                  selectedImage.value = File(image.path);
                  // 🔥 opsional: langsung upload ke API
                  // await uploadImage();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  //alamat
  void editAlamat() {
    TextEditingController alamatController = TextEditingController(
      text: alamat.value,
    );

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25), // 🔥 rounded modern
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Text(
              "Edit Alamat",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),
            TextField(
              controller: alamatController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Masukkan alamat lengkap",
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (alamatController.text.isEmpty) {
                    Get.snackbar("Error", "Alamat tidak boleh kosong");
                    return;
                  }

                  try {
                    isLoading(true);

                    alamat.value = alamatController.text;

                    bool success = await ApiService.updateAlamat(alamat.value);

                    if (success) {
                      Get.back();
                      Get.snackbar("Sukses", "Alamat berhasil diupdate");
                    } else {
                      Get.snackbar("Error", "Gagal update alamat");
                    }
                  } catch (e) {
                    Get.snackbar("Error", "Terjadi kesalahan koneksi");
                  } finally {
                    isLoading(false);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1565C0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Simpan",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  //No hp
  void editNoHp() {
    final TextEditingController noHpController = TextEditingController(
      text: noHp.value,
    );

    Get.bottomSheet(
      ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        child: Container(
          color: Colors.white,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// DRAG HANDLE
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  /// TITLE
                  const Text(
                    "Edit Nomor Telepon",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  /// INPUT
                  TextField(
                    controller: noHpController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Masukkan nomor telepon",
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (noHpController.text.isEmpty) {
                          Get.snackbar("Error", "Nomor HP tidak boleh kosong");
                          return;
                        }

                        noHp.value = noHpController.text;
                        Get.back();

                        bool success = await ApiService.updateNoHp(noHp.value);

                        if (success) {
                          Get.snackbar("Sukses", "Nomor HP berhasil diupdate");
                        } else {
                          Get.snackbar("Error", "Gagal update nomor HP");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1565C0),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Simpan",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  //logout
  void logout() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const Icon(Icons.logout, size: 40, color: Colors.red),

            const SizedBox(height: 10),

            const Text("Yakin ingin logout?", style: TextStyle(fontSize: 16)),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      "Batal",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

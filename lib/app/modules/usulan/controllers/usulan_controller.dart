import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musrenbang/services/api_service.dart';

class UsulanController extends GetxController {
  // 1. Controller untuk TextField
  final judulController = TextEditingController();
  final permasalahanController = TextEditingController();
  final biayaController = TextEditingController();
  final lokasiController = TextEditingController();
  final koordinatController = TextEditingController();

  // 2. Variabel untuk Dropdown
  var selectedDusun = "".obs;
  var selectedUrgensi = "".obs;
  var selectedTerdampak = "".obs;
  var selectedKerusakan = "".obs;

  // 3. Variabel untuk Foto
  var selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  // 4. Loading state
  var isLoading = false.obs;

  // Fungsi ambil foto
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  Future<void> simpanUsulan() async {
    // Validasi dasar
    String errorMessage = "";

    if (judulController.text.isEmpty) {
      errorMessage = "Judul usulan wajib diisi";
    } else if (permasalahanController.text.isEmpty) {
      errorMessage = "Permasalahan wajib diisi";
    } else if (selectedDusun.value.isEmpty) {
      errorMessage = "Dusun wajib dipilih";
    } else if (selectedUrgensi.value.isEmpty) {
      errorMessage = "Urgensi wajib dipilih";
    } else if (selectedTerdampak.value.isEmpty) {
      errorMessage = "Masyarakat terdampak wajib dipilih";
    } else if (selectedKerusakan.value.isEmpty) {
      errorMessage = "Tingkat kerusakan wajib dipilih";
    } else if (biayaController.text.isEmpty) {
      errorMessage = "Biaya wajib diisi";
    } else if (lokasiController.text.isEmpty) {
      errorMessage = "Lokasi wajib diisi";
    } else if (koordinatController.text.isEmpty) {
      errorMessage = "Koordinat wajib diisi";
    } else if (selectedImage.value == null) {
      errorMessage = "Foto usulan wajib diupload";
    }

    if (errorMessage.isNotEmpty) {
      Get.snackbar(
        "Validasi",
        errorMessage,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Tampilkan loading
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // Siapkan data teks dalam bentuk Map<String, String>
      Map<String, String> body = {
  "user_id": "1",
  "judul_usulan": judulController.text,
  "permasalahan": permasalahanController.text,
  "dusun": selectedDusun.value,
  "urgensi": selectedUrgensi.value,
  "masyarakat_terdampak": selectedTerdampak.value,
  "tingkat_kerusakan": selectedKerusakan.value,
  "biaya": biayaController.text.replaceAll('.', ''),
  "lokasi_detail": lokasiController.text,
  "koordinat": koordinatController.text,
};

      // Panggil ApiService
      var result = await ApiService.simpanUsulan(
        data: body,
        foto: selectedImage.value, // Kirim File jika ada, null jika tidak
      );

      Get.back(); // Tutup loading

      if (result['statusCode'] == 200 || result['statusCode'] == 201) {
        Get.snackbar(
          "Berhasil",
          "Usulan berhasil disimpan",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        _bersihkanForm();
        Get.offAllNamed('/home');
      } else {
        Get.snackbar("Gagal", result['body']['message'] ?? "Terjadi kesalahan");
      }
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Gagal mengirim data: $e");
    }
  }

  void _bersihkanForm() {
    // Reset semua TextEditingController
    judulController.clear();
    permasalahanController.clear();
    biayaController.clear();
    lokasiController.clear();
    koordinatController.clear();
    // Reset semua variabel Rx (GetX) ke nilai awal
    selectedDusun.value = "";
    selectedUrgensi.value = "";
    selectedTerdampak.value = "";
    selectedKerusakan.value = "";
    selectedImage.value = null; // Reset foto

    update(); // Memastikan UI diperbarui
  }
}

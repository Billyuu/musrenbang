import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musrenbang/services/api_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musrenbang/app/routes/app_pages.dart';

class UsulanController extends GetxController {
  final judulController = TextEditingController();
  final permasalahanController = TextEditingController();
  final biayaController = TextEditingController();
  final panjangController = TextEditingController();
  final lebarController = TextEditingController();
  final tinggiController = TextEditingController();
  final lokasiController = TextEditingController();
  final koordinatController = TextEditingController();

  var selectedDusun = "".obs;
  var selectedUrgensi = "".obs;
  var selectedTerdampak = "".obs;
  var selectedKerusakan = "".obs;

  var selectedImageDepan = Rx<File?>(null);
  var selectedImageBelakang = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

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
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
      ),
    );
  }

  Future<void> pickImageDepan() async {
  final XFile? image = await _picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 70,
    maxWidth: 1280,
    maxHeight: 1280,
  );

  if (image != null) {
    final file = File(image.path);
    final sizeInBytes = await file.length();
    final sizeInMb = sizeInBytes / (1024 * 1024);

    if (sizeInMb > 2) {
      showMessage(
        title: "Foto terlalu besar",
        message: "Ukuran foto depan maksimal 2 MB.",
      );
      return;
    }

    selectedImageDepan.value = file;
  }
}

Future<void> pickImageBelakang() async {
  final XFile? image = await _picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 70,
    maxWidth: 1280,
    maxHeight: 1280,
  );

  if (image != null) {
    final file = File(image.path);
    final sizeInBytes = await file.length();
    final sizeInMb = sizeInBytes / (1024 * 1024);

    if (sizeInMb > 2) {
      showMessage(
        title: "Foto terlalu besar",
        message: "Ukuran foto belakang maksimal 2 MB.",
      );
      return;
    }

    selectedImageBelakang.value = file;
  }
}

  //hitung volume
  double? hitungVolume() {
    final panjangText = panjangController.text.trim();
    final lebarText = lebarController.text.trim();
    final tinggiText = tinggiController.text.trim();

    if (panjangText.isEmpty && lebarText.isEmpty && tinggiText.isEmpty) {
      return null;
    }

    if (panjangText.isEmpty || lebarText.isEmpty || tinggiText.isEmpty) {
      return null;
    }

    final panjang = double.tryParse(panjangText.replaceAll(',', '.'));
    final lebar = double.tryParse(lebarText.replaceAll(',', '.'));
    final tinggi = double.tryParse(tinggiText.replaceAll(',', '.'));

    if (panjang == null || lebar == null || tinggi == null) {
      return null;
    }

    return panjang * lebar * tinggi;
  }

  bool validateForm() {
    if (judulController.text.trim().isEmpty) {
      showMessage(
        title: "Judul belum diisi",
        message: "Silakan masukkan judul usulan pembangunan.",
      );
      return false;
    }

    if (permasalahanController.text.trim().isEmpty) {
      showMessage(
        title: "Permasalahan belum diisi",
        message: "Silakan jelaskan permasalahan yang terjadi.",
      );
      return false;
    }

    if (selectedDusun.value.isEmpty) {
      showMessage(
        title: "Dusun belum dipilih",
        message: "Silakan pilih dusun lokasi usulan.",
      );
      return false;
    }

    if (selectedUrgensi.value.isEmpty) {
      showMessage(
        title: "Urgensi belum dipilih",
        message: "Silakan pilih tingkat urgensi usulan.",
      );
      return false;
    }

    if (selectedTerdampak.value.isEmpty) {
      showMessage(
        title: "Data terdampak belum dipilih",
        message: "Silakan pilih jumlah masyarakat yang terdampak.",
      );
      return false;
    }

    if (selectedKerusakan.value.isEmpty) {
      showMessage(
        title: "Kerusakan belum dipilih",
        message: "Silakan pilih tingkat kerusakan.",
      );
      return false;
    }

    if (biayaController.text.trim().isEmpty) {
      showMessage(
        title: "Biaya belum diisi",
        message: "Silakan masukkan perkiraan biaya usulan.",
      );
      return false;
    }
    final panjang = panjangController.text.trim();
    final lebar = lebarController.text.trim();
    final tinggi = tinggiController.text.trim();

    final adaInputVolume =
        panjang.isNotEmpty || lebar.isNotEmpty || tinggi.isNotEmpty;

    if (adaInputVolume) {
      if (panjang.isEmpty || lebar.isEmpty || tinggi.isEmpty) {
        showMessage(
          title: "Data volume belum lengkap",
          message:
              "Jika ingin mengisi volume, panjang, lebar, dan tinggi harus diisi lengkap.",
        );
        return false;
      }

      if (double.tryParse(panjang.replaceAll(',', '.')) == null ||
          double.tryParse(lebar.replaceAll(',', '.')) == null ||
          double.tryParse(tinggi.replaceAll(',', '.')) == null) {
        showMessage(
          title: "Format volume tidak valid",
          message: "Panjang, lebar, dan tinggi harus berupa angka.",
        );
        return false;
      }
    }

    if (lokasiController.text.trim().isEmpty) {
      showMessage(
        title: "Lokasi belum diisi",
        message: "Silakan masukkan detail lokasi usulan.",
      );
      return false;
    }

    if (koordinatController.text.trim().isEmpty) {
      showMessage(
        title: "Koordinat belum diisi",
        message: "Silakan masukkan titik koordinat lokasi.",
      );
      return false;
    }

   if (selectedImageDepan.value == null) {
  showMessage(
    title: "Foto depan belum dipilih",
    message: "Silakan unggah foto tampak depan. Maksimal 2 MB.",
  );
  return false;
}

if (selectedImageBelakang.value == null) {
  showMessage(
    title: "Foto belakang belum dipilih",
    message: "Silakan unggah foto tampak belakang. Maksimal 2 MB.",
  );
  return false;
}

    return true;
  }

  Future<void> simpanUsulan() async {
    if (!validateForm()) return;

    try {
      isLoading.value = true;

      final box = GetStorage();
      final userId = box.read("user_id");

      if (userId == null || userId.toString().isEmpty) {
        showMessage(
          title: "Sesi tidak ditemukan",
          message: "Silakan login ulang sebelum mengirim usulan.",
        );
        return;
      }

      final volume = hitungVolume();

      Map<String, String> body = {
        "user_id": userId.toString(),
        "jenis_usulan": "fisik",
        "judul_usulan": judulController.text.trim(),
        "permasalahan": permasalahanController.text.trim(),
        "dusun": selectedDusun.value,
        "urgensi": selectedUrgensi.value,
        "masyarakat_terdampak": selectedTerdampak.value,
        "tingkat_kerusakan": selectedKerusakan.value,
        "biaya": biayaController.text.trim().replaceAll('.', ''),
        "lokasi_detail": lokasiController.text.trim(),
        "koordinat": koordinatController.text.trim(),

        "panjang": panjangController.text.trim().isEmpty
            ? ""
            : panjangController.text.trim().replaceAll(',', '.'),
        "lebar": lebarController.text.trim().isEmpty
            ? ""
            : lebarController.text.trim().replaceAll(',', '.'),
        "tinggi": tinggiController.text.trim().isEmpty
            ? ""
            : tinggiController.text.trim().replaceAll(',', '.'),
        "volume": volume == null ? "" : volume.toStringAsFixed(2),
      };

    var result = await ApiService.simpanUsulan(
  data: body,
  fotoDepan: selectedImageDepan.value,
  fotoBelakang: selectedImageBelakang.value,
);

      if (result['statusCode'] == 200 || result['statusCode'] == 201) {
        showMessage(
          title: "Usulan Berhasil Dikirim",
          message: "Usulan Anda berhasil disimpan dan akan diproses.",
          isSuccess: true,
        );

        _bersihkanForm();
        Get.offAllNamed(Routes.HOME);
      } else {
        showMessage(
          title: "Usulan Gagal Dikirim",
          message:
              result['body']['message'] ?? "Terjadi kesalahan pada server.",
        );
      }
    } catch (e) {
      showMessage(
        title: "Terjadi Kesalahan",
        message: "Koneksi atau server bermasalah. Silakan coba lagi.",
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _bersihkanForm() {
    judulController.clear();
    permasalahanController.clear();
    biayaController.clear();
    panjangController.clear();
    lebarController.clear();
    tinggiController.clear();
    lokasiController.clear();
    koordinatController.clear();

    selectedDusun.value = "";
    selectedUrgensi.value = "";
    selectedTerdampak.value = "";
    selectedKerusakan.value = "";
   selectedImageDepan.value = null;
selectedImageBelakang.value = null;
  }

  @override
  void onClose() {
    judulController.dispose();
    permasalahanController.dispose();
    biayaController.dispose();
    panjangController.dispose();
    lebarController.dispose();
    tinggiController.dispose();
    lokasiController.dispose();
    koordinatController.dispose();
    super.onClose();
  }
}

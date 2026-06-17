import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musrenbang/app/routes/app_pages.dart';
import 'package:musrenbang/services/api_service.dart';

class UsulanNonFisikController extends GetxController {
  final dusunC = TextEditingController();
  final judulC = TextEditingController();
  final permasalahanC = TextEditingController();
  final biayaC = TextEditingController();
  final lokasiC = TextEditingController();

  var tingkatKebutuhan = "".obs;
  var jumlahPenerimaManfaat = "".obs;
  var bidangUsulan = "".obs;

  var selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  var isLoading = false.obs;
  final List<Map<String, String>> opsiTingkatKebutuhan = [
    {'value': 'Sangat Dibutuhkan', 'label': 'Sangat Dibutuhkan'},
    {'value': 'Dibutuhkan', 'label': 'Dibutuhkan'},
    {'value': 'Cukup Dibutuhkan', 'label': 'Cukup Dibutuhkan'},
    {'value': 'Kurang Dibutuhkan', 'label': 'Kurang Dibutuhkan'},
    {'value': 'Tidak Terlalu Dibutuhkan', 'label': 'Tidak Terlalu Dibutuhkan'},
  ];

  final List<Map<String, String>> opsiPenerimaManfaat = [
    {
      'value': 'Sangat Banyak (> 80 orang)',
      'label': 'Sangat Banyak (> 80 orang)',
    },
    {'value': 'Banyak (51 - 80 orang)', 'label': 'Banyak (51 - 80 orang)'},
    {'value': 'Sedang (31 - 50 orang)', 'label': 'Sedang (31 - 50 orang)'},
    {'value': 'Sedikit (11 - 30 orang)', 'label': 'Sedikit (11 - 30 orang)'},
    {
      'value': 'Sangat Sedikit (1 - 10 orang)',
      'label': 'Sangat Sedikit (1 - 10 orang)',
    },
  ];

  final List<Map<String, String>> opsiBidangUsulan = [
    {'value': 'Kesehatan', 'label': 'Kesehatan'},
    {'value': 'Sosial/Kesejahteraan', 'label': 'Sosial/Kesejahteraan'},
    {'value': 'UMKM/Ekonomi', 'label': 'UMKM/Ekonomi'},
    {'value': 'Pendidikan', 'label': 'Pendidikan'},
    {'value': 'Pemberdayaan Masyarakat', 'label': 'Pemberdayaan Masyarakat'},
  ];

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

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  bool validateForm() {
    if (dusunC.text.trim().isEmpty) {
      showMessage(
        title: "Dusun belum dipilih",
        message: "Silakan pilih dusun pengusul.",
      );
      return false;
    }

    if (judulC.text.trim().isEmpty) {
      showMessage(
        title: "Judul belum diisi",
        message: "Silakan masukkan judul usulan non fisik.",
      );
      return false;
    }

    if (permasalahanC.text.trim().isEmpty) {
      showMessage(
        title: "Permasalahan belum diisi",
        message: "Silakan jelaskan permasalahan atau kebutuhan masyarakat.",
      );
      return false;
    }

    if (tingkatKebutuhan.value.isEmpty) {
      showMessage(
        title: "Tingkat kebutuhan belum dipilih",
        message: "Silakan pilih tingkat kebutuhan usulan.",
      );
      return false;
    }

    if (jumlahPenerimaManfaat.value.isEmpty) {
      showMessage(
        title: "Penerima manfaat belum dipilih",
        message: "Silakan pilih jumlah penerima manfaat.",
      );
      return false;
    }
    if (bidangUsulan.value.isEmpty) {
      showMessage(
        title: "Bidang usulan belum dipilih",
        message: "Silakan pilih bidang usulan.",
      );
      return false;
    }

    final biayaBersih = biayaC.text.trim().replaceAll(RegExp(r'[^0-9]'), '');

    if (biayaBersih.isEmpty) {
      showMessage(
        title: "Biaya belum diisi",
        message: "Silakan masukkan estimasi biaya usulan.",
      );
      return false;
    }

    if (lokasiC.text.trim().isEmpty) {
      showMessage(
        title: "Alamat lokasi belum diisi",
        message: "Silakan masukkan alamat lokasi atau sasaran usulan.",
      );
      return false;
    }

    return true;
  }

  Future<void> simpanUsulanNonFisik() async {
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

      final biayaBersih = biayaC.text.trim().replaceAll(RegExp(r'[^0-9]'), '');

      Map<String, String> body = {
        "user_id": userId.toString(),
        "jenis_usulan": "non_fisik",
        "dusun": dusunC.text.trim(),
        "judul_usulan": judulC.text.trim(),
        "permasalahan": permasalahanC.text.trim(),

        // Kriteria non fisik
        "tingkat_kebutuhan": tingkatKebutuhan.value,
        "jumlah_penerima_manfaat": jumlahPenerimaManfaat.value,
        "bidang_usulan": bidangUsulan.value,
        "biaya": biayaBersih,
        // Data umum
        "lokasi_detail": lokasiC.text.trim(),
      };

      print("===== BODY NON FISIK SEBELUM DIKIRIM =====");
      print(body);
      print("TINGKAT KEBUTUHAN: ${tingkatKebutuhan.value}");
      print("JUMLAH PENERIMA MANFAAT: ${jumlahPenerimaManfaat.value}");
      print("BIDANG USULAN: ${bidangUsulan.value}");
      print("BIAYA: $biayaBersih");

      var result = await ApiService.simpanUsulan(
        data: body,
        fotoDepan: selectedImage.value,
        fotoBelakang: null,
      );

      if (result['statusCode'] == 200 || result['statusCode'] == 201) {
        showMessage(
          title: "Usulan Berhasil Dikirim",
          message: "Usulan non fisik Anda berhasil disimpan dan akan diproses.",
          isSuccess: true,
        );

        _bersihkanForm();
        Get.offAllNamed(Routes.HOME);
      } else {
        print("ERROR BODY NON FISIK: ${result['body']}");

        showMessage(
          title: "Usulan Gagal Dikirim",
          message:
              result['body']['message'] ?? "Terjadi kesalahan pada server.",
        );
      }
    } catch (e) {
      print("ERROR SIMPAN NON FISIK: $e");

      showMessage(
        title: "Terjadi Kesalahan",
        message: "Koneksi atau server bermasalah. Silakan coba lagi.",
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _bersihkanForm() {
    dusunC.clear();
    judulC.clear();
    permasalahanC.clear();
    biayaC.clear();
    lokasiC.clear();

    tingkatKebutuhan.value = "";
    jumlahPenerimaManfaat.value = "";
    bidangUsulan.value = "";
    selectedImage.value = null;
  }

  @override
  void onClose() {
    dusunC.dispose();
    judulC.dispose();
    permasalahanC.dispose();
    biayaC.dispose();
    lokasiC.dispose();
    super.onClose();
  }
}

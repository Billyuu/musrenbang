import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musrenbang/services/api_service.dart';

class DetailHasilMusrenbangController extends GetxController {
  final isLoading = false.obs;
  final data = {}.obs;
  final isActionLoading = false.obs;

  late int id;

  @override
  void onInit() {
    super.onInit();

    id = int.tryParse(Get.arguments['id'].toString()) ?? 0;
    getDetail();
  }

  Future<void> getDetail() async {
    try {
      isLoading.value = true;

      // Pakai detail admin dulu karena datanya sudah lengkap.
      // Kalau nanti buat API khusus detail hasil musrenbang, tinggal ganti function ini.
      final result = await ApiService.getDetailUsulanAdmin(id);

      if (result['statusCode'] == 200) {
        data.value = result['body']['data'] ?? {};
      } else {
        Get.snackbar(
          "Gagal",
          result['body']['message']?.toString() ??
              "Detail hasil musrenbang tidak ditemukan",
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil detail hasil musrenbang");
    } finally {
      isLoading.value = false;
    }
  }

  String getFotoUsulan(String fileName) {
    return ApiService.getFotoUsulan(fileName);
  }

  //realisasi
  Future<bool> realisasi({required String tahun}) async {
    try {
      isActionLoading.value = true;

      final result = await ApiService.realisasiUsulan(id: id, tahun: tahun);

      if (result['statusCode'] == 200) {
        Get.snackbar(
          "Berhasil",
          "Usulan berhasil direalisasikan",
          backgroundColor: const Color(0xFF003E79),
          colorText: Colors.white,
        );

        return true;
      } else {
        Get.snackbar(
          "Gagal",
          result['body']['message'] ?? "Gagal merealisasikan usulan",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Terjadi kesalahan: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return false;
    } finally {
      isActionLoading.value = false;
    }
  }

  //tunda
  Future<bool> tunda({required String tahun, required String catatan}) async {
    try {
      isActionLoading.value = true;

      final result = await ApiService.tundaUsulan(
        id: id,
        tahun: tahun,
        catatan: catatan,
      );

      if (result['statusCode'] == 200) {
        Get.snackbar(
          "Berhasil",
          "Usulan berhasil ditunda",
          backgroundColor: const Color(0xFF003E79),
          colorText: Colors.white,
        );

        return true;
      } else {
        Get.snackbar(
          "Gagal",
          result['body']['message'] ?? "Gagal menunda usulan",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Terjadi kesalahan: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return false;
    } finally {
      isActionLoading.value = false;
    }
  }
}

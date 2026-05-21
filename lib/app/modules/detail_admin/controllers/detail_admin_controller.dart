import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musrenbang/services/api_service.dart';
import 'package:musrenbang/app/modules/admin/controllers/admin_controller.dart';

class DetailAdminController extends GetxController {
  final isLoading = false.obs;
  final data = {}.obs;

  late int id;

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments['id'];
    getDetail();
  }

  Future<void> getDetail() async {
    isLoading.value = true;

    final result = await ApiService.getDetailUsulanAdmin(id);

    if (result['statusCode'] == 200) {
      data.value = result['body']['data'] ?? {};
    }

    isLoading.value = false;
  }

  //terima
  Future<bool> terima({
    required String biayaFinal,
    required String tahun,
  }) async {
    try {
      isLoading.value = true;

      final result = await ApiService.terimaUsulanAdmin(
        id: id,
        biayaFinal: biayaFinal,
        tahunRealisasi: tahun,
      );

      if (result['statusCode'] == 200) {
        Get.snackbar(
          "Berhasil",
          "Usulan berhasil disetujui",
          backgroundColor: const Color(0xFF003E79),
          colorText: Colors.white,
        );

        await getDetail();

        if (Get.isRegistered<AdminController>()) {
          final adminC = Get.find<AdminController>();
          adminC.statusAktif.value = "Disetujui";
          await adminC.refreshData();
        }

        return true;
      } else {
        Get.snackbar(
          "Gagal",
          result['body']['message']?.toString() ?? "Usulan gagal disetujui",
        );

        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  //tolak usulan
  Future<bool> tolak({required String catatan}) async {
    try {
      isLoading.value = true;

      final result = await ApiService.tolakUsulanAdmin(
        id: id,
        catatan: catatan,
      );

      if (result['statusCode'] == 200) {
        Get.snackbar(
          "Berhasil",
          "Usulan berhasil ditolak",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        await getDetail();

        if (Get.isRegistered<AdminController>()) {
          final adminC = Get.find<AdminController>();
          adminC.statusAktif.value = "Ditolak";
          await adminC.refreshData();
        }

        return true;
      } else {
        Get.snackbar(
          "Gagal",
          result['body']['message']?.toString() ?? "Usulan gagal ditolak",
        );

        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> hapus() async {
    await ApiService.hapusUsulanAdmin(id);
    Get.back(result: true);
  }

  String getFotoUsulan(String fileName) {
    return ApiService.getFotoUsulan(fileName);
  }
}

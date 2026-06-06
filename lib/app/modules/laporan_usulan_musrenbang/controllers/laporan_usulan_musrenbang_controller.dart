import 'package:get/get.dart';
import 'package:musrenbang/services/api_service.dart';
import 'package:musrenbang/services/laporan_usulan_pdf.dart';

class LaporanUsulanMusrenbangController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var dataUsulan = <dynamic>[].obs;

  var statusAktif = "Diproses".obs;
  var jenisAktif = "Fisik".obs;

  // total kategori usulan berdasarkan status aktif
  int totalByJenis(String jenis) {
    return dataUsulan.where((item) {
      final status = item["status"]?.toString().toLowerCase().trim() ?? "";
      final jenisUsulan = formatJenis(item["jenis_usulan"]);

      return status == statusAktif.value.toLowerCase().trim() &&
          jenisUsulan == jenis;
    }).length;
  }

  @override
  void onInit() {
    super.onInit();
    getDataLaporan();
  }

  Future<void> refreshData() async {
    await getDataLaporan();
  }

  Future<void> getDataLaporan() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await ApiService.getAllUsulanAdmin();

      if (result["statusCode"] == 200) {
        final data = result["body"]["data"];

        if (data is List) {
          dataUsulan.value = data;
        } else {
          dataUsulan.value = [];
        }
      } else {
        errorMessage.value =
            result["body"]["message"]?.toString() ??
            "Gagal mengambil data laporan";
      }
    } catch (e) {
      errorMessage.value = "Terjadi kesalahan: $e";
    } finally {
      isLoading.value = false;
    }
  }

  String mapJenis(String jenis) {
    return jenis == "Non Fisik" ? "non_fisik" : "fisik";
  }

  List<dynamic> get filteredLaporan {
    final status = statusAktif.value.toLowerCase().trim();
    final jenis = mapJenis(jenisAktif.value);

    return dataUsulan.where((item) {
      final statusItem = item["status"]?.toString().toLowerCase().trim() ?? "";

      final jenisItem =
          item["jenis_usulan"]?.toString().toLowerCase().trim() ?? "fisik";

      return statusItem == status && jenisItem == jenis;
    }).toList();
  }

  int countStatus(String status) {
    return dataUsulan.where((item) {
      final statusItem = item["status"]?.toString().toLowerCase().trim() ?? "";

      return statusItem == status.toLowerCase().trim();
    }).length;
  }

  int totalByStatus(String status) {
    return dataUsulan.where((item) {
      final statusItem = item["status"]?.toString().toLowerCase().trim() ?? "";

      return statusItem == status.toLowerCase().trim();
    }).length;
  }

  String formatJenis(dynamic value) {
    final jenis = value?.toString().toLowerCase().trim() ?? "fisik";

    if (jenis == "non_fisik") {
      return "Non Fisik";
    }

    return "Fisik";
  }

  //pdf
  Future<void> cetakLaporan() async {
    final data = filteredLaporan;

    if (data.isEmpty) {
      Get.snackbar("Tidak Ada Data", "Tidak ada data laporan untuk dicetak.");
      return;
    }

    await LaporanUsulanPdfService.cetakLaporan(
      data: data,
      status: statusAktif.value,
      jenis: jenisAktif.value,
    );
  }
}

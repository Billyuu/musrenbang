import 'package:get/get.dart';
import 'package:musrenbang/services/api_service.dart';

class HasilMusrenbangController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var dataHasil = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    getHasilMusrenbang();
  }

  //tahun hasil musrenbang
  final tahunAktif = 2026.obs;

final List<int> daftarTahun = List.generate(
  10,
  (index) => 2026 + index,
);

void pilihTahun(int tahun) {
  tahunAktif.value = tahun;
}

List<dynamic> get hasilSesuaiTahun {
  return dataHasil.where((item) {
    final tahunRealisasi =
        item["tahun_realisasi"]?.toString().trim() ?? "";

    return tahunRealisasi == tahunAktif.value.toString();
  }).toList();
}

  Future<void> getHasilMusrenbang() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await ApiService.getHasilMusrenbang();

      if (result["statusCode"] == 200) {
        dataHasil.value = result["body"]["data"] ?? [];
      } else {
        errorMessage.value =
            result["body"]["message"] ?? "Gagal mengambil data hasil musrenbang";
      }
    } catch (e) {
      errorMessage.value = "Terjadi kesalahan saat mengambil data hasil musrenbang";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await getHasilMusrenbang();
  }
}
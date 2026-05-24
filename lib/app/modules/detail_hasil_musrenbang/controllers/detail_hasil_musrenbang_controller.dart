import 'package:get/get.dart';
import 'package:musrenbang/services/api_service.dart';

class DetailHasilMusrenbangController extends GetxController {
  final isLoading = false.obs;
  final data = {}.obs;

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
}
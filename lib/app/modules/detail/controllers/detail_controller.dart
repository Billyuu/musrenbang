import 'package:get/get.dart';
import 'package:musrenbang/services/api_service.dart';

class DetailController extends GetxController {
  final isLoading = false.obs;
  final detailUsulan = {}.obs;

  late int idUsulan;

  @override
  void onInit() {
    super.onInit();

    idUsulan = int.tryParse(Get.arguments['id'].toString()) ?? 0;

    getDetailUsulan();
  }

  Future<void> getDetailUsulan() async {
    try {
      isLoading.value = true;

      final result = await ApiService.getDetailUsulan(idUsulan);

      if (result["statusCode"] == 200) {
        detailUsulan.value = result["body"]["data"];
      } else {
        Get.snackbar(
          "Gagal",
          result["body"]["message"] ?? "Data detail usulan tidak ditemukan",
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil detail usulan");
    } finally {
      isLoading.value = false;
    }
  }
}
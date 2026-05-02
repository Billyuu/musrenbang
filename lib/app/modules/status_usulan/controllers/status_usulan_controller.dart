import 'package:get/get.dart';
import 'package:musrenbang/services/api_service.dart';

class StatusUsulanController extends GetxController {
  // 🔄 State
  var isLoading = false.obs;
  var dataUsulan = <dynamic>[].obs;
  var errorMessage = "".obs;

  // 🔥 sementara hardcode (nanti ambil dari login)
  final int userId = 1;

  @override
  void onInit() {
    super.onInit();
    getUsulan();
  }

  // =============================
  // 🔥 GET DATA USULAN
  // =============================
  Future<void> getUsulan() async {
    try {
      isLoading(true);
      errorMessage.value = "";

      var result = await ApiService.getUsulan(userId);

      print("GET STATUS: ${result['statusCode']}");
      print("GET BODY: ${result['body']}");

      if (result['statusCode'] == 200) {
        dataUsulan.value = result['body']['data'] ?? [];
      } else {
        errorMessage.value = result['body']['message'] ?? "Gagal mengambil data";
        dataUsulan.clear();
      }
    } catch (e) {
      errorMessage.value = "Terjadi kesalahan: $e";
      dataUsulan.clear();
      print("ERROR GET USULAN: $e");
    } finally {
      isLoading(false);
    }
  }

  // =============================
  // 🔄 REFRESH (PULL TO REFRESH)
  // =============================
  Future<void> refreshData() async {
    await getUsulan();
  }

  // =============================
  // 📊 HELPER (OPTIONAL)
  // =============================
  bool get isEmpty => dataUsulan.isEmpty;
}
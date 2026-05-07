import 'package:get/get.dart';
import 'package:musrenbang/services/api_service.dart';
import 'package:get_storage/get_storage.dart';

class StatusUsulanController extends GetxController {
  // 🔄 State
  var isLoading = false.obs;
  var dataUsulan = <dynamic>[].obs;
  var errorMessage = "".obs;

  //id_user
  final box = GetStorage();

  int get userId => box.read("user_id") ?? 0;

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

      print("USER LOGIN ID: $userId");

      var result = await ApiService.getUsulan(userId);

      print("GET STATUS: ${result['statusCode']}");
      print("GET BODY: ${result['body']}");

      if (result['statusCode'] == 200) {
        dataUsulan.value = result['body']['data'] ?? [];
      } else {
        errorMessage.value =
            result['body']['message'] ?? "Gagal mengambil data";
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

  get statusAktif => null;

  get filteredUsulan => null;
}

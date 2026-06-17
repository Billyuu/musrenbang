import 'package:get/get.dart';
import 'package:musrenbang/app/modules/profil/controllers/profil_controller.dart';
import 'package:musrenbang/services/api_service.dart';
import 'package:musrenbang/app/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  //usulan
  Future<void> fetchHomeData() async {
    try {
      isLoading(true);
      var result = await ApiService.getUsulan(userId);
      if (result['statusCode'] == 200) {
        // Ambil 3-5 data terbaru saja untuk di Home
        var semuaData = result['body']['data'] ?? [];
        dataUsulan.value = semuaData.take(5).toList();
      }
    } finally {
      isLoading(false);
    }
  }

  /// 🔢 Bottom Navigation Index
  var bottomNavIndex = 0.obs;

  /// 👤 Ambil data profil
  final ProfilController profilController = Get.find<ProfilController>();

  /// 🔄 State
  var isLoading = false.obs;
  var dataUsulan = <dynamic>[].obs;
  var errorMessage = "".obs;

  final box = GetStorage();
  late int userId;

  /// 🎯 Status aktif (UI)
  var statusAktif = "Diproses".obs;

  String mapStatus(String statusUI) {
    switch (statusUI.toLowerCase()) {
      case "diproses":
        return "diproses";
      case "disetujui":
        return "disetujui";
      case "ditolak":
        return "ditolak";
      case "ditunda":
        return "ditunda";
      case "direalisasikan":
        return "direalisasikan";
      default:
        return "";
    }
  }

  //filter data usulan
  List<dynamic> get filteredUsulan {
    final statusFilter = statusAktif.value.toLowerCase().trim();

    return dataUsulan.where((item) {
      final statusApi = item["status"]?.toString().toLowerCase().trim() ?? "";

      print("STATUS API: $statusApi");
      print("STATUS FILTER: $statusFilter");

      return statusApi == statusFilter;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();

    final role = box.read("role");
    final isLogin = box.read("is_login") == true;
    final isUserLogin = box.read("isUserLogin") == true;
    final storedUserId = box.read("user_id");

    if (!isLogin || role != "user" || !isUserLogin || storedUserId == null) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

   if (storedUserId == null || storedUserId == "") {
  Get.offAllNamed(Routes.LOGIN);
  return;
}

userId = int.parse(storedUserId.toString());

    if (userId == 0) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    print("USER ID HOME: $userId");

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

        // 🔥 DEBUG DATA
        print("DATA USULAN: $dataUsulan");
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
  // 📭 HELPER
  // =============================
  bool get isEmpty => dataUsulan.isEmpty;
}

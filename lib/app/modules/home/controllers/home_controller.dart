import 'package:get/get.dart';
import 'package:musrenbang/app/modules/profil/controllers/profil_controller.dart';
import 'package:musrenbang/services/api_service.dart';

class HomeController extends GetxController {
  /// 🔢 Bottom Navigation Index
  var bottomNavIndex = 0.obs;

  /// 👤 Ambil data profil
  final ProfilController profilController = Get.find<ProfilController>();

  /// 🔄 State
  var isLoading = false.obs;
  var dataUsulan = <dynamic>[].obs;
  var errorMessage = "".obs;

  /// 🔥 sementara (nanti dari login)
  final int userId = 1;

  /// 🎯 Status aktif (UI)
  var statusAktif = "Diproses".obs;

  // =============================
  // 🔄 MAPPING STATUS UI → API
  // =============================
  String mapStatus(String statusUI) {
    switch (statusUI) {
      case "Diproses":
        return "pending";
      case "Disetujui":
        return "disetujui";
      case "Ditolak":
        return "ditolak";
      default:
        return "";
    }
  }

  // =============================
  // 📊 FILTER DATA BERDASARKAN STATUS
  // =============================
  List<dynamic> get filteredUsulan {
    final statusFilter = mapStatus(statusAktif.value).toLowerCase();

    return dataUsulan.where((item) {
      final statusApi =
          item["status"]?.toString().toLowerCase() ?? "";

      // 🔥 DEBUG (hapus kalau sudah aman)
      print("STATUS API: $statusApi");
      print("STATUS FILTER: $statusFilter");

      return statusApi == statusFilter;
    }).toList();
  }

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
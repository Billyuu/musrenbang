import 'package:get/get.dart';
import 'package:musrenbang/services/api_service.dart';
import 'package:get_storage/get_storage.dart';

class StatusUsulanController extends GetxController {
  // 🔄 State
  var isLoading = false.obs;
  var dataUsulan = <dynamic>[].obs;
  var errorMessage = "".obs;

  // =============================
  // 📌 KATEGORI FISIK / NON FISIK
  // =============================
 var kategoriAktif = "Fisik".obs;

  void pilihKategori(String kategori) {
    kategoriAktif.value = kategori;
  }

  int get totalFisik {
    return dataUsulan.where((item) {
      final jenis = item["jenis_usulan"]?.toString().toLowerCase().trim() ?? "";
      return jenis == "fisik";
    }).length;
  }

  int get totalNonFisik {
    return dataUsulan.where((item) {
      final jenis = item["jenis_usulan"]?.toString().toLowerCase().trim() ?? "";
      return jenis == "non_fisik";
    }).length;
  }

  List<dynamic> get filteredUsulan {
    return dataUsulan.where((item) {
      final jenis = item["jenis_usulan"]?.toString().toLowerCase().trim() ?? "";

      if (kategoriAktif.value == "Fisik") {
        return jenis == "fisik";
      }

      return jenis == "non_fisik";
    }).toList();
  }

  // =============================
  // 👤 USER ID
  // =============================
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

        print("TOTAL DATA: ${dataUsulan.length}");
        print("TOTAL FISIK: $totalFisik");
        print("TOTAL NON FISIK: $totalNonFisik");
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
  // 🔄 REFRESH
  // =============================
  Future<void> refreshData() async {
    await getUsulan();
  }

  // =============================
  // 📊 HELPER
  // =============================
  bool get isEmpty => dataUsulan.isEmpty;
}

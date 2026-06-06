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

  //pencarian
  var keywordPencarian = ''.obs;
  void ubahPencarian(String value) {
    keywordPencarian.value = value;
  }

  //total usulan
int get totalSemuaUsulan {
  return hasilSesuaiTahun.length;
}

int get totalFisik {
  return hasilSesuaiTahun.where((item) {
    final jenis = item["jenis_usulan"]?.toString().toLowerCase().trim() ?? "";
    return jenis == "fisik";
  }).length;
}

int get totalNonFisik {
  return hasilSesuaiTahun.where((item) {
    final jenis = item["jenis_usulan"]?.toString().toLowerCase().trim() ?? "";
    return jenis == "non_fisik" || jenis == "non fisik";
  }).length;
}

  List<dynamic> get hasilSesuaiKategoriPencarian {
    final data = hasilSesuaiKategori;
    final keyword = keywordPencarian.value.toLowerCase().trim();

    if (keyword.isEmpty) {
      return data;
    }

    return data.where((item) {
      final judul = item["judul_usulan"]?.toString().toLowerCase().trim() ?? "";

      final lokasi =
          item["lokasi_detail"]?.toString().toLowerCase().trim() ?? "";

      final dusun = item["dusun"]?.toString().toLowerCase().trim() ?? "";

      final tahun =
          item["tahun_realisasi"]?.toString().toLowerCase().trim() ?? "";

      final status = item["status"]?.toString().toLowerCase().trim() ?? "";

      final jenis = item["jenis_usulan"]?.toString().toLowerCase().trim() ?? "";

      return judul.contains(keyword) ||
          lokasi.contains(keyword) ||
          dusun.contains(keyword) ||
          tahun.contains(keyword) ||
          status.contains(keyword) ||
          jenis.contains(keyword);
    }).toList();
  }

  //kategori
  var kategoriAktif = "Fisik".obs;

  void pilihKategori(String kategori) {
    kategoriAktif.value = kategori;
  }

  List<dynamic> get hasilSesuaiKategori {
    final data = hasilSesuaiTahun;

    if (kategoriAktif.value == "Fisik") {
      return data.where((item) {
        final jenis =
            item["jenis_usulan"]?.toString().toLowerCase().trim() ?? "";
        return jenis == "fisik";
      }).toList();
    }

    if (kategoriAktif.value == "Non Fisik") {
      return data.where((item) {
        final jenis =
            item["jenis_usulan"]?.toString().toLowerCase().trim() ?? "";
        return jenis == "non_fisik";
      }).toList();
    }

    return data;
  }

  //tahun hasil musrenbang
  final tahunAktif = 2026.obs;

  final List<int> daftarTahun = List.generate(15, (index) => 2026 + index);

  void pilihTahun(int tahun) {
    tahunAktif.value = tahun;
  }

  List<dynamic> get hasilSesuaiTahun {
    return dataHasil.where((item) {
      final tahunRealisasi = item["tahun_realisasi"]?.toString().trim() ?? "";

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
            result["body"]["message"] ??
            "Gagal mengambil data hasil musrenbang";
      }
    } catch (e) {
      errorMessage.value =
          "Terjadi kesalahan saat mengambil data hasil musrenbang";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await getHasilMusrenbang();
  }
}

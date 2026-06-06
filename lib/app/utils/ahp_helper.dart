class AhpHelper {
  // =========================
  // BOBOT KRITERIA AHP FISIK
  // =========================
  static const double bobotUrgensi = 0.40;
  static const double bobotDampak = 0.30;
  static const double bobotKerusakan = 0.20;
  static const double bobotBiaya = 0.10;

  // =========================
  // BOBOT KRITERIA AHP NON FISIK
  // =========================
  static const double bobotKebutuhan = 0.35;
  static const double bobotPenerimaManfaat = 0.25;
  static const double bobotDampakSosial = 0.25;
  static const double bobotKelayakan = 0.15;

  // =========================
  // HITUNG TOTAL AHP OTOMATIS
  // =========================
  static double hitungTotalAhp(dynamic item) {
    final jenisUsulan =
        item["jenis_usulan"]?.toString().toLowerCase().trim() ?? "fisik";

    if (jenisUsulan == "non_fisik") {
      return hitungTotalAhpNonFisik(item);
    }

    return hitungTotalAhpFisik(item);
  }

  // =========================
  // HITUNG TOTAL AHP FISIK
  // =========================
  static double hitungTotalAhpFisik(dynamic item) {
    String kondisiUrgensi = item["urgensi"]?.toString() ?? "-";
    String kondisiDampak = item["masyarakat_terdampak"]?.toString() ?? "-";
    String kondisiKerusakan = item["tingkat_kerusakan"]?.toString() ?? "-";
    String biayaInputUser = item["biaya"]?.toString() ?? "0";

    double skorUrgensi = skorUrgensiKondisi(kondisiUrgensi);
    double skorDampak = skorDampakKondisi(kondisiDampak);
    double skorKerusakan = skorKerusakanKondisi(kondisiKerusakan);
    double skorBiaya = skorBiayaNominal(biayaInputUser);

    return (bobotUrgensi * skorUrgensi) +
        (bobotDampak * skorDampak) +
        (bobotKerusakan * skorKerusakan) +
        (bobotBiaya * skorBiaya);
  }

  // =========================
  // HITUNG TOTAL AHP NON FISIK
  // =========================
  static double hitungTotalAhpNonFisik(dynamic item) {
    String kondisiKebutuhan = item["tingkat_kebutuhan"]?.toString() ?? "-";
    String kondisiPenerima =
        item["jumlah_penerima_manfaat"]?.toString() ?? "-";
    String kondisiDampakSosial = item["dampak_sosial"]?.toString() ?? "-";
    String kondisiKelayakan =
        item["kelayakan_pelaksanaan"]?.toString() ?? "-";

    double skorKebutuhan = skorKebutuhanKondisi(kondisiKebutuhan);
    double skorPenerima = skorPenerimaManfaatKondisi(kondisiPenerima);
    double skorDampakSosial =
        skorDampakSosialKondisi(kondisiDampakSosial);
    double skorKelayakan = skorKelayakanKondisi(kondisiKelayakan);

    return (bobotKebutuhan * skorKebutuhan) +
        (bobotPenerimaManfaat * skorPenerima) +
        (bobotDampakSosial * skorDampakSosial) +
        (bobotKelayakan * skorKelayakan);
  }

  // =========================
  // SKOR URGENSI FISIK
  // =========================
  static double skorUrgensiKondisi(String kondisi) {
    final value = kondisi.toLowerCase();

    if (value.contains("sangat mendesak")) return 5;
    if (value.contains("cukup mendesak")) return 3;
    if (value.contains("kurang mendesak")) return 2;
    if (value.contains("tidak mendesak")) return 1;
    if (value.contains("mendesak")) return 4;

    return double.tryParse(kondisi) ?? 0;
  }

  // =========================
  // SKOR MASYARAKAT TERDAMPAK FISIK
  // =========================
  static double skorDampakKondisi(String kondisi) {
    final value = kondisi.toLowerCase();

    if (value.contains("desa")) return 5;
    if (value.contains("dusun")) return 4;
    if (value.contains("rw")) return 3;
    if (value.contains("rt")) return 2;
    if (value.contains("kelompok")) return 1;

    return double.tryParse(kondisi) ?? 0;
  }

  // =========================
  // SKOR TINGKAT KERUSAKAN FISIK
  // =========================
  static double skorKerusakanKondisi(String kondisi) {
    final value = kondisi.toLowerCase();

    if (value.contains("tidak punya")) return 5;
    if (value.contains("rusak berat")) return 4;
    if (value.contains("rusak sedang")) return 3;
    if (value.contains("rusak ringan")) return 2;
    if (value.contains("layak")) return 1;

    return double.tryParse(kondisi) ?? 0;
  }

  // =========================
  // SKOR TINGKAT KEBUTUHAN NON FISIK
  // =========================
  static double skorKebutuhanKondisi(String kondisi) {
    final value = kondisi.toLowerCase();

    if (value.contains("sangat dibutuhkan")) return 5;
    if (value.contains("tidak terlalu dibutuhkan")) return 1;
    if (value.contains("kurang dibutuhkan")) return 2;
    if (value.contains("cukup dibutuhkan")) return 3;
    if (value.contains("dibutuhkan")) return 4;

    return double.tryParse(kondisi) ?? 0;
  }

  // =========================
  // SKOR JUMLAH PENERIMA MANFAAT NON FISIK
  // =========================
  static double skorPenerimaManfaatKondisi(String kondisi) {
    final value = kondisi.toLowerCase();

    if (value.contains("sangat banyak")) return 5;
    if (value.contains("sangat sedikit")) return 1;
    if (value.contains("banyak")) return 4;
    if (value.contains("sedang")) return 3;
    if (value.contains("sedikit")) return 2;

    return double.tryParse(kondisi) ?? 0;
  }

  // =========================
  // SKOR DAMPAK SOSIAL NON FISIK
  // =========================
  static double skorDampakSosialKondisi(String kondisi) {
    final value = kondisi.toLowerCase();

    if (value.contains("sangat berdampak")) return 5;
    if (value.contains("tidak terlalu berdampak")) return 1;
    if (value.contains("kurang berdampak")) return 2;
    if (value.contains("cukup berdampak")) return 3;
    if (value.contains("berdampak")) return 4;

    return double.tryParse(kondisi) ?? 0;
  }

  // =========================
  // SKOR KELAYAKAN PELAKSANAAN NON FISIK
  // =========================
  static double skorKelayakanKondisi(String kondisi) {
    final value = kondisi.toLowerCase();

    if (value.contains("sangat layak")) return 5;
    if (value.contains("tidak layak")) return 1;
    if (value.contains("kurang layak")) return 2;
    if (value.contains("cukup layak")) return 3;
    if (value.contains("layak")) return 4;

    return double.tryParse(kondisi) ?? 0;
  }

  // =========================
  // PARSE RUPIAH
  // =========================
  static double parseRupiah(String value) {
    String cleaned = value
        .replaceAll("Rp", "")
        .replaceAll("rp", "")
        .replaceAll(".", "")
        .replaceAll(",", "")
        .replaceAll(" ", "")
        .trim();

    return double.tryParse(cleaned) ?? 0;
  }

  // =========================
  // SKOR BIAYA FISIK
  // =========================
  static double skorBiayaNominal(String biaya) {
    double nominal = parseRupiah(biaya);

    if (nominal <= 50000000) return 5;
    if (nominal <= 100000000) return 4;
    if (nominal <= 150000000) return 3;
    if (nominal <= 200000000) return 2;

    return 1;
  }

  // =========================
  // FORMAT RUPIAH
  // =========================
  static String formatRupiah(String value) {
    if (value.trim().isEmpty || value == "null") {
      return "Tidak diisi";
    }

    double nominal = parseRupiah(value);

    String angka = nominal.toInt().toString();
    String hasil = "";

    int hitung = 0;
    for (int i = angka.length - 1; i >= 0; i--) {
      hitung++;
      hasil = angka[i] + hasil;

      if (hitung % 3 == 0 && i != 0) {
        hasil = ".$hasil";
      }
    }

    return "Rp$hasil";
  }

  //100
  // =========================
// KONVERSI NILAI AHP KE SKALA 100
// =========================
static double konversiKeSkala100(double nilaiSkala5) {
  return nilaiSkala5 * 20;
}

// =========================
// HITUNG TOTAL AHP SKALA 100 OTOMATIS
// =========================
static double hitungTotalAhp100(dynamic item) {
  final totalSkala5 = hitungTotalAhp(item);
  return konversiKeSkala100(totalSkala5);
}

// =========================
// HITUNG TOTAL AHP FISIK SKALA 100
// =========================
static double hitungTotalAhpFisik100(dynamic item) {
  final totalSkala5 = hitungTotalAhpFisik(item);
  return konversiKeSkala100(totalSkala5);
}

// =========================
// HITUNG TOTAL AHP NON FISIK SKALA 100
// =========================
static double hitungTotalAhpNonFisik100(dynamic item) {
  final totalSkala5 = hitungTotalAhpNonFisik(item);
  return konversiKeSkala100(totalSkala5);
}
}
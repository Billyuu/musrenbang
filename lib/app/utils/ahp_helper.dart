class AhpHelper {
  // =========================
  // BOBOT KRITERIA AHP FISIK
  // Sesuai hasil kuesioner AHP
  // =========================
  static const double bobotUrgensi = 0.443;
  static const double bobotDampak = 0.250;
  static const double bobotKerusakan = 0.231;
  static const double bobotBiaya = 0.076;

  // =========================
  // BOBOT KRITERIA AHP NON FISIK
  // Sesuai hasil kuesioner AHP
  // =========================
  static const double bobotKebutuhan = 0.439;
  static const double bobotPenerimaManfaat = 0.193;
  static const double bobotBidangUsulan = 0.294;
  static const double bobotBiayaNonFisik = 0.074;

  // =========================
  // HITUNG TOTAL AHP OTOMATIS
  // =========================
  static double hitungTotalAhp(dynamic item) {
    final jenisUsulan =
        item["jenis_usulan"]?.toString().toLowerCase().trim() ?? "fisik";

    if (jenisUsulan == "non_fisik" ||
        jenisUsulan == "non fisik" ||
        jenisUsulan == "nonfisik") {
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
    double skorBiaya = skorBiayaNominalFisik(biayaInputUser);

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
    String kondisiPenerima = item["jumlah_penerima_manfaat"]?.toString() ?? "-";
    String kondisiBidang = item["bidang_usulan"]?.toString() ?? "-";
    String biayaInputUser = item["biaya"]?.toString() ?? "0";

    double skorKebutuhan = skorKebutuhanKondisi(kondisiKebutuhan);
    double skorPenerima = skorPenerimaManfaatKondisi(kondisiPenerima);
    double skorBidang = skorBidangUsulanKondisi(kondisiBidang);
    double skorBiaya = skorBiayaNominalNonFisik(biayaInputUser);

    return (bobotKebutuhan * skorKebutuhan) +
        (bobotPenerimaManfaat * skorPenerima) +
        (bobotBidangUsulan * skorBidang) +
        (bobotBiayaNonFisik * skorBiaya);
  }

  // =========================
  // SKOR URGENSI FISIK
  // =========================
  static double skorUrgensiKondisi(String kondisi) {
    final value = kondisi.toLowerCase().trim();

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
    final value = kondisi.toLowerCase().trim();

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
    final value = kondisi.toLowerCase().trim();

    if (value.contains("tidak ada") || value.contains("tidak punya")) return 5;
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
    final value = kondisi.toLowerCase().trim();

    if (value.contains("sangat dibutuhkan")) return 5;
    if (value.contains("tidak terlalu dibutuhkan")) return 1;
    if (value.contains("kurang dibutuhkan")) return 2;
    if (value.contains("cukup dibutuhkan")) return 3;
    if (value.contains("dibutuhkan")) return 4;

    return double.tryParse(kondisi) ?? 0;
  }

  // =========================
  // SKOR JUMLAH PENERIMA MANFAAT NON FISIK
  // Semakin banyak penerima manfaat, semakin tinggi skor
  // =========================
  static double skorPenerimaManfaatKondisi(String kondisi) {
    final value = kondisi.toLowerCase().trim();

    // Format rentang dari dropdown, misalnya "1-10 orang", "51-80 orang"
    if (value.contains(">80") ||
        value.contains("> 80") ||
        value.contains("lebih dari 80")) {
      return 5;
    }

    if (value.contains("51-80") ||
        value.contains("51 - 80") ||
        value.contains("51 sampai 80")) {
      return 4;
    }

    if (value.contains("31-50") ||
        value.contains("31 - 50") ||
        value.contains("31 sampai 50")) {
      return 3;
    }

    if (value.contains("11-30") ||
        value.contains("11 - 30") ||
        value.contains("11 sampai 30")) {
      return 2;
    }

    if (value.contains("1-10") ||
        value.contains("1 - 10") ||
        value.contains("1 sampai 10")) {
      return 1;
    }

    // Jika di aplikasi pakai label umum
    if (value.contains("sangat banyak")) return 5;
    if (value.contains("banyak")) return 4;
    if (value.contains("sedang")) return 3;
    if (value.contains("sedikit")) return 2;
    if (value.contains("sangat sedikit")) return 1;

    return double.tryParse(kondisi) ?? 0;
  }

  // =========================
  // SKOR BIDANG USULAN NON FISIK
  // Sesuai tabel nilai kondisi penelitian
  // =========================
  static double skorBidangUsulanKondisi(String kondisi) {
    final value = kondisi.toLowerCase().trim();

    if (value.contains("kesehatan")) return 5;
    if (value.contains("sosial") || value.contains("kesejahteraan")) return 4;
    if (value.contains("ekonomi") || value.contains("umkm")) return 3;
    if (value.contains("pendidikan")) return 2;
    if (value.contains("pemberdayaan")) return 1;

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
  // 5 = 0 - 50 juta
  // 4 = 50 - 100 juta
  // 3 = 100 - 150 juta
  // 2 = 150 - 200 juta
  // 1 = > 200 juta
  // =========================
  static double skorBiayaNominalFisik(String biaya) {
    double nominal = parseRupiah(biaya);

    if (nominal <= 50000000) return 5;
    if (nominal <= 100000000) return 4;
    if (nominal <= 150000000) return 3;
    if (nominal <= 200000000) return 2;

    return 1;
  }

  // =========================
  // SKOR BIAYA NON FISIK
  // 5 = 0 - 5 juta
  // 4 = 5 - 10 juta
  // 3 = 10 - 15 juta
  // 2 = 15 - 20 juta
  // 1 = > 20 juta
  // =========================
  static double skorBiayaNominalNonFisik(String biaya) {
    double nominal = parseRupiah(biaya);

    if (nominal <= 5000000) return 5;
    if (nominal <= 10000000) return 4;
    if (nominal <= 15000000) return 3;
    if (nominal <= 20000000) return 2;

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
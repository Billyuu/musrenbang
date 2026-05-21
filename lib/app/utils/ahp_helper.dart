class AhpHelper {
  // =========================
  // BOBOT KRITERIA AHP
  // =========================
  static const double bobotUrgensi = 0.40;
  static const double bobotDampak = 0.30;
  static const double bobotKerusakan = 0.20;
  static const double bobotBiaya = 0.10;

  // =========================
  // HITUNG TOTAL AHP
  // =========================
  static double hitungTotalAhp(dynamic item) {
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
  // SKOR URGENSI
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
  // SKOR MASYARAKAT TERDAMPAK
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
  // SKOR TINGKAT KERUSAKAN
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
  // SKOR BIAYA
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
}
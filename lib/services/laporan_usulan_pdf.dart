import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:musrenbang/app/utils/ahp_helper.dart';

class LaporanUsulanPdfService {
  static Future<void> cetakLaporan({
    required List<dynamic> data,
    required String status,
    required String jenis,
  }) async {
    final fontRegular = await PdfGoogleFonts.poppinsRegular();
    final fontBold = await PdfGoogleFonts.poppinsBold();

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: fontRegular, bold: fontBold),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return [
            _kopLaporan(status: status, jenis: jenis),

            pw.SizedBox(height: 18),

            pw.Text(
              "Jumlah Data: ${data.length}",
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),

            pw.SizedBox(height: 10),

            _tabelLaporan(data: data, status: status, jenis: jenis),

            pw.SizedBox(height: 28),

            _tandaTangan(),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static pw.Widget _kopLaporan({
    required String status,
    required String jenis,
  }) {
    return pw.Center(
      child: pw.Column(
        children: [
          pw.Text(
            "PEMERINTAH DESA SUKOREJO",
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            "KEC. POHJENTREK KAB. PASURUAN",
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            "LAPORAN HASIL REKAPITULASI USULAN MUSRENBANG DESA",
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            "Status: $status | Jenis Usulan: $jenis",
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  static pw.Widget _tabelLaporan({
    required List<dynamic> data,
    required String status,
    required String jenis,
  }) {
    final isNonFisikLaporan =
        jenis.toLowerCase().trim() == "non_fisik" ||
        jenis.toLowerCase().trim() == "non fisik" ||
        jenis.toLowerCase().trim() == "nonfisik";

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.5),
      columnWidths: {
        0: const pw.FixedColumnWidth(24), // No
        1: const pw.FixedColumnWidth(60), // Tanggal
        2: const pw.FixedColumnWidth(120), // Judul
        3: const pw.FixedColumnWidth(130), // Kriteria
        4: const pw.FixedColumnWidth(150), // Kondisi + Nilai
        5: const pw.FixedColumnWidth(75), // Volume
        6: const pw.FixedColumnWidth(55), // Skor
        7: const pw.FixedColumnWidth(130), // Keterangan
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _pdfCell("No", isHeader: true),
            _pdfCell("Tanggal", isHeader: true),
            _pdfCell("Judul Usulan", isHeader: true),
            _pdfCell("Kriteria\n(Bobot)", isHeader: true),
            _pdfCell("Kondisi\n(Nilai)", isHeader: true),
            _pdfCell(
              isNonFisikLaporan ? "Volume" : "Volume\nP/L/T",
              isHeader: true,
            ),
            _pdfCell("Skor", isHeader: true),
            _pdfCell("Keterangan", isHeader: true),
          ],
        ),

        ...List.generate(data.length, (index) {
          final item = data[index];

          return pw.TableRow(
            children: [
              _pdfCell("${index + 1}"),
              _pdfCell(_safe(item["tanggal"])),
              _pdfCell(_safe(item["judul_usulan"])),
              _pdfCell(_getKriteria(item)),
              _pdfCell(_getKondisiNilai(item)),
              _pdfCell(_getVolumePLT(item)),
              _pdfCell(_getSkor(item)),
              _pdfCell(_keteranganByStatus(item, status)),
            ],
          );
        }),
      ],
    );
  }

  static bool _isNonFisik(dynamic item) {
    final jenis =
        item["jenis_usulan"]?.toString().toLowerCase().trim() ?? "fisik";

    return jenis == "non_fisik" || jenis == "non fisik" || jenis == "nonfisik";
  }

  static String _getKriteria(dynamic item) {
    if (_isNonFisik(item)) {
      return "Tingkat Kebutuhan (${AhpHelper.bobotKebutuhan.toStringAsFixed(3)})\n"
          "Jumlah Penerima Manfaat (${AhpHelper.bobotPenerimaManfaat.toStringAsFixed(3)})\n"
          "Bidang Usulan (${AhpHelper.bobotBidangUsulan.toStringAsFixed(3)})\n"
          "Biaya (${AhpHelper.bobotBiayaNonFisik.toStringAsFixed(3)})";
    }

    return "Urgensi (${AhpHelper.bobotUrgensi.toStringAsFixed(3)})\n"
        "Masyarakat Terdampak (${AhpHelper.bobotDampak.toStringAsFixed(3)})\n"
        "Tingkat Kerusakan (${AhpHelper.bobotKerusakan.toStringAsFixed(3)})\n"
        "Biaya (${AhpHelper.bobotBiaya.toStringAsFixed(3)})";
  }

  static String _getKondisiNilai(dynamic item) {
    if (_isNonFisik(item)) {
      return _getKondisiNilaiNonFisik(item);
    }

    return _getKondisiNilaiFisik(item);
  }

  static String _getKondisiNilaiFisik(dynamic item) {
    final urgensi = _safe(item["urgensi"]);
    final dampak = _safe(item["masyarakat_terdampak"]);
    final kerusakan = _safe(item["tingkat_kerusakan"]);
    final biaya = _safe(item["biaya"]);

    final skorUrgensi = AhpHelper.skorUrgensiKondisi(urgensi);
    final skorDampak = AhpHelper.skorDampakKondisi(dampak);
    final skorKerusakan = AhpHelper.skorKerusakanKondisi(kerusakan);
    final skorBiaya = AhpHelper.skorBiayaNominalFisik(biaya);

    return "$urgensi ($skorUrgensi)\n"
        "$dampak ($skorDampak)\n"
        "$kerusakan ($skorKerusakan)\n"
        "${_formatRupiah(biaya)} ($skorBiaya)";
  }

  static String _getKondisiNilaiNonFisik(dynamic item) {
    final kebutuhan = _safe(item["tingkat_kebutuhan"]);
    final penerima = _safe(item["jumlah_penerima_manfaat"]);
    final bidang = _safe(item["bidang_usulan"]);
    final biaya = _safe(item["biaya"]);

    final skorKebutuhan = AhpHelper.skorKebutuhanKondisi(kebutuhan);
    final skorPenerima = AhpHelper.skorPenerimaManfaatKondisi(penerima);
    final skorBidang = AhpHelper.skorBidangUsulanKondisi(bidang);
    final skorBiaya = AhpHelper.skorBiayaNominalNonFisik(biaya);

    return "$kebutuhan ($skorKebutuhan)\n"
        "$penerima ($skorPenerima)\n"
        "$bidang ($skorBidang)\n"
        "${_formatRupiah(biaya)} ($skorBiaya)";
  }

  static String _getVolumePLT(dynamic item) {
    if (_isNonFisik(item)) {
      return "-";
    }

    final panjang = _safeVolume(item["panjang"]);
    final lebar = _safeVolume(item["lebar"]);
    final tinggi = _safeVolume(item["tinggi"]);
    var volume = _safeVolume(item["volume"]);

    if (panjang == "-" && lebar == "-" && tinggi == "-" && volume == "-") {
      return "-";
    }

    if (volume == "-" && panjang != "-" && lebar != "-" && tinggi != "-") {
      final p = double.tryParse(panjang.replaceAll(",", "."));
      final l = double.tryParse(lebar.replaceAll(",", "."));
      final t = double.tryParse(tinggi.replaceAll(",", "."));

      if (p != null && l != null && t != null) {
        volume = (p * l * t).toStringAsFixed(2);
      }
    }

    return "P: $panjang m\n"
        "L: $lebar m\n"
        "T: $tinggi m\n"
        "Vol: $volume m3";
  }

  static String _safeVolume(dynamic value) {
    final text = value?.toString().trim() ?? "";

    if (text.isEmpty ||
        text == "null" ||
        text == "-" ||
        text == "0" ||
        text == "0.0" ||
        text == "0.00") {
      return "-";
    }

    return text;
  }

  static pw.Widget _tandaTangan() {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            "Sukorejo, ....................",
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.SizedBox(height: 4),
          pw.Text("Kepala Desa", style: const pw.TextStyle(fontSize: 10)),
          pw.SizedBox(height: 50),
          pw.Text(
            "(................................)",
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  static pw.Widget _pdfCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static String _safe(dynamic value) {
    final text = value?.toString().trim() ?? "";
    if (text.isEmpty || text == "null") {
      return "-";
    }
    return text;
  }

  static String _getSkor(dynamic item) {
    final hasil = AhpHelper.hitungTotalAhp100(item);

    if (hasil > 0) {
      return hasil.toStringAsFixed(2);
    }

    final skorDb = item["skor_ahp"]?.toString().trim() ?? "";

    if (skorDb.isNotEmpty && skorDb != "null") {
      final nilaiDb = double.tryParse(skorDb);

      if (nilaiDb != null) {
        if (nilaiDb <= 5) {
          return (nilaiDb * 20).toStringAsFixed(2);
        }

        return nilaiDb.toStringAsFixed(2);
      }

      return skorDb;
    }

    return "-";
  }

  static String _keteranganByStatus(dynamic item, String status) {
    final statusLower = status.toLowerCase().trim();

    if (statusLower == "disetujui") {
      final tahun = _safe(item["tahun_realisasi"]);
      final biayaFinal = _formatRupiah(_safe(item["biaya_final"]));

      return "Tahun: $tahun\nBiaya Final: $biayaFinal";
    }

    if (statusLower == "ditolak") {
      return _safe(item["catatan_penolakan"]);
    }

    if (statusLower == "ditunda") {
      final tahun = _safe(item["tahun_realisasi"]);
      final catatan = _safe(item["catatan_penundaan"]);

      return "Tahun: $tahun\nCatatan: $catatan";
    }

    if (statusLower == "direalisasikan") {
      final tahun = _safe(item["tahun_realisasi"]);
      final biayaFinal = _formatRupiah(_safe(item["biaya_final"]));

      return "Tahun Realisasi: $tahun\nBiaya Final: $biayaFinal";
    }

    return "Menunggu keputusan admin";
  }

  static String _formatRupiah(String value) {
    if (value.isEmpty || value == "-" || value == "null") {
      return "-";
    }

    String cleaned = value
        .replaceAll("Rp", "")
        .replaceAll("rp", "")
        .replaceAll(".", "")
        .replaceAll(",", "")
        .replaceAll(" ", "")
        .trim();

    final nominal = int.tryParse(cleaned);

    if (nominal == null) {
      return "-";
    }

    final angka = nominal.toString();
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../controllers/detail_admin_controller.dart';
import 'package:musrenbang/app/utils/ahp_helper.dart';
import 'package:musrenbang/app/routes/app_pages.dart';

class DetailAdminView extends GetView<DetailAdminController> {
  const DetailAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: const Color(0xFF003E79),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2_copy, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Detail Usulan',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Color(0xFF003E79),
                  strokeWidth: 3,
                ),
                const SizedBox(height: 14),
                Text(
                  'Memuat detail...',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003E79),
                  ),
                ),
              ],
            ),
          );
        }
        final item = controller.data;
        final args = Get.arguments ?? {};
        final fromLaporan = args["from"] == "laporan";

        final isNonFisik = _isNonFisik(item);
        final isFisik = _isFisik(item);

        final labelJenisUsulan = isNonFisik ? "Non Fisik" : "Fisik";

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _statusHeader(item),
              const SizedBox(height: 16),

              _section(
                title: "Data Pengusul",
                icon: Iconsax.user_copy,
                children: [
                  _info("Nama Pengusul", item["nama_pengusul"]),
                  _info("NIK", item["nik_pengusul"]),
                  _info("Email", item["email_pengusul"]),
                  _info("Jenis Kelamin", item["jenis_kelamin"]),
                  _info(
                    "No HP",
                    item["no_hp_pengusul"] != null
                        ? "+62 ${item["no_hp_pengusul"].toString().replaceFirst('0', '')}"
                        : "-",
                  ),
                ],
              ),

              _section(
                title: "Informasi Usulan",
                icon: Iconsax.document_text_copy,
                children: [
                  _info("Jenis Usulan", labelJenisUsulan),
                  _info("Judul Usulan", item["judul_usulan"]),
                  _info("Dusun", item["dusun"]),
                  _info("Permasalahan", item["permasalahan"]),
                  _info(
                    isFisik ? "Lokasi" : "Alamat Lokasi / Sasaran",
                    item["lokasi_detail"],
                  ),

                  if (isFisik) _info("Titik Koordinat", item["koordinat"]),

                  if (isFisik && _adaVolume(item["volume"]))
                    _info("Volume", "${item["volume"]} m³"),

                  if (isFisik &&
                      (_adaVolume(item["panjang"]) ||
                          _adaVolume(item["lebar"]) ||
                          _adaVolume(item["tinggi"])))
                    _info(
                      "Ukuran",
                      "Panjang: ${_nilaiAtauStrip(item["panjang"])} m, "
                          "Lebar: ${_nilaiAtauStrip(item["lebar"])} m, "
                          "Tinggi: ${_nilaiAtauStrip(item["tinggi"])} m",
                    ),

                  _info("Tanggal", item["tanggal"]),
                ],
              ),

              _tabelPerhitunganAhp(item),

              _fotoUsulan(item),

              const SizedBox(height: 24),

              if (!fromLaporan) _actionArea(item),

              if (fromLaporan) _laporanInfoBox(),

              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  bool _isNonFisik(dynamic item) {
    final jenis =
        item["jenis_usulan"]?.toString().toLowerCase().trim() ?? "fisik";

    return jenis == "non_fisik" || jenis == "non fisik" || jenis == "nonfisik";
  }

  bool _isFisik(dynamic item) {
    return !_isNonFisik(item);
  }

  Widget _headerBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _statusHeader(dynamic item) {
    final isNonFisik = _isNonFisik(item);
    final labelJenisUsulan = isNonFisik ? "NON FISIK" : "FISIK";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF003E79),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item["judul_usulan"]?.toString() ?? "-",
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _headerBadge(labelJenisUsulan),
              _headerBadge(item["status"]?.toString().toUpperCase() ?? "-"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE6E8EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF003E79)),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _info(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            value?.toString() ?? "-",
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  bool _adaFoto(dynamic foto) {
    final value = foto?.toString().trim() ?? '';
    return value.isNotEmpty && value != '-' && value != 'null';
  }

  bool _adaVolume(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isNotEmpty && text != '-' && text != 'null' && text != '0';
  }

  String _nilaiAtauStrip(dynamic value) {
    final text = value?.toString().trim() ?? '';
    if (text.isEmpty || text == 'null' || text == '-') {
      return '-';
    }
    return text;
  }

  //tabel perhitungan
  Widget _tabelPerhitunganAhp(dynamic item) {
    if (_isNonFisik(item)) {
      return _tabelPerhitunganAhpNonFisik(item);
    }

    return _tabelPerhitunganAhpFisik(item);
  }

  //fisik
  Widget _tabelPerhitunganAhpFisik(dynamic item) {
    String kondisiUrgensi = item["urgensi"]?.toString() ?? "-";
    String kondisiDampak = item["masyarakat_terdampak"]?.toString() ?? "-";
    String kondisiKerusakan = item["tingkat_kerusakan"]?.toString() ?? "-";

    String biayaInputUser = item["biaya"]?.toString() ?? "0";
    String kondisiBiaya = AhpHelper.formatRupiah(biayaInputUser);

    double skorUrgensi = AhpHelper.skorUrgensiKondisi(kondisiUrgensi);
    double skorDampak = AhpHelper.skorDampakKondisi(kondisiDampak);
    double skorKerusakan = AhpHelper.skorKerusakanKondisi(kondisiKerusakan);
    double skorBiaya = AhpHelper.skorBiayaNominalFisik(biayaInputUser);

    double hasilUrgensi = AhpHelper.bobotUrgensi * skorUrgensi * 20;
    double hasilDampak = AhpHelper.bobotDampak * skorDampak * 20;
    double hasilKerusakan = AhpHelper.bobotKerusakan * skorKerusakan * 20;
    double hasilBiaya = AhpHelper.bobotBiaya * skorBiaya * 20;

    double total = AhpHelper.hitungTotalAhpFisik100(item);

    return _tabelAhpWidget(
      title: "Tabel Perhitungan AHP Fisik",
      rows: [
        _rowAhp(
          "Urgensi",
          AhpHelper.bobotUrgensi,
          kondisiUrgensi,
          skorUrgensi,
          hasilUrgensi,
        ),
        _rowAhp(
          "Masyarakat Terdampak",
          AhpHelper.bobotDampak,
          kondisiDampak,
          skorDampak,
          hasilDampak,
        ),
        _rowAhp(
          "Tingkat Kerusakan",
          AhpHelper.bobotKerusakan,
          kondisiKerusakan,
          skorKerusakan,
          hasilKerusakan,
        ),
        _rowAhp(
          "Biaya",
          AhpHelper.bobotBiaya,
          kondisiBiaya,
          skorBiaya,
          hasilBiaya,
        ),
      ],
      total: total,
    );
  }

  //nonfisik
  Widget _tabelPerhitunganAhpNonFisik(dynamic item) {
    String kondisiKebutuhan = item["tingkat_kebutuhan"]?.toString() ?? "-";
    String kondisiPenerima = item["jumlah_penerima_manfaat"]?.toString() ?? "-";
    String kondisiBidang = item["bidang_usulan"]?.toString() ?? "-";

    String biayaInputUser = item["biaya"]?.toString() ?? "0";
    String kondisiBiaya = AhpHelper.formatRupiah(biayaInputUser);

    double skorKebutuhan = AhpHelper.skorKebutuhanKondisi(kondisiKebutuhan);
    double skorPenerima = AhpHelper.skorPenerimaManfaatKondisi(kondisiPenerima);
    double skorBidang = AhpHelper.skorBidangUsulanKondisi(kondisiBidang);
    double skorBiaya = AhpHelper.skorBiayaNominalNonFisik(biayaInputUser);

    double hasilKebutuhan = AhpHelper.bobotKebutuhan * skorKebutuhan * 20;
    double hasilPenerima = AhpHelper.bobotPenerimaManfaat * skorPenerima * 20;
    double hasilBidang = AhpHelper.bobotBidangUsulan * skorBidang * 20;
    double hasilBiaya = AhpHelper.bobotBiayaNonFisik * skorBiaya * 20;

    double total = AhpHelper.hitungTotalAhpNonFisik100(item);

    return _tabelAhpWidget(
      title: "Tabel Perhitungan AHP Non Fisik",
      rows: [
        _rowAhp(
          "Tingkat Kebutuhan",
          AhpHelper.bobotKebutuhan,
          kondisiKebutuhan,
          skorKebutuhan,
          hasilKebutuhan,
        ),
        _rowAhp(
          "Penerima Manfaat",
          AhpHelper.bobotPenerimaManfaat,
          kondisiPenerima,
          skorPenerima,
          hasilPenerima,
        ),
        _rowAhp(
          "Bidang Usulan",
          AhpHelper.bobotBidangUsulan,
          kondisiBidang,
          skorBidang,
          hasilBidang,
        ),
        _rowAhp(
          "Biaya",
          AhpHelper.bobotBiayaNonFisik,
          kondisiBiaya,
          skorBiaya,
          hasilBiaya,
        ),
      ],
      total: total,
    );
  }

  Widget _tabelAhpWidget({
    required String title,
    required List<DataRow> rows,
    required double total,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE6E8EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Iconsax.chart_2_copy,
                size: 20,
                color: Color(0xFF003E79),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(
                const Color(0xFF003E79).withOpacity(0.08),
              ),
              columnSpacing: 20,
              horizontalMargin: 12,
              columns: [
                DataColumn(
                  label: Text(
                    "Kriteria",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Bobot",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Kondisi",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Skor",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Hasil",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              rows: rows,
            ),
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF003E79).withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Nilai Akhir",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF003E79),
                  ),
                ),
                Text(
                  total.toStringAsFixed(2),
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF003E79),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _rowAhp(
    String kriteria,
    double bobot,
    String kondisi,
    double skorKondisi,
    double hasil,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(kriteria, style: GoogleFonts.poppins(fontSize: 11))),
        DataCell(
          Text(
            bobot.toStringAsFixed(3),
            style: GoogleFonts.poppins(fontSize: 11),
          ),
        ),
        DataCell(Text(kondisi, style: GoogleFonts.poppins(fontSize: 11))),
        DataCell(
          Text(
            skorKondisi.toStringAsFixed(0),
            style: GoogleFonts.poppins(fontSize: 11),
          ),
        ),
        DataCell(
          Text(
            hasil.toStringAsFixed(2),
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF003E79),
            ),
          ),
        ),
      ],
    );
  }

  //fotousulan
  Widget _fotoUsulan(dynamic item) {
    final isFisik = _isFisik(item);

    final fotoDepan = item["foto_usulan"]?.toString() ?? "";
    final fotoBelakang = item["foto_usulan_belakang"]?.toString() ?? "";

    final adaFotoDepan = _adaFoto(fotoDepan);
    final adaFotoBelakang = _adaFoto(fotoBelakang);

    // 🔥 NON FISIK: kalau kosong semua → JANGAN TAMPIL SAMA SEKALI
    if (!isFisik && !adaFotoDepan) {
      return const SizedBox(); // << INI FIX UTAMA
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE6E8EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Iconsax.gallery_copy,
                size: 20,
                color: Color(0xFF003E79),
              ),
              const SizedBox(width: 8),
              Text(
                "Foto Usulan",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          if (isFisik) ...[
            if (adaFotoDepan)
              _fotoItem(label: "Foto Tampak Depan", fileName: fotoDepan),

            if (adaFotoBelakang)
              _fotoItem(label: "Foto Tampak Belakang", fileName: fotoBelakang),
          ] else ...[
            if (adaFotoDepan)
              _fotoItem(label: "Foto Pendukung", fileName: fotoDepan),
          ],
        ],
      ),
    );
  }

  Widget _fotoItem({required String label, required String fileName}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),

        const SizedBox(height: 8),

        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.network(
            controller.getFotoUsulan(fileName),
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;

              return Container(
                height: 220,
                alignment: Alignment.center,
                color: Colors.grey.shade200,
                child: const CircularProgressIndicator(
                  color: Color(0xFF003E79),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 220,
                alignment: Alignment.center,
                color: Colors.grey.shade200,
                child: Text(
                  "Foto tidak tersedia",
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  //action terima dan tolak
  Widget _actionArea(dynamic item) {
    final status = item["status"]?.toString().toLowerCase().trim() ?? "";

    final masihDiproses = status == "diproses";
    final sudahDiterima = status == "disetujui";
    final sudahDitolak = status == "ditolak";
    final sudahDitunda = status == "ditunda";
    final sudahDirealisasikan = status == "direalisasikan";

    if (masihDiproses) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE6E8EC)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.fact_check_rounded,
                  size: 21,
                  color: Color(0xFF003E79),
                ),
                const SizedBox(width: 8),
                Text(
                  "Keputusan Admin",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              "Silakan pilih tindakan untuk memproses usulan masyarakat.",
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _decisionButton(
                    title: "Terima",
                    subtitle: "Setujui usulan",
                    icon: Icons.check_rounded,
                    color: Colors.green,
                    onTap: () => _showTerimaSheet(),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _decisionButton(
                    title: "Tolak",
                    subtitle: "Tolak usulan",
                    icon: Icons.close_rounded,
                    color: Colors.red,
                    onTap: () => _showTolakSheet(),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (sudahDiterima) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _statusKeputusanBox(
            title: "Usulan Sudah Diterima",
            subtitle:
                "Usulan ini telah disetujui oleh admin dan dapat diproses ke tahap berikutnya.",
            icon: Icons.check_circle_rounded,
            color: Colors.green,
            children: [
              _keputusanInfo(
                "Biaya Final",
                item["biaya_final"] != null &&
                        item["biaya_final"].toString().isNotEmpty
                    ? AhpHelper.formatRupiah(item["biaya_final"].toString())
                    : "-",
              ),
              _keputusanInfo(
                "Tahun Realisasi",
                item["tahun_realisasi"]?.toString() ?? "-",
              ),
              _keputusanInfo("Skor AHP", _formatSkorAhp(item)),
            ],
          ),

          const SizedBox(height: 16),

          // 🔥 INI YANG BARU KAMU TAMBAH
          Row(
            children: [
              Expanded(
                child: _decisionButton(
                  title: "Tunda",
                  subtitle: "Ke Hasil Musrenbang",
                  icon: Icons.update_rounded,
                  color: Colors.orange,
                  onTap: () {
                    Get.toNamed(
                      Routes.DETAIL_HASIL_MUSRENBANG,
                      arguments: {
                        "id": item["id"],
                        "from": "admin",
                        "mode": "tunda",
                      },
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _decisionButton(
                  title: "Realisasikan",
                  subtitle: "Selesaikan usulan",
                  icon: Icons.verified_rounded,
                  color: Colors.green,
                  onTap: () {
                    Get.toNamed(
                      Routes.DETAIL_HASIL_MUSRENBANG,
                      arguments: {
                        "id": item["id"],
                        "from": "admin",
                        "mode": "realisasi",
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (sudahDitunda) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE6E8EC)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _statusKeputusanBox(
              title: "Usulan Sedang Ditunda",
              subtitle:
                  "Usulan ini masih berstatus ditunda. Admin dapat menunda kembali atau merealisasikan usulan.",
              icon: Icons.update_rounded,
              color: Colors.orange,
              children: [
                _keputusanInfo(
                  "Tahun Realisasi",
                  item["tahun_realisasi"]?.toString() ?? "-",
                ),
                _keputusanInfo(
                  "Catatan Penundaan",
                  item["catatan_penundaan"]?.toString() ?? "-",
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _decisionButton(
                    title: "Tunda Lagi",
                    subtitle: "Perbarui tahun",
                    icon: Icons.update_rounded,
                    color: Colors.orange,
                    onTap: () {
                      Get.toNamed(
                        Routes.DETAIL_HASIL_MUSRENBANG,
                        arguments: {
                          "id": item["id"],
                          "from": "admin",
                          "mode": "tunda",
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _decisionButton(
                    title: "Realisasikan",
                    subtitle: "Selesaikan usulan",
                    icon: Icons.verified_rounded,
                    color: Colors.green,
                    onTap: () {
                      Get.toNamed(
                        Routes.DETAIL_HASIL_MUSRENBANG,
                        arguments: {
                          "id": item["id"],
                          "from": "admin",
                          "mode": "realisasi",
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (sudahDirealisasikan) {
      return _statusKeputusanBox(
        title: "Usulan Sudah Direalisasikan",
        subtitle:
            "Usulan ini telah direalisasikan dan dinyatakan selesai dalam hasil Musrenbang.",
        icon: Icons.verified_rounded,
        color: const Color(0xFF003E79),
        children: [
          _keputusanInfo(
            "Tahun Realisasi",
            item["tahun_realisasi"]?.toString() ?? "-",
          ),
          _keputusanInfo(
            "Biaya Final",
            item["biaya_final"] != null &&
                    item["biaya_final"].toString().isNotEmpty
                ? AhpHelper.formatRupiah(item["biaya_final"].toString())
                : "-",
          ),
        ],
      );
    }

    if (sudahDitolak) {
      return _statusKeputusanBox(
        title: "Usulan Sudah Ditolak",
        subtitle:
            "Usulan ini telah ditolak oleh admin dan tidak dapat diproses ulang.",
        icon: Icons.cancel_rounded,
        color: Colors.red,
        children: [
          _keputusanInfo(
            "Catatan Penolakan",
            item["catatan_penolakan"]?.toString() ?? "-",
          ),
        ],
      );
    }

    return const SizedBox();
  }

  Widget _decisionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.35), width: 1.2),
        ),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 24),
            ),

            const SizedBox(height: 10),

            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //pengecualian di detail admin diproses
  Widget _laporanInfoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF003E79).withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF003E79).withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_rounded, color: Color(0xFF003E79), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Halaman ini dibuka dari laporan usulan, sehingga hanya digunakan untuk melihat detail data dan tidak menampilkan aksi terima atau tolak.",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF1F2937),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //
  String _formatSkorAhp(dynamic item) {
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

  Widget _statusKeputusanBox({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    List<Widget> children = const [],
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF4B5563),
                  ),
                ),

                if (children.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: children,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _keputusanInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.isNotEmpty ? value : "-",
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: const Color(0xFF1F2937),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  //
  void _showKonfirmasiKeputusan({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
    required String buttonText,
    required Future<void> Function() onConfirm,
  }) {
    Get.bottomSheet(
      Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 5,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, size: 34, color: color),
            ),

            const SizedBox(height: 18),

            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF003E79),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 18),

            _konfirmasiItemAdmin(
              icon: Icons.fact_check_rounded,
              text: "Detail usulan sudah diperiksa dengan benar.",
            ),
            _konfirmasiItemAdmin(
              icon: Icons.location_on_rounded,
              text:
                  "Lokasi, biaya, data pengusul, dan data pendukung sudah dipertimbangkan.",
            ),
            _konfirmasiItemAdmin(
              icon: Icons.warning_amber_rounded,
              text: "Keputusan ini akan mengubah status usulan masyarakat.",
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Cek Lagi",
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        await onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  Widget _konfirmasiItemAdmin({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF003E79)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
  //

  void _showTerimaSheet() {
    final biayaC = TextEditingController();
    final tahunC = TextEditingController();

    Get.bottomSheet(
      _bottomSheet(
        title: "Terima Usulan",
        children: [
          _inputField("Biaya Final", biayaC, TextInputType.number),
          const SizedBox(height: 14),
          _inputField("Tahun Realisasi", tahunC, TextInputType.number),
          const SizedBox(height: 20),

          Obx(
            () => _submitButton(
              title: "Simpan",
              color: const Color(0xFF003E79),
              isLoading: controller.isActionLoading.value,
              onTap: () async {
                final biayaFinal = biayaC.text.trim();
                final tahun = tahunC.text.trim();

                if (biayaFinal.isEmpty || tahun.isEmpty) {
                  Get.snackbar(
                    "Lengkapi Data",
                    "Biaya final dan tahun realisasi wajib diisi",
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                  );
                  return;
                }

                if (tahun.length != 4) {
                  Get.snackbar(
                    "Tahun Tidak Valid",
                    "Tahun realisasi harus 4 digit, contoh: 2026",
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                  );
                  return;
                }
                _showKonfirmasiKeputusan(
                  title: "Setujui Usulan?",
                  message:
                      "Pastikan biaya final dan tahun realisasi sudah benar. Usulan yang disetujui belum tentu langsung direalisasikan, karena masih dapat ditunda sesuai prioritas dan anggaran.",
                  icon: Icons.check_circle_rounded,
                  color: Colors.green,
                  buttonText: "Ya, Setujui",
                  onConfirm: () async {
                    final berhasil = await controller.terima(
                      biayaFinal: biayaFinal,
                      tahun: tahun,
                    );

                    if (berhasil) {
                      Get.closeAllSnackbars();

                      Get.back(closeOverlays: true);

                      await Future.delayed(const Duration(milliseconds: 300));

                      Get.back(result: true);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      isScrollControlled: true,
    );
  }

  void _showTolakSheet() {
    final catatanC = TextEditingController();

    Get.bottomSheet(
      _bottomSheet(
        title: "Tolak Usulan",
        children: [
          TextField(
            controller: catatanC,
            maxLines: 4,
            decoration: _inputDecoration("Catatan Penolakan"),
          ),
          const SizedBox(height: 20),

          Obx(
            () => _submitButton(
              title: "Simpan",
              color: const Color(0xFF003E79),
              isLoading: controller.isActionLoading.value,
              onTap: () async {
                if (catatanC.text.trim().isEmpty) {
                  Get.snackbar(
                    "Lengkapi Data",
                    "Catatan penolakan wajib diisi",
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                  );
                  return;
                }
                _showKonfirmasiKeputusan(
                  title: "Tolak Usulan?",
                  message:
                      "Pastikan catatan penolakan sudah jelas dan sesuai. Usulan dapat ditolak apabila data tidak lengkap, tidak relevan, atau tidak sesuai kebutuhan masyarakat.",
                  icon: Icons.cancel_rounded,
                  color: Colors.red,
                  buttonText: "Ya, Tolak",
                  onConfirm: () async {
                    final berhasil = await controller.tolak(
                      catatan: catatanC.text.trim(),
                    );

                    if (berhasil) {
                      Get.closeAllSnackbars();

                      Get.back(closeOverlays: true);

                      await Future.delayed(const Duration(milliseconds: 300));

                      Get.back(result: true);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      isScrollControlled: true,
    );
  }

  Widget _bottomSheet({required String title, required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.only(
        left: 22,
        right: 22,
        top: 18,
        bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 55,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF003E79).withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
          ),

          const SizedBox(height: 22),

          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF003E79),
            ),
          ),

          const SizedBox(height: 24),

          ...children,
        ],
      ),
    );
  }

  Widget _inputField(
    String label,
    TextEditingController controller,
    TextInputType type,
  ) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: _inputDecoration(label),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,

      labelStyle: GoogleFonts.poppins(
        fontSize: 13,
        color: const Color(0xFF003E79),
        fontWeight: FontWeight.w500,
      ),

      filled: true,
      fillColor: const Color(0xffF5F7FA),

      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: const Color(0xFF003E79).withOpacity(0.15),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFF003E79), width: 1.8),
      ),
    );
  }

  Widget _submitButton({
    required String title,
    required Color color,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: color.withOpacity(0.6),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
            : Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
}

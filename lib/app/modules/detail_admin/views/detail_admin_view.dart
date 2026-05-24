import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../controllers/detail_admin_controller.dart';
import 'package:musrenbang/app/utils/ahp_helper.dart';

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
                  _info("Judul Usulan", item["judul_usulan"]),
                  _info("Dusun", item["dusun"]),
                  _info("Permasalahan", item["permasalahan"]),
                  _info("Lokasi", item["lokasi_detail"]),
                  _info("Tanggal", item["tanggal"]),
                ],
              ),

              _tabelPerhitunganAhp(item),

              _fotoUsulan(item),

              const SizedBox(height: 24),

              _actionArea(item),

              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _statusHeader(dynamic item) {
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              item["status"]?.toString().toUpperCase() ?? "-",
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
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

  //tabel perhitungan
  Widget _tabelPerhitunganAhp(dynamic item) {
    String kondisiUrgensi = item["urgensi"]?.toString() ?? "-";
    String kondisiDampak = item["masyarakat_terdampak"]?.toString() ?? "-";
    String kondisiKerusakan = item["tingkat_kerusakan"]?.toString() ?? "-";

    // Ambil biaya asli dari inputan user
    String biayaInputUser = item["biaya"]?.toString() ?? "0";

    // Kondisi biaya tetap ditampilkan sebagai nominal rupiah
    String kondisiBiaya = AhpHelper.formatRupiah(biayaInputUser);

    double skorUrgensi = AhpHelper.skorUrgensiKondisi(kondisiUrgensi);
    double skorDampak = AhpHelper.skorDampakKondisi(kondisiDampak);
    double skorKerusakan = AhpHelper.skorKerusakanKondisi(kondisiKerusakan);

    double skorBiaya = AhpHelper.skorBiayaNominal(biayaInputUser);

    double bobotUrgensi = AhpHelper.bobotUrgensi;
    double bobotDampak = AhpHelper.bobotDampak;
    double bobotKerusakan = AhpHelper.bobotKerusakan;
    double bobotBiaya = AhpHelper.bobotBiaya;

    double hasilUrgensi = bobotUrgensi * skorUrgensi;
    double hasilDampak = bobotDampak * skorDampak;
    double hasilKerusakan = bobotKerusakan * skorKerusakan;
    double hasilBiaya = bobotBiaya * skorBiaya;

    double total = AhpHelper.hitungTotalAhp(item);

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
                "Tabel Perhitungan AHP",
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
              rows: [
                _rowAhp(
                  "Urgensi",
                  bobotUrgensi,
                  kondisiUrgensi,
                  skorUrgensi,
                  hasilUrgensi,
                ),
                _rowAhp(
                  "Masyarakat Terdampak",
                  bobotDampak,
                  kondisiDampak,
                  skorDampak,
                  hasilDampak,
                ),
                _rowAhp(
                  "Tingkat Kerusakan",
                  bobotKerusakan,
                  kondisiKerusakan,
                  skorKerusakan,
                  hasilKerusakan,
                ),
                _rowAhp(
                  "Biaya",
                  bobotBiaya,
                  kondisiBiaya,
                  skorBiaya,
                  hasilBiaya,
                ),
              ],
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
            bobot.toStringAsFixed(2),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              controller.getFotoUsulan(item["foto_usulan"]?.toString() ?? ""),
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
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
        ],
      ),
    );
  }

  Widget _actionButton({
    required String title,
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),

      label: Text(title),

      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),

        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        ),

        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),

        side: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return const BorderSide(color: Color(0xFF003E79), width: 2);
          }

          return BorderSide(color: color, width: 2);
        }),

        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return const Color(0xFF003E79);
          }

          return backgroundColor;
        }),

        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.white;
          }

          return color;
        }),

        textStyle: MaterialStateProperty.all(
          GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  //action terima dan tolak
  Widget _actionArea(dynamic item) {
    final status = item["status"]?.toString().toLowerCase().trim() ?? "";

    final masihDiproses = status == "diproses";
    final sudahDiterima = status == "disetujui";
    final sudahDitolak = status == "ditolak";

    if (masihDiproses) {
      return Row(
        children: [
          Expanded(
            child: _actionButton(
              title: "Terima",
              icon: Icons.check_rounded,
              color: const Color(0xFF003E79),
              backgroundColor: Colors.white,
              onTap: () => _showTerimaSheet(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _actionButton(
              title: "Tolak",
              icon: Icons.close_rounded,
              color: const Color(0xFF003E79),
              backgroundColor: Colors.white,
              onTap: () => _showTolakSheet(),
            ),
          ),
        ],
      );
    }

    if (sudahDiterima) {
      return _statusKeputusanBox(
        title: "Usulan Sudah Diterima",
        subtitle:
            "Usulan ini telah disetujui oleh admin dan tidak dapat diproses ulang.",
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
          _keputusanInfo(
            "Skor AHP",
            item["skor_ahp"] != null
                ? double.tryParse(
                        item["skor_ahp"].toString(),
                      )?.toStringAsFixed(2) ??
                      "-"
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

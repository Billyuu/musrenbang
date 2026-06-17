import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musrenbang/app/routes/app_pages.dart';
import 'package:musrenbang/app/utils/ahp_helper.dart';
import '../controllers/laporan_usulan_musrenbang_controller.dart';

class LaporanUsulanMusrenbangView
    extends GetView<LaporanUsulanMusrenbangController> {
  const LaporanUsulanMusrenbangView({super.key});

  static const Color primaryColor = Color(0xFF003E79);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Laporan Usulan Musrenbang",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final errorMessage = controller.errorMessage.value;
        final statusAktif = controller.statusAktif.value;
        final jenisAktif = controller.jenisAktif.value;

        final totalDiproses = controller.totalByStatus("Diproses").toString();
        final totalDisetujui = controller.totalByStatus("Disetujui").toString();
        final totalDitolak = controller.totalByStatus("Ditolak").toString();
        final totalDitunda = controller.totalByStatus("Ditunda").toString();
        final totalDirealisasikan = controller
            .totalByStatus("Direalisasikan")
            .toString();
        final totalFisik = controller.totalByJenis("Fisik");
        final totalNonFisik = controller.totalByJenis("Non Fisik");

        final data = controller.filteredLaporan;

        return Column(
          children: [
            _headerLaporan(
              totalDiproses: totalDiproses,
              totalDisetujui: totalDisetujui,
              totalDitolak: totalDitolak,
              totalDitunda: totalDitunda,
              totalDirealisasikan: totalDirealisasikan,
              statusAktif: statusAktif,
            ),

            const SizedBox(height: 16),

            _filterJenis(
              jenisAktif,
              totalFisik: totalFisik,
              totalNonFisik: totalNonFisik,
            ),

            const SizedBox(height: 12),

            _cetakLaporanButton(
              statusAktif: statusAktif,
              jenisAktif: jenisAktif,
              totalData: data.length,
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Builder(
                builder: (context) {
                  if (isLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(color: primaryColor),
                          const SizedBox(height: 12),
                          Text(
                            "Memuat laporan usulan...",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (errorMessage.isNotEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  }

                  if (data.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: controller.refreshData,
                      color: Colors.white,
                      backgroundColor: primaryColor,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          top: 120,
                          left: 20,
                          right: 20,
                        ),
                        children: [
                          Icon(
                            Icons.folder_off_rounded,
                            size: 70,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Text(
                              "Belum ada laporan ${jenisAktif.toLowerCase()} dengan status ${statusAktif.toLowerCase()}",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.refreshData,
                    color: Colors.white,
                    backgroundColor: primaryColor,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];

                        return _laporanCard(item: item, index: index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  //cetak pdf
  Widget _cetakLaporanButton({
    required String statusAktif,
    required String jenisAktif,
    required int totalData,
  }) {
    final bool bisaCetak = totalData > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE0E0E0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Laporan $jenisAktif - $statusAktif",
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1F2937),
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    bisaCetak
                        ? "Total $totalData data siap dicetak"
                        : "Tidak ada data untuk dicetak",
                    style: GoogleFonts.poppins(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            InkWell(
              onTap: bisaCetak
                  ? () {
                      controller.cetakLaporan();
                    }
                  : null,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: bisaCetak ? primaryColor : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.picture_as_pdf_rounded,
                      color: bisaCetak ? Colors.white : Colors.grey.shade600,
                      size: 15,
                    ),

                    const SizedBox(width: 5),

                    Text(
                      "Cetak Semua",
                      style: GoogleFonts.poppins(
                        color: bisaCetak ? Colors.white : Colors.grey.shade600,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerLaporan({
    required String totalDiproses,
    required String totalDisetujui,
    required String totalDitolak,
    required String totalDitunda,
    required String totalDirealisasikan,
    required String statusAktif,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Rekap Laporan Usulan",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Laporan usulan berdasarkan status dan jenis pengajuan masyarakat.",
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.85),
              fontSize: 12,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 18),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _summaryBox(
                  title: "Diproses",
                  value: totalDiproses,
                  icon: Icons.hourglass_bottom_rounded,
                  isActive: statusAktif == "Diproses",
                  onTap: () {
                    controller.statusAktif.value = "Diproses";
                  },
                ),

                const SizedBox(width: 10),

                _summaryBox(
                  title: "Disetujui",
                  value: totalDisetujui,
                  icon: Icons.check_circle_rounded,
                  isActive: statusAktif == "Disetujui",
                  onTap: () {
                    controller.statusAktif.value = "Disetujui";
                  },
                ),

                const SizedBox(width: 10),

                _summaryBox(
                  title: "Ditolak",
                  value: totalDitolak,
                  icon: Icons.cancel_rounded,
                  isActive: statusAktif == "Ditolak",
                  onTap: () {
                    controller.statusAktif.value = "Ditolak";
                  },
                ),

                const SizedBox(width: 10),

                _summaryBox(
                  title: "Ditunda",
                  value: totalDitunda,
                  icon: Icons.update_rounded,
                  isActive: statusAktif == "Ditunda",
                  onTap: () {
                    controller.statusAktif.value = "Ditunda";
                  },
                ),

                const SizedBox(width: 10),

                _summaryBox(
                  title: "Realisasi",
                  value: totalDirealisasikan,
                  icon: Icons.verified_rounded,
                  isActive: statusAktif == "Direalisasikan",
                  onTap: () {
                    controller.statusAktif.value = "Direalisasikan";
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryBox({
    required String title,
    required String value,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 105,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.14),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isActive ? Colors.white : Colors.white.withOpacity(0.25),
            ),
            boxShadow: [
              if (isActive)
                BoxShadow(
                  color: Colors.black.withOpacity(0.16),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isActive ? primaryColor : Colors.white,
                size: 22,
              ),

              const SizedBox(height: 6),

              Text(
                value,
                style: GoogleFonts.poppins(
                  color: isActive ? primaryColor : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              Text(
                title,
                style: GoogleFonts.poppins(
                  color: isActive
                      ? primaryColor
                      : Colors.white.withOpacity(0.85),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusSegmentItem(String title, String statusAktif) {
    final isActive = statusAktif == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.statusAktif.value = title;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: isActive ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              if (isActive)
                BoxShadow(
                  color: primaryColor.withOpacity(0.18),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isActive ? Colors.white : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _filterJenis(
    String jenisAktif, {
    required int totalFisik,
    required int totalNonFisik,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            _jenisSegmentItem(
              title: "Fisik",
              icon: Icons.home_repair_service_rounded,
              jenisAktif: jenisAktif,
              total: totalFisik,
            ),
            _jenisSegmentItem(
              title: "Non Fisik",
              icon: Icons.groups_rounded,
              jenisAktif: jenisAktif,
              total: totalNonFisik,
            ),
          ],
        ),
      ),
    );
  }

  Widget _jenisSegmentItem({
    required String title,
    required IconData icon,
    required String jenisAktif,
    required int total,
  }) {
    final isActive = jenisAktif == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.jenisAktif.value = title;
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              width: double.infinity,
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color: isActive ? primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 17,
                    color: isActive ? Colors.white : const Color(0xFF64748B),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isActive ? Colors.white : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            if (total > 0)
              Positioned(top: -4, right: 8, child: _badgeTotalKategori(total)),
          ],
        ),
      ),
    );
  }

  Widget _badgeTotalKategori(int total) {
    return Container(
      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 1.2),
      ),
      alignment: Alignment.center,
      child: Text(
        total.toString(),
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          height: 1,
        ),
      ),
    );
  }

  Widget _laporanCard({required dynamic item, required int index}) {
    final judul = item["judul_usulan"]?.toString() ?? "-";
    final dusun = item["dusun"]?.toString() ?? "-";
    final lokasi = item["lokasi_detail"]?.toString() ?? "-";
    final tanggal = item["tanggal"]?.toString() ?? "-";
    final status = item["status"]?.toString() ?? "-";
    final skor = _formatSkorItem(item);
    final idUsulan = int.tryParse(item["id"]?.toString() ?? "0") ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TANGGAL DI ATAS CARD
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 6),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                size: 14,
                color: Colors.grey,
              ),
              const SizedBox(width: 5),
              Text(
                tanggal,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        /// CARD LAPORAN
        Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE3E6EA)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// SKOR
              /// SKOR
              Row(children: [_skorBadge(skor)]),

              const SizedBox(height: 10),

              /// JUDUL
              Text(
                judul,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),

              const SizedBox(height: 5),

              /// DUSUN
              Text(
                dusun,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF003E79),
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              /// LOKASI
              Text(
                lokasi,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 13),

              /// STATUS + SKOR + DETAIL
              Row(
                children: [
                  _statusBadge(status),

                  const Spacer(),

                  GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        Routes.DETAIL_ADMIN,
                        arguments: {"id": idUsulan, "from": "laporan"},
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Detail",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatSkorItem(dynamic item) {
    final skorDb = item["skor_ahp"]?.toString().trim() ?? "";

    // Jika skor sudah tersimpan di database
    if (skorDb.isNotEmpty && skorDb != "null") {
      final nilaiDb = double.tryParse(skorDb);

      if (nilaiDb != null) {
        // Kalau skor lama masih skala 5, ubah ke skala 100
        if (nilaiDb <= 5) {
          return (nilaiDb * 20).toStringAsFixed(2);
        }

        return nilaiDb.toStringAsFixed(2);
      }

      return skorDb;
    }

    // Jika skor_ahp masih null, hitung langsung dari data usulan
    final hasil = AhpHelper.hitungTotalAhp100(item);

    if (hasil <= 0) {
      return "-";
    }

    return hasil.toStringAsFixed(2);
  }

  Widget _statusBadge(String status) {
    Color color;

    switch (status.toLowerCase().trim()) {
      case "diproses":
        color = Colors.orange;
        break;
      case "disetujui":
        color = Colors.green;
        break;
      case "ditolak":
        color = Colors.red;
        break;
      case "ditunda":
        color = Colors.deepOrange;
        break;
      case "direalisasikan":
        color = primaryColor;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _skorBadge(String skor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF003E79).withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF003E79).withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.analytics_rounded,
            size: 13,
            color: Color(0xFF003E79),
          ),
          const SizedBox(width: 4),
          Text(
            "Skor: $skor",
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: const Color(0xFF003E79),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musrenbang/app/routes/app_pages.dart';

import '../controllers/hasil_musrenbang_controller.dart';

class HasilMusrenbangView extends GetView<HasilMusrenbangController> {
  const HasilMusrenbangView({super.key});

  String getValue(Map<String, dynamic> item, List<String> keys) {
    for (final key in keys) {
      final value = item[key];

      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }

    return "-";
  }

  //kategori
  Widget _kategoriChip({
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF003E79) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isActive
                  ? const Color(0xFF003E79)
                  : const Color(0xFFCCCCCC),
            ),
            boxShadow: [
              if (isActive)
                BoxShadow(
                  color: const Color(0xFF003E79).withOpacity(0.18),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isActive ? Colors.white : const Color(0xFF003E79),
            ),
          ),
        ),
      ),
    );
  }

  //
  Widget _kategoriSegment({
    required String kategoriAktif,
    required Function(String) onPilih,
    required int totalFisik,
    required int totalNonFisik,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _kategoriSegmentItem(
            title: "Fisik",
            icon: Icons.home_repair_service_rounded,
            total: totalFisik,
            isActive: kategoriAktif == "Fisik",
            onTap: () => onPilih("Fisik"),
          ),
          _kategoriSegmentItem(
            title: "Non Fisik",
            icon: Icons.groups_rounded,
            total: totalNonFisik,
            isActive: kategoriAktif == "Non Fisik",
            onTap: () => onPilih("Non Fisik"),
          ),
        ],
      ),
    );
  }

  Widget _kategoriSegmentItem({
    required String title,
    required IconData icon,
    required int total,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              width: double.infinity,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF003E79) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  if (isActive)
                    BoxShadow(
                      color: const Color(0xFF003E79).withOpacity(0.22),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                ],
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
              Positioned(top: -3, right: 8, child: _badgeTotalKategori(total)),
          ],
        ),
      ),
    );
  }

  //total setiap kategori
  Widget _badgeTotalKategori(int total) {
    return Container(
      constraints: const BoxConstraints(minWidth: 25, minHeight: 25),
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

  @override
  Widget build(BuildContext context) {
    final hasilController = Get.isRegistered<HasilMusrenbangController>()
        ? Get.find<HasilMusrenbangController>()
        : Get.put(HasilMusrenbangController());

    return Material(
      color: Colors.white,
      child: Column(
        children: [
          /// ================= HEADER BIRU =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 25,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF003E79),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                Obx(
                  () => Text(
                    "Rekapitulasi Hasil Musrenbang ${hasilController.tahunAktif.value}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Obx(
                  () => Text(
                    "Total Semua Usulan: ${hasilController.totalSemuaUsulan}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: hasilController.daftarTahun.length,
                    itemBuilder: (context, index) {
                      final tahun = hasilController.daftarTahun[index];

                      return Obx(() {
                        final isActive =
                            hasilController.tahunAktif.value == tahun;

                        return GestureDetector(
                          onTap: () {
                            hasilController.pilihTahun(tahun);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.35),
                              ),
                            ),
                            child: Text(
                              tahun.toString(),
                              style: GoogleFonts.poppins(
                                color: isActive
                                    ? const Color(0xFF003E79)
                                    : Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          /// ================= ISI HALAMAN =================
          Expanded(
            child: Column(
              children: [
                /// ================= SEARCH TETAP =================
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: const Color(0xFFD1D5DB),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: hasilController.ubahPencarian,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF374151),
                      ),
                      decoration: InputDecoration(
                        hintText: "Cari hasil musrenbang...",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF9CA3AF),
                        ),
                        border: InputBorder.none,
                        icon: const Icon(
                          Icons.search_rounded,
                          size: 22,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ),
                ),
                //kategori
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: Obx(
                    () => _kategoriSegment(
                      kategoriAktif: hasilController.kategoriAktif.value,
                      onPilih: hasilController.pilihKategori,
                      totalFisik: hasilController.totalFisik,
                      totalNonFisik: hasilController.totalNonFisik,
                    ),
                  ),
                ),

                /// ================= DATA HASIL =================
                Obx(() {
                  if (hasilController.isLoading.value) {
                    return Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF003E79),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Memuat hasil musrenbang...",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF003E79),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (hasilController.errorMessage.isNotEmpty) {
                    return Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            hasilController.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  final hasil = hasilController.hasilSesuaiKategoriPencarian;

                  if (hasil.isEmpty) {
                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: hasilController.refreshData,
                        color: Colors.white,
                        backgroundColor: const Color(0xFF003E79),
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 250, 16, 100),
                          children: [
                            Center(
                              child: Text(
                                hasilController.keywordPencarian.value.isEmpty
                                    ? "Belum ada hasil musrenbang"
                                    : "Hasil pencarian tidak ditemukan",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: const Color.fromARGB(
                                    255,
                                    122,
                                    122,
                                    122,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: hasilController.refreshData,
                      color: Colors.white,
                      backgroundColor: const Color(0xFF003E79),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
                        itemCount: hasil.length,
                        itemBuilder: (context, index) {
                          final item = Map<String, dynamic>.from(hasil[index]);

                          final idUsulan =
                              int.tryParse(item["id"].toString()) ?? 0;

                          final judul = item["judul_usulan"]?.toString() ?? "-";

                          final lokasi =
                              item["lokasi_detail"]?.toString() ?? "-";

                          final tahunRealisasi =
                              item["tahun_realisasi"]?.toString() ?? "-";

                          final status = item["status"]?.toString() ?? "-";

                          final skorAhp =
                              double.tryParse(
                                item["skor_ahp"]?.toString() ?? "0",
                              ) ??
                              0.0;
                          final skor = skorAhp.toStringAsFixed(2);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: const Color(0xFFCCCCCC),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// PRIORITAS DAN SKOR
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Prioritas ${index + 1}",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.blueGrey,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),

                                    Text(
                                      "Skor: $skor",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF003E79),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 5),

                                /// JUDUL USULAN
                                Text(
                                  judul,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF263238),
                                  ),
                                ),

                                const SizedBox(height: 5),

                                /// LOKASI
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        lokasi,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: const Color(0xFF607D8B),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 3),

                                /// TAHUN REALISASI DAN TOMBOL DETAIL
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Tahun Realisasi: $tahunRealisasi",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: const Color(0xFF607D8B),
                                            ),
                                          ),

                                          const SizedBox(height: 8),

                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                0xFF2E7D32,
                                              ).withOpacity(0.10),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: const Color(
                                                  0xFF2E7D32,
                                                ).withOpacity(0.35),
                                              ),
                                            ),
                                            child: Text(
                                              status,
                                              style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF2E7D32),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                          Routes.DETAIL_HASIL_MUSRENBANG,
                                          arguments: {"id": idUsulan},
                                        );
                                      },
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF003E79),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.10,
                                              ),
                                              blurRadius: 6,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

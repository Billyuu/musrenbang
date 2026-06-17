import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/status_usulan_controller.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:musrenbang/app/routes/app_pages.dart';

class StatusUsulanView extends GetView<StatusUsulanController> {
  const StatusUsulanView({super.key});

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
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF003E79) : Colors.transparent,
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
              Positioned(top: -5, right: 1, child: _badgeTotalKategori(total)),
          ],
        ),
      ),
    );
  }

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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Latar belakang abu muda halus
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'Status Pengajuan Usulan',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF003E79),

        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2_copy, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),

      body: Obx(() {
        // 🔄 State: Loading
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff1565C0)),
                  strokeWidth: 3,
                ),
                const SizedBox(height: 15),
                Text(
                  "Memuat data...",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF003E79),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        // ❌ State: Error
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                controller.errorMessage.value,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.red, fontSize: 14),
              ),
            ),
          );
        }

        // 📭 State: Kosong
        final data = controller.filteredUsulan;

        // 📋 State: Kategori tetap tampil
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _kategoriSegment(
                kategoriAktif: controller.kategoriAktif.value,
                onPilih: controller.pilihKategori,
                totalFisik: controller.totalFisik,
                totalNonFisik: controller.totalNonFisik,
              ),
            ),

            Expanded(
              child: data.isEmpty
                  ? Center(
                      child: Text(
                        controller.kategoriAktif.value == "Fisik"
                            ? "Belum ada usulan fisik"
                            : "Belum ada usulan non fisik",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: controller.refreshData,
                      color: Colors.white,
                      backgroundColor: const Color(0xFF003E79),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];

                          return InkWell(
                            onTap: () {
                              Get.toNamed(
                                Routes.DETAIL,
                                arguments: {
                                  'id':
                                      int.tryParse(item['id'].toString()) ?? 0,
                                },
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    item["tanggal"]?.toString() ?? "-",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: const Color(0xFFE0E0E0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item["judul_usulan"]
                                                      ?.toString() ??
                                                  "-",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: const Color(0xFF2D2D2D),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),

                                            const SizedBox(height: 4),

                                            Text(
                                              item["lokasi_detail"]
                                                      ?.toString() ??
                                                  "-",
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.grey[500],
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),

                                            const SizedBox(height: 10),

                                            _buildStatusBadge(
                                              item["status"]?.toString() ?? "",
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(width: 10),

                                      SizedBox(
                                        height: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF003E79),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "Detail",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.chevron_right,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }

  /// Helper untuk membuat Badge Status yang lebih kecil di dalam card
  Widget _buildStatusBadge(String status) {
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
      case "ditunda": // <--- tambah ini
        color = Colors.deepOrange;
        break;
      case "direalisasikan": // <--- tambah ini
        color = const Color(0xFF003E79);
        break;
      case "diverifikasi":
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

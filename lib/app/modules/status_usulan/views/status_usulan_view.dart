import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/status_usulan_controller.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:musrenbang/app/routes/app_pages.dart';

class StatusUsulanView extends GetView<StatusUsulanController> {
  const StatusUsulanView({super.key});

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
        final data = controller.dataUsulan;
        if (data.isEmpty) {
          return Center(
            child: Text(
              "Belum ada usulan",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            ),
          );
        }

        // 📋 State: Success dengan List View
        return RefreshIndicator(
          onRefresh: controller.refreshData,
          color: Colors.white, // Warna ikon panah refresh
          backgroundColor: const Color(
            0xFF003E79,
          ), // Warna latar belakang lingkaran loading (disesuaikan dengan warna AppBar)
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              final jenisUsulan = item["jenis_usulan"]?.toString() ?? "fisik";

              final labelJenisUsulan = jenisUsulan == "non_fisik"
                  ? "Non Fisik"
                  : "Fisik";

              final warnaJenisUsulan = jenisUsulan == "non_fisik"
                  ? const Color(0xFF1565C0)
                  : const Color(0xFF003E79);

              return InkWell(
                onTap: () => Get.toNamed('/detail-usulan', arguments: item),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TANGGAL (Di luar Card)
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

                    /// CARD KONTEN
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Badge Jenis Usulan
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: warnaJenisUsulan.withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: warnaJenisUsulan.withOpacity(0.35),
                                    ),
                                  ),
                                  child: Text(
                                    labelJenisUsulan,
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: warnaJenisUsulan,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 7),

                                // Judul Usulan
                                Text(
                                  item["judul_usulan"]?.toString() ?? "-",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: const Color(0xFF2D2D2D),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                // Lokasi
                                Text(
                                  item["lokasi_detail"]?.toString() ?? "-",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 10),
                                // Badge Status (Opsional: Tambahkan kembali jika ingin melihat status di list)
                                _buildStatusBadge(
                                  item["status"]?.toString() ?? "",
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),

                          /// ➡️ ICON PANAH
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                Routes.DETAIL,
                                arguments: {
                                  'id':
                                      int.tryParse(item['id'].toString()) ?? 0,
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF0F0C10),
                                ),
                              ),
                              child: const Icon(Icons.arrow_forward, size: 20),
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
        );
      }),
    );
  }

  /// Helper untuk membuat Badge Status yang lebih kecil di dalam card
  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case "diproses":
        color = Colors.orange;
        break;
      case "disetujui":
        color = Colors.green;
        break;
      case "ditolak":
        color = Colors.red;
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

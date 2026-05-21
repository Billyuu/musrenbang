import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../controllers/notif_controller.dart';

class NotifView extends GetView<NotifController> {
  const NotifView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> panduanList = [
      {
        "icon": Icons.edit_note_rounded,
        "title": "Isi Usulan dengan Jelas",
        "desc":
            "Tuliskan judul dan permasalahan secara detail agar usulan mudah dipahami.",
      },
      {
        "icon": Icons.location_on_rounded,
        "title": "Pastikan Lokasi Sesuai",
        "desc":
            "Masukkan lokasi dan titik koordinat dengan benar sesuai kondisi lapangan.",
      },
      {
        "icon": Icons.photo_camera_rounded,
        "title": "Upload Foto Pendukung",
        "desc":
            "Tambahkan foto terbaru agar kondisi usulan dapat diverifikasi lebih cepat.",
      },
      {
        "icon": Icons.groups_rounded,
        "title": "Utamakan Kepentingan Bersama",
        "desc":
            "Usulan yang berdampak bagi banyak warga akan menjadi prioritas pembangunan.",
      },
      {
        "icon": Icons.fact_check_rounded,
        "title": "Periksa Data Sebelum Dikirim",
        "desc": "Pastikan semua data sudah benar sebelum menyimpan usulan.",
      },
      {
        "icon": Icons.track_changes_rounded,
        "title": "Pantau Status Usulan",
        "desc":
            "Cek halaman status usulan secara berkala untuk melihat perkembangan usulan Anda.",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),

      appBar: AppBar(
        backgroundColor: const Color(0xFF003E79),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2_copy, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.white),

        title: Text(
          "Panduan Musrenbang",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1565C0).withOpacity(0.15),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.campaign_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "Musrenbang Desa Sukorejo",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Sampaikan aspirasi dan usulan pembangunan desa secara mudah, transparan, dan digital.",
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 13,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Text(
              "Panduan Pengajuan Usulan",
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF003E79),
              ),
            ),

            const SizedBox(height: 18),

            /// LIST PANDUAN
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: panduanList.length,
              itemBuilder: (context, index) {
                final item = panduanList[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          item['icon'],
                          color: const Color(0xFF003E79),
                          size: 24,
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'],
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF003E79),
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              item['desc'],
                              style: GoogleFonts.poppins(
                                fontSize: 12.5,
                                height: 1.6,
                                color: Colors.grey.shade700,
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

            const SizedBox(height: 10),

            Center(
              child: Text(
                "Musrenbang Desa Sukorejo © 2026",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

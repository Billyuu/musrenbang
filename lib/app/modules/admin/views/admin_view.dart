import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:musrenbang/app/routes/app_pages.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musrenbang/app/utils/ahp_helper.dart';

import '../controllers/admin_controller.dart';

class AdminView extends GetView<AdminController> {
  const AdminView({super.key});
//panduan
void _showAdminMenu(BuildContext context) {
  Get.bottomSheet(
    Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 18),

          Text(
            "Menu Admin",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF263238),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "Pilih menu yang dibutuhkan untuk mengelola Musrenbang Desa.",
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 18),

          _adminMenuItem(
            icon: Icons.help_outline_rounded,
            title: "Panduan Admin",
            subtitle: "Lihat tata cara mengelola usulan Musrenbang",
            onTap: () {
              Get.back();
              _showAdminGuide(context);
            },
          ),

          _adminMenuItem(
            icon: Icons.logout_rounded,
            title: "Logout",
            subtitle: "Keluar dari akun admin",
            iconColor: const Color(0xFF003E79),
            onTap: () {
              Get.back();
              controller.logoutAdmin();
            },
          ),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}

Widget _adminMenuItem({
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
  Color iconColor = const Color(0xFF1565C0),
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 23,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF263238),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right_rounded,
            color: Colors.grey,
          ),
        ],
      ),
    ),
  );
}

void _showAdminGuide(BuildContext context) {
  Get.bottomSheet(
    Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 46,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    color: Color(0xFF1565C0),
                    size: 26,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    "Panduan Admin Musrenbang",
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF263238),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              "Panduan ini membantu admin dalam mengelola usulan masyarakat, mengecek detail usulan, menentukan status, dan menjaga keamanan akses admin.",
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 18),

            _guideItem(
              icon: Icons.list_alt_rounded,
              title: "1. Lihat Daftar Usulan",
              desc:
                  "Admin dapat melihat seluruh usulan pembangunan yang diajukan oleh masyarakat.",
            ),

            _guideItem(
              icon: Icons.filter_alt_rounded,
              title: "2. Gunakan Filter Status",
              desc:
                  "Gunakan menu Diproses, Disetujui, dan Ditolak untuk melihat usulan berdasarkan status pengajuan.",
            ),

            _guideItem(
              icon: Icons.visibility_rounded,
              title: "3. Periksa Detail Usulan",
              desc:
                  "Tekan ikon panah pada usulan untuk melihat detail seperti judul, lokasi, permasalahan, urgensi, biaya, dan data pendukung.",
            ),

            _guideItem(
              icon: Icons.check_circle_rounded,
              title: "4. Setujui Usulan",
              desc:
                  "Jika usulan layak diproses, admin dapat mengubah status usulan menjadi disetujui.",
            ),

            _guideItem(
              icon: Icons.cancel_rounded,
              title: "5. Tolak Usulan",
              desc:
                  "Jika usulan belum sesuai, admin dapat menolak usulan agar statusnya tercatat dengan jelas.",
            ),

            _guideItem(
              icon: Icons.analytics_rounded,
              title: "6. Perhatikan Skor AHP",
              desc:
                  "Skor AHP membantu admin melihat nilai prioritas usulan berdasarkan kriteria yang digunakan dalam sistem.",
            ),

            _guideItem(
              icon: Icons.logout_rounded,
              title: "7. Logout Admin",
              desc:
                  "Gunakan menu logout setelah selesai agar akses admin tetap aman.",
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                child: Text(
                  "Saya Mengerti",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}

Widget _guideItem({
  required IconData icon,
  required String title,
  required String desc,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFF1565C0),
          size: 22,
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF263238),
                ),
              ),

              const SizedBox(height: 3),

              Text(
                desc,
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  color: Colors.grey.shade700,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003E79),
        title: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Text(
            'Selamat Datang,',
            style: GoogleFonts.poppins(
              // Sudah Poppins
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
  IconButton(
    tooltip: "Menu Admin",
    icon: const Icon(
      Icons.more_vert_rounded,
      color: Colors.white,
    ),
    onPressed: () {
      _showAdminMenu(context);
    },
  ),
],
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 0,
              bottom: 80,
              left: 35,
              right: 0,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF003E79),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Kelola Usulan, Wujudkan Pembangunan!',
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
                ),
              ],
            ),
          ),

          Transform.translate(
            offset: const Offset(0, -55),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.HASIL_MUSRENBANG);
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F0C10).withOpacity(0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
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
                              "Hasil Musrenbang",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Wujudkan Transparansi Pembangunan\nMelalui Hasil Musrenbang Desa",
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF0F0C10)),
                        ),
                        child: const Icon(Icons.arrow_forward, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -30),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// BARIS ATAS
                  Row(
                    children: [
                      const Icon(Icons.description_outlined, size: 20),

                      const SizedBox(width: 8),

                      Text(
                        "Status Pengajuan Usulan Masyarakat",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// DESKRIPSI FULL KE KIRI
                  Text(
                    "Cek status dan perkembangan usulan masyarakat di sini",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// FILTER STATUS
          const SizedBox(height: 0),

          Transform.translate(
            offset: const Offset(0, -20),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFCCCCCC), width: 1),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  /// DIPROSES
                  GestureDetector(
                    onTap: () => controller.statusAktif.value = "Diproses",
                    child: Obx(
                      () => Row(
                        children: [
                          Icon(
                            Icons.local_shipping,
                            size: 20,
                            color: controller.statusAktif.value == "Diproses"
                                ? const Color(0xFF003E79)
                                : Colors.grey,
                          ),

                          const SizedBox(width: 6),

                          Text(
                            "Diproses",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: controller.statusAktif.value == "Diproses"
                                  ? const Color(0xFF003E79)
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// DISETUJUI
                  GestureDetector(
                    onTap: () => controller.statusAktif.value = "Disetujui",
                    child: Obx(
                      () => Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 20,
                            color: controller.statusAktif.value == "Disetujui"
                                ? const Color(0xFF003E79)
                                : Colors.grey,
                          ),

                          const SizedBox(width: 6),

                          Text(
                            "Disetujui",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: controller.statusAktif.value == "Disetujui"
                                  ? const Color(0xFF003E79)
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// DITOLAK
                  GestureDetector(
                    onTap: () => controller.statusAktif.value = "Ditolak",
                    child: Obx(
                      () => Row(
                        children: [
                          Icon(
                            Icons.cancel,
                            size: 20,
                            color: controller.statusAktif.value == "Ditolak"
                                ? const Color(0xFF003E79)
                                : Colors.grey,
                          ),

                          const SizedBox(width: 6),

                          Text(
                            "Ditolak",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: controller.statusAktif.value == "Ditolak"
                                  ? const Color(0xFF003E79)
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 0),
          Obx(() {
            /// 🔄 LOADING
            if (controller.isLoading.value) {
              return Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xff1565C0),
                        ),
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
                ),
              );
            }

            /// ❌ ERROR
            if (controller.errorMessage.isNotEmpty) {
              return Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      controller.errorMessage.value,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            }

            final filtered = controller.filteredUsulan;

            /// 📭 KOSONG
            if (filtered.isEmpty) {
              return Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.refreshData,
                  color: Colors.white,
                  backgroundColor: const Color(0xFF003E79),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      const SizedBox(height: 150),
                      Center(
                        child: Text(
                          "Belum ada usulan",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            /// 📋 ADA DATA
            return Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshData,
                color: Colors.white,
                backgroundColor: const Color(0xFF003E79),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      //skor
                      final totalSkor = AhpHelper.hitungTotalAhp(item);
                      final totalSkorText = totalSkor.toStringAsFixed(2);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 🗓️ TANGGAL
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              item["tanggal"]?.toString() ?? "-",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ),

                          const SizedBox(height: 5),

                          /// 📦 CARD
                          Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color(0xFFCCCCCC),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// 📝 JUDUL
                                      Text(
                                        item["judul_usulan"]?.toString() ?? "-",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),

                                      const SizedBox(height: 5),

                                      /// 📍 LOKASI
                                      Text(
                                        item["lokasi_detail"]?.toString() ??
                                            "-",
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                /// 🔢 SKOR TOTAL + ➡️ ICON PANAH
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Text(
                                    //   "Skor",
                                    //   style: GoogleFonts.poppins(
                                    //     fontSize: 10,
                                    //     color: Colors.grey,
                                    //     fontWeight: FontWeight.w500,
                                    //   ),
                                    // ),

                                    // const SizedBox(height: 2),
                                    Text(
                                      totalSkorText,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: const Color(0xFF003E79),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                          Routes.DETAIL_ADMIN,
                                          arguments: {
                                            'id':
                                                int.tryParse(
                                                  item['id'].toString(),
                                                ) ??
                                                0,
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0xFF0F0C10),
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.arrow_forward,
                                          size: 14,
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
                    },
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
  
}

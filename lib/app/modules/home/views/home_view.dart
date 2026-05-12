import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:musrenbang/app/routes/app_pages.dart';
import 'package:musrenbang/app/modules/hasil_musrenbang/views/hasil_musrenbang_view.dart';
import 'package:musrenbang/app/modules/profil/views/profil_view.dart';
import 'package:musrenbang/app/modules/profil/controllers/profil_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfilController());
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          final index = controller.bottomNavIndex.value;

          // ================= 1. APPBAR HALAMAN HOME (INDEX 0) =================
          if (index == 0) {
            return AppBar(
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
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ],
            );
          } else if (index == 1) {
            return AppBar(
              backgroundColor: const Color(0xFF003E79),
              elevation: 0,
              centerTitle: true,
              title: Text(
                "Rekapitulasi Hasil Musrenbang 2026",
                style: GoogleFonts.poppins(
                  // Sudah Poppins
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }
          // ================= 3. APPBAR HALAMAN PROFIL (INDEX 2) =================
          else if (index == 2) {
            return AppBar(
              centerTitle: true,
              title: Text(
                'Profil Pengguna',
                style: GoogleFonts.poppins(
                  // Sudah Poppins
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: const Color(0xFF003E79),
            );
          }

          return const SizedBox.shrink();
        }),
      ),

      /// ================= BODY =================
      body: Obx(() {
        return IndexedStack(
          index: controller.bottomNavIndex.value,
          children: [
            _buildHomeContent(),
            const HasilMusrenbangView(),
            const ProfilView(),
          ],
        );
      }),

      /// ================= BOTTOM NAVIGATION =================
      bottomNavigationBar: Obx(
        () => Container(
          height: 70,
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(3, (index) {
              final isActive = controller.bottomNavIndex.value == index;
              final icons = [Icons.home, Icons.assignment, Icons.person];
              final labels = ["Home", "Hasil", "Profil"];

              return GestureDetector(
                onTap: () {
                  controller.bottomNavIndex.value = index;
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF003E79)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: AnimatedScale(
                        scale: isActive ? 1.2 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                        child: Icon(
                          icons[index],
                          color: isActive ? Colors.white : Colors.grey,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),

                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      style: GoogleFonts.poppins(
                        // Teks Label BottomNav jadi Poppins
                        color: isActive ? const Color(0xFF003E79) : Colors.grey,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: isActive ? 13 : 12,
                      ),
                      child: Text(labels[index]),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
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
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // 'Vera Angelina',
                      controller.profilController.nama.value,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Suaramu, Masa Depan Desa!',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //tombol usulan
            Positioned(
              bottom: -40,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.USULAN);
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF0F0C10).withOpacity(0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      /// TEXT
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pengajuan Usulan",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Kirimkan usulan Anda untuk peningkatan\nsistem dan layanan",
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// ICON
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFF0F0C10)),
                        ),
                        child: const Icon(Icons.arrow_forward, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Icon(Icons.description_outlined, size: 20),
              const SizedBox(width: 2),

              Text(
                "Status Pengajuan Usulan",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Spacer(),

              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.STATUS_USULAN);
                },
                child: Text(
                  "Selengkapnya",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Cek status dan perkembangan usulan\nAnda di sini",
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
          ),
        ),

        const SizedBox(height: 10),
        // action di proses
        Container(
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
              /// 🔵 DIPROSES
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

              /// 🔵 DISETUJUI
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

              /// 🔵 DITOLAK
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
        const SizedBox(height: 15),
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
                    style: GoogleFonts.poppins(color: Colors.red, fontSize: 14),
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
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];

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
                            border: Border.all(color: const Color(0xFFCCCCCC)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      item["lokasi_detail"]?.toString() ?? "-",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// ➡️ ICON PANAH
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF0F0C10),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  size: 20,
                                ),
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
    );
  }
}

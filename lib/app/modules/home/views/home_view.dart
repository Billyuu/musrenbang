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
              backgroundColor: Color(0xFF003E79),
              title: Padding(
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: Text(
                  'Selamat Datang,',
                  style: GoogleFonts.poppins(fontSize: 15, color: Colors.white),
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
          }
          // APPBAR HALAMAN HASIL (INDEX 1)
          else if (index == 1) {
            return AppBar(
              backgroundColor: const Color(0xFF003E79),
              elevation: 7,
              shadowColor: Colors.black,
              centerTitle: true,

              title: Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "Cari hasil musrenbang...",
                    hintStyle: TextStyle(color: Colors.white60, fontSize: 13),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white70,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            );
          }
          // ================= 3. APPBAR HALAMAN PROFIL (INDEX 2) =================
          else if (index == 2) {
            return AppBar(
              title: const Text(
                "Profil Pengguna",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: const Color(0xFF003E79),
              centerTitle: true,
              elevation: 0,
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
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 25),
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
                  /// 🔥 CUMA GANTI INDEX (NO NAVIGASI)
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

                      /// 🔥 animasi scale lebih smooth
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
                      style: TextStyle(
                        color: isActive ? const Color(0xFF003E79) : Colors.grey,
                        fontWeight: isActive
                            ? FontWeight.bold
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
    // Hubungkan ke controller
    final HomeController controller = Get.find<HomeController>();

    return ListView(
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
                      'Vera Angelina',
                      // controller.profilController.nama.value,
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

        ///STATUS SECTION
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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

              const SizedBox(height: 10),

              /// 🔽 DESKRIPSI
              Text(
                "Cek status dan perkembangan usulan\nAnda di sini",
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFCCCCCC),
                    width: 1, // bisa kamu atur (0.5 - 2)
                  ),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.local_shipping,
                          color: Color(0xFF003E79),
                          size: 20,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Diproses",
                          style: TextStyle(
                            color: Color(0xFF003E79),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: Color(0xFF0F0C10),
                          size: 20,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Disetujui",
                          style: TextStyle(
                            color: Color(0xFF0F0C10),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Icon(Icons.cancel, color: Color(0xFF0F0C10), size: 20),
                        SizedBox(width: 5),
                        Text(
                          "Ditolak",
                          style: TextStyle(
                            color: Color(0xFF0F0C10),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

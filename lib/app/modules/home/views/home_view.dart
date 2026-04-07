import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:musrenbang/app/routes/app_pages.dart';
import 'package:musrenbang/app/modules/hasil_musrenbang/views/hasil_musrenbang_view.dart';
import 'package:musrenbang/app/modules/profil/views/profil_view.dart';
import 'package:musrenbang/app/modules/profil/controllers/profil_controller.dart';

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
              backgroundColor: const Color(0xff1565C0),

              // --- 1. KEMBALIKAN ELEVATION & SHADOW ---
              elevation: 8, // Angka lebih besar = bayangan lebih tegas
              shadowColor: Colors.black, // Warna bayangannya hitam
              // --- 2. TETAPKAN GARIS HITAM DI BAWAH ---
              shape: const Border(
                bottom: BorderSide(color: Color(0xff1565C0), width: 1.5),
              ),

              title: const Text(
                'MUSRENBANG DIGITAL',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
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
              backgroundColor: const Color(0xff1565C0),
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
              backgroundColor: const Color(0xff1565C0),
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
                            ? const Color(0xff1565C0)
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
                        color: isActive ? const Color(0xff1565C0) : Colors.grey,
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

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: 15,
            bottom: 0,
            left: 25,
            right: 25,
          ),
          decoration: const BoxDecoration(color: Color(0xff1565C0)),
          // Gunakan Obx agar nama terpantau secara real-time
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang,',
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.profilController.nama.value,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),

        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// TOMBOL USULAN
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.USULAN);
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xff1565C0),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                          size: 35,
                        ),

                        SizedBox(height: 10),

                        Text(
                          "Buat Pengajuan Usulan Baru",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                /// STATUS USULAN
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.STATUS_USULAN);
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ), // ⬅️ biar rapi
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.assignment_outlined,
                          color: Colors.white,
                          size: 35,
                        ),

                        SizedBox(height: 10),
                        Text(
                          "Daftar Status Usulan",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(
                    color: Color.fromARGB(255, 202, 202, 202),
                    thickness: 1.5,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Status Usulan Saya:",
                      style: TextStyle(
                        color: Color.fromARGB(255, 90, 90, 90),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(height: 5),

                    /// CARD 1
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          /// ICON KIRI
                          const Icon(
                            Icons.access_time,
                            color: Color(0xFFFFA726),
                            size: 30,
                          ),

                          const SizedBox(width: 15),

                          /// TEKS
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Diproses",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 90, 90, 90),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                          255,
                                          116,
                                          115,
                                          115,
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          /// CARD KECIL KANAN
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFA726),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "3 Usulan",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// CARD 2
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 30,
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Disetujui",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 90, 90, 90),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                /// DOT DI BAWAH TEKS
                                Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                          255,
                                          116,
                                          115,
                                          115,
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "2 Usulan",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// CARD 3
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.cancel, color: Colors.red, size: 30),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Ditolak",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 90, 90, 90),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                          255,
                                          116,
                                          115,
                                          115,
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "1 Usulan",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:musrenbang/app/routes/app_pages.dart';
import 'package:musrenbang/app/modules/hasil_musrenbang/views/hasil_musrenbang_view.dart';
import 'package:musrenbang/app/modules/profil/views/profil_view.dart';
import 'package:musrenbang/app/modules/profil/controllers/profil_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(ProfilController());

    return Obx(() {
      final index = controller.bottomNavIndex.value;

      return Scaffold(
        backgroundColor: Colors.grey.shade200,
        extendBody: true,

        /// ================= APPBAR =================
        /// Index 0 = Home
        /// Index 1 = Hasil Musrenbang, tidak pakai AppBar dari HomeView
        /// Index 2 = Profil
        appBar: index == 1
            ? null
            : AppBar(
                backgroundColor: const Color(0xFF003E79),
                elevation: 0,
                centerTitle: index == 2,
                title: index == 0
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        child: Text(
                          'Selamat Datang,',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        'Profil Pengguna',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                actions: index == 0
                    ? [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Builder(
                            builder: (context) {
                              final box = GetStorage();

                              final bool sudahPernahDibuka =
                                  box.read('sudah_buka_panduan') == true;

                              final RxBool sudahBukaPanduan = RxBool(
                                sudahPernahDibuka,
                              );

                              return Obx(
                                () => Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.help_outline,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        box.write('sudah_buka_panduan', true);
                                        sudahBukaPanduan.value = true;

                                        Get.toNamed(Routes.NOTIF);
                                      },
                                    ),

                                    if (!sudahBukaPanduan.value)
                                      Positioned(
                                        right: 12,
                                        top: 12,
                                        child: Container(
                                          width: 9,
                                          height: 9,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1.2,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ]
                    : null,
              ),

        /// ================= BODY =================
        body: IndexedStack(
          index: index,
          children: [
            _buildHomeContent(),
            const HasilMusrenbangView(),
            const ProfilView(),
          ],
        ),

        /// ================= BOTTOM NAVIGATION =================
        bottomNavigationBar: Container(
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
            children: List.generate(3, (navIndex) {
              final isActive = index == navIndex;
              final icons = [Icons.home, Icons.assignment, Icons.person];
              final labels = ["Home", "Hasil", "Profil"];

              return GestureDetector(
                onTap: () {
                  controller.bottomNavIndex.value = navIndex;
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
                          icons[navIndex],
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
                        color: isActive ? const Color(0xFF003E79) : Colors.grey,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: isActive ? 13 : 12,
                      ),
                      child: Text(labels[navIndex]),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      );
    });
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
                  Get.bottomSheet(
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(28),
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
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Text(
                            "Pilih Jenis Usulan",
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F0C10),
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Silakan pilih jenis usulan yang ingin Anda ajukan.",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// USULAN FISIK
                          GestureDetector(
                            onTap: () {
                              Get.back();
                              Get.toNamed(Routes.USULAN);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF3FC),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFFD6E8F8),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF003E79),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.home_repair_service_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Usulan Fisik",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF0F0C10),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Jalan, drainase, lampu, jembatan, atau fasilitas umum.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: Color(0xFF003E79),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          /// USULAN NON FISIK
                          GestureDetector(
                            onTap: () {
                              Get.back();
                              Get.toNamed(Routes.USULAN_NON_FISIK);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F8FB),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFFE2E6EA),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF1565C0),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.groups_rounded,
                                      color: Colors.white,
                                      size: 23,
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Usulan Non Fisik",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF0F0C10),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "UMKM, Pendidikan, pelatihan, bantuan sosial, atau kesehatan.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: Color(0xFF1565C0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
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
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFCCCCCC), width: 1),
          ),

          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,

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
                        const SizedBox(width: 18),
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
                        const SizedBox(width: 18),
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
                        const SizedBox(width: 18),
                      ],
                    ),
                  ),
                ),

                /// 🔵 DITUNDA
                GestureDetector(
                  onTap: () => controller.statusAktif.value = "Ditunda",
                  child: Obx(
                    () => Row(
                      children: [
                        Icon(
                          Icons.update,
                          size: 20,
                          color: controller.statusAktif.value == "Ditunda"
                              ? const Color(0xFF003E79)
                              : Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Ditunda",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: controller.statusAktif.value == "Ditunda"
                                ? const Color(0xFF003E79)
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 18),
                      ],
                    ),
                  ),
                ),

                /// 🔵 DIREALISASIKAN
                GestureDetector(
                  onTap: () => controller.statusAktif.value = "Direalisasikan",
                  child: Obx(
                    () => Row(
                      children: [
                        Icon(
                          Icons.verified,
                          size: 20,
                          color:
                              controller.statusAktif.value == "Direalisasikan"
                              ? const Color(0xFF003E79)
                              : Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Direalisasikan",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color:
                                controller.statusAktif.value == "Direalisasikan"
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
                    final jenisUsulan =
                        item["jenis_usulan"]?.toString() ?? "fisik";

                    final labelJenisUsulan = jenisUsulan == "non_fisik"
                        ? "Non Fisik"
                        : "Fisik";

                    final warnaJenisUsulan = jenisUsulan == "non_fisik"
                        ? const Color(0xFF1565C0)
                        : const Color(0xFF003E79);

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
                                    /// 🏷️ JENIS USULAN
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: warnaJenisUsulan.withOpacity(
                                          0.10,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
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

                                    const SizedBox(height: 8),

                                    /// 📝 JUDUL
                                    Text(
                                      item["judul_usulan"]?.toString() ?? "-",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
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
                              const SizedBox(width: 15),

                              /// ➡️ ICON PANAH
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    Routes.DETAIL,
                                    arguments: {
                                      'id':
                                          int.tryParse(item['id'].toString()) ??
                                          0,
                                    },
                                  );
                                },
                                child: Container(
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:musrenbang/app/routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: const Color(0xff1565C0),
      ),

      /// ================= BODY =================
      body: 
      Padding(
        
        padding: const EdgeInsets.all(20),
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selamat Datang di Aplikasi Musrenbang',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            /// TOMBOL USULAN
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1565C0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "USULAN",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Get.toNamed(Routes.USULAN);
                },
              ),
            ),

            const SizedBox(height: 15),

            /// STATUS USULAN
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "STATUS USULAN",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Get.toNamed(Routes.STATUS_USULAN);
                },
              ),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),

      /// ================= BOTTOM NAVIGATION =================
     bottomNavigationBar: Obx(
  () => Container(
    height: 75,
    margin: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        )
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(3, (index) {
        final isActive = controller.bottomNavIndex.value == index;

        final icons = [
          Icons.home,
          Icons.assignment,
          Icons.person,
        ];

        final labels = [
          "Home",
          "Hasil",
          "Profil",
        ];

        return GestureDetector(
          onTap: () {
            controller.bottomNavIndex.value = index;

            if (index == 0) {
              Get.offAllNamed(Routes.HOME);
            } else if (index == 1) {
              Get.offAllNamed(Routes.HASIL_MUSRENBANG);
            } else if (index == 2) {
              Get.offAllNamed(Routes.PROFIL);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xff1565C0)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 300),
                  padding:
                      EdgeInsets.only(bottom: isActive ? 6 : 0),
                  child: Icon(
                    icons[index],
                    color:
                        isActive ? Colors.white : Colors.grey,
                    size: isActive ? 26 : 24,
                  ),
                ),
              ),

              const SizedBox(height: 4),

              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  color: isActive
                      ? const Color(0xff1565C0)
                      : Colors.grey,
                  fontWeight:
                      isActive ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
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
}

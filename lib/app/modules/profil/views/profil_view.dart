import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profil_controller.dart';
import 'package:musrenbang/app/routes/app_pages.dart';

class ProfilView extends GetView<ProfilController> {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profil User'),
        centerTitle: true,
        backgroundColor: const Color(0xff1565C0),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// ================= PROFIL CARD (SEMUA DIGABUNG) =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ===== FOTO + NAMA =====
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/profile.png'),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: controller.editFoto,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xff1565C0),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Obx(
                          () => Text(
                            controller.nama.value,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),
                  const Divider(),
                  const SizedBox(height: 10),

                  /// ===== DATA USER =====
                  Obx(
                    () => buildItem(
                      title: "NIK",
                      value: controller.nik.value,
                      icon: Icons.credit_card,
                    ),
                  ),
                  const Divider(),

                  Obx(
                    () => buildItem(
                      title: "Alamat",
                      value: controller.alamat.value,
                      icon: Icons.location_on,
                    ),
                  ),
                  const Divider(),

                  Obx(
                    () => buildItem(
                      title: "Jenis Kelamin",
                      value: controller.jenisKelamin.value,
                      icon: Icons.person,
                    ),
                  ),
                  const Divider(),

                  Obx(
                    () => buildItemEditable(
                      title: "Nomor Telepon",
                      value: controller.noHp.value,
                      icon: Icons.phone,
                      onEdit: controller.editNoHp,
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// ===== LOGOUT =====
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: controller.logout,
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1565C0),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                  padding: EdgeInsets.only(
                      bottom: isActive ? 6 : 0),
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

  /// ================= WIDGET DATA =================
  Widget buildItem({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xff1565C0)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold, // 🔥 TITLE BOLD
        ),
      ),
      subtitle: Text(value, style: const TextStyle(fontSize: 14)),
    );
  }

  Widget buildItemEditable({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onEdit,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xff1565C0)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold, // 🔥 TITLE BOLD
        ),
      ),
      subtitle: Text(value, style: const TextStyle(fontSize: 14)),
      trailing: IconButton(
        icon: const Icon(Icons.edit, color: Color(0xff1565C0)),
        onPressed: onEdit,
      ),
    );
  }
}

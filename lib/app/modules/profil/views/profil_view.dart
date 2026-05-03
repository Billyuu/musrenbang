import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profil_controller.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilView extends GetView<ProfilController> {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
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
                  Obx(
                    () => Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                                image: controller.selectedImage.value != null
                                    ? DecorationImage(
                                        image: FileImage(
                                          controller.selectedImage.value!,
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : (controller.imageUrl.value != ""
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                controller.imageUrl.value,
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : null),
                              ),
                              child:
                                  (controller.selectedImage.value == null &&
                                      controller.imageUrl.value == "")
                                  ? const Icon(
                                      Iconsax.user,
                                      size: 50,
                                      color: Colors.black54,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: controller.editFoto,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF003E79),
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
                    () => buildItemEditable(
                      title: "Alamat",
                      value: controller.alamat.value,
                      icon: Icons.location_on,
                      onEdit: controller.editAlamat,
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
                      label: Text(
                        "Logout",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003E79),
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
    );
  }

  /// ================= WIDGET DATA =================
  Widget buildItem({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF003E79)),
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
      leading: Icon(icon, color: const Color(0xFF003E79)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold, // 🔥 TITLE BOLD
        ),
      ),
      subtitle: Text(value, style: const TextStyle(fontSize: 14)),
      trailing: IconButton(
        icon: const Icon(Icons.edit, color: Color(0xFF003E79)),
        onPressed: onEdit,
      ),
    );
  }
}

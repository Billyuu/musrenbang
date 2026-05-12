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
                          alignment: Alignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (controller.selectedImage.value != null ||
                                    controller.imageUrl.value != "") {
                                  Get.dialog(
                                    Dialog(
                                      backgroundColor: Colors.transparent,
                                      insetPadding: const EdgeInsets.all(20),
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                            child:
                                                controller
                                                        .selectedImage
                                                        .value !=
                                                    null
                                                ? Image.file(
                                                    controller
                                                        .selectedImage
                                                        .value!,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.network(
                                                    "${controller.imageUrl.value}?t=${DateTime.now().millisecondsSinceEpoch}",
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),

                                          Positioned(
                                            top: 10,
                                            right: 10,
                                            child: GestureDetector(
                                              onTap: () => Get.back(),
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                width: 90,
                                height: 90,
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
                                                  "${controller.imageUrl.value}?t=${DateTime.now().millisecondsSinceEpoch}",
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
                            ),

                            if (controller.isUploadFotoLoading.value)
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.45),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.3,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: controller.isUploadFotoLoading.value
                                    ? null
                                    : controller.editFoto,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: controller.isUploadFotoLoading.value
                                        ? Colors.grey
                                        : const Color(0xFF003E79),
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
                          child: Text(
                            controller.nama.value,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF003E79),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 0),

                  /// ===== DATA USER =====
                  Obx(
                    () => buildItem(
                      title: "Email",
                      value: controller.email.value,
                      icon: Icons.email,
                    ),
                  ),
                  const Divider(),
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
                      value: controller.noHp.value.isNotEmpty
                          ? "+62 ${controller.noHp.value}"
                          : "-",
                      icon: Icons.phone_rounded,
                      onEdit: controller.editNoHp,
                    ),
                  ),

                  const SizedBox(height: 20),

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
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(value, style: GoogleFonts.poppins(fontSize: 12)),
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
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(value, style: GoogleFonts.poppins(fontSize: 12)),
      trailing: IconButton(
        icon: const Icon(Icons.edit, color: Color(0xFF003E79)),
        onPressed: onEdit,
      ),
    );
  }
}

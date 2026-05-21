import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musrenbang/app/routes/app_pages.dart';
import 'package:musrenbang/services/api_service.dart';

class AdminController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var dataUsulan = <dynamic>[].obs;

  var statusAktif = "Diproses".obs;
var logoutLoading = false.obs;
  final box = GetStorage();

  String mapStatus(String statusUI) {
    switch (statusUI) {
      case "Diproses":
        return "diproses";
      case "Disetujui":
        return "disetujui";
      case "Ditolak":
        return "ditolak";
      default:
        return "";
    }
  }

  List<dynamic> get filteredUsulan {
    final statusFilter = mapStatus(statusAktif.value);

    return dataUsulan.where((item) {
      final statusApi =
          item["status"]?.toString().toLowerCase().trim() ?? "";

      return statusApi == statusFilter;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();

    // CEK AKSES ADMIN
    final role = box.read("role");
    final isAdminLogin = box.read("isAdminLogin") ?? false;

    if (role != "admin" || isAdminLogin != true) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    getAllUsulan();
  }

  Future<void> getAllUsulan() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final result = await ApiService.getAllUsulanAdmin();

      if (result['statusCode'] == 200) {
        dataUsulan.value = result['body']['data'] ?? [];

        print("JUMLAH SEMUA USULAN: ${dataUsulan.length}");
        print("STATUS AKTIF: ${statusAktif.value}");
        print("JUMLAH FILTERED: ${filteredUsulan.length}");

        for (var item in dataUsulan) {
          print("STATUS API: ${item["status"]}");
        }
      } else {
        errorMessage.value =
            result['body']['message'] ?? "Gagal mengambil data usulan";
        dataUsulan.clear();
      }
    } catch (e) {
      errorMessage.value = "Terjadi kesalahan: $e";
      dataUsulan.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await getAllUsulan();
  }

 void logoutAdmin() {
  Get.bottomSheet(
    Obx(
      () => Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 5,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.logout_rounded,
                size: 34,
                color: Color(0xFF003E79),
              ),
            ),

            const SizedBox(height: 18),

            Text(
              "Logout Admin?",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF003E79),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Anda akan keluar dari halaman admin Musrenbang Desa Sukorejo.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: logoutLoading.value ? null : () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: logoutLoading.value
                              ? Colors.grey.shade200
                              : Colors.grey.shade300,
                        ),
                        backgroundColor: logoutLoading.value
                            ? Colors.grey.shade100
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: logoutLoading.value
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.grey.shade500,
                              ),
                            )
                          : Text(
                              "Batal",
                              style: GoogleFonts.poppins(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: logoutLoading.value
                          ? null
                          : () async {
                              try {
                                logoutLoading.value = true;

                                box.remove("isAdminLogin");
                                box.remove("role");
                                box.remove("admin_id");
                                box.remove("admin_name");
                                box.remove("admin_email");

                                Get.back();

                                Get.offAllNamed(Routes.LOGIN);
                              } finally {
                                logoutLoading.value = false;
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003E79),
                        disabledBackgroundColor: const Color(0xFF003E79),
                        disabledForegroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: logoutLoading.value
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "Logout",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
    ignoreSafeArea: false,
  );
}
}
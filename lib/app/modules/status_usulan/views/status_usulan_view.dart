import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/status_usulan_controller.dart';

class StatusUsulanView extends GetView<StatusUsulanController> {
  const StatusUsulanView({super.key});

  // 🎨 Warna status
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.orange;
      case "disetujui":
        return Colors.green;
      case "ditolak":
        return Colors.red;
      case "diverifikasi":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Status Usulan"),
        centerTitle: true,
        backgroundColor: const Color(0xff1565C0),
      ),

      body: Obx(() {
        // 🔄 Loading
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // ❌ Error dari API
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        // 📭 Kosong
        if (controller.dataUsulan.isEmpty) {
          return const Center(
            child: Text(
              "Belum ada usulan",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        // 📋 Data
        return RefreshIndicator(
          onRefresh: controller.refreshData, // ✅ FIX
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.dataUsulan.length,
            itemBuilder: (context, index) {
              final item = controller.dataUsulan[index];

              return InkWell(
                onTap: () {
                  Get.toNamed('/detail-usulan', arguments: item);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 📝 Judul
                        Text(
                          item["judul_usulan"] ?? "-",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // 📍 Lokasi
                        Text("Lokasi: ${item["lokasi_detail"] ?? "-"}"),

                        const SizedBox(height: 5),

                        // 📊 Status text
                        Text("Status: ${item["status"] ?? "-"}"),

                        const SizedBox(height: 10),

                        // 🎨 Badge status
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: getStatusColor(item["status"] ?? ""),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item["status"] ?? "-",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
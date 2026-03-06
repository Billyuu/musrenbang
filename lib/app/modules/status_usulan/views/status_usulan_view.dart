import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/status_usulan_controller.dart';

class StatusUsulanView extends GetView<StatusUsulanController> {
  const StatusUsulanView({super.key});

  Color getStatusColor(String status) {
    switch (status) {
      case "Diajukan":
        return Colors.orange;
      case "Diverifikasi":
        return Colors.blue;
      case "Disetujui":
        return Colors.green;
      case "Ditolak":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dummy Data sementara
    final List<Map<String, String>> dataUsulan = [
      {
        "judul": "Perbaikan Jalan Desa",
        "lokasi": "Desa Sukamaju",
        "tahun": "2026",
        "status": "Diajukan"
      },
      {
        "judul": "Pembangunan Drainase",
        "lokasi": "Dusun Melati",
        "tahun": "2026",
        "status": "Diverifikasi"
      },
      {
        "judul": "Renovasi Balai Desa",
        "lokasi": "Desa Harapan",
        "tahun": "2026",
        "status": "Disetujui"
      },
      {
        "judul": "Pengadaan Lampu Jalan",
        "lokasi": "RT 05",
        "tahun": "2026",
        "status": "Ditolak"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Status Usulan"),
        centerTitle: true,
        backgroundColor: const Color(0xff1565C0),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dataUsulan.length,
        itemBuilder: (context, index) {
          final item = dataUsulan[index];
          return Card(
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
                  Text(
                    item["judul"]!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Lokasi : ${item["lokasi"]}"),
                  Text("Tahun : ${item["tahun"]}"),
                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: getStatusColor(item["status"]!),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item["status"]!,
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
          );
        },
      ),
    );
  }
}
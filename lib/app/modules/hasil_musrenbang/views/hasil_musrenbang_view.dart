import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hasil_musrenbang_controller.dart';
import 'package:musrenbang/app/routes/app_pages.dart';

class HasilMusrenbangView extends GetView<HasilMusrenbangController> {
  const HasilMusrenbangView({super.key});

  Color getPriorityColor(String prioritas) {
    switch (prioritas) {
      case "Tinggi":
        return Colors.red;
      case "Sedang":
        return Colors.orange;
      case "Rendah":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dummy Data Hasil Musrenbang
    final List<Map<String, dynamic>> hasil = [
      {
        "judul": "Perbaikan Jalan Desa",
        "lokasi": "Desa Sukamaju",
        "skor": 88,
        "prioritas": "Tinggi",
        "anggaran": "Rp 500.000.000"
      },
      {
        "judul": "Pembangunan Drainase",
        "lokasi": "Dusun Melati",
        "skor": 75,
        "prioritas": "Sedang",
        "anggaran": "Rp 250.000.000"
      },
      {
        "judul": "Renovasi Balai Desa",
        "lokasi": "Desa Harapan",
        "skor": 60,
        "prioritas": "Rendah",
        "anggaran": "Rp 150.000.000"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
         automaticallyImplyLeading: false,
        title: const Text("Hasil Musrenbang"),
        centerTitle: true,
        backgroundColor: const Color(0xff1565C0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// REKAP ATAS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff1565C0),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Text(
                    "Rekapitulasi Hasil Musrenbang 2026",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Total Usulan Disetujui: ${hasil.length}",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// LIST HASIL
            Expanded(
              child: ListView.builder(
                itemCount: hasil.length,
                itemBuilder: (context, index) {
                  final item = hasil[index];

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Ranking
                          Text(
                            "Prioritas ${index + 1}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(height: 8),

                          /// Judul
                          Text(
                            item["judul"],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),
                          Text("Lokasi : ${item["lokasi"]}"),
                          Text("Skor : ${item["skor"]}"),
                          Text("Anggaran : ${item["anggaran"]}"),

                          const SizedBox(height: 10),

                          /// Badge Prioritas
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: getPriorityColor(item["prioritas"]),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                item["prioritas"],
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
            ),
          ],
        ),
      ),
  
    );
  }
}
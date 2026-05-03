import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/hasil_musrenbang_controller.dart';

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
    final List<Map<String, dynamic>> hasil = [
      {
        "judul": "Perbaikan Jalan Desa",
        "lokasi": "Desa Sukamaju",
        "skor": 88,
        "prioritas": "Tinggi",
        "anggaran": "Rp 500.000.000",
      },
      {
        "judul": "Pembangunan Drainase",
        "lokasi": "Dusun Melati",
        "skor": 75,
        "prioritas": "Sedang",
        "anggaran": "Rp 250.000.000",
      },
      {
        "judul": "Renovasi Balai Desa",
        "lokasi": "Desa Harapan",
        "skor": 60,
        "prioritas": "Rendah",
        "anggaran": "Rp 150.000.000",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          Container(
            height: 40,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 0),
            decoration: const BoxDecoration(color: Color(0xFF003E79)),
            child: Text(
              "Total Usulan Disetujui: 3",
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
            ),
          ),

          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Color.fromARGB(211, 0, 63, 121),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF003E79)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Cari hasil musrenbang...",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white,
                  ),

                  border: InputBorder.none,

                  icon: const Icon(Icons.search, size: 20, color: Colors.white),
                ),
              ),
            ),
          ),

          /// 📄 LIST HASIL
          Padding(
            padding: const EdgeInsets.only(top: 120),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: hasil.length,
              itemBuilder: (context, index) {
                final item = hasil[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFFCCCCCC)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Ranking
                      Text(
                        "Prioritas ${index + 1}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// Judul
                      Text(
                        item["judul"],
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        "Lokasi : ${item["lokasi"]}",
                        style: GoogleFonts.poppins(fontSize: 13),
                      ),
                      Text(
                        "Skor : ${item["skor"]}",
                        style: GoogleFonts.poppins(fontSize: 13),
                      ),
                      Text(
                        "Anggaran : ${item["anggaran"]}",
                        style: GoogleFonts.poppins(fontSize: 13),
                      ),

                      const SizedBox(height: 10),

                      /// Badge Prioritas
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: getPriorityColor(item["prioritas"]),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item["prioritas"],
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
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
        ],
      ),
    );
  }
}

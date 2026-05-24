import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/detail_hasil_musrenbang_controller.dart';

class DetailHasilMusrenbangView
    extends GetView<DetailHasilMusrenbangController> {
  const DetailHasilMusrenbangView({super.key});

  String _value(dynamic item, String key) {
    final value = item[key];
    if (value == null || value.toString().trim().isEmpty) {
      return "-";
    }
    return value.toString();
  }

  String _formatTanggal(dynamic value) {
    if (value == null || value.toString().isEmpty) return "-";

    try {
      final date = DateTime.parse(value.toString()).toLocal();

      final hari = date.day.toString().padLeft(2, '0');
      final bulan = date.month.toString().padLeft(2, '0');
      final tahun = date.year.toString();
      final jam = date.hour.toString().padLeft(2, '0');
      final menit = date.minute.toString().padLeft(2, '0');

      return "$hari-$bulan-$tahun $jam:$menit";
    } catch (e) {
      return value.toString();
    }
  }

  String _formatRupiah(dynamic value) {
    if (value == null || value.toString().isEmpty) return "-";

    final numberText = value.toString().replaceAll(RegExp(r'[^0-9]'), '');
    final number = int.tryParse(numberText);

    if (number == null) return "-";

    final result = number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        );

    return "Rp $result";
  }

  String _formatSkor(dynamic value) {
    if (value == null || value.toString().isEmpty) return "-";

    final skor = double.tryParse(value.toString());
    if (skor == null) return "-";

    return skor.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003E79),
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          "Detail Hasil Musrenbang",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Color(0xFF003E79),
                ),
                const SizedBox(height: 14),
                Text(
                  "Memuat detail hasil musrenbang...",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF003E79),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        final item = controller.data;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _headerCard(item),
              const SizedBox(height: 16),

              _sectionCard(
                title: "Informasi Hasil Musrenbang",
                icon: Icons.assignment_turned_in_rounded,
                children: [
                  _infoItem(
                    title: "Tanggal Diterima",
                    value: _formatTanggal(
                      item["updated_at"] ?? item["tanggal_diterima"] ?? item["tanggal"],
                    ),
                  ),
                  _infoItem(
                    title: "Judul Usulan",
                    value: _value(item, "judul_usulan"),
                  ),
                  _infoItem(
                    title: "Skor AHP",
                    value: _formatSkor(item["skor_ahp"]),
                  ),
                  _infoItem(
                    title: "Permasalahan",
                    value: _value(item, "permasalahan"),
                  ),
                  _infoItem(
                    title: "Dusun",
                    value: _value(item, "dusun"),
                  ),
                  _infoItem(
                    title: "Alamat Lokasi",
                    value: _value(item, "lokasi_detail"),
                  ),
                  _infoItem(
                    title: "Titik Koordinat",
                    value: _value(item, "koordinat"),
                  ),
                  _infoItem(
                    title: "Tahun Realisasi",
                    value: _value(item, "tahun_realisasi"),
                  ),
                  _infoItem(
                    title: "Anggaran",
                    value: _formatRupiah(item["biaya_final"]),
                    isLast: true,
                  ),
                ],
              ),

              _fotoCard(item),

              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _headerCard(dynamic item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF003E79),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _value(item, "judul_usulan"),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  "DISETUJUI",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                "Skor: ${_formatSkor(item["skor_ahp"])}",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE6E8EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 21,
                color: const Color(0xFF003E79),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _infoItem({
    required String title,
    required String value,
    bool isLast = false,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: isLast ? 0 : 14),
      padding: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.16),
                ),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF1F2937),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fotoCard(dynamic item) {
    final foto = _value(item, "foto_usulan");

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE6E8EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.image_rounded,
                size: 21,
                color: Color(0xFF003E79),
              ),
              const SizedBox(width: 8),
              Text(
                "Foto Usulan",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              controller.getFotoUsulan(foto),
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;

                return Container(
                  height: 220,
                  alignment: Alignment.center,
                  color: Colors.grey.shade200,
                  child: const CircularProgressIndicator(
                    color: Color(0xFF003E79),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 220,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    "Foto tidak tersedia",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
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
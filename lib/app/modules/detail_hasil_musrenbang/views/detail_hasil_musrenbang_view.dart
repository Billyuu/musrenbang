import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musrenbang/app/utils/ahp_helper.dart';
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

  bool _adaFoto(dynamic foto) {
    final value = foto?.toString().trim() ?? '';
    return value.isNotEmpty && value != '-' && value != 'null';
  }

  bool _adaVolume(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isNotEmpty && text != '-' && text != 'null' && text != '0';
  }

  String _nilaiAtauStrip(dynamic value) {
    final text = value?.toString().trim() ?? '';
    if (text.isEmpty || text == 'null' || text == '-') {
      return '-';
    }
    return text;
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
                const CircularProgressIndicator(color: Color(0xFF003E79)),
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

        final jenisUsulan =
            item["jenis_usulan"]?.toString().toLowerCase().trim() ?? "fisik";

        final isFisik = jenisUsulan == "fisik";
        final isNonFisik = jenisUsulan == "non_fisik";

        //pengecekan detail admin atau user
        final args = Get.arguments ?? {};
        final from = args is Map ? args["from"] ?? "user" : "user";
        final isAdmin = from == "admin";

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
                      item["updated_at"] ??
                          item["tanggal_diterima"] ??
                          item["tanggal"],
                    ),
                  ),
                  _infoItem(
                    title: "Judul Usulan",
                    value: _value(item, "judul_usulan"),
                  ),
                  _infoItem(title: "Skor AHP", value: _getSkorAHP(item)),
                  _infoItem(
                    title: "Permasalahan",
                    value: _value(item, "permasalahan"),
                  ),
                  _infoItem(title: "Dusun", value: _value(item, "dusun")),

                  _infoItem(
                    title: isFisik ? "Lokasi" : "Alamat Lokasi / Sasaran",
                    value: _value(item, "lokasi_detail"),
                  ),

                  if (isFisik)
                    _infoItem(
                      title: "Titik Koordinat",
                      value: _value(item, "koordinat"),
                    ),

                  if (isFisik && _adaVolume(item["volume"]))
                    _infoItem(title: "Volume", value: "${item["volume"]} m³"),

                  if (isFisik &&
                      (_adaVolume(item["panjang"]) ||
                          _adaVolume(item["lebar"]) ||
                          _adaVolume(item["tinggi"])))
                    _infoItem(
                      title: "Ukuran",
                      value:
                          "Panjang: ${_nilaiAtauStrip(item["panjang"])} m, "
                          "Lebar: ${_nilaiAtauStrip(item["lebar"])} m, "
                          "Tinggi: ${_nilaiAtauStrip(item["tinggi"])} m",
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

              const SizedBox(height: 4),

              _statusUsulanBox(item),

              if (isAdmin) ...[
                const SizedBox(height: 12),
                _adminActionBox(item),
              ],

              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  //keterangan status usulan
  Widget _statusUsulanBox(dynamic item) {
    final status = item["status"]?.toString().toLowerCase().trim() ?? "";

    if (status == "ditunda") {
      return _statusInfoBox(
        title: "Usulan Sedang Ditunda",
        subtitle:
            "Usulan ini belum dapat direalisasikan pada tahun berjalan dan akan dipertimbangkan kembali sesuai prioritas serta ketersediaan anggaran desa.\n\n"
            "Tahun Realisasi : ${_value(item, "tahun_realisasi")}",
        icon: Icons.update_rounded,
        color: Colors.orange,
      );
    }

    if (status == "direalisasikan") {
      return _statusInfoBox(
        title: "Usulan Telah Direalisasikan",
        subtitle:
            "Usulan ini telah direalisasikan sebagai bagian dari pelaksanaan hasil Musrenbang Desa.\n\n"
            "Tahun Realisasi : ${_value(item, "tahun_realisasi")}",
        icon: Icons.verified_rounded,
        color: Colors.green,
      );
    }

    return _statusInfoBox(
      title: "Usulan Telah Disetujui",
      subtitle:
          "Usulan ini telah ditetapkan dalam hasil Musrenbang dan menunggu proses realisasi sesuai tahun yang telah direncanakan.",
      icon: Icons.check_circle_rounded,
      color: const Color(0xFF003E79),
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

              const SizedBox(width: 8),

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
                  (_value(item, "jenis_usulan").toLowerCase() == "non_fisik")
                      ? "NON FISIK"
                      : "FISIK",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const Spacer(),

              Text(
                "Skor: ${_getSkorAHP(item)}",
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

  //skor
  String _getSkorAHP(dynamic item) {
    final skorDb = item["skor_ahp"]?.toString().trim() ?? "";

    if (skorDb.isNotEmpty && skorDb != "null") {
      final nilai = double.tryParse(skorDb);

      if (nilai != null) {
        if (nilai <= 5) {
          return (nilai * 20).toStringAsFixed(2);
        }

        return nilai.toStringAsFixed(2);
      }

      return skorDb;
    }

    final hasil = AhpHelper.hitungTotalAhp100(item);

    return hasil.toStringAsFixed(2);
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
              Icon(icon, size: 21, color: const Color(0xFF003E79)),
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
            : Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.16))),
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
    final jenisUsulan =
        item["jenis_usulan"]?.toString().toLowerCase().trim() ?? "fisik";

    final isFisik = jenisUsulan == "fisik";

    final fotoDepan = item["foto_usulan"]?.toString() ?? "";
    final fotoBelakang = item["foto_usulan_belakang"]?.toString() ?? "";

    // Kalau non-fisik dan foto kosong, jangan tampilkan section foto
    if (!isFisik && !_adaFoto(fotoDepan)) {
      return const SizedBox();
    }

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

          if (isFisik) ...[
            if (_adaFoto(fotoDepan))
              _fotoItem(label: "Foto Tampak Depan", fileName: fotoDepan)
            else
              _fotoKosongItem(label: "Foto Tampak Depan"),

            if (_adaFoto(fotoBelakang))
              _fotoItem(label: "Foto Tampak Belakang", fileName: fotoBelakang)
            else
              _fotoKosongItem(label: "Foto Tampak Belakang"),
          ] else ...[
            _fotoItem(label: "Foto Pendukung", fileName: fotoDepan),
          ],
        ],
      ),
    );
  }

  Widget _fotoItem({required String label, required String fileName}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),

        const SizedBox(height: 8),

        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.network(
            controller.getFotoUsulan(fileName),
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
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _fotoKosongItem({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),

        const SizedBox(height: 8),

        Container(
          width: double.infinity,
          height: 180,
          margin: const EdgeInsets.only(bottom: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            "Foto tidak tersedia",
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _fotoKosongCard({required String title}) {
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
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            height: 160,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              "Foto tidak tersedia",
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  //action admin
  Widget _adminActionBox(dynamic item) {
    final status = item["status"]?.toString().toLowerCase().trim() ?? "";

    if (status == "direalisasikan") {
      return _statusInfoBox(
        title: "Usulan Sudah Direalisasikan",
        subtitle:
            "Usulan ini telah direalisasikan dan tidak dapat diproses ulang.",
        icon: Icons.task_alt_rounded,
        color: Colors.green,
      );
    }

    return Container(
      width: double.infinity,
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
                Icons.fact_check_rounded,
                size: 21,
                color: Color(0xFF003E79),
              ),
              const SizedBox(width: 8),
              Text(
                status == "ditunda"
                    ? "Keputusan Lanjutan Admin"
                    : "Keputusan Admin",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            status == "ditunda"
                ? "Usulan ini masih ditunda. Admin dapat menunda kembali atau merealisasikan usulan."
                : "Silakan pilih tindakan untuk memproses usulan masyarakat.",
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _actionButton(
                  title: "Ditunda",
                  icon: Icons.update_rounded,
                  color: Colors.orange,
                  onTap: () => _showTundaSheet(),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _actionButton(
                  title: "Direalisasikan",
                  icon: Icons.verified,
                  color: Colors.green,
                  onTap: () => _showRealisasiSheet(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //
  void _showKonfirmasiKeputusan({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
    required String buttonText,
    required Future<void> Function() onConfirm,
  }) {
    Get.bottomSheet(
      Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, size: 34, color: color),
            ),

            const SizedBox(height: 18),

            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF003E79),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 18),

            _konfirmasiItemAdmin(
              icon: Icons.fact_check_rounded,
              text: "Detail usulan dan hasil Musrenbang sudah diperiksa.",
            ),
            _konfirmasiItemAdmin(
              icon: Icons.calendar_month_rounded,
              text: "Tahun realisasi sudah sesuai dengan rencana pembangunan.",
            ),
            _konfirmasiItemAdmin(
              icon: Icons.warning_amber_rounded,
              text: "Keputusan ini akan mengubah status usulan masyarakat.",
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Cek Lagi",
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
                      onPressed: () async {
                        Get.back();
                        await onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        buttonText,
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
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  Widget _konfirmasiItemAdmin({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF003E79)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //ditunda
  void _showTundaSheet() {
    final tahunC = TextEditingController();
    final catatanC = TextEditingController();

    Get.bottomSheet(
      _bottomSheet(
        title: "Tunda Usulan",
        children: [
          _inputField("Tahun Realisasi", tahunC, TextInputType.number),
          const SizedBox(height: 14),
          TextField(
            controller: catatanC,
            maxLines: 4,
            decoration: _inputDecoration("Catatan Penundaan"),
          ),
          const SizedBox(height: 20),
          _submitButton(
            title: "Simpan",
            color: const Color(0xFF003E79),
            onTap: () async {
              if (tahunC.text.trim().isEmpty || catatanC.text.trim().isEmpty) {
                Get.snackbar(
                  "Lengkapi Data",
                  "Tahun realisasi dan catatan penundaan wajib diisi",
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
                return;
              }
              _showKonfirmasiKeputusan(
                title: "Tunda Usulan?",
                message:
                    "Pastikan tahun realisasi dan catatan penundaan sudah benar. Usulan yang ditunda akan tetap tercatat dan dapat dipertimbangkan kembali sesuai prioritas dan anggaran desa.",
                icon: Icons.update_rounded,
                color: Colors.orange,
                buttonText: "Ya, Tunda",
                onConfirm: () async {
                  final bool berhasil = await controller.tunda(
                    tahun: tahunC.text.trim(),
                    catatan: catatanC.text.trim(),
                  );

                  if (berhasil) {
                    Get.back(closeOverlays: true);
                    await controller.getDetail();
                  }
                },
              );
            },
          ),
        ],
      ),
      isScrollControlled: true,
    );
  }

  //direalisasikan
  void _showRealisasiSheet() {
    final tahunC = TextEditingController();

    Get.bottomSheet(
      _bottomSheet(
        title: "Realisasikan Usulan",
        children: [
          _inputField("Tahun Realisasi", tahunC, TextInputType.number),
          const SizedBox(height: 20),
          _submitButton(
            title: "Simpan",
            color: const Color(0xFF003E79),
            onTap: () async {
              if (tahunC.text.trim().isEmpty) {
                Get.snackbar(
                  "Lengkapi Data",
                  "Tahun realisasi wajib diisi",
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
                return;
              }

              _showKonfirmasiKeputusan(
                title: "Realisasikan Usulan?",
                message:
                    "Pastikan usulan benar-benar sudah direalisasikan di lapangan. Status akan berubah menjadi direalisasikan dan tidak dapat diproses ulang.",
                icon: Icons.verified_rounded,
                color: Colors.green,
                buttonText: "Ya, Realisasikan",
                onConfirm: () async {
                  final berhasil = await controller.realisasi(
                    tahun: tahunC.text.trim(),
                  );

                  if (berhasil) {
                    Get.back(closeOverlays: true);
                    await controller.getDetail();
                  }
                },
              );
            },
          ),
        ],
      ),
      isScrollControlled: true,
    );
  }

  //
  Widget _bottomSheet({required String title, required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.only(
        left: 22,
        right: 22,
        top: 18,
        bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 55,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF003E79).withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF003E79),
            ),
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _inputField(
    String label,
    TextEditingController controller,
    TextInputType type,
  ) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: _inputDecoration(label),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(
        fontSize: 13,
        color: const Color(0xFF003E79),
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: const Color(0xffF5F7FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: const Color(0xFF003E79).withOpacity(0.15),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFF003E79), width: 1.8),
      ),
    );
  }

  Widget _submitButton({
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
    );
  }

  //
  Widget _statusInfoBox({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: const Color(0xFF4B5563),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

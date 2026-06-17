import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/detail_controller.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:musrenbang/services/api_service.dart';

class DetailView extends GetView<DetailController> {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'Detail Usulan',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF003E79),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2_copy, color: Colors.white),
          onPressed: () {
            Get.back();
          },
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
                  strokeWidth: 3,
                ),
                const SizedBox(height: 14),
                Text(
                  'Memuat detail usulan...',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003E79),
                  ),
                ),
              ],
            ),
          );
        }

        final data = controller.detailUsulan;

        if (data.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_rounded,
                  size: 70,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 14),
                Text(
                  'Data detail tidak ditemukan',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        final jenisUsulan =
            data['jenis_usulan']?.toString().toLowerCase().trim() ?? 'fisik';
        final isFisik = jenisUsulan == 'fisik';
        final isNonFisik = jenisUsulan == 'non_fisik';

        final labelJenisUsulan = isNonFisik ? 'Non Fisik' : 'Fisik';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF003E79),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['judul_usulan']?.toString() ?? '-',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _jenisUsulanBadge(labelJenisUsulan, isNonFisik),
                        const SizedBox(width: 8),
                        _statusBadge(data['status']?.toString() ?? '-'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _detailItem(
                icon: Icons.calendar_month_rounded,
                title: 'Dibuat Pada',
               value: data['tanggal'] != null
    ? _formatTanggalIndonesia(data['tanggal'].toString())
    : '-',
              ),

              const SizedBox(height: 20),

              /// FOTO USULAN
              /// Fisik: tampil foto depan dan belakang.
              /// Non fisik: tampil hanya kalau ada foto.
              if (_adaFoto(data['foto_usulan']) ||
                  _adaFoto(data['foto_usulan_belakang']) ||
                  isFisik) ...[
                _sectionTitle('Foto Usulan'),

                if (_adaFoto(data['foto_usulan']))
                  _buildFotoUsulan(
                    data['foto_usulan']?.toString(),
                    label: isFisik ? 'Foto Tampak Depan' : 'Foto Pendukung',
                  )
                else if (isFisik)
                  _buildFotoKosong(label: 'Foto Tampak Depan'),

                if (isFisik && _adaFoto(data['foto_usulan_belakang']))
                  _buildFotoUsulan(
                    data['foto_usulan_belakang']?.toString(),
                    label: 'Foto Tampak Belakang',
                  )
                else if (isFisik)
                  _buildFotoKosong(label: 'Foto Tampak Belakang'),

                const SizedBox(height: 12),
              ],

              _sectionTitle('Informasi Usulan'),

              _detailItem(
                icon: Icons.category_rounded,
                title: 'Jenis Usulan',
                value: labelJenisUsulan,
              ),

              _detailItem(
                icon: Icons.home_rounded,
                title: 'Dusun',
                value: data['dusun']?.toString() ?? '-',
              ),

              _detailItem(
                icon: Icons.location_on_rounded,
                title: isFisik ? 'Lokasi Detail' : 'Alamat Lokasi / Sasaran',
                value: data['lokasi_detail']?.toString() ?? '-',
              ),

              if (isFisik)
                _detailItem(
                  icon: Icons.map_rounded,
                  title: 'Titik Koordinat',
                  value: data['koordinat']?.toString() ?? '-',
                ),

              const SizedBox(height: 12),

              _sectionTitle('Isi Pengajuan'),

              _detailItem(
                icon: Icons.report_problem_rounded,
                title: 'Permasalahan',
                value: data['permasalahan']?.toString() ?? '-',
              ),

              if (isFisik) ...[
                _detailItem(
                  icon: Icons.priority_high_rounded,
                  title: 'Urgensi',
                  value: data['urgensi']?.toString() ?? '-',
                ),

                _detailItem(
                  icon: Icons.groups_rounded,
                  title: 'Masyarakat Terdampak',
                  value: data['masyarakat_terdampak']?.toString() ?? '-',
                ),

                _detailItem(
                  icon: Icons.construction_rounded,
                  title: 'Tingkat Kerusakan',
                  value: data['tingkat_kerusakan']?.toString() ?? '-',
                ),

                /// VOLUME
                if (_adaVolume(data['volume']))
                  _detailItem(
                    icon: Icons.calculate_rounded,
                    title: 'Volume',
                    value: '${data['volume']} m³',
                  ),

                /// Kalau kamu juga ingin tampilkan panjang, lebar, tinggi,
                /// bagian ini boleh dipakai.
                if (_adaVolume(data['panjang']) ||
                    _adaVolume(data['lebar']) ||
                    _adaVolume(data['tinggi']))
                  _detailItem(
                    icon: Icons.straighten_rounded,
                    title: 'Ukuran',
                    value:
                        'Panjang: ${_nilaiAtauStrip(data['panjang'])} m, '
                        'Lebar: ${_nilaiAtauStrip(data['lebar'])} m, '
                        'Tinggi: ${_nilaiAtauStrip(data['tinggi'])} m',
                  ),

                _detailItem(
                  icon: Icons.payments_rounded,
                  title: 'Perkiraan Biaya',
                  value: _formatBiaya(data['biaya']),
                ),
              ],

              if (isNonFisik) ...[
                _detailItem(
                  icon: Icons.assignment_turned_in_rounded,
                  title: 'Tingkat Kebutuhan',
                  value: data['tingkat_kebutuhan']?.toString() ?? '-',
                ),

                _detailItem(
                  icon: Icons.groups_rounded,
                  title: 'Jumlah Penerima Manfaat',
                  value: data['jumlah_penerima_manfaat']?.toString() ?? '-',
                ),

                _detailItem(
                  icon: Icons.category_rounded,
                  title: 'Bidang Usulan',
                  value: data['bidang_usulan']?.toString() ?? '-',
                ),

                _detailItem(
                  icon: Icons.payments_rounded,
                  title: 'Perkiraan Biaya',
                  value: _formatBiaya(data['biaya']),
                ),
              ],

              const SizedBox(height: 12),

              _keputusanAdminBox(data),
            ],
          ),
        );
      }),
    );
  }

  /// FORMAT TANGGAL
  /// Dari: 2026-06-10 15:19:57
  /// Jadi: 10 Juni 2026
  String _formatTanggalIndonesia(String tanggal) {
    final parts = tanggal.split(' ')[0].split('-');

    if (parts.length != 3) return tanggal;

    final year = parts[0];
    final monthNum = int.tryParse(parts[1]) ?? 0;
    final day = parts[2];

    final bulan = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    if (monthNum < 1 || monthNum > 12) {
      return tanggal.split(' ')[0];
    }

    return '$day ${bulan[monthNum]} $year';
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

  Widget _buildFotoUsulan(
    String? foto, {
    String label = 'Foto Usulan',
  }) {
    if (!_adaFoto(foto)) {
      return _buildFotoKosong(label: label);
    }

    final imageUrl = ApiService.getFotoUsulan(foto!);

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
          height: 220,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8E8E8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;

                return Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: Color(0xFF003E79),
                          strokeWidth: 3,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Memuat foto...',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF003E79),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image_rounded,
                          size: 55,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Gagal memuat foto',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFotoKosong({
    String label = 'Foto Usulan',
  }) {
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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8E8E8)),
          ),
          child: Center(
            child: Text(
              'Foto tidak tersedia',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF003E79),
        ),
      ),
    );
  }

  Widget _detailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF003E79)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2D2D2D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _keputusanAdminBox(dynamic data) {
    final status = data['status']?.toString().toLowerCase().trim() ?? '';

    if (status == 'disetujui') {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 6, bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.withOpacity(0.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  'Keputusan Admin',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _keputusanItem(title: 'Status', value: 'Usulan disetujui'),
            _keputusanItem(
              title: 'Biaya Final',
              value:
                  data['biaya_final'] != null &&
                      data['biaya_final'].toString().isNotEmpty
                  ? 'Rp ${data['biaya_final']}'
                  : '-',
            ),
            _keputusanItem(
              title: 'Tahun Realisasi',
              value: data['tahun_realisasi']?.toString() ?? '-',
            ),
          ],
        ),
      );
    }

    if (status == 'ditunda') {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 6, bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange.withOpacity(0.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.update_rounded,
                  color: Colors.orange,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  'Status Penundaan',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Usulan ini belum dapat direalisasikan pada tahun berjalan dan akan dipertimbangkan kembali sesuai prioritas pembangunan desa serta ketersediaan anggaran.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.orange.shade800,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            _keputusanItem(
              title: 'Tahun Realisasi',
              value: data['tahun_realisasi']?.toString() ?? '-',
            ),
            _keputusanItem(
              title: 'Catatan Penundaan',
              value: data['catatan_penundaan']?.toString() ?? '-',
            ),
          ],
        ),
      );
    }

    if (status == 'direalisasikan') {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 6, bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.withOpacity(0.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.verified_rounded,
                  color: Color(0xFF003E79),
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  'Usulan Telah Direalisasikan',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF003E79),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Selamat, usulan yang diajukan telah direalisasikan dan menjadi bagian dari pelaksanaan program pembangunan desa. Terima kasih atas partisipasi Anda dalam Musrenbang Desa.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: const Color(0xFF003E79),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            _keputusanItem(
              title: 'Tahun Realisasi',
              value: data['tahun_realisasi']?.toString() ?? '-',
            ),
          ],
        ),
      );
    }

    if (status == 'ditolak') {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 6, bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withOpacity(0.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.cancel_rounded, color: Colors.red, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Keputusan Admin',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _keputusanItem(title: 'Status', value: 'Usulan ditolak'),
            _keputusanItem(
              title: 'Catatan Penolakan',
              value: data['catatan_penolakan']?.toString() ?? '-',
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 6, bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.hourglass_bottom_rounded,
            color: Colors.orange,
            size: 22,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Usulan sedang diproses oleh admin. Silakan cek status secara berkala.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.orange.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _keputusanItem({required String title, required String value}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.isNotEmpty ? value : '-',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF2D2D2D),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _jenisUsulanBadge(String label, bool isNonFisik) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _formatBiaya(dynamic biaya) {
    final value = biaya?.toString().trim() ?? '';

    if (value.isEmpty || value == 'null') {
      return 'Tidak diisi';
    }

    return 'Rp $value';
  }

  Widget _statusBadge(String status) {
    Color color;

    switch (status.toLowerCase().trim()) {
      case 'diproses':
        color = Colors.orange;
        break;
      case 'disetujui':
        color = Colors.green;
        break;
      case 'ditolak':
        color = Colors.red;
        break;
      case 'ditunda':
        color = Colors.deepOrange;
        break;
      case 'direalisasikan':
        color = const Color(0xFF003E79);
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status.toLowerCase() == "direalisasikan"
                ? Icons.verified_rounded
                : status.toLowerCase() == "ditunda"
                    ? Icons.update_rounded
                    : status.toLowerCase() == "ditolak"
                        ? Icons.cancel_rounded
                        : status.toLowerCase() == "disetujui"
                            ? Icons.check_circle_rounded
                            : Icons.hourglass_bottom_rounded,
            size: 13,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
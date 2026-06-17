import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../controllers/notif_controller.dart';

class NotifView extends GetView<NotifController> {
  const NotifView({super.key});

  static const Color primaryColor = Color(0xFF003E79);
  static const Color softBlue = Color(0xFFEAF2FF);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> panduanFisik = [
      {
        "icon": Icons.home_repair_service_rounded,
        "title": "Pilih Menu Usulan Fisik",
        "desc":
            "Gunakan menu ini untuk mengajukan pembangunan atau perbaikan berbentuk fisik, seperti jalan, drainase, jembatan kecil, fasilitas umum, lampu jalan, atau sarana desa lainnya.",
      },
      {
        "icon": Icons.edit_note_rounded,
        "title": "Isi Judul dan Permasalahan",
        "desc":
            "Tuliskan judul usulan secara singkat dan jelas. Pada bagian permasalahan, jelaskan kondisi yang terjadi, dampaknya bagi warga, dan alasan mengapa usulan tersebut perlu diajukan.",
      },
      {
        "icon": Icons.priority_high_rounded,
        "title": "Pilih Kriteria Usulan",
        "desc":
            "Lengkapi tingkat urgensi, masyarakat terdampak, dan tingkat kerusakan. Pilih sesuai kondisi sebenarnya agar admin dapat menilai prioritas usulan dengan lebih tepat.",
      },
      {
        "icon": Icons.payments_rounded,
        "title": "Masukkan Estimasi Biaya",
        "desc":
            "Isi perkiraan biaya pembangunan atau perbaikan. Biaya tidak harus sangat rinci, namun sebaiknya dibuat masuk akal sesuai kebutuhan di lapangan.",
      },
      {
        "icon": Icons.straighten_rounded,
        "title": "Isi Volume Jika Diperlukan",
        "desc":
            "Jika usulan membutuhkan ukuran, isi panjang, lebar, dan tinggi. Contohnya untuk jalan, saluran air, atau bangunan. Jika tidak membutuhkan volume, bagian ini boleh dikosongkan.",
      },
      {
        "icon": Icons.location_on_rounded,
        "title": "Lengkapi Lokasi dan Koordinat",
        "desc":
            "Masukkan alamat lokasi secara jelas. Jika tersedia, isi titik koordinat agar lokasi usulan lebih mudah ditemukan saat proses verifikasi.",
      },
      {
        "icon": Icons.photo_camera_rounded,
        "title": "Upload Foto Depan dan Belakang",
        "desc":
            "Tambahkan foto tampak depan dan tampak belakang lokasi usulan. Foto harus jelas, terbaru, dan menunjukkan kondisi sebenarnya. Gunakan format JPG/PNG dengan ukuran maksimal 2 MB per foto.",
      },
    ];

    final List<Map<String, dynamic>> panduanNonFisik = [
      {
        "icon": Icons.groups_rounded,
        "title": "Pilih Menu Usulan Non-Fisik",
        "desc":
            "Gunakan menu ini untuk mengajukan kegiatan atau program masyarakat, seperti pelatihan UMKM, bantuan sosial, kegiatan kesehatan, pendidikan, pemberdayaan masyarakat, atau kebutuhan non-bangunan lainnya.",
      },
      {
        "icon": Icons.edit_note_rounded,
        "title": "Isi Judul dan Permasalahan",
        "desc":
            "Tuliskan judul program dengan jelas. Pada bagian permasalahan, jelaskan kebutuhan masyarakat, masalah yang ingin diselesaikan, dan manfaat kegiatan bagi warga.",
      },
      {
        "icon": Icons.assignment_turned_in_rounded,
        "title": "Pilih Tingkat Kebutuhan",
        "desc":
            "Pilih tingkat kebutuhan sesuai kondisi masyarakat. Semakin penting kebutuhan tersebut bagi warga, semakin jelas alasan usulan untuk dipertimbangkan.",
      },
      {
        "icon": Icons.people_alt_rounded,
        "title": "Isi Jumlah Penerima Manfaat",
        "desc":
            "Pilih jumlah warga yang akan menerima manfaat dari usulan. Data ini membantu admin memahami seberapa luas dampak usulan terhadap masyarakat.",
      },
      {
        "icon": Icons.category_rounded,
        "title": "Pilih Bidang Usulan",
        "desc":
            "Pilih bidang yang sesuai, seperti kesehatan, pendidikan, sosial, ekonomi, UMKM, atau pemberdayaan masyarakat. Pastikan bidang sesuai dengan isi usulan.",
      },
      {
        "icon": Icons.payments_rounded,
        "title": "Masukkan Estimasi Biaya",
        "desc":
            "Isi perkiraan biaya kegiatan atau program. Estimasi biaya digunakan sebagai pertimbangan dalam proses penilaian dan perencanaan anggaran.",
      },
      {
        "icon": Icons.photo_camera_rounded,
        "title": "Upload Foto Pendukung Jika Ada",
        "desc":
            "Untuk usulan non-fisik, foto bersifat opsional. Jika ada foto pendukung, unggah agar admin lebih mudah memahami kondisi atau kebutuhan masyarakat.",
      },
    ];

    final List<Map<String, dynamic>> aturanList = [
      {
        "icon": Icons.verified_user_rounded,
        "title": "Gunakan Data yang Benar",
        "desc":
            "Pastikan data yang diisi sesuai kondisi sebenarnya. Jangan mengisi lokasi, biaya, foto, atau keterangan palsu.",
      },
      {
        "icon": Icons.warning_amber_rounded,
        "title": "Dilarang Menggunakan Kata Kasar",
        "desc":
            "Usulan tidak boleh berisi kata-kata kasar, hinaan, ancaman, provokasi, atau kalimat yang merendahkan pihak lain.",
      },
      {
        "icon": Icons.diversity_3_rounded,
        "title": "Tidak Mengandung SARA",
        "desc":
            "Usulan tidak boleh menyinggung suku, agama, ras, antargolongan, pilihan politik, atau hal lain yang dapat menimbulkan konflik sosial.",
      },
      {
        "icon": Icons.fact_check_rounded,
        "title": "Periksa Sebelum Dikirim",
        "desc":
            "Sebelum menekan tombol simpan, periksa kembali judul, permasalahan, lokasi, biaya, kriteria, dan foto agar tidak terjadi kesalahan pengajuan.",
      },
    ];

    final List<Map<String, dynamic>> statusList = [
      {
        "icon": Icons.hourglass_bottom_rounded,
        "title": "Diproses",
        "desc":
            "Usulan yang baru dikirim akan masuk status diproses. Pada tahap ini admin akan memeriksa kelengkapan dan kesesuaian data.",
      },
      {
        "icon": Icons.check_circle_rounded,
        "title": "Disetujui",
        "desc":
            "Jika usulan sesuai dan layak dipertimbangkan, admin dapat menyetujui usulan. Namun, usulan yang disetujui belum tentu langsung direalisasikan.",
      },
      {
        "icon": Icons.cancel_rounded,
        "title": "Ditolak",
        "desc":
            "Usulan dapat ditolak apabila data tidak sesuai, kurang jelas, tidak relevan, mengandung unsur SARA/kata kasar, atau tidak memenuhi kebutuhan prioritas desa.",
      },
      {
        "icon": Icons.update_rounded,
        "title": "Ditunda",
        "desc":
            "Usulan yang disetujui dapat ditunda apabila belum menjadi prioritas tahun berjalan atau menunggu ketersediaan anggaran desa.",
      },
      {
        "icon": Icons.verified_rounded,
        "title": "Direalisasikan",
        "desc":
            "Usulan yang telah masuk tahap pelaksanaan akan berubah menjadi direalisasikan. Artinya usulan tersebut telah menjadi bagian dari program pembangunan desa.",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2_copy, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Panduan Musrenbang",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1565C0).withOpacity(0.15),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                          ),
                        ),
                        child: Image.asset(
                          "assets/images/logo1.png",
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Text(
                        "MusrenYuk",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "Halo, Warga Desa Sukorejo!",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Halaman ini berisi panduan untuk mengajukan usulan Musrenbang, baik usulan fisik maupun non-fisik. Bacalah panduan ini agar usulan yang dikirim jelas, sesuai kebutuhan, dan mudah diproses oleh admin.",
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 13,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            /// APA ITU MUSRENBANG
            _infoBox(
              icon: Icons.info_rounded,
              title: "Apa itu Musrenbang?",
              desc:
                  "Musrenbang adalah forum musyawarah perencanaan pembangunan desa. Melalui aplikasi ini, masyarakat dapat menyampaikan usulan pembangunan atau program desa secara digital, transparan, dan lebih mudah dipantau.",
            ),

            const SizedBox(height: 26),

            _sectionTitle("Panduan Usulan Fisik"),
            const SizedBox(height: 14),
            _guideList(panduanFisik),

            const SizedBox(height: 16),

            _sectionTitle("Panduan Usulan Non-Fisik"),
            const SizedBox(height: 14),
            _guideList(panduanNonFisik),

            const SizedBox(height: 16),

            _sectionTitle("Ketentuan Pengisian Usulan"),
            const SizedBox(height: 14),
            _guideList(aturanList),

            const SizedBox(height: 16),

            _sectionTitle("Alur Status Usulan"),
            const SizedBox(height: 14),
            _guideList(statusList),

            const SizedBox(height: 16),

            _infoBox(
              icon: Icons.lightbulb_rounded,
              title: "Catatan Penting",
              desc:
                  "Usulan yang dikirim akan diperiksa oleh admin terlebih dahulu. Jika disetujui, usulan belum tentu langsung direalisasikan karena masih menyesuaikan prioritas pembangunan, hasil musyawarah, dan ketersediaan anggaran desa.",
            ),

            const SizedBox(height: 24),

            Center(
              child: Text(
                "Musrenbang Desa Sukorejo © 2026",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
    );
  }

  Widget _guideList(List<Map<String, dynamic>> items) {
    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE6EEF8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// NOMOR + ICON
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: softBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(item['icon'], color: primaryColor, size: 24),
                  ),
                  Positioned(
                    top: -7,
                    right: -7,
                    child: Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Text(
                        "${index + 1}",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['desc'],
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        height: 1.6,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _infoBox({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE6EEF8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: softBlue,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: primaryColor, size: 24),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  desc,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    height: 1.6,
                    color: Colors.grey.shade700,
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

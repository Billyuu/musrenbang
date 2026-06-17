import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/usulan_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musrenbang/app/routes/app_pages.dart';

class UsulanView extends GetView<UsulanController> {
  const UsulanView({super.key});

  //
  void _showKonfirmasiSimpan(BuildContext context) {
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
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.fact_check_rounded,
                size: 34,
                color: Color(0xFF003E79),
              ),
            ),

            const SizedBox(height: 18),

            Text(
              "Periksa Usulan Anda",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF003E79),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Pastikan data usulan fisik sudah sesuai sebelum dikirim. Data yang sudah dikirim akan diperiksa dan diproses oleh admin.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 18),

            _konfirmasiItem(
              icon: Icons.check_circle_outline_rounded,
              text: "Judul dan permasalahan pembangunan sudah jelas.",
            ),
            _konfirmasiItem(
              icon: Icons.check_circle_outline_rounded,
              text:
                  "Dusun, urgensi, masyarakat terdampak, dan tingkat kerusakan sudah sesuai.",
            ),
            _konfirmasiItem(
              icon: Icons.check_circle_outline_rounded,
              text: "Estimasi biaya, lokasi, dan koordinat sudah benar.",
            ),
            _konfirmasiItem(
              icon: Icons.check_circle_outline_rounded,
              text:
                  "Foto tampak depan dan belakang sudah jelas serta sesuai kondisi lapangan.",
            ),
            _konfirmasiItem(
              icon: Icons.warning_amber_rounded,
              text:
                  "Usulan tidak mengandung kata kasar, hinaan, SARA, atau data palsu.",
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
                      onPressed: () {
                        Get.back();
                        controller.simpanUsulan();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003E79),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Ya, Simpan",
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

  Widget _konfirmasiItem({required IconData icon, required String text}) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'Pengajuan Usulan Fisik',
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

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.NOTIF);
                  },
                  icon: const Icon(
                    Icons.help_outline,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Dusun
            const SizedBox(height: 10),
            DropdownButtonFormField2<String>(
              isExpanded: true,

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 13,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFCCCCCC),
                    width: 1,
                  ),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFCCCCCC),
                    width: 1,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFF003E79),
                    width: 1.5,
                  ),
                ),
              ),

              /// 🔽 HINT TANPA ICON + POPPINS
              hint: Text(
                "Dusun",
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
              ),

              iconStyleData: const IconStyleData(
                icon: Icon(Icons.keyboard_arrow_down),
                iconSize: 24,
              ),

              dropdownStyleData: DropdownStyleData(
                elevation: 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),

              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
              ),
              items: ["Dusun Suko", "Dusun Duyo", "Dusun Rujak Sente"]
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 10, // 🔥 kecil biar elegan
                            color: Color(0xFF003E79),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            item,
                            style: GoogleFonts.poppins(
                              color: Colors.black87,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),

              onChanged: (val) {
                controller.selectedDusun.value = val!;
              },
            ),
            const SizedBox(height: 15),

            /// Judul Usulan
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: controller.judulController,
                  cursorColor: Colors.black54,

                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black87,
                  ),

                  decoration: InputDecoration(
                    hintText: "Masukkan judul usulan",
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.black54,
                      fontSize: 13,
                    ),

                    filled: true,
                    fillColor: Colors.white,

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 13,
                    ),

                    /// 🔥 BORDER NORMAL
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Color(0xFFCCCCCC),
                        width: 1,
                      ),
                    ),

                    /// 🔥 ENABLED
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Color(0xFFCCCCCC),
                        width: 1,
                      ),
                    ),

                    /// 🔥 FOCUS
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Color(0xFF003E79),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            /// Permasalahan
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: controller.permasalahanController,
                  cursorColor: Colors.black54,
                  maxLines: 4,

                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black87,
                  ),

                  decoration: InputDecoration(
                    hintText: "Masukkan permasalahan",
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.black54,
                      fontSize: 13,
                    ),

                    filled: true,
                    fillColor: Colors.white,

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 13,
                    ),

                    /// 🔥 BORDER
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Color(0xFFCCCCCC),
                        width: 1,
                      ),
                    ),

                    /// 🔥 ENABLED
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Color(0xFFCCCCCC),
                        width: 1,
                      ),
                    ),

                    /// 🔥 FOCUS
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Color(0xFF003E79),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            ///Urgensi
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField2<String>(
                  isExpanded: true,
                  value: controller.selectedUrgensi.value.isEmpty
                      ? null
                      : controller.selectedUrgensi.value,

                  hint: Text(
                    "Pilih tingkat urgensi",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),

                  items:
                      [
                        "Sangat Mendesak",
                        "Mendesak",
                        "Cukup Mendesak",
                        "Kurang Mendesak",
                        "Tidak Mendesak",
                      ].map((e) {
                        return DropdownMenuItem<String>(
                          value: e,
                          child: Row(
                            children: [
                              /// 🔵 ICON BULLET
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF003E79,
                                  ), // warna utama kamu
                                  shape: BoxShape.circle,
                                ),
                              ),

                              const SizedBox(width: 10),

                              /// 📝 TEXT
                              Text(
                                e,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                  onChanged: (value) {
                    controller.selectedUrgensi.value = value!;
                  },

                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.keyboard_arrow_down),
                  ),

                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 13,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Color(0xFF003E79),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            ///Masyarakat Terdampak
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 DROPDOWN
                DropdownButtonFormField2<String>(
                  isExpanded: true,
                  value: controller.selectedTerdampak.value.isEmpty
                      ? null
                      : controller.selectedTerdampak.value,

                  hint: Text(
                    "Pilih masyarakat terdampak",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),

                  items: ["Desa", "Dusun", "RW", "RT", "Kelompok"].map((e) {
                    return DropdownMenuItem<String>(
                      value: e,
                      child: Row(
                        children: [
                          /// 🔵 ICON BULLET
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF003E79,
                              ), // warna utama kamu
                              shape: BoxShape.circle,
                            ),
                          ),

                          const SizedBox(width: 10),

                          /// 📝 TEXT
                          Text(
                            e,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  onChanged: (value) {
                    controller.selectedTerdampak.value = value!;
                  },

                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.keyboard_arrow_down),
                  ),

                  dropdownStyleData: DropdownStyleData(
                    elevation: 4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  /// 🔥 STYLE UTAMA (SAMAKAN SEMUA FIELD)
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 13,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Color(0xFF003E79),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            ///Tingkat Kerusakan
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField2<String>(
                  isExpanded: true,
                  value: controller.selectedKerusakan.value.isEmpty
                      ? null
                      : controller.selectedKerusakan.value,

                  hint: Text(
                    "Pilih tingkat kerusakan",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),

                  items:
                      [
                        "Tidak Punya",
                        "Rusak Berat",
                        "Rusak Sedang",
                        "Rusak Ringan",
                        "Layak",
                      ].map((e) {
                        return DropdownMenuItem<String>(
                          value: e,
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF003E79,
                                  ), // warna utama kamu
                                  shape: BoxShape.circle,
                                ),
                              ),

                              const SizedBox(width: 10),

                              /// 📝 TEXT
                              Text(
                                e,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                  onChanged: (value) {
                    controller.selectedKerusakan.value = value!;
                  },

                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.keyboard_arrow_down),
                  ),

                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  /// 🔥 STYLE CONSISTENT
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 13,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Color(0xFF003E79),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            /// BIAYA
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: controller.biayaController,
                  keyboardType: TextInputType.number,
                  cursorColor: const Color(0xFF003E79),

                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black87,
                  ),

                  decoration: InputDecoration(
                    hintText: "Masukkan estimasi biaya",
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                    ),

                    filled: true,
                    fillColor: Colors.white,

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 13,
                    ),

                    /// 💰 PREFIX RP
                    prefixText: "Rp ",
                    prefixStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),

                    /// 🔥 BORDER
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Color(0xFF003E79),
                        width: 1.5,
                      ),
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon masukkan estimasi biaya';
                    }
                    return null;
                  },
                ),
              ],
            ),
            const SizedBox(height: 15),

            /// VOLUME OPSIONAL
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Volume (Opsional)",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF003E79),
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.panjangController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        cursorColor: const Color(0xFF003E79),
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: "Panjang",
                          suffixText: "m",
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 13,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Color(0xFFCCCCCC),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Color(0xFFCCCCCC),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Color(0xFF003E79),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: TextFormField(
                        controller: controller.lebarController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        cursorColor: const Color(0xFF003E79),
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: "Lebar",
                          suffixText: "m",
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 13,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Color(0xFFCCCCCC),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Color(0xFFCCCCCC),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Color(0xFF003E79),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: TextFormField(
                        controller: controller.tinggiController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        cursorColor: const Color(0xFF003E79),
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: "Tinggi",
                          suffixText: "m",
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 13,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Color(0xFFCCCCCC),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Color(0xFFCCCCCC),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Color(0xFF003E79),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  "Kosongkan jika usulan tidak membutuhkan perhitungan volume.",
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 15),

            /// Alamat lokasi
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: controller.lokasiController,
                  keyboardType: TextInputType.text,
                  cursorColor: const Color(0xFF003E79),

                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black87,
                  ),

                  decoration: InputDecoration(
                    hintText: "Alamat Lengkap Lokasi",
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                    ),

                    filled: true,
                    fillColor: Colors.white,

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 20,
                    ),

                    /// 🔥 BORDER
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Color(0xFF003E79),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            /// TITIK KOORDINAT
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: controller.koordinatController,
                  keyboardType: TextInputType.text,
                  cursorColor: const Color(0xFF003E79),

                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black87,
                  ),

                  decoration: InputDecoration(
                    hintText: "Contoh: -7.123, 110.123",
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                    ),

                    filled: true,
                    fillColor: Colors.white,

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 13,
                    ),

                    /// 🔥 BORDER
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Color(0xFF003E79),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            /// UPLOAD FOTO
            /// UPLOAD FOTO DEPAN & BELAKANG
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Foto Usulan",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF003E79),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Upload foto tampak depan dan belakang. Format JPG/PNG, maksimal 2 MB per foto.",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // FOTO DEPAN
                  GestureDetector(
                    onTap: () => controller.pickImageDepan(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFCCCCCC)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            controller.selectedImageDepan.value == null
                                ? Icons.camera_alt
                                : Icons.check_circle,
                            size: 20,
                            color: controller.selectedImageDepan.value == null
                                ? Colors.black54
                                : Colors.green,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            controller.selectedImageDepan.value == null
                                ? "Upload Foto Tampak Depan"
                                : "Foto depan berhasil dipilih",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (controller.selectedImageDepan.value != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            controller.selectedImageDepan.value!,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "File depan: ${controller.selectedImageDepan.value!.path.split('/').last}",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 15),

                  // FOTO BELAKANG
                  GestureDetector(
                    onTap: () => controller.pickImageBelakang(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFCCCCCC)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            controller.selectedImageBelakang.value == null
                                ? Icons.camera_alt
                                : Icons.check_circle,
                            size: 20,
                            color:
                                controller.selectedImageBelakang.value == null
                                ? Colors.black54
                                : Colors.green,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            controller.selectedImageBelakang.value == null
                                ? "Upload Foto Tampak Belakang"
                                : "Foto belakang berhasil dipilih",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (controller.selectedImageBelakang.value != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            controller.selectedImageBelakang.value!,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "File belakang: ${controller.selectedImageBelakang.value!.path.split('/').last}",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// TOMBOL SIMPAN
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003E79),
                    disabledBackgroundColor: const Color(0xFF003E79),
                    disabledForegroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          FocusScope.of(context).unfocus();

                          if (controller.validateForm()) {
                            _showKonfirmasiSimpan(context);
                          }
                        },
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "Simpan Usulan",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

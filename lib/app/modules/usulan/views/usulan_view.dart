import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/usulan_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class UsulanView extends GetView<UsulanController> {
  const UsulanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'Pengajuan Usulan',
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
                  vertical: 18,
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
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
              color:  Color(0xFF003E79), 
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
                      vertical: 18,
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
                      vertical: 14,
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
                      vertical: 18,
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
                      vertical: 18,
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
                      vertical: 18,
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
                      vertical: 18,
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
                      vertical: 18,
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
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => controller.pickImage(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFCCCCCC)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            controller.selectedImage.value == null
                                ? Icons.camera_alt
                                : Icons.check_circle,
                            size: 20,
                            color: controller.selectedImage.value == null
                                ? Colors.black54
                                : Colors.green,
                          ),

                          const SizedBox(width: 10),

                          Text(
                            controller.selectedImage.value == null
                                ? "Upload Foto Lokasi"
                                : "Foto berhasil dipilih",
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

                  /// 🔥 PREVIEW
                  if (controller.selectedImage.value != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            controller.selectedImage.value!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "File: ${controller.selectedImage.value!.path.split('/').last}",
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

            const SizedBox(height: 24),

            /// TOMBOL SIMPAN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003E79),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                // 🔥 Panggil fungsi simpanUsulan dari controller
                onPressed: () {
                  controller.simpanUsulan();
                },
                child: Text(
                  "Simpan Usulan",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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

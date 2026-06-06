import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musrenbang/app/routes/app_pages.dart';

import '../controllers/usulan_non_fisik_controller.dart';

class UsulanNonFisikView extends GetView<UsulanNonFisikController> {
  const UsulanNonFisikView({super.key});

  static const Color primaryColor = Color(0xFF003E79);
  static const Color borderColor = Color(0xFFCCCCCC);

  InputDecoration _inputDecoration({
    required String hintText,
    String? prefixText,
    double vertical = 13,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
      prefixText: prefixText,
      prefixStyle: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: vertical),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: borderColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
    );
  }

  Widget _textField({
    required TextEditingController textController,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? prefixText,
  }) {
    return TextFormField(
      controller: textController,
      maxLines: maxLines,
      keyboardType: keyboardType,
      cursorColor: primaryColor,
      style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
      decoration: _inputDecoration(
        hintText: hintText,
        prefixText: prefixText,
        vertical: maxLines > 1 ? 13 : 13,
      ),
    );
  }

  Widget _dropdownField({
    required String hintText,
    required List<Map<String, String>> items,
    required RxString selectedValue,
  }) {
    return Obx(
      () => DropdownButtonFormField2<String>(
        isExpanded: true,
        value: selectedValue.value.isEmpty ? null : selectedValue.value,
        hint: Text(
          hintText,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item['value'],
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item['label'] ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          selectedValue.value = value ?? '';
        },
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
        decoration: _inputDecoration(hintText: hintText),
      ),
    );
  }

  Widget _dusunDropdown() {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: _inputDecoration(hintText: "Dusun"),
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
      items: ["Dusun Suko", "Dusun Duyo", "Dusun Rujak Sente"].map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Row(
            children: [
              const Icon(Icons.circle, size: 10, color: primaryColor),
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
        );
      }).toList(),
      onChanged: (value) {
        controller.dusunC.text = value ?? '';
      },
    );
  }

  Widget _infoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3FC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD6E8F8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Iconsax.info_circle_copy, color: primaryColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Usulan non fisik digunakan untuk pengajuan seperti pelatihan, bantuan sosial, pendidikan, kesehatan, UMKM, atau program pemberdayaan masyarakat.",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black87,
                height: 1.5,
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
          'Usulan Non Fisik',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2_copy, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () {
                Get.toNamed(Routes.NOTIF);
              },
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 25,
              ),
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
            const SizedBox(height: 10),

            _infoBox(),

            const SizedBox(height: 18),

            /// Dusun
            _dusunDropdown(),

            const SizedBox(height: 15),

            /// Judul Usulan
            _textField(
              textController: controller.judulC,
              hintText: "Masukkan judul usulan",
            ),

            const SizedBox(height: 15),

            /// Permasalahan
            _textField(
              textController: controller.permasalahanC,
              hintText: "Masukkan permasalahan",
              maxLines: 4,
            ),

            const SizedBox(height: 15),

            /// Tingkat Kebutuhan
            _dropdownField(
              hintText: "Pilih tingkat kebutuhan",
              items: controller.opsiTingkatKebutuhan,
              selectedValue: controller.tingkatKebutuhan,
            ),

            const SizedBox(height: 15),

            /// Jumlah Penerima Manfaat
            _dropdownField(
              hintText: "Pilih jumlah penerima manfaat",
              items: controller.opsiPenerimaManfaat,
              selectedValue: controller.jumlahPenerimaManfaat,
            ),

            const SizedBox(height: 15),

            /// Dampak Sosial
            _dropdownField(
              hintText: "Pilih dampak sosial",
              items: controller.opsiDampakSosial,
              selectedValue: controller.dampakSosial,
            ),

            const SizedBox(height: 15),

            /// Kelayakan Pelaksanaan
            _dropdownField(
              hintText: "Pilih kelayakan pelaksanaan",
              items: controller.opsiKelayakan,
              selectedValue: controller.kelayakanPelaksanaan,
            ),

            const SizedBox(height: 15),

            /// Biaya
            _textField(
              textController: controller.biayaC,
              hintText: "Masukkan estimasi biaya (opsional)",
              keyboardType: TextInputType.number,
              prefixText: "Rp ",
            ),
            const SizedBox(height: 15),

            /// Alamat Lokasi / Sasaran
            _textField(
              textController: controller.lokasiC,
              hintText: "Alamat lengkap lokasi atau sasaran usulan",
              maxLines: 2,
            ),
            const SizedBox(height: 15),

            /// Upload Foto Pendukung
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => controller.pickImage(),
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
                                ? "Upload Foto Pendukung (Opsional)"
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

            const SizedBox(height: 25),

            /// Tombol Simpan
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    disabledBackgroundColor: primaryColor,
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
                          controller.simpanUsulanNonFisik();
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

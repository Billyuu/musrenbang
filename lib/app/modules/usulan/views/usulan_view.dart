import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/usulan_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class UsulanView extends GetView<UsulanController> {
  const UsulanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengajuan Usulan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff1565C0),
        centerTitle: true,
      leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2_copy, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Dusun
            const SizedBox(height: 10),

            DropdownButtonFormField2<String>(
              isExpanded: true,

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade300,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 18,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              hint: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.home, size: 20, color: Colors.black54),
                  SizedBox(width: 15),
                  Text(
                    "Dusun",
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                ],
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
                            Icons.home,
                            size: 20,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 15),
                          Text(
                            item,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),

              onChanged: (value) {},
            ),
            const SizedBox(height: 15),

            /// Judul Usulan
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  cursorColor: Colors.black54,

                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: "Masukkan judul usulan",
                    hintStyle: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),

                    filled: true,
                    fillColor: Colors.grey.shade300,

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 18,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),

                    prefixIcon: const Icon(
                      Icons.edit_note,
                      color: Colors.black54,
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
                  cursorColor: Colors.black54,
                  maxLines: 4,

                  style: const TextStyle(fontSize: 14, color: Colors.black87),

                  decoration: InputDecoration(
                    hintText: "Masukkan permasalahan",
                    hintStyle: TextStyle(color: Colors.black54, fontSize: 16),

                    filled: true,
                    fillColor: Colors.grey.shade300,

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 12,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            ///Urgensi
            Row(
              children: [
                SizedBox(width: 8),
                const Text(
                  "Urgensi",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8, width: 10),
            DropdownButtonFormField2(
              isExpanded: true,
              value: null,

              hint: Row(
                children: const [
                  Icon(Icons.flag, size: 20, color: Colors.black54),
                  SizedBox(width: 10),
                  Text(
                    "Pilih tingkat urgensi",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),

              items:
                  [
                        "Sangat Mendesak",
                        "Mendesak",
                        "Cukup Mendesak",
                        "Kurang Mendesak",
                        "Tidak Mendesak",
                      ]
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.circle,
                                size: 10,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                e,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),

              onChanged: (value) {},
              iconStyleData: const IconStyleData(
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                iconSize: 24,
              ),

              dropdownStyleData: DropdownStyleData(
                elevation: 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade300,

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 18,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),

            ///Masyarakat Terdampak
            Row(
              children: [
                SizedBox(width: 8),
                const Text(
                  "Masyarakat Terdampak",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8, width: 10),
            DropdownButtonFormField2(
              isExpanded: true,
              value: null,

              hint: Row(
                children: const [
                  Icon(Icons.groups, size: 20, color: Colors.black54),
                  SizedBox(width: 10),
                  Text(
                    "Pilih Masyarakat Terdampak",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),

              items: ["Desa", "Dusun", "RW", "RT", "Kelompok"]
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 10,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            e,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),

              onChanged: (value) {},
              iconStyleData: const IconStyleData(
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                iconSize: 24,
              ),

              dropdownStyleData: DropdownStyleData(
                elevation: 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade300,

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 18,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),

            ///Tingkat Kerusakan
            Row(
              children: [
                SizedBox(width: 8),
                const Text(
                  "Tingkat Kerusakan",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8, width: 10),
            DropdownButtonFormField2(
              isExpanded: true,
              value: null,

              hint: Row(
                children: const [
                  Icon(Icons.construction, size: 20, color: Colors.black54),
                  SizedBox(width: 10),
                  Text(
                    "Pilih tingkat kerusakan",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),

              items:
                  [
                        "Tidak Punya"
                            "Rusak Berat",
                        "Rusak Sedang",
                        "Rusak Ringan",
                        "Layak",
                      ]
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.circle,
                                size: 10,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                e,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),

              onChanged: (value) {},
              iconStyleData: const IconStyleData(
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                iconSize: 24,
              ),

              dropdownStyleData: DropdownStyleData(
                elevation: 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade300,

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 18,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),

            /// BIAYA
            Row(
              children: [
                SizedBox(width: 8),
                const Text(
                  "Biaya",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            TextFormField(
              keyboardType: TextInputType.number,
              cursorColor: const Color(0xff1565C0),

              style: const TextStyle(fontSize: 16, color: Colors.black87),

              decoration: InputDecoration(
                hintText: "Masukkan estimasi biaya",
                hintStyle: const TextStyle(color: Colors.black54, fontSize: 16),

                filled: true,
                fillColor: Colors.grey.shade300,

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 18,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),

                prefixIcon: const Icon(Icons.money, color: Colors.black54),

                prefixText: "Rp ",
                prefixStyle: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    SizedBox(width: 10),
                    Text(
                      "Lokasi",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  cursorColor: Colors.black54,

                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: "Alamat lokasi",
                    hintStyle: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),

                    filled: true,
                    fillColor: Colors.grey.shade300,

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 18,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),

                    prefixIcon: const Icon(
                      Icons.location_on,
                      color: Colors.black54,
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
                Row(
                  children: const [
                    SizedBox(width: 10),
                    Text(
                      "Titik Koordinat",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: "-7.12345, 110.12345",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            /// UPLOAD FOTO
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.camera_alt, color: Colors.black54),
                label: const Text(
                  "Upload Foto Lokasi",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// TOMBOL SIMPAN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1565C0),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Simpan Usulan",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

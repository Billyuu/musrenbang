import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/usulan_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Dusun
            const SizedBox(height: 8),

            Padding(
  padding: const EdgeInsets.only(bottom: 15),
  child: DropdownButtonFormField2<String>(
    isExpanded: true,
    alignment: Alignment.centerLeft,

    decoration: InputDecoration(
      hintText: "Dusun",

      filled: true,
      fillColor: Colors.grey.shade300,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18, // ⬅️ bikin lebih tinggi & lega
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20), // ⬅️ lebih smooth
        borderSide: BorderSide.none,
      ),
    ),

    iconStyleData: const IconStyleData(
      icon: Icon(Icons.keyboard_arrow_down),
      iconSize: 24,
    ),

    dropdownStyleData: DropdownStyleData(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
      ),
    ),

    items: ["Dusun Suko", "Dusun Duyo", "Dusun Rujak Sente"]
        .map(
          (item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        )
        .toList(),

    onChanged: (value) {},
  ),
),
            const SizedBox(height: 16),

            /// Judul Usulan
            const Text("Judul Usulan"),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Masukkan judul usulan",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            /// Permasalahan
            const Text("Permasalahan"),
            TextFormField(
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Jelaskan permasalahan",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            /// Urgensi
            const Text("Urgensi"),
            DropdownButtonFormField<String>(
              items: [
                "5 - Sangat Mendesak",
                "4 - Mendesak",
                "3 - Cukup Mendesak",
                "2 - Kurang Mendesak",
                "1 - Tidak Mendesak",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) {},
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),

            /// Masyarakat Terdampak
            const Text("Masyarakat Terdampak"),
            DropdownButtonFormField<String>(
              items: [
                "5 - Desa",
                "4 - Dusun",
                "3 - RW",
                "2 - RT",
                "1 - Kelompok",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) {},
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),

            /// Biaya
            const Text("Biaya"),
            DropdownButtonFormField<String>(
              items: [
                "5 - 0-50 Juta",
                "4 - 50-100 Juta",
                "3 - 100-150 Juta",
                "2 - 150-200 Juta",
                "1 - >200 Juta",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) {},
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),

            /// Tingkat Kerusakan
            const Text("Tingkat Kerusakan"),
            DropdownButtonFormField<String>(
              items: [
                "5 - Rusak Berat",
                "4 - Rusak Sedang",
                "3 - Rusak Ringan",
                "2 - Layak",
                "1 - Baik",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) {},
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),

            /// Alamat Lokasi
            const Text("Alamat Lokasi"),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Masukkan alamat lokasi",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            /// Titik Koordinat
            const Text("Titik Koordinat (Lat, Long)"),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "-7.12345, 110.12345",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            /// Upload Foto (Dummy Button)
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt),
              label: const Text("Upload Foto Lokasi"),
            ),
            const SizedBox(height: 24),

            /// Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Simpan Usulan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

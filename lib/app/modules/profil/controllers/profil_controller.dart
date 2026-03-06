import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilController extends GetxController {
  var bottomNavIndex = 2.obs; // karena ini halaman profil

  // 🔥 Data user (kosong dulu, akan diisi saat login)
  var nama = "".obs;
  var nik = "".obs;
  var alamat = "".obs;
  var noHp = "".obs;
  var jenisKelamin = "".obs;

  /// 🔥 Method untuk menerima data dari LoginController
  void setUserData(Map<String, dynamic> user) {
    nama.value = user["nama"] ?? "";
    nik.value = user["nik"] ?? "";
    alamat.value = user["alamat"] ?? "";
    noHp.value = user["nomor_telepon"] ?? "";

    // Konversi jenis kelamin
    if (user["jenis_kelamin"] == "L") {
      jenisKelamin.value = "Laki-laki";
    } else if (user["jenis_kelamin"] == "P") {
      jenisKelamin.value = "Perempuan";
    } else {
      jenisKelamin.value = user["jenis_kelamin"] ?? "";
    }
  }

  void editFoto() {
    Get.snackbar("Edit Foto", "Fitur ganti foto belum dibuat");
  }
  void editNoHp() {
  final TextEditingController noHpController =
      TextEditingController(text: noHp.value);

  Get.defaultDialog(
    title: "Edit Nomor Telepon",
    content: TextField(
      controller: noHpController,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        hintText: "Masukkan nomor telepon baru",
      ),
    ),
    textConfirm: "Simpan",
    textCancel: "Batal",
    onConfirm: () {
      noHp.value = noHpController.text;
      Get.back();
    },
  );
}

  void logout() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Yakin ingin logout?",
      textConfirm: "Ya",
      textCancel: "Batal",
      onConfirm: () {
        Get.offAllNamed('/login');
      },
    );
  }
}
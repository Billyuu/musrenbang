import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../controllers/registrasi_controller.dart';

class RegistrasiView extends GetView<RegistrasiController> {
  const RegistrasiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003E79),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.only(
                top: 45,
                left: 25,
                right: 25,
                bottom: 25,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Registrasi",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Silahkan daftar menggunakan Email aktif dan data sesuai KTP Anda!.",
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            /// FORM CARD
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),

                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),

                child: ListView(
                  children: [
                    /// NAMA
                    TextField(
                      controller: controller.namaController,
                      cursorColor: const Color(0xFF003E79),

                      style: GoogleFonts.poppins(fontSize: 14),

                      decoration: InputDecoration(
                        hintText: "Nama Lengkap",
                        hintStyle: GoogleFonts.poppins(fontSize: 14),

                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: Color(0xFF003E79),
                          size: 22,
                        ),

                        filled: true,
                        fillColor: const Color(0xffF5F7FA),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// EMAIL
                    TextField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: const Color(0xFF003E79),

                      style: GoogleFonts.poppins(fontSize: 14),

                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: GoogleFonts.poppins(fontSize: 14),

                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFF003E79),
                          size: 22,
                        ),

                        filled: true,
                        fillColor: const Color(0xffF5F7FA),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// NIK
                    TextField(
                      controller: controller.nikController,
                      keyboardType: TextInputType.number,
                      cursorColor: const Color(0xFF003E79),

                      style: GoogleFonts.poppins(fontSize: 14),

                      decoration: InputDecoration(
                        hintText: "NIK",
                        hintStyle: GoogleFonts.poppins(fontSize: 14),

                        prefixIcon: const Icon(
                          Icons.credit_card_outlined,
                          color: Color(0xFF003E79),
                          size: 22,
                        ),

                        filled: true,
                        fillColor: const Color(0xffF5F7FA),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// ALAMAT
                    TextField(
                      controller: controller.alamatController,
                      maxLines: 2,
                      cursorColor: const Color(0xFF003E79),

                      style: GoogleFonts.poppins(fontSize: 14),

                      decoration: InputDecoration(
                        hintText: "Alamat",
                        hintStyle: GoogleFonts.poppins(fontSize: 14),

                        prefixIcon: const Icon(
                          Icons.home_outlined,
                          color: Color(0xFF003E79),
                          size: 22,
                        ),

                        filled: true,
                        fillColor: const Color(0xffF5F7FA),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// GENDER
                    Obx(
                      () => DropdownButtonFormField2<String>(
                        value: controller.selectedGender.value,
                        isExpanded: true,

                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),

                        decoration: InputDecoration(
                          hintText: "Jenis Kelamin",
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),

                          prefixIcon: Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Color(0xffE5E7EB)),
                              ),
                            ),
                            child: const Icon(
                              Icons.people_alt_outlined,
                              color: Color(0xFF003E79),
                              size: 22,
                            ),
                          ),

                          filled: true,
                          fillColor: const Color(0xffF8FAFC),

                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 10,
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              color: Color(0xffE5E7EB),
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              color: Color(0xFF003E79),
                              width: 1.5,
                            ),
                          ),
                        ),

                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF003E79),
                            size: 25,
                          ),
                        ),

                        dropdownStyleData: DropdownStyleData(
                          elevation: 3,
                          maxHeight: 200,

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),

                        menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),

                        items: ["Laki-laki", "Perempuan"]
                            .map(
                              (item) => DropdownMenuItem<String>(
                                value: item,
                                child: Row(
                                  children: [
                                    Icon(
                                      item == "Laki-laki"
                                          ? Icons.male_rounded
                                          : Icons.female_rounded,
                                      size: 18,
                                      color: const Color(0xFF003E79),
                                    ),

                                    const SizedBox(width: 10),

                                    Text(
                                      item,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),

                        onChanged: (value) {
                          controller.selectedGender.value = value!;
                        },
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      cursorColor: const Color(0xFF003E79),
                      style: GoogleFonts.poppins(fontSize: 14),

                      decoration: InputDecoration(
                        hintText: "Nomor Telepon",
                        hintStyle: GoogleFonts.poppins(fontSize: 14),

                        prefixIcon: const Icon(
                          Icons.phone_outlined,
                          color: Color(0xFF003E79),
                          size: 22,
                        ),

                        prefix: Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Text(
                            "+62",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        filled: true,
                        fillColor: const Color(0xffF5F7FA),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    /// PASSWORD
                    Obx(
                      () => TextField(
                        controller: controller.passwordController,
                        obscureText: !controller.isPasswordVisible.value,
                        cursorColor: const Color(0xFF003E79),

                        style: GoogleFonts.poppins(fontSize: 14),

                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: GoogleFonts.poppins(fontSize: 14),

                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Color(0xFF003E79),
                            size: 22,
                          ),

                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xFF003E79),
                              size: 22,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),

                          filled: true,
                          fillColor: const Color(0xffF5F7FA),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// KONFIRMASI PASSWORD
                    Obx(
                      () => TextField(
                        controller: controller.confirmPasswordController,
                        obscureText: !controller.isConfirmPasswordVisible.value,
                        cursorColor: const Color(0xFF003E79),

                        style: GoogleFonts.poppins(fontSize: 14),

                        decoration: InputDecoration(
                          hintText: "Konfirmasi Password",
                          hintStyle: GoogleFonts.poppins(fontSize: 14),

                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Color(0xFF003E79),
                            size: 22,
                          ),

                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isConfirmPasswordVisible.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xFF003E79),
                              size: 22,
                            ),
                            onPressed:
                                controller.toggleConfirmPasswordVisibility,
                          ),

                          filled: true,
                          fillColor: const Color(0xffF5F7FA),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// BUTTON
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                                  FocusScope.of(context).unfocus();
                                  controller.register();
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
                                  "Daftar",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// LOGIN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sudah punya akun?",
                          style: GoogleFonts.poppins(fontSize: 13),
                        ),
                        TextButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Get.back();
                          },
                          child: Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: const Color(0xFF003E79),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

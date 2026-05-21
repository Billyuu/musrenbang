import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import 'package:musrenbang/app/routes/app_pages.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFF003E79),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      /// HEADER
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 60,
                            left: 25,
                            right: 25,
                            bottom: 30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Selamat Datang",
                                style: GoogleFonts.poppins(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 8),

                            GestureDetector(
  behavior: HitTestBehavior.translucent,
  onTapDown: (_) {
    controller.startAdminLoginTimer();
  },
  onTapUp: (_) {
    controller.cancelAdminLoginTimer();
  },
  onTapCancel: () {
    controller.cancelAdminLoginTimer();
  },
  child: Text(
    "Silahkan Login Menggunakan Email Anda!",
    style: GoogleFonts.poppins(
      color: Colors.white.withOpacity(0.9),
      fontSize: 13,
    ),
  ),
),
                            ],
                          ),
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

                          child: Column(
                            children: [
                              /// EMAIL
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

                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              /// PASSWORD
                              Obx(
                                () => TextField(
                                  controller: controller.passwordController,
                                  obscureText:
                                      !controller.isPasswordVisible.value,
                                  cursorColor: const Color(0xFF003E79),

                                  style: GoogleFonts.poppins(fontSize: 14),

                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: GoogleFonts.poppins(
                                      fontSize: 14,
                                    ),

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
                                      onPressed:
                                          controller.togglePasswordVisibility,
                                    ),

                                    filled: true,
                                    fillColor: const Color(0xffF5F7FA),

                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),

                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              /// LUPA PASSWORD
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.RESET_PASSWORD);
                                  },
                                  child: Text(
                                    "Lupa Password?",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: const Color(0xFF003E79),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              /// LOGIN BUTTON
                              Obx(
                                () => SizedBox(
                                  width: double.infinity,
                                  height: 54,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF003E79),
                                      disabledBackgroundColor: const Color(
                                        0xFF003E79,
                                      ),
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
                                            controller.login();
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
                                            "Masuk",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 22),

                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(color: Colors.grey.shade300),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      "Musrenbang Digital",
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(color: Colors.grey.shade300),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Belum punya akun?",
                                    style: GoogleFonts.poppins(fontSize: 13),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      Get.toNamed(Routes.REGISTRASI);
                                    },
                                    child: Text(
                                      "Daftar",
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
              ),
            );
          },
        ),
      ),
    );
  }
}

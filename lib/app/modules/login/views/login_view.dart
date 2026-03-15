import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import 'package:musrenbang/app/routes/app_pages.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xff1565C0),

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
                            children: const [
                              Text(
                                "Selamat Datang!",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Silahkan Login Menggunakan NIK KTP Anda.",
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.white,fontSize: 15),
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
                            color: Color(0xffF3F3F3),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35),
                            ),
                          ),

                          child: Column(
                            children: [
                              /// NIK
                              TextField(
                                controller: controller.nikController,
                                keyboardType: TextInputType.number,
                                cursorColor:
                                    Colors.black, // mengubah warna kursor

                                decoration: InputDecoration(
                                  hintText: "NIK",
                                  prefixIcon: const Icon(Icons.credit_card),

                                  filled: true,
                                  fillColor: Colors.grey.shade300,

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              /// PASSWORD
                              Obx(
                                () => TextField(
                                  cursorColor: Colors.black,
                                  controller: controller.passwordController,
                                  obscureText:
                                      !controller.isPasswordVisible.value,

                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    prefixIcon: const Icon(Icons.lock),

                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        controller.isPasswordVisible.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed:
                                          controller.togglePasswordVisibility,
                                    ),

                                    filled: true,
                                    fillColor: Colors.grey.shade300,

                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
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
                                  child: const Text(
                                    "Lupa Password?",
                                    style: TextStyle(color: Color(0xff1565C0)),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              /// LOGIN BUTTON
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff1565C0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    controller.login();
                                  },
                                ),
                              ),

                              const SizedBox(height: 25),

                              const Divider(),

                              const SizedBox(height: 10),

                              /// REGISTER
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Belum punya akun?"),
                                  TextButton(
                                    onPressed: () {
                                      Get.toNamed(Routes.REGISTRASI);
                                    },
                                    child: const Text(
                                      "Daftar",
                                      style: TextStyle(color: Color(0xff1565C0)),
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

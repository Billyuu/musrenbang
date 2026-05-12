import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musrenbang/app/routes/app_pages.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  final PageController _pageController = PageController();

  int currentPage = 0;

  final List<Map<String, dynamic>> splashData = [
   {
  "image": "assets/images/logo.png",
  "badge": "Selamat Datang di",
  "title": "MUSRENBANG\nDESA SUKOREJO",
  "subtitle": "Bangun Desa Bersama",
  "desc":
      "Wujudkan pembangunan desa yang lebih maju melalui aspirasi, usulan, dan partisipasi aktif masyarakat secara digital.",
},
{
  "badge": "🗳️ Aspirasi Warga",
  "title": "SUARA WARGA",
  "subtitle": "Lebih Didengar",
  "desc":
      "Sampaikan usulan dan aspirasi pembangunan dengan lebih mudah, cepat, dan transparan langsung melalui aplikasi.",
},
{
  "badge": "🚀 Desa Modern",
  "title": "DESA DIGITAL",
  "subtitle": "Transparan & Efisien",
  "desc":
      "Pantau proses pembangunan desa secara real-time dengan sistem Musrenbang digital yang modern dan terpercaya.",
},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: splashData.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        children: [
                          const Spacer(),

                          /// LOGO CARD
                          /// ICON / IMAGE
                          if (splashData[index]['image'] != null)
                            Image.asset(splashData[index]['image'], height: 180)
                          else
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF003E79).withOpacity(0.15),
                                    const Color(0xFF1565C0).withOpacity(0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Icon(
                                index == 1
                                    ? Icons.campaign_rounded
                                    : Icons.hub_rounded,
                                size: 75,
                                color: const Color(0xFF003E79),
                              ),
                            ),

                          const SizedBox(height: 50),

                          /// BADGE
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF003E79),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              splashData[index]['badge'],
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          /// TITLE
                          Text(
                            splashData[index]['title'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF003E79),
                              height: 1.2,
                              letterSpacing: 1,
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// SUBTITLE
                          Text(
                            splashData[index]['subtitle'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F0C10),
                            ),
                          ),

                          const SizedBox(height: 30),

                          /// DESC
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              splashData[index]['desc'],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.grey,
                                height: 1.8,
                              ),
                            ),
                          ),

                          const Spacer(),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// DOT INDICATOR
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  splashData.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: currentPage == index ? 26 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: currentPage == index
                          ? const Color(0xFF003E79)
                          : const Color.fromARGB(
                              255,
                              0,
                              19,
                              102,
                            ).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              /// BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003E79),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      if (currentPage == splashData.length - 1) {
                        Get.offNamed(Routes.LOGIN);
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(
                      currentPage == splashData.length - 1
                          ? "Mulai Sekarang"
                          : "Selanjutnya",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Desa Sukorejo • Musrenbang Digital",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF003E79),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:musrenbang/app/routes/app_pages.dart';

import '../controllers/admin_controller.dart';

class AdminView extends GetView<AdminController> {
  const AdminView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Admin Musrenbang Desa',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Iconsax.menu_1_copy),
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff1565C0),
        shape: const Border(
          bottom: BorderSide(color: Color(0xff1565C0), width: 1),
        ),
        elevation: 7,
        shadowColor: Colors.black,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: 230,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                color: Color(0xff1565C0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Admin Musrenbang',
                      style: TextStyle(
                        fontFamily: 'pacifico',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      //mengisi ruang yang di perlukan
                      child: Text(
                        'davisabilissalimuyp@gmail.com',
                        style: const TextStyle(
                          fontFamily: 'calfont',
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                //mengisi ruang kosong
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(Icons.assignment, color: Color(0xff1565C0)),
                      title: Text('Hasil Musrenbang'),
                      onTap: () {
                        Get.toNamed(Routes.HASIL_MUSRENBANG);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Color(0xff1565C0),
                      ),
                      title: const Text('Logout'),
                      onTap: () => controller.logout(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: const BoxDecoration(color: Color(0xff1565C0)),
            child: const Text(
              'Selamat Datang, Admin!',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 15),

          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  /// ================= DIPROSES =================
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.changeStatus("diproses");
                      },
                      child: Container(
                        height: 110,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFA726),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "12",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Diproses",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.fastOutSlowIn,
                                height: 4,
                                width:
                                    controller.selectedStatus.value ==
                                        "diproses"
                                    ? 40
                                    : 0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// ================= DITERIMA =================
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.changeStatus("diterima");
                      },
                      child: Container(
                        height: 110,
                        decoration: BoxDecoration(
                          color: const Color(0xFF66BB6A),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "3",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Diterima",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),

                            /// 🔥 GARIS ANIMASI HALUS
                            const SizedBox(height: 8),
                            Center(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.fastOutSlowIn,
                                height: 4,
                                width:
                                    controller.selectedStatus.value ==
                                        "diterima"
                                    ? 40
                                    : 0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// ================= DITOLAK =================
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.changeStatus("ditolak");
                      },
                      child: Container(
                        height: 110,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF5350),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "5",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Ditolak",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.fastOutSlowIn,
                                height: 4,
                                width:
                                    controller.selectedStatus.value == "ditolak"
                                    ? 40
                                    : 0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// 🔻 GARIS PEMBATAS
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(
              thickness: 1.5,
              color: Color.fromARGB(255, 200, 200, 200),
            ),
          ),
          Expanded(
            child: Obx(() {
              String title = "";

              if (controller.selectedStatus.value == "diproses") {
                title = "Usulan Diproses:";
              } else if (controller.selectedStatus.value == "diterima") {
                title = "Usulan Diterima:";
              } else {
                title = "Usulan Ditolak:";
              }

              return Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                      child: const ListTile(
                        leading: Icon(Icons.description),
                        title: Text("Saluran air mampet"),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

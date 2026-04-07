import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Application",

      /// 🔥 TAMBAHKAN INI
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xff1565C0), // garis cursor
          selectionColor: Color(0xff1565C0), // blok teks
          selectionHandleColor: Color(0xff1565C0), // 🔥 ubah ungu jadi biru
        ),
      ),

      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent, 
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

/// 🔥 BACKGROUND HANDLER
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔥 BACKGROUND NOTIF: ${message.notification?.title}");
}

String getInitialRoute() {
  final box = GetStorage();

  final sudahLihatSplash = box.read("sudah_lihat_splash") ?? true;

  final isLogin = box.read("is_login") ?? false;

  final role = box.read("role") ?? "";

  if (!sudahLihatSplash) {
    return Routes.SPLASH_SCREEN;
  }

  if (isLogin == true && role == "admin") {
    return Routes.ADMIN;
  }

  if (isLogin == true && role == "user") {
    return Routes.HOME;
  }

  return Routes.LOGIN;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await GetStorage.init();

  /// 🔥 WAJIB: background handler
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

  /// 🔥 FOREGROUND NOTIFICATION HANDLER (INI YANG KAMU BELUM PUNYA)
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("🔥 FOREGROUND NOTIF MASUK");
    print("TITLE: ${message.notification?.title}");
    print("BODY: ${message.notification?.body}");

    Get.snackbar(
      message.notification?.title ?? "Notifikasi",
      message.notification?.body ?? "",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue.withOpacity(0.9),
      colorText: Colors.white,
    );
  });

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MusrenYuk",
      initialRoute: getInitialRoute(),
      getPages: AppPages.routes,

      theme: ThemeData(
        primaryColor: const Color(0xFF003E79),

        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF003E79),
          selectionColor: Color(0x33003E79),
          selectionHandleColor: Color(0xFF003E79),
        ),
      ),
    ),
  );
}

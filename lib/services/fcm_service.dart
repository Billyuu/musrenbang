import 'package:firebase_messaging/firebase_messaging.dart';

class FcmService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<String?> initFcm() async {
    // Minta izin notifikasi, terutama untuk Android 13+ dan iOS
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("FCM PERMISSION: ${settings.authorizationStatus}");

    final token = await _messaging.getToken();

    print("FCM TOKEN: $token");

    return token;
  }
}
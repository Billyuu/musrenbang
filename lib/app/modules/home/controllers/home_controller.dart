import 'package:get/get.dart';
import 'package:musrenbang/app/modules/profil/controllers/profil_controller.dart';

class HomeController extends GetxController {
  ///Index Bottom Navigation
  var bottomNavIndex = 0.obs;
  //ambil nama dari profile
  final ProfilController profilController = Get.find<ProfilController>();

  /// Optional counter (kalau masih mau dipakai)
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}

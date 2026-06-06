import 'package:get/get.dart';

import '../controllers/laporan_usulan_musrenbang_controller.dart';

class LaporanUsulanMusrenbangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LaporanUsulanMusrenbangController>(
      () => LaporanUsulanMusrenbangController(),
    );
  }
}

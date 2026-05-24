import 'package:get/get.dart';

import '../controllers/detail_hasil_musrenbang_controller.dart';

class DetailHasilMusrenbangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailHasilMusrenbangController>(
      () => DetailHasilMusrenbangController(),
    );
  }
}

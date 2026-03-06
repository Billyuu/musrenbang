import 'package:get/get.dart';

import '../controllers/hasil_musrenbang_controller.dart';

class HasilMusrenbangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HasilMusrenbangController>(
      () => HasilMusrenbangController(),
    );
  }
}

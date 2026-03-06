import 'package:get/get.dart';

import '../controllers/status_usulan_controller.dart';

class StatusUsulanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatusUsulanController>(
      () => StatusUsulanController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/usulan_controller.dart';

class UsulanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsulanController>(
      () => UsulanController(),
    );
  }
}

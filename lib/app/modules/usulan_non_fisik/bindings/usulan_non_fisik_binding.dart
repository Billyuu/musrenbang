import 'package:get/get.dart';

import '../controllers/usulan_non_fisik_controller.dart';

class UsulanNonFisikBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsulanNonFisikController>(
      () => UsulanNonFisikController(),
    );
  }
}

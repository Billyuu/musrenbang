import 'package:get/get.dart';

import '../controllers/detail_admin_controller.dart';

class DetailAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailAdminController>(
      () => DetailAdminController(),
    );
  }
}

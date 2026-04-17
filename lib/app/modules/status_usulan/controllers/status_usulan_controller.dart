import 'package:get/get.dart';
import 'package:musrenbang/services/api_service.dart';


class StatusUsulanController extends GetxController {
  var isLoading = false.obs;
  var dataUsulan = [].obs;

  @override
  void onInit() {
    super.onInit();
    getUsulan();
  }

  void getUsulan() async {
    try {
      isLoading(true);

      var userId = 1; // 🔥 sementara hardcode dulu

      var result = await ApiService.getUsulan(userId);

      if (result['statusCode'] == 200) {
        dataUsulan.value = result['body']['data'];
      }
    } catch (e) {
      print("Error ambil usulan: $e");
    } finally {
      isLoading(false);
    }
  }

  void getDataUsulan() {}
}
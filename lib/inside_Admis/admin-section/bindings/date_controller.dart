import 'package:aisect_custom/GetController/date_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DateController>(
      () => DateController(),
    );
  }
}

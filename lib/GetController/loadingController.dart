import 'package:get/get.dart';

class Loading extends GetxController {
  RxBool isClicked = false.obs;
}
// Obx(() => model.isOnline
//                 ? c.isClicked.value == true
//                     ? Center(
//                         child: Container(
//                           height: size.height / 20,
//                           width: size.height / 20,
//                           child: CircularProgressIndicator(),
//                         ),
//                       )
//                     : stackMethod(size)
//                 : NoInternet());
//           }
//   controller.isClicked.value = true;        ;await Future.delayed(Duration(milliseconds: 600));controller.isClicked.value = false;
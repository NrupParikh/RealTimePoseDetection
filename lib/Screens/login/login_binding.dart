import 'package:get/get.dart';
import 'package:pose_detection/Screens/login/login_controller.dart';

class   LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
  
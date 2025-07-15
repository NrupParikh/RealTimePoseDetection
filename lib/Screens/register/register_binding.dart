import 'package:get/get.dart';
import 'package:pose_detection/Screens/register/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RegisterController());
  }
}

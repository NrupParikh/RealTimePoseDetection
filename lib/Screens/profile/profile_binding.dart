import 'package:get/get.dart';

import 'package:pose_detection/Screens/profile/profile_controller.dart';

class  ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
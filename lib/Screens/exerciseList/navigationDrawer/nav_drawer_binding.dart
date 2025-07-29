import 'package:get/get.dart';
import 'package:pose_detection/Screens/exerciseList/navigationDrawer/nav_drawer_controller.dart';

class NavDrawerBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut<NavDrawerController>(() => NavDrawerController()); 
  }
}

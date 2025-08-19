import 'package:get/get.dart';
import 'package:pose_detection/Screens/bmi_calc/bmi_calc_controller.dart';


class BmiCalcBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BMICalcController>(() => BMICalcController());
  }
}
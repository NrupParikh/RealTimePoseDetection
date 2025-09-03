import 'package:get/get.dart';
import 'package:pose_detection/Screens/goalHistory/goal_history_controller.dart';


class  GoalHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoalHistoryController>(() => GoalHistoryController());
  }
}
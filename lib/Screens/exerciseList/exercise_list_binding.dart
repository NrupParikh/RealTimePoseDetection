import 'package:get/get.dart';
import 'package:pose_detection/Screens/exerciseList/exercise_list_controller.dart';

class ExerciseListBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut<ExerciseListController>(() => ExerciseListController()); 
  }
}

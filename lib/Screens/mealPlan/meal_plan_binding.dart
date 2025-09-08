import 'package:get/get.dart';
import 'package:pose_detection/Screens/mealPlan/meal_plan_controller.dart';


class  MealPlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MealPlanController>(() => MealPlanController());
  }
}
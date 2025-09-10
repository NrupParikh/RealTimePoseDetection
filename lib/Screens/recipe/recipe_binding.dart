import 'package:get/get.dart';
import 'package:pose_detection/Screens/recipe/recipe_controller.dart';

class RecipeBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<RecipeController>(()=>RecipeController(Get.arguments));
  }
}
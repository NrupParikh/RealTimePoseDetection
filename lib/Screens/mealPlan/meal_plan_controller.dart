import 'package:get/get.dart';
import 'package:pose_detection/Components/fancy_alert_dialog.dart';
import 'package:pose_detection/Components/session_expire_controller.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Constants/gemini_prompt.dart';
import 'package:pose_detection/Singleton/api_service_singleton.dart';
import 'package:pose_detection/api/apiModels/meal_plan_response.dart';
import 'package:pose_detection/api/api_service.dart';
import 'package:pose_detection/api/gemini_api_service.dart';
import 'package:pose_detection/main.dart';
import 'package:tuple/tuple.dart';

class MealPlanController extends GetxController {
  final Rx<MealPlanResponse?> mealPlanDataModel = Rx<MealPlanResponse?>(null);

  final geminiService = GeminiApiService();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final ApiService _apiService = ApiServiceSingleton().apiService;
  final SessionExpireController sessionController =
      Get.find<SessionExpireController>();

  @override
  void onInit() async {
    super.onInit();
    // mealPlanDataModel.value = MealPlanResponse.fromJsonString(mealPlan);
    // print("day: ${mealPlanDataModel.value?.mealPlan?[0].day}");

    await handleMealPlan();
  }

//   var mealPlan = """{
//   "mealPlan": [
//     {
//       "day": "Monday",
//       "breakfast": [
//         "Idli with Sambar and Chutney",
//         "Vegetable Upma"
//       ],
//       "lunch": [
//         "Moong Dal Cheela with Curd",
//         "Mixed Vegetable Curry with Roti"
//       ],
//       "snack": [
//         "Fruit Salad",
//         "Sprouts Salad"
//       ],
//       "dinner": [
//         "Vegetable Biryani",
//         "Paneer Tikka Masala with Brown Rice"
//       ]
//     },
//     {
//       "day": "Tuesday",
//       "breakfast": [
//         "Besan Chilla with Green Chutney",
//         "Oats Porridge with Fruits"
//       ],
//       "lunch": [
//         "Rajma Chawal",
//         "Chole Bhature"
//       ],
//       "snack": [
//         "Peanut Butter Sandwich",
//         "Handful of Almonds"
//       ],
//       "dinner": [
//         "Aloo Gobi with Roti",
//         "Palak Paneer with Brown Rice"
//       ]
//     },
//     {
//       "day": "Wednesday",
//       "breakfast": [
//         "Vegetable Sandwich",
//         "Masala Dosa"
//       ],
//       "lunch": [
//         "Vegetable Pulao",
//         "Soyabean Curry with Rice"
//       ],
//       "snack": [
//         "Banana",
//         "Greek Yogurt"
//       ],
//       "dinner": [
//         "Dal Makhani with Rice",
//         "Chana Masala with Roti"
//       ]
//     },
//     {
//       "day": "Thursday",
//       "breakfast": [
//         "Poha",
//         "Sheera"
//       ],
//       "lunch": [
//         "Mixed Vegetable Curry with Chapati",
//         "Paneer Bhurji with Roti"
//       ],
//       "snack": [
//         "Roasted chickpeas",
//         "Makhana"
//       ],
//       "dinner": [
//         "Baingan Bharta with Roti",
//         "Malai Kofta with Naan"
//       ]
//     },
//     {
//       "day": "Friday",
//       "breakfast": [
//         "Uttapam",
//         "Stuffed Paratha"
//       ],
//       "lunch": [
//         "Mattar Paneer with Rice",
//         "Vegetable Biryani"
//       ],
//       "snack": [
//         "Apple slices with Peanut Butter",
//         "Orange"
//       ],
//       "dinner": [
//         "Dal Tadka with Jeera Rice",
//         "Navratan Korma with Naan"
//       ]
//     },
//     {
//       "day": "Saturday",
//       "breakfast": [
//         "Aloo Paratha",
//         "Vegetable Omelette"
//       ],
//       "lunch": [
//         "Kadhi Chawal",
//         "Vegetable Fried Rice"
//       ],
//       "snack": [
//         "Popcorn",
//         "Mixed Nuts"
//       ],
//       "dinner": [
//         "Mushroom Matar with Rice",
//         "Vegetable Curry with Chapati"
//       ]
//     },
//     {
//       "day": "Sunday",
//       "breakfast": [
//         "Dhokla",
//         "Bread Toast with Avocado"
//       ],
//       "lunch": [
//         "Paneer Butter Masala with Roti",
//         "Malai Kofta"
//       ],
//       "snack": [
//         "Fruit Chaat",
//         "Smoothie"
//       ],
//       "dinner": [
//         "Vegetable Stew with Brown Rice",
//         "Chole with Rice"
//       ]
//     }
//   ]
// } """;

  Future<void> handleMealPlan() async {
    // =========== PREFERENCE CHECK
    final mealPlan = await secureStorage.getMealPlan();
    if (mealPlan != null) {
      print("Tag_meals_plan_lenght ${mealPlan.mealPlan?.length}");
      mealPlanDataModel.value = mealPlan;
    } else {
      // =========== OUR API CHECK
      await getMealPlanFromAPI().then((result) async {
        if (result.item1) {
          print("Success");

          final mealPlan = await secureStorage.getMealPlan();
    if (mealPlan != null) {
      print("Tag_meals_plan_lenght ${mealPlan.mealPlan?.length}");
     
    }
        } else if (result.item3 == 401) {
          displaySessionExpireDialog(result);
        } else {
          // =========== GEMINI API CALL
          await callMealPlanFromGemini();
        }
      });
    }
  }

  Future<void> callMealPlanFromGemini() async {
    final mealPlan = await getMealPlanFromGemini();
    if (mealPlan != null) {
      // =========== SAVE TO OUR API
      final result = await saveMealPlanAPI();
      if (result.item1) {
        // sessionController.geminiUpdateRequired.value = false;
      } else if (result.item3 == 401) {
        displaySessionExpireDialog(result);
      } else {
        showFancyDialog(result.item2.toString());
      }
    }
  }

  Future<MealPlanResponse?> getMealPlanFromGemini() async {
    final profileData = secureStorage.getProfileData();
    if (profileData != null) {
      final mealPlan = await getGeminiMealPlan(
        age: profileData.age,
        gender: profileData.gender,
        height: profileData.height.toInt(),
        weight: profileData.weight.toInt(),
        goal: profileData.goal,
        goalDuration: profileData.goalDuration.toInt(),
      );
      return mealPlan;
    } else {
      errorMessage.value = "No profile data found for meal plan";
      return null;
    }
  }

  Future<MealPlanResponse?> getGeminiMealPlan({
    required int age,
    required String gender,
    required int height,
    required int weight,
    required String goal,
    required int goalDuration,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      mealPlanDataModel.value = null;

      final mealPlanPrompt = GeminiPrompt.buildFitnessPrompt(
        age: age,
        gender: gender,
        height: height,
        weight: weight,
        goal: goal,
        goalDuration: goalDuration,
        taskDescription: GeminiPrompt.taskDescMealPlan,
        jsonStructure: GeminiPrompt.jsonStructureForMealPlan,
      );

      final jsonMap = await geminiService.fetchJsonResponse(mealPlanPrompt);
      mealPlanDataModel.value = MealPlanResponse.fromJson(jsonMap);

      if (mealPlanDataModel.value != null) {
        secureStorage.storeMealPlan(mealPlanDataModel.value!);
        return mealPlanDataModel.value;
      }
      return null;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  void displaySessionExpireDialog(Tuple3<bool, String?, int> result) {
    if (Get.context != null && !Get.isDialogOpen!) {
      sessionController.showSessionExpiredDialog(
        Get.context!,
        result.item2.toString(),
      );
    }
  }

  void showFancyDialog(String message) {
    if (Get.context != null && !Get.isDialogOpen!) {
      FancyAlertDialog.showFancyAlertDialog(
        context: Get.context!,
        title: AppStrings.appName,
        message: message,
        onOkPressed: () {
          Get.back();
        },
        onCancelPressed: null,
      );
    }
  }

  Future<Tuple3<bool, String?, int>> getMealPlanFromAPI() async {
     print("Tag_getMealPlanFromAPI");
    try {
      isLoading.value = true;
      var appResponse = await _apiService.getMealPlanAPI();
      if (appResponse.statusCode == 200) {
        print("Tag_success200");
        isLoading.value = false;
        if (appResponse.data is Map<String, dynamic>) {
          try {
            final MealPlanResponse data = MealPlanResponse.fromJson(
              appResponse.data,
            );
            mealPlanDataModel.value = data;
            print("Tag_meal_pan_data ${data.toString()}");
            secureStorage.storeMealPlan(data);
            return Tuple3(
              true,
              appResponse.message.toString(),
              appResponse.statusCode.toInt(),
            );
          } catch (e) {
            isLoading.value = false;
            return Tuple3(
              false,
              "Error parsing ApiResponse",
              appResponse.statusCode.toInt(),
            );
          }
        } else {
          isLoading.value = false;
          return Tuple3(
            false,
            "appResponse.data is not a Map",
            appResponse.statusCode.toInt(),
          );
        }
      } else if (appResponse.statusCode == 401) {
        isLoading.value = false;
        return Tuple3(
          false,
          appResponse.message.toString(),
          appResponse.statusCode.toInt(),
        );
      } else {
        isLoading.value = false;
        return Tuple3(
          false,
          appResponse.message.toString(),
          appResponse.statusCode.toInt(),
        );
      }
    } catch (ex) {
      isLoading.value = false;
      return Tuple3(false, "$ex", 0);
    }
  }

  Future<Tuple3<bool, String?, int>> saveMealPlanAPI() async {
    print("Tag_Save_meal_plan_Function");
    final mealPlan = secureStorage.getMealPlan();
    final stringValueOfTipsObj = mealPlan?.toJsonString();
    print("Tag_MY_request ${stringValueOfTipsObj}");
    if (stringValueOfTipsObj != null) {
      try {
        isLoading.value = true;
        var appResponse = await _apiService.saveMealPlanAPI(
          mealPlan: stringValueOfTipsObj,
        );
        // For 200 or 201 handling we use result=1
        if (appResponse.result == 1) {
          isLoading.value = false;
          return Tuple3(
                true,
                appResponse.message.toString(),
                appResponse.statusCode.toInt(),
              );
        } else {
          isLoading.value = false;
          return Tuple3(
            false,
            appResponse.message.toString(),
            appResponse.statusCode.toInt(),
          );
        }
      } catch (ex) {
        isLoading.value = false;
        return Tuple3(false, "$ex", 0);
      }
    } else {
      isLoading.value = false;
      return Tuple3(false, "Invalid Json format", 0);
    }
  }
}

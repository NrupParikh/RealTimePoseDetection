import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/fancy_alert_dialog.dart';
import 'package:pose_detection/Components/session_expire_controller.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Constants/gemini_prompt.dart';
import 'package:pose_detection/Singleton/api_service_singleton.dart';
import 'package:pose_detection/api/apiModels/fitness_plan_data.dart';
import 'package:pose_detection/api/apiModels/fitness_plan_response.dart';
import 'package:pose_detection/api/apiModels/fitness_tips_data.dart';
import 'package:pose_detection/api/apiModels/fitness_tips_response.dart';
import 'package:pose_detection/api/apiModels/profile_response.dart';
import 'package:pose_detection/api/api_service.dart';
import 'package:pose_detection/api/gemini_api_service.dart';
import 'package:pose_detection/main.dart';
import 'package:tuple/tuple.dart';

class DashboardController extends GetxController {
  final geminiService = GeminiApiService();
  final ApiService _apiService = ApiServiceSingleton().apiService;
  final SessionExpireController sessionController =
      Get.find<SessionExpireController>();

  // --- UI STATE VARIABLES ---
  final RxBool isLoading = false.obs;
  final RxBool isLoadingForTips = false.obs;

  final RxString errorMessageForFitnessPlan = ''.obs;
  final RxString errorMessageForFitnessTips = ''.obs;

  final Rx<FitnessPlanResponse?> fitnessPlan = Rx<FitnessPlanResponse?>(null);
  final Rx<FitnessTipsResponse?> fitnessTipsDataModel =
      Rx<FitnessTipsResponse?>(null);

  // --- USER PROFILE & BMI DATA ---
  final RxDouble height = 0.0.obs;
  final RxDouble weight = 0.0.obs;

  final RxTotalBurnedCal = 0.0.obs;

  var currentTipIndex = 0.obs;

  @override
  void onInit() async {
    super.onInit();

    // Set initial height and weight from stored profile or use defaults
    // Load profile data once at the beginning
    final profileData = secureStorage.getProfileData();
    if (profileData != null) {
      height.value = (profileData.height ?? 0).toDouble();
      weight.value = (profileData.weight ?? 0).toDouble();
      calculateBMI();
    } else {
      await callProfileAPI();
    }

    await handleFitnessPlan();
    await handleFitnessTips();
  }

  Future<void> callProfileAPI() async {
    await getProfile().then((result) {
      if (result.item1) {
        final profileData = secureStorage.getProfileData();
        if (profileData != null) {
          height.value = (profileData.height ?? 0).toDouble();
          weight.value = (profileData.weight ?? 0).toDouble();
          calculateBMI();
        }
      } else if (result.item3 == 401) {
        displaySessionExpireDialog(result);
      } else {
        showFancyDialog(result);
      }
    });
  }

  // =========== FITNESS PLAN ===========
  Future<void> handleFitnessPlan() async {
    // =========== PREFERENCE CHECK
    final plan = await secureStorage.getFitnessPlan();
    if (plan != null) {
      print("Tag_workout_lenght ${plan.workoutPlan.length}");
      fitnessPlan.value = plan;
    } else {
      // =========== OUR API CHECK
      await getFitnessPlanFromAPI().then((result) async {
        if (result.item1) {
        } else if (result.item3 == 401) {
          displaySessionExpireDialog(result);
        } else {
          // =========== GEMINI API CALL
          final plan = await getFitnessPlanFromGemini();
          if (plan != null) {
            // =========== SAVE TO OUR API
            final result = await saveFitnessPlanAPI();
            if (result.item1) {
            } else if (result.item3 == 401) {
              displaySessionExpireDialog(result);
            } else {
              showFancyDialog(result);
            }
          }
        }
      });
    }
  }

  // =========== FITNESS TIPS ===========
  Future<void> handleFitnessTips() async {
    // =========== PREFERENCE CHECK
    final tips = await secureStorage.getFitnessTips();
    if (tips != null) {
      print("Tag_tips_lenght ${tips.fitnessTips.length}");
      fitnessTipsDataModel.value = tips;
    } else {
      // =========== OUR API CHECK
      await getFitnessTipsFromAPI().then((result) async {
        if (result.item1) {
        } else if (result.item3 == 401) {
          displaySessionExpireDialog(result);
        } else {
          // =========== GEMINI API CALL
          final tips = await getFitnessTipsFromGemini();
          if (tips != null) {
            // =========== SAVE TO OUR API
            final result = await saveFitnessTipsAPI();
            if (result.item1) {
            } else if (result.item3 == 401) {
              displaySessionExpireDialog(result);
            } else {
              showFancyDialog(result);
            }
          }
        }
      });
    }
  }

  void showFancyDialog(Tuple3<bool, String?, int> result) {
    if (Get.context != null && !Get.isDialogOpen!) {
      FancyAlertDialog.showFancyAlertDialog(
        context: Get.context!,
        title: AppStrings.appName,
        message: result.item2.toString(),
        onOkPressed: () {
          Get.back();
        },
        onCancelPressed: null,
      );
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

  // --- BMI CALCULATION LOGIC ---

  double calculateBMI() {
    if (height.value <= 0 || weight.value <= 0) return 0.0;
    final h = height.value / 100;
    return weight.value / (h * h);
  }

  String getBMIInterpretation() {
    final bmi = calculateBMI();
    if (bmi < 18.5) return AppStrings.underweight;
    if (bmi < 24.9) return AppStrings.normal;
    if (bmi < 29.9) return AppStrings.overweight;
    return AppStrings.obese;
  }

  Future<FitnessPlanResponse?> getFitnessPlanFromGemini() async {
    final profileData = secureStorage.getProfileData();
    if (profileData != null) {
      final plan = await getGeminiFitnessPlan(
        age: profileData.age ?? 0,
        gender: profileData.gender ?? 'male',
        height: profileData.height?.toInt() ?? 0,
        weight: profileData.weight?.toInt() ?? 0,
        goal: profileData.goal ?? 'Lose weight',
        goalDuration: profileData.goalDuration?.toInt() ?? 0,
      );
      return plan;
    } else {
      errorMessageForFitnessPlan.value =
          "No profile data found for recommanded exercise";
      return null;
    }
  }

  Future<FitnessTipsResponse?> getFitnessTipsFromGemini() async {
    final profileData = secureStorage.getProfileData();
    if (profileData != null) {
      final tips = await getGeminiFitnessTips(
        age: profileData.age ?? 0,
        gender: profileData.gender ?? 'male',
        height: profileData.height?.toInt() ?? 0,
        weight: profileData.weight?.toInt() ?? 0,
        goal: profileData.goal ?? 'Lose weight',
        goalDuration: profileData.goalDuration?.toInt() ?? 0,
      );
      return tips;
    } else {
      errorMessageForFitnessTips.value =
          "No profile data found for fitness tips";
      return null;
    }
  }

  /// Fetches the fitness plan using a direct HTTP request to the Google AI API.
  Future<FitnessPlanResponse?> getGeminiFitnessPlan({
    required int age,
    required String gender,
    required int height,
    required int weight,
    required String goal,
    required int goalDuration,
  }) async {
    try {
      isLoading.value = true;
      errorMessageForFitnessPlan.value = '';
      fitnessPlan.value = null;

      final exercisePrompt = GeminiPrompt.buildFitnessPrompt(
        age: age,
        gender: gender,
        height: height,
        weight: weight,
        goal: goal,
        goalDuration: goalDuration,
        taskDescription: GeminiPrompt.taskDescForFitnessPlan,
        jsonStructure: GeminiPrompt.jsonStructureForFitnessPlan,
      );

      final jsonMap = await geminiService.fetchJsonResponse(exercisePrompt);
      fitnessPlan.value = FitnessPlanResponse.fromJson(jsonMap);
      if (fitnessPlan.value != null) {
        secureStorage.storeFitnessPlan(fitnessPlan.value!);
        return fitnessPlan.value; // ✅ success
      }
      return null;
    } catch (e) {
      errorMessageForFitnessPlan.value = e.toString();
      return null;
    } finally {
      isLoading.value = false;
    }
  }
  
  // Get Profile Data
  Future<Tuple3<bool, String?, int>> getProfile() async {
    final userId = secureStorage.getUserData()?.id ?? 0;
    try {
      isLoading.value = true;
      var appResponse = await _apiService.getProfile(id: userId);
      if (appResponse.statusCode == 200) {
        isLoading.value = false;
        if (appResponse.data is Map<String, dynamic>) {
          try {
            final ProfileResponse data = ProfileResponse.fromJson(
              appResponse.data,
            );
            debugPrint("Tag_data ${data.profile}");
            secureStorage.storeProfileData(data.profile);
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

  // ===================== Fitness Tips =====================
  Future<FitnessTipsResponse?> getGeminiFitnessTips({
    required int age,
    required String gender,
    required int height,
    required int weight,
    required String goal,
    required int goalDuration,
  }) async {
    try {
      isLoadingForTips.value = true;
      errorMessageForFitnessTips.value = '';
      fitnessTipsDataModel.value = null;

      final tipsPrompt = GeminiPrompt.buildFitnessPrompt(
        age: age,
        gender: gender,
        height: height,
        weight: weight,
        goal: goal,
        goalDuration: goalDuration,
        taskDescription: GeminiPrompt.taskDescForFitnessTips,
        jsonStructure: GeminiPrompt.jsonStructureForFitnessTips,
      );

      final jsonMap = await geminiService.fetchJsonResponse(tipsPrompt);
      fitnessTipsDataModel.value = FitnessTipsResponse.fromJson(jsonMap);

      if (fitnessTipsDataModel.value != null) {
        secureStorage.storeFitnessTips(fitnessTipsDataModel.value!);
        return fitnessTipsDataModel.value; // ✅ success
      }
      return null;
    } catch (e) {
      errorMessageForFitnessTips.value = e.toString();
      return null;
    } finally {
      isLoadingForTips.value = false;
    }
  }

  Future<Tuple3<bool, String?, int>> getFitnessTipsFromAPI() async {
    try {
      isLoading.value = true;
      var appResponse = await _apiService.getFitnessTips();
      if (appResponse.statusCode == 200) {
        isLoading.value = false;
        if (appResponse.data is Map<String, dynamic>) {
          try {
            final FitnessTipsData data = FitnessTipsData.fromJson(
              appResponse.data,
            );
            fitnessTipsDataModel.value = data.geminiFitnessTips;
            if (data.geminiFitnessTips != null) {
              secureStorage.storeFitnessTips(data.geminiFitnessTips!);
            }
            debugPrint("Tag_fitness_tips ${data.geminiFitnessTips.toString()}");
            debugPrint("Tag_created_at ${data.createdAt.toString()}");
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

  Future<Tuple3<bool, String?, int>> saveFitnessTipsAPI() async {
    print("Tag_Save_fitness_tips_Function");
    final tips = secureStorage.getFitnessTips();
    final stringValueOfTipsObj = tips?.toJsonString();
    print("Tag_MY_request ${stringValueOfTipsObj}");
    if (stringValueOfTipsObj != null) {
      try {
        isLoading.value = true;
        var appResponse = await _apiService.saveFitnessTipsAPI(
          fitnessTips: stringValueOfTipsObj,
        );
        // For 200 or 201 handling we use result=1
        if (appResponse.result == 1) {
          isLoading.value = false;
          if (appResponse.data is Map<String, dynamic>) {
            try {
              final FitnessTipsData data = FitnessTipsData.fromJson(
                appResponse.data,
              );
              fitnessTipsDataModel.value = data.geminiFitnessTips;
              if (data.geminiFitnessTips != null) {
                secureStorage.storeFitnessTips(data.geminiFitnessTips!);
              }
              debugPrint(
                "Tag_fitness_tips ${data.geminiFitnessTips.toString()}",
              );
              debugPrint("Tag_created_at ${data.createdAt.toString()}");
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

  Future<Tuple3<bool, String?, int>> getFitnessPlanFromAPI() async {
    try {
      isLoading.value = true;
      var appResponse = await _apiService.getFitnessPlan();
      if (appResponse.statusCode == 200) {
        isLoading.value = false;
        if (appResponse.data is Map<String, dynamic>) {
          try {
            final FitnessPlanData data = FitnessPlanData.fromJson(
              appResponse.data,
            );
            fitnessPlan.value = data.geminiFitnessPlan;
            if (data.geminiFitnessPlan != null) {
              secureStorage.storeFitnessPlan(data.geminiFitnessPlan!);
            }
            debugPrint("Tag_fitness_plan ${data.geminiFitnessPlan.toString()}");
            debugPrint("Tag_created_at ${data.createdAt.toString()}");
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

  Future<Tuple3<bool, String?, int>> saveFitnessPlanAPI() async {
    print("Tag_Save_fitness_plan_Function");
    final plan = secureStorage.getFitnessPlan();
    final stringValueOfFitnessPlanObj = plan?.toJsonString();
    print("Tag_MY_request ${stringValueOfFitnessPlanObj}");
    if (stringValueOfFitnessPlanObj != null) {
      try {
        isLoading.value = true;
        var appResponse = await _apiService.saveFitnessPlanAPI(
          fitnessPlan: stringValueOfFitnessPlanObj,
        );
        // For 200 or 201 handling we use result=1
        if (appResponse.result == 1) {
          isLoading.value = false;
          if (appResponse.data is Map<String, dynamic>) {
            try {
              final FitnessPlanData data = FitnessPlanData.fromJson(
                appResponse.data,
              );
              fitnessPlan.value = data.geminiFitnessPlan;
              if (data.geminiFitnessPlan != null) {
                secureStorage.storeFitnessPlan(data.geminiFitnessPlan!);
              }
              debugPrint(
                "Tag_fitness_plan ${data.geminiFitnessPlan.toString()}",
              );
              debugPrint("Tag_created_at ${data.createdAt.toString()}");
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

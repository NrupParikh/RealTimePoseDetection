import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Constants/gemini_prompt.dart';
import 'package:pose_detection/Screens/dashboard/fitness_tips.dart';
import 'package:pose_detection/api/apiModels/fitness_plan_response.dart';
import 'package:pose_detection/api/apiModels/fitness_tips_response.dart';
import 'package:pose_detection/api/gemini_api_service.dart';
import 'package:pose_detection/main.dart';

class DashboardController extends GetxController {
  final geminiService = GeminiApiService();

  // --- UI STATE VARIABLES ---
  final RxBool isLoading = false.obs;
  final RxBool isLoadingForTips = false.obs;

  final RxString errorMessageForFitnessPlan = ''.obs;
  final RxString errorMessageForFitnessTips = ''.obs;

  final Rx<FitnessPlanResponse?> fitnessPlan = Rx<FitnessPlanResponse?>(null);
  final Rx<FitnessTipsResponse?> fitnessTipsDataModel =
      Rx<FitnessTipsResponse?>(null);

  // --- USER PROFILE & BMI DATA ---
  final RxInt height = 0.obs;
  final RxInt weight = 0.obs;
  // Load profile data once at the beginning
  final profileData = secureStorage.getProfileData();

  final RxTotalBurnedCal = 0.0.obs;

  var currentTipIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    // Set initial height and weight from stored profile or use defaults
    if (profileData != null) {
      height.value = (profileData?.height ?? 150).toInt();
      weight.value = (profileData?.weight ?? 60).toInt();
    } else {
      height.value = 150;
      weight.value = 60;
    }
    calculateBMI();
    loadFitnessPlan();
    loadFitnessTips();
  }

  // --- BMI CALCULATION LOGIC ---

  double calculateBMI() {
    if (height.value <= 0 || weight.value <= 0) {
      return 0.0;
    }
    double heightInMeters = height.value / 100.0;
    return weight.value / (heightInMeters * heightInMeters);
  }

  String getBMIInterpretation() {
    double bmi = calculateBMI();
    if (bmi < 18.5) {
      return AppStrings.underweight;
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return AppStrings.normal;
    } else if (bmi >= 25 && bmi < 29.9) {
      return AppStrings.overweight;
    } else {
      return AppStrings.obese;
    }
  }

  // --- DATA FETCHING LOGIC ---

  /// Retrieves user profile from storage and triggers the API call.
  Future<void> loadFitnessPlan() async {
    // This logic uses the profile data if it exists, otherwise uses sensible defaults.
    if (profileData != null) {
      await getFitnessPlan(
        age: profileData!.age ?? 25,
        gender: profileData!.gender ?? 'male',
        height: profileData!.height?.toInt() ?? 150,
        weight: profileData!.weight?.toInt() ?? 60,
        goal: profileData!.goal ?? 'Lose weight',
      );
    } else {
      // This path is taken if the user has no profile saved.
      errorMessageForFitnessPlan.value =
          "Profile not found. Using default values for plan.";
      await getFitnessPlan(
        age: 25,
        gender: 'male',
        height: 150,
        weight: 60, // Avoid sending 0 as weight
        goal: 'Lose weight',
      );
    }
  }

  Future<void> loadFitnessTips() async {
    // This logic uses the profile data if it exists, otherwise uses sensible defaults.
    if (profileData != null) {
      await getFitnessTips(
        age: profileData!.age ?? 25,
        gender: profileData!.gender ?? 'male',
        height: profileData!.height?.toInt() ?? 150,
        weight: profileData!.weight?.toInt() ?? 60,
        goal: profileData!.goal ?? 'Lose weight',
      );
    } else {
      // This path is taken if the user has no profile saved.
      errorMessageForFitnessTips.value =
          "Profile not found. Using default values for plan.";
      await getFitnessTips(
        age: 25,
        gender: 'male',
        height: 150,
        weight: 60, // Avoid sending 0 as weight
        goal: 'Lose weight',
      );
    }
  }

  /// Fetches the fitness plan using a direct HTTP request to the Google AI API.
  // Future<void> getFitnessPlan({
  //   required int age,
  //   required String gender,
  //   required int height,
  //   required int weight,
  //   required String goal,
  // }) async {
  //   try {
  //     isLoading.value = true;
  //     errorMessageForFitnessPlan.value = '';
  //     fitnessPlan.value = null;

  //     final exercisePrompt = GeminiPrompt.buildFitnessPrompt(
  //       age: age,
  //       gender: gender,
  //       height: height,
  //       weight: weight,
  //       goal: goal,
  //       taskDescription: GeminiPrompt.taskDescForFitnessPlan,
  //       jsonStructure: GeminiPrompt.jsonStructureForFitnessPlan,
  //     );

  //     final jsonMap = await geminiService.fetchJsonResponse(exercisePrompt);
  //     fitnessPlan.value = FitnessPlanResponse.fromJson(jsonMap);
  //   } catch (e) {
  //     errorMessageForFitnessPlan.value = e.toString();
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> getFitnessPlan({
    required int age,
    required String gender,
    required int height,
    required int weight,
    required String goal,
  }) async {
    isLoading.value = false;
    errorMessageForFitnessPlan.value = '';
    final Map<String, dynamic> jsonMap = json.decode(
      GeminiPrompt.recommandedExerciseStaticResponse,
    );
    fitnessPlan.value = FitnessPlanResponse.fromJson(jsonMap);
  }

  // Fitness Tips
  // Future<void> getFitnessTips({
  //   required int age,
  //   required String gender,
  //   required int height,
  //   required int weight,
  //   required String goal,
  // }) async {
  //   try {
  //     isLoadingForTips.value = true;
  //     errorMessageForFitnessTips.value = '';
  //     fitnessTipsDataModel.value = null;

  //     final tipsPrompt = GeminiPrompt.buildFitnessPrompt(
  //       age: age,
  //       gender: gender,
  //       height: height,
  //       weight: weight,
  //       goal: goal,
  //       taskDescription: GeminiPrompt.taskDescForFitnessTips,
  //       jsonStructure: GeminiPrompt.jsonStructureForFitnessTips,
  //     );

  //     final jsonMap = await geminiService.fetchJsonResponse(tipsPrompt);
  //     fitnessTipsDataModel.value = FitnessTipsResponse.fromJson(jsonMap);
  //   } catch (e) {
  //     errorMessageForFitnessTips.value = e.toString();
  //   } finally {
  //     isLoadingForTips.value = false;
  //   }
  // }

  Future<void> getFitnessTips({
    required int age,
    required String gender,
    required int height,
    required int weight,
    required String goal,
  }) async {
    isLoadingForTips.value = false;
    errorMessageForFitnessTips.value = '';
    final Map<String, dynamic> jsonMap = json.decode(
      GeminiPrompt.fitnessTipsStaticResponse,
    );
    print("Tag_jsonMap ${jsonMap.toString()}");
    fitnessTipsDataModel.value = FitnessTipsResponse.fromJson(jsonMap);
  }
}

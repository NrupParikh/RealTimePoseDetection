import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/fancy_alert_dialog.dart';
import 'package:pose_detection/Components/session_expire_controller.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Singleton/api_service_singleton.dart';
import 'package:pose_detection/api/apiModels/profile_response.dart';
import 'package:pose_detection/api/api_service.dart';
import 'package:pose_detection/main.dart';
import 'package:tuple/tuple.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = ApiServiceSingleton().apiService;
  final SessionExpireController sessionController =
      Get.find<SessionExpireController>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final genderController = TextEditingController();
  final goalController = TextEditingController();
  final goalDurationController = TextEditingController();

  final focusNodeName = FocusNode();
  final focusNodeAge = FocusNode();
  final focusNodeHeight = FocusNode();
  final focusNodeWeight = FocusNode();
  final focusNodeGender = FocusNode();
  final focusNodeGoal = FocusNode();
  final focusNodeGoalDuration = FocusNode();

  RxBool isEdit = true.obs;
  final RxBool isLoading = false.obs;

  // Variables to store initial profile data
  String initialName = '';
  String initialAge = '';
  String initialHeight = '';
  String initialWeight = '';
  String initialGender = '';
  String initialGoal = '';
  String initialGoalDuration = '';

  @override
  void onInit() async {
    super.onInit();
    await getProfile().then((result) {
      if (result.item1) {
        final profileData = secureStorage.getProfileData();
        if (profileData != null) {
          nameController.text = profileData.name.toString();
          ageController.text = profileData.age.toString();
          heightController.text = profileData.height.toString();
          weightController.text = profileData.weight.toString();
          genderController.text = profileData.gender.toString();
          goalController.text = profileData.goal.toString();
          goalDurationController.text = profileData.goalDuration.toString();

          // Store initial values
          initialName = profileData.name.toString();
          initialAge = profileData.age.toString();
          initialHeight = profileData.height.toString();
          initialWeight = profileData.weight.toString();
          initialGender = profileData.gender.toString();
          initialGoal = profileData.goal.toString();
          initialGoalDuration = profileData.goalDuration.toString();
        }
      } else if (result.item3 == 401) {
        if (Get.context != null && !Get.isDialogOpen!) {
          sessionController.showSessionExpiredDialog(
            Get.context!,
            result.item2.toString(),
          );
        }
      } else {
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
    });
  }

  Future<Tuple3<bool, String?, int>> handleUpdateProfile() async {
    final name = nameController.text;
    final age = int.tryParse(ageController.text);
    final height = double.tryParse(heightController.text);
    final weight = double.tryParse(weightController.text);
    final gender = genderController.text.toLowerCase();
    final goal = goalController.text;
    final duration = int.tryParse(goalDurationController.text);
    final userId = secureStorage.getUserData()?.id ?? 0;

    // Check if any value has changed
    if (name == initialName &&
        age.toString() == initialAge &&
        height.toString() == initialHeight &&
        weight.toString() == initialWeight &&
        gender == initialGender &&
        goal == initialGoal &&
        duration.toString() == initialGoalDuration) {
      isEdit.value = true;
      return Tuple3(
        false,
        AppStrings.noChangesMade,
        0,
      ); // Assuming you have a string constant for this
    }

    if (GetUtils.isNullOrBlank(name) == true) {
      return Tuple3(false, AppStrings.valEnterUserName, 0);
    } else if (age == null || age <= 0 || age >= 120) {
      return Tuple3(false, AppStrings.valEnterValidAge, 0);
    } else if (height == null || height <= 50 || height > 250) {
      return Tuple3(false, AppStrings.valEnterValidHeight, 0);
    } else if (weight == null || weight <= 20 || weight > 200) {
      return Tuple3(false, AppStrings.valEnterValidWeight, 0);
    } else if (['male', 'female', 'other'].contains(gender) == false) {
      return Tuple3(false, AppStrings.valEnterValidGender, 0);
    } else if (GetUtils.isNullOrBlank(goal) == true) {
      return Tuple3(false, AppStrings.valEnterGoal, 0);
    } else if (GetUtils.isNullOrBlank(duration) == true) {
      return Tuple3(false, AppStrings.valEnterGoalDuration, 0);
    } else if (duration == null || duration < 1 || duration > 52) {
      return Tuple3(false, AppStrings.valEnterValidGoalDuration, 0);
    } else {
      try {
        isEdit.value = true;
        isLoading.value = true;
        var appResponse = await _apiService.updateUserProfile(
          id: userId,
          name: name,
          age: age,
          height: height,
          weight: weight,
          gender: gender,
          goal: goal,
          goalDuration: duration,
        );
        if (appResponse.statusCode == 200) {
          isLoading.value = false;
          if (appResponse.data is Map<String, dynamic>) {
            try {
              final ProfileResponse data = ProfileResponse.fromJson(
                appResponse.data,
              );
              debugPrint("Tag_data ${data.profile}");
              secureStorage.storeProfileData(data.profile);
              // Update initial values after successful API call
              initialName = name;
              initialAge = age.toString();
              initialHeight = height.toString();
              initialWeight = weight.toString();
              initialGender = gender;
              initialGoal = goal;
              initialGoalDuration = duration.toString();
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

  @override
  void onClose() {
    nameController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    genderController.dispose();
    goalController.dispose();
    goalDurationController.dispose();

    focusNodeName.dispose();
    focusNodeAge.dispose();
    focusNodeHeight.dispose();
    focusNodeWeight.dispose();
    focusNodeGender.dispose();
    focusNodeGoal.dispose();
    focusNodeGoalDuration.dispose();
    super.onClose();
  }
}

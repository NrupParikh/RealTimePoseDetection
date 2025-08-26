import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Screens/dashboard/dashboard_controller.dart';
import 'package:pose_detection/main.dart';

class Helper {
  static Future<void> navigateAndShowWorkoutSummary(
    String routeName, {
    dynamic arguments,
  }) async {
    final result = await Get.toNamed(routeName, arguments: arguments);

    if (result != null && result is Map<String, dynamic>) {
      print("Tag_navigateAndShowWorkoutSummary_Yes");
      final String title = result['exType'] ?? 'Exercise';
      final int reps = result['poseCount'] ?? 0;
      final double calories = (result['caloriesBurned'] ?? 0).toDouble();
      final double duration = (result['duration'] ?? 0).toDouble();

      final dashboardController = Get.find<DashboardController>();
      dashboardController.totalBurnedCal.value += calories;
      await secureStorage.storeBurnCalories(dashboardController.totalBurnedCal.value);
      dashboardController.callSaveCaloriesStatus();

      Get.snackbar(
        backgroundColor: Colors.green,
        colorText: Colors.white,
        AppStrings.workoutStatus,
        AppStrings.workoutStatusSummary (
          reps,
          title,
          calories,
          duration,
        ),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    } else {
      print("Tag_navigateAndShowWorkoutSummary_null");
    }
  }
}

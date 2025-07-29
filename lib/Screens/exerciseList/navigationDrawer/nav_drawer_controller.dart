import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/fancy_alert_dialog.dart';
import 'package:pose_detection/Components/session_expire_controller.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Constants/page_name.dart';
import 'package:pose_detection/Singleton/api_service_singleton.dart';
import 'package:pose_detection/api/api_service.dart';
import 'package:pose_detection/main.dart';
import 'package:tuple/tuple.dart';

class NavDrawerController extends GetxController {
  final ApiService _apiService = ApiServiceSingleton().apiService;
  final SessionExpireController sessionController =
      Get.find<SessionExpireController>();

  Future<Tuple3<bool, String?, int>> logout() async {
    try {
      var appResponse = await _apiService.logout();
      if (appResponse.statusCode == 200) {
        return Tuple3(
          true,
          appResponse.message.toString(),
          appResponse.statusCode,
        );
      } else {
        return Tuple3(
          false,
          appResponse.message.toString(),
          appResponse.statusCode,
        );
      }
    } catch (ex) {
      return Tuple3(false, "$ex", 0);
    }
  }

  Future<void> handleLogout() async {
    FancyAlertDialog.showFancyAlertDialog(
      context: Get.overlayContext ?? Get.context!,
      title: AppStrings.appName,
      message: "Are you sure you want to logout ?",
      onOkPressed: () async {
        Get.back();
        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        final result = await logout();

        // Dismiss the loader
        Get.back(); // This will pop the loader dialog

        if (result.item1) {
          secureStorage.clearSharedPreference();
          Get.offAllNamed(PageName.onboard);
        } else if (result.item3 == 401) {
          if (Get.context != null && !Get.isDialogOpen!) {
            sessionController.showSessionExpiredDialog(
              Get.context!,
              result.item2.toString(),
            );
          }
        } else {
          // Handle logout failure, e.g., show a snackbar or another dialog
          Get.snackbar(
            AppStrings.appName,
            "Logout Failed, Please try again.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      onCancelPressed: () {
        Get.back();
      },
    );
  }
}

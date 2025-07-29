import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/fancy_alert_dialog.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Constants/page_name.dart';
import 'package:pose_detection/Singleton/sercure_storage_singleton.dart';

class SessionExpireController extends GetxController {
  // Inject SecureStorageSingleton
  final SecureStorageSingleton _secureStorage;

  // Constructor to receive the injected instance
  SessionExpireController(this._secureStorage);

  void showSessionExpiredDialog(BuildContext context, String message) {
    FancyAlertDialog.showFancyAlertDialog(
      context: context,
      title: AppStrings.appName,
      message: message,
      onOkPressed: () async {
        Get.back(); // Close the dialog
        await logoutWhenSessionExpire(); // Call your logout logic
      },
      onCancelPressed: null, // No cancel button for session expiry
    );
  }

  Future<void> logoutWhenSessionExpire() async {
    _secureStorage.clearSharedPreference(); // Use the injected instance
    Get.offAllNamed(PageName.login);
  }
}

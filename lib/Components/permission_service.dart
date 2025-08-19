import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/fancy_alert_dialog.dart';
import 'package:pose_detection/Constants/page_name.dart';
import 'package:pose_detection/Models/excercise_data_model.dart';
import 'package:pose_detection/Utility/helper.dart';

class PermissionService {
  static Future<void> requestAllPermissionsAndNavigate(
    ExcerciseDataModel item,
    BuildContext context,
  ) async {
    debugPrint('TAG_--- Permission Request Flow Started ---');

    // 1. Get initial status without requesting
    var cameraPermissionStatus = await Permission.camera.status;
    var microphonePermissionStatus = await Permission.microphone.status;
    debugPrint('TAG_TAG_Initial Camera Status: $cameraPermissionStatus');
    debugPrint('TAG_Initial Mic Status: $microphonePermissionStatus');

    bool cameraRequestedThisCall = false;
    bool micRequestedThisCall = false;

    // 2. Request camera permission if it's currently denied (includes undetermined)
    if (cameraPermissionStatus.isDenied) {
      debugPrint(
        'TAG_Camera permission is denied or undetermined. Requesting...',
      );
      cameraPermissionStatus = await Permission.camera.request();
      cameraRequestedThisCall = true;
    }

    // 3. Request microphone permission if it's currently denied (includes undetermined)
    if (microphonePermissionStatus.isDenied) {
      debugPrint(
        'TAG_Microphone permission is denied or undetermined. Requesting...',
      );
      microphonePermissionStatus = await Permission.microphone.request();
      micRequestedThisCall = true;
    }

    debugPrint(
      'TAG_Final Camera Status (after potential request): $cameraPermissionStatus',
    );
    debugPrint(
      'TAG_Final Mic Status (after potential request): $microphonePermissionStatus',
    );
    debugPrint('TAG_Was Camera Requested this call: $cameraRequestedThisCall');
    debugPrint('TAG_Was Mic Requested this call: $micRequestedThisCall');

    // 4. Check final status and navigate/show dialog
    if (cameraPermissionStatus.isGranted &&
        microphonePermissionStatus.isGranted) {
      debugPrint(
        'TAG_Both permissions granted. Navigating to DetectionScreen.',
      );
      // Get.to(
      //   () => DetectionScreen(),
      //   binding: DetectionBinding(item),
      // );      
      await Helper.navigateAndShowWorkoutSummary(PageName.detection, arguments: item);
    } else {
      // At least one permission is NOT granted
      if (context.mounted) {
        // Condition to determine if a dialog was just shown and denied
        // OR if it's already in a denied state (either denied or permanently denied)

        if (cameraPermissionStatus.isPermanentlyDenied ||
            microphonePermissionStatus.isPermanentlyDenied) {
          debugPrint(
            'TAG_At least one permission is PERMANENTLY DENIED. Showing permanent denied dialog.',
          );
          FancyAlertDialog.showFancyAlertDialog(
            context: context,
            title: "Permission Denied Permanently",
            message:
                "Camera and Microphone permissions are required to start detection. Please enable them in your app settings.",
            onOkPressed: () {
              Get.back();
              openAppSettings(); // Directs user to app settings
            },
            onCancelPressed: null,
          );
        } else if (cameraPermissionStatus.isDenied ||
            microphonePermissionStatus.isDenied) {
          // This condition covers:
          // a) First "Don't Allow" (status goes from denied/undetermined to denied)
          // b) Subsequent "Don't Allow" (status remains denied)
          // This is the core of your initial request's behavior.
          debugPrint(
            'TAG_At least one permission is DENIED (not permanently). Showing general denied dialog.',
          );
          FancyAlertDialog.showFancyAlertDialog(
            context: context,
            title: "Permission Denied",
            message:
                "Camera and Microphone permissions are required to start detection.",
            onOkPressed: () {
              Get.back();
            },
            onCancelPressed: null,
          );
        } else {
          // Fallback for any other unexpected non-granted status (e.g., restricted)
          debugPrint(
            'TAG_Permissions not granted due to restricted or unknown status. Showing general denied dialog.',
          );
          FancyAlertDialog.showFancyAlertDialog(
            context: context,
            title: "Permission Denied",
            message:
                "Camera and Microphone permissions are required to start detection. Please check your device settings.",
            onOkPressed: () {
              Get.back();
            },
            onCancelPressed: null,
          );
        }
      }
    }
    debugPrint('TAG_--- Permission Request Flow Ended ---');
  }
}

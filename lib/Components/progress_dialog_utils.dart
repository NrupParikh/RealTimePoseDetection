import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressDialogUtils {
  static bool isProgressVisible = false;

  static void showProgressDialog({bool isCancellable = false}) async {
    if (!isProgressVisible) {
      Get.dialog(
        PopScope(
          canPop: isCancellable,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              return; // Let the system handle the pop
            }
            if (!isCancellable) {
              if (kDebugMode) {
                print("Back button pressed (not cancellable)");
              }
              // Handle non-cancellable back press if needed
            } else {
              if (kDebugMode) {
                print("Back button pressed (cancellable)");
              }
              // Handle cancellable back press if needed
            }
          },

          child: const Center(
            child: CircularProgressIndicator.adaptive(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
        ),
        barrierDismissible: isCancellable,
      );
      isProgressVisible = true;
    }
  }

  /// Common method for hiding progress dialog
  static void hideProgressDialog() {
    if (isProgressVisible) {
      Get.back();
      isProgressVisible = false;
    }
  }
}
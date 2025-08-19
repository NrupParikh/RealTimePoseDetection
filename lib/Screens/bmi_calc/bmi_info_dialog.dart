import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/button_widget.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Constants/app_string.dart';

class BMIInfoDialog extends StatelessWidget {
  const BMIInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final BorderRadius dialogBorderRadius = BorderRadius.circular(20);

    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: dialogBorderRadius),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: FrostedGlass(
        applyFilter: true,
        gradientColors: [ColorConstants.endColor, Colors.black],
        borderRadius: dialogBorderRadius,
        padding: const EdgeInsets.all(20),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.aboutBmi,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Scrollable content
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        AppStrings.description,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppStrings.bmiDescription,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        AppStrings.bmiHowToCalculate,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppStrings.bmiHowToCalculateDesc,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        AppStrings.bmiCategories,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppStrings.bmiCategoriesDesc,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              // Fixed OK button at bottom using Buttonwidget
              Align(
                alignment: Alignment.center,
                child: Buttonwidget(
                  buttontitle: 'OK',
                  gradientColors: [
                    ColorConstants.startColor,
                    ColorConstants.endColor,
                  ],
                  onPressed: () {
                    Get.back(); // Assuming GetX for navigation
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showBMIinfo(BuildContext mCtx) {
    showDialog(
      context: mCtx,
      barrierDismissible: false,
      builder: (context) {
        return BMIInfoDialog();
      },
    );
  }
}

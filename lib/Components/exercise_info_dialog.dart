import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/button_widget.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Models/excercise_data_model.dart';

class ExerciseInfoDialog extends StatelessWidget {
  final ExcerciseDataModel dataModel;

  const ExerciseInfoDialog({super.key, required this.dataModel});

  @override
  Widget build(BuildContext context) {
    final BorderRadius dialogBorderRadius = BorderRadius.circular(20);

    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: dialogBorderRadius),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: FrostedGlass(
        applyFilter: true,
        gradientColors: [ColorConstants.endColor,Colors.black],
        borderRadius: dialogBorderRadius,        
        padding: const EdgeInsets.all(20),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dataModel.title,
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
                      Align(
                        alignment: Alignment.topCenter,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            dataModel.startPosition,
                            fit: BoxFit.scaleDown,
                            height: 200,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dataModel.description,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Pose Tips',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dataModel.poseTip,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Advantages',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dataModel.advantage,
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

  static void showExerciseInfo(
    BuildContext mCtx,
    ExcerciseDataModel dataModel,
  ) {
    showDialog(
      context: mCtx,
      barrierDismissible: false,
      builder: (context) {
        return ExerciseInfoDialog(dataModel: dataModel);
      },
    );
  }
}

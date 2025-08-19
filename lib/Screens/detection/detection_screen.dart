import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/exercise_info_dialog.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Screens/detection/detection_controller.dart';
import 'package:pose_detection/Utility/pose_painter.dart';

class DetectionScreen extends StatefulWidget {
  // final ExcerciseDataModel dataModel;
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  final DetectionController controller = Get.find<DetectionController>();
  @override
  Widget build(BuildContext context) {
    debugPrint("TAG_DetectionScreen build() called");

    return PopScope(
      // block automatic pop so we control result
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          handleBackNavigation();
        }
      },

      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            controller.dataModel.title,
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              handleBackNavigation();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              onPressed:
                  () => ExerciseInfoDialog.showExerciseInfo(
                    context,
                    controller.dataModel,
                  ),
            ),
          ],
        ),
        body: Obx(() {
          final List<Widget> children = [];

          final camController = controller.controller.value;
          if (camController != null && camController.value.isInitialized) {
            debugPrint("TAG_Camera initialized, rendering preview and results");
            children.add(Positioned.fill(child: CameraPreview(camController)));

            children.add(
              Positioned.fill(
                child: Obx(() {
                  final results = controller.scanResults.value;
                  final cameraController = controller.controller.value;

                  if (results == null ||
                      cameraController == null ||
                      !cameraController.value.isInitialized) {
                    debugPrint(
                      "TAG_Skipping result render: results/controller not ready",
                    );
                    return const SizedBox.shrink();
                  }

                  final imageSize = Size(
                    cameraController.value.previewSize!.height,
                    cameraController.value.previewSize!.width,
                  );

                  debugPrint(
                    "TAG_Rendering PosePainter with ${results.length} poses",
                  );
                  return CustomPaint(painter: PosePainter(imageSize, results));
                }),
              ),
            );
          } else {
            debugPrint("TAG_Camera controller not initialized");
          }

           if (controller.goalForExercies.value.isNotEmpty) {
            children.add(
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 100),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Do ${controller.goalForExercies.value}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }

          // if (controller.warningMessage.value.isNotEmpty) {
          //   debugPrint(
          //     "TAG_Warning message shown: ${controller.warningMessage.value}",
          //   );
          //   children.add(
          //     Align(
          //       alignment: Alignment.bottomCenter,
          //       child: Container(
          //         margin: const EdgeInsets.only(bottom: 100),
          //         padding: const EdgeInsets.symmetric(
          //           horizontal: 20,
          //           vertical: 10,
          //         ),
          //         decoration: BoxDecoration(
          //           color: Colors.white.withValues(alpha: 0.2),
          //           borderRadius: BorderRadius.circular(12),
          //         ),
          //         child: Text(
          //           controller.warningMessage.value,
          //           style: const TextStyle(
          //             color: Colors.white,
          //             fontSize: 18,
          //             fontWeight: FontWeight.w600,
          //           ),
          //         ),
          //       ),
          //     ),
          //   );
          // }

          // if (controller.distanceFeedback.value.isNotEmpty) {
          //   debugPrint(
          //     "TAG_Distance feedback: ${controller.distanceFeedback.value}",
          //   );
          //   children.add(
          //     Positioned(
          //       top: 20,
          //       left: 20,
          //       right: 20,
          //       child: Container(
          //         padding: const EdgeInsets.all(10),
          //         decoration: BoxDecoration(
          //           color: Colors.red.withValues(alpha: 0.6),
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         child: Text(
          //           controller.distanceFeedback.value,
          //           textAlign: TextAlign.center,
          //           style: const TextStyle(
          //             color: Colors.white,
          //             fontSize: 16,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ),
          //     ),
          //   );
          // }

          // debugPrint(
          //   "TAG_Current Distance Ratio: ${controller.distanceRatio.value.toStringAsFixed(2)}",
          // );
          // children.add(
          //   Positioned(
          //     top: 60,
          //     left: 20,
          //     child: Text(
          //       'Distance Ratio: ${controller.distanceRatio.value.toStringAsFixed(2)}',
          //       style: const TextStyle(color: Colors.white),
          //     ),
          //   ),
          // );

          debugPrint("TAG_Current Count: ${controller.getCount()}");
          children.add(
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FrostedGlass(
                  width: 70,
                  height: 70,
                  applyFilter: false,
                  borderRadius: BorderRadius.circular(50),
                  child: Center(
                    child: Text(
                      controller.getCount().toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );

          if (controller.showCountdown.value) {
            debugPrint("TAG_Showing countdown: ${controller.countdown.value}");
            children.add(
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.6),
                  child: Center(
                    child: Text(
                      '${controller.countdown.value}',
                      style: const TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          return Stack(
            children: [
              Positioned.fill(
                child: FrostedGlass(
                  applyFilter: false,
                  borderRadius: BorderRadius.zero,
                  gradientColors: [
                    ColorConstants.startColor,
                    ColorConstants.endColor,
                  ],
                  child: SizedBox.expand(),
                ),
              ),

              SafeArea(child: Stack(children: children)),
            ],
          );
        }),
      ),
    );
  }

  void handleBackNavigation() {
    controller.getBurnCaloriesAndGoBack();
  }
}

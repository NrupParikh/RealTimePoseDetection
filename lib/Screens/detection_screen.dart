import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Controllers/detection_controller.dart';
import 'package:pose_detection/Models/excercise_data_model.dart';
import 'package:pose_detection/Utility/pose_painter.dart';
import 'package:pose_detection/Utility/utility.dart';

class DetectionScreen extends StatelessWidget {
  final ExcerciseDataModel dataModel;
  const DetectionScreen({super.key, required this.dataModel});

  @override
  Widget build(BuildContext context) {
    debugPrint(">> DetectionScreen build() called");
    final DetectionController controller = Get.put(
      DetectionController(dataModel),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          dataModel.title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => showExerciseInfo(context, dataModel),
          ),
        ],
      ),
      body: Obx(() {
        final List<Widget> children = [];

        final camController = controller.controller.value;
        if (camController != null && camController.value.isInitialized) {
          debugPrint(">> Camera initialized, rendering preview and results");
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
                    ">> Skipping result render: results/controller not ready",
                  );
                  return const SizedBox.shrink();
                }

                final imageSize = Size(
                  cameraController.value.previewSize!.height,
                  cameraController.value.previewSize!.width,
                );

                debugPrint(">> Rendering PosePainter with ${results.length} poses");
                return CustomPaint(painter: PosePainter(imageSize, results));
              }),
            ),
          );
        } else {
          debugPrint(">> Camera controller not initialized");
        }

        if (controller.warningMessage.value.isNotEmpty) {
          debugPrint(">> Warning message shown: ${controller.warningMessage.value}");
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
                  controller.warningMessage.value,
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

        if (controller.distanceFeedback.value.isNotEmpty) {
          debugPrint(">> Distance feedback: ${controller.distanceFeedback.value}");
          children.add(
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  controller.distanceFeedback.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }

        debugPrint(
          ">> Current Distance Ratio: ${controller.distanceRatio.value.toStringAsFixed(2)}",
        );
        children.add(
          Positioned(
            top: 60,
            left: 20,
            child: Text(
              'Distance Ratio: ${controller.distanceRatio.value.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );

        debugPrint(">> Current Count: ${controller.getCount()}");
        children.add(
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(50),
              ),
              width: 70,
              height: 70,
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
        );

        if (controller.showCountdown.value) {
          debugPrint(">> Showing countdown: ${controller.countdown.value}");
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

        return Stack(children: children);
      }),
    );
  }
}

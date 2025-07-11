import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pose_detection/Controllers/camera_permission_controller.dart';
import 'package:pose_detection/Models/excercise_data_model.dart';
import 'package:pose_detection/Screens/detection_screen.dart';
import 'package:pose_detection/Utility/utility.dart';
import 'package:pose_detection/bindings/detection_binding.dart';

class ExcerciseListScreen extends StatelessWidget {
  ExcerciseListScreen({super.key});

  final CameraPermissionController cameraController = Get.put(CameraPermissionController());

  Future<void> requestAllPermissionsAndNavigate(ExcerciseDataModel item) async {
    // Request both CAMERA and MICROPHONE permissions
    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && micStatus.isGranted) {
      Get.to(() => DetectionScreen(dataModel: item),binding: DetectionBinding(item));
    } else {  
      Get.snackbar(
        'Permission Denied',
        'Camera and Microphone permissions are required to start detection.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exercise List',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: exerciseList.length,
        itemBuilder: (context, index) {
          final item = exerciseList[index];
          return InkWell(
            onTap: () => requestAllPermissionsAndNavigate(item),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Theme.of(context).colorScheme.primary,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        item.gifPath,
                        fit: BoxFit.cover,
                        width: 150,
                        height: 100,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.white),
                      onPressed: () => showExerciseInfo(context, item),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

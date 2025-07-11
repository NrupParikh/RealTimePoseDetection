import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:pose_detection/Models/excercise_data_model.dart';
import 'package:pose_detection/Utility/exercise_detectors.dart';

import 'package:pose_detection/main.dart';

class DetectionController extends GetxController {
  final ExcerciseDataModel dataModel;

  DetectionController(this.dataModel);

  final Rx<CameraController?> controller = Rx<CameraController?>(null);
  bool isBusy = false;
  late PoseDetector poseDetector;
  Timer? _countdownTimer;

  CameraImage? img;
  final Rxn<List<Pose>> scanResults = Rxn<List<Pose>>();

  RxDouble distanceRatio = 0.0.obs;
  RxString distanceFeedback = ''.obs;

  RxInt jumpingJackCount = 0.obs;
  RxInt plankToDownwardDogCount = 0.obs;
  RxInt clapCount = 0.obs;

  bool isJumpingJackOpen = false;
  bool wasInPlank = false;
  RxInt countdown = 3.obs;
  RxBool showCountdown = true.obs;
  String lastLegMoved = '';
  bool isClapOpen = false;

  RxInt pushCount = 0.obs;
  bool isLowered = false;

  RxInt squatCount = 0.obs;
  bool isSquatting = false;

  DateTime? lastRepTime;
  bool warningShown = false;
  Timer? inactivityTimer;
  RxString warningMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('>> DetectionController initialized for: ${dataModel.title}');
    startCountdown();
    startInactivityWatcher();
  }

  void markExerciseStarted() {
    lastRepTime = DateTime.now();
    debugPrint('>> Exercise started');
  }

  void startCountdown() async {
    debugPrint('>> Starting countdown');
    await initializeCamera();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
        debugPrint('>> Countdown: ${countdown.value}');
      } else {
        countdown.value = 0;
        showCountdown.value = false;
        debugPrint('>> Countdown finished');
        timer.cancel();
      }
    });
  }

  Future<void> initializeCamera() async {
    debugPrint('>> Initializing camera');
    final options = PoseDetectorOptions(mode: PoseDetectionMode.stream);
    poseDetector = PoseDetector(options: options);

    final newController = CameraController(
      cameras[0],
      ResolutionPreset.veryHigh,
      imageFormatGroup:
          Platform.isAndroid
              ? ImageFormatGroup.yuv420
              : ImageFormatGroup.bgra8888,
    );
    await newController.initialize();

    newController.startImageStream((image) {
      if (!isBusy && !showCountdown.value) {
        isBusy = true;
        img = image;
        debugPrint('>> Frame received, starting pose estimation');
        doPoseEstimationOnFrame();
      }
    });

    controller.value = newController;
    debugPrint('>> CameraController set and image stream started');
  }

  void doPoseEstimationOnFrame() async {
    final inputImage = _inputImageFromCameraImage();
    if (inputImage == null) {
      isBusy = false;
      debugPrint('>> Failed to convert camera image to InputImage');
      return;
    }

    try {
      final poses = await poseDetector.processImage(inputImage);
      scanResults.value = poses;
      debugPrint('>> Poses detected: ${poses.length}');

      if (poses.isNotEmpty) {
        final pose = poses.first;
        final landmarks = pose.landmarks;

        final allPoints = landmarks.values.toList();
        final xCoords = allPoints.map((e) => e.x);
        final yCoords = allPoints.map((e) => e.y);
        final left = xCoords.reduce((a, b) => a < b ? a : b);
        final right = xCoords.reduce((a, b) => a > b ? a : b);
        final top = yCoords.reduce((a, b) => a < b ? a : b);
        final bottom = yCoords.reduce((a, b) => a > b ? a : b);
        final boxWidth = right - left;
        final boxHeight = bottom - top;
        final imageSize = Size(img!.width.toDouble(), img!.height.toDouble());
        final heightRatio = boxHeight / imageSize.height;
        final widthRatio = boxWidth / imageSize.width;
        distanceRatio.value = (heightRatio + widthRatio) / 2;

        distanceFeedback.value =
            distanceRatio.value < 0.15
                ? 'You are too far from the camera'
                : distanceRatio.value > 0.45
                ? 'You are too close to the camera'
                : '';

        if (distanceFeedback.value.isNotEmpty) {
          debugPrint('>> Distance feedback: ${distanceFeedback.value}');
        }

        switch (dataModel.type) {
          case ExcerciseType.pushup:
            ExerciseDetectors.detectPushUp(
              landmarks: landmarks,
              onPushUpCount: () {
                pushCount.value++;
                debugPrint('>> Push-up count: ${pushCount.value}');
              },
              isLowered: isLowered,
              updateLowered: (val) => isLowered = val,
              onRepDetected: showWarningOnScreen,
            );
            break;
          case ExcerciseType.squat:
            ExerciseDetectors.detectSquat(
              landmarks: landmarks,
              onSquatCount: () {
                squatCount.value++;
                debugPrint('>> Squat count: ${squatCount.value}');
              },
              isSquatting: isSquatting,
              updateSquatting: (val) => isSquatting = val,
              onRepDetected: showWarningOnScreen,
            );
            break;
          case ExcerciseType.jumpingJack:
            ExerciseDetectors.detectJumpingJack(
              landmarks: landmarks,
              onJumpingJackCount: () {
                jumpingJackCount.value++;
                debugPrint('>> Jumping Jack count: ${jumpingJackCount.value}');
              },
              isOpen: isJumpingJackOpen,
              updateOpen: (val) => isJumpingJackOpen = val,
              onRepDetected: showWarningOnScreen,
            );
            break;
          case ExcerciseType.plankToDownwardDog:
            ExerciseDetectors.detectPlankToDownwardDog(
              landmarks: landmarks,
              onTransitionCount: () {
                plankToDownwardDogCount.value++;
                debugPrint(
                  '>> Plank to Downward Dog count: ${plankToDownwardDogCount.value}',
                );
              },
              getWasPlank: () => wasInPlank,
              updateWasPlank: (val) {
                debugPrint('>> wasInPlank updated to: $val');
                wasInPlank = val;
              },
              onRepDetected: showWarningOnScreen,
            );
            break;
          case ExcerciseType.overHeadArmClap:
            ExerciseDetectors.detectOverheadClaps(
              landmarks: landmarks,
              onClapCount: () {
                clapCount.value++;
                debugPrint('>> Arm Clap count: ${clapCount.value}');
              },
              isClapped: isClapOpen,
              updateClapState: (val) => isClapOpen = val,
              onRepDetected: showWarningOnScreen,
            );
            break;
        }
      }
    } catch (e) {
      debugPrint('>> Error during pose detection: $e');
    }

    isBusy = false;
  }

  void startInactivityWatcher() {
    inactivityTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (showCountdown.value || lastRepTime == null) return;
      final elapsed = DateTime.now().difference(lastRepTime!).inSeconds;
      if (elapsed >= 3 && !warningShown) {
        warningMessage.value = "Please do ${dataModel.title} properly";
        warningShown = true;
        debugPrint('>> Showing inactivity warning');
      }
    });
  }

  void showWarningOnScreen() {
    lastRepTime = DateTime.now();
    if (warningShown) {
      warningShown = false;
      warningMessage.value = '';
      debugPrint('>> Hiding warning');
    }
  }

  InputImage? _inputImageFromCameraImage() {
    try {
      final camera = cameras[0];
      final sensorOrientation = camera.sensorOrientation;
      final rotation = InputImageRotationValue.fromRawValue(sensorOrientation);

      if (rotation == null) {
        debugPrint('>> Rotation is null');
        return null;
      }

      InputImageFormat format = InputImageFormat.nv21; // Force NV21
      Uint8List? bytes;

      if (Platform.isAndroid) {
        final WriteBuffer allBytes = WriteBuffer();
        // Manually convert YUV420 to NV21
        allBytes.putUint8List(img!.planes[0].bytes); // Y
        allBytes.putUint8List(img!.planes[1].bytes); // U
        allBytes.putUint8List(img!.planes[2].bytes); // V
        bytes = allBytes.done().buffer.asUint8List();
      } else {
        // iOS/macOS
        format = InputImageFormat.bgra8888;
        final WriteBuffer allBytes = WriteBuffer();
        for (final plane in img!.planes) {
          allBytes.putUint8List(plane.bytes);
        }
        bytes = allBytes.done().buffer.asUint8List();
      }

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(img!.width.toDouble(), img!.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: img!.planes[0].bytesPerRow,
        ),
      );

      debugPrint('>> InputImage created successfully');
      return inputImage;
    } catch (e) {
      debugPrint('>> Error in _inputImageFromCameraImage: $e');
      return null;
    }
  }

  int getCount() {
    switch (dataModel.type) {
      case ExcerciseType.pushup:
        return pushCount.value;
      case ExcerciseType.squat:
        return squatCount.value;
      case ExcerciseType.jumpingJack:
        return jumpingJackCount.value;
      case ExcerciseType.plankToDownwardDog:
        return plankToDownwardDogCount.value;
      case ExcerciseType.overHeadArmClap:
        return clapCount.value;
    }
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    controller.value?.stopImageStream();
    controller.value?.dispose();
    poseDetector.close();
    inactivityTimer?.cancel();
    debugPrint('>> DetectionController disposed');
    super.onClose();
  }
}

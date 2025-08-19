import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:pose_detection/Models/excercise_data_model.dart';
import 'package:pose_detection/Screens/dashboard/dashboard_controller.dart';
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

  final userProfileData = secureStorage.getProfileData();
  DateTime? exerciseStartTime;
  DateTime? exerciseEndTime;

  // DateTime? lastRepTime;
  // bool warningShown = false;
  // Timer? inactivityTimer;
  // RxString warningMessage = ''.obs;

  RxString goalForExercies = ''.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint(
      'TAG_DetectionController initialized for: ${dataModel.type.name}',
    );
    startCountdown();
    // startInactivityWatcher();
    print("Tag_current_type ${dataModel.type.name.toString()}");
    // showGoalForExercise();
  }

  void showGoalForExercise() {
    final controller = Get.find<DashboardController>();
    final fitnessPlan = controller.fitnessPlan.value;
    final workoutPlan = fitnessPlan?.workoutPlan;
    final item = workoutPlan?.firstWhere(
      (element) =>
          element.exerciseName.toString().toLowerCase() ==
          dataModel.type.name.toLowerCase(),
    );
    goalForExercies.value = item?.value.toString() ?? '';
  }

  // void markExerciseStarted() {
  //   lastRepTime = DateTime.now();
  //   debugPrint('TAG_Exercise started');
  // }

  void startCountdown() async {
    debugPrint('TAG_Starting countdown');
    await initializeCamera();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
        debugPrint('TAG_Countdown: ${countdown.value}');
      } else {
        countdown.value = 0;
        showCountdown.value = false;
        debugPrint('TAG_Countdown finished');
        timer.cancel();
      }
    });
  }

  Future<void> initializeCamera() async {
    debugPrint('TAG_Initializing camera');
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
        debugPrint('TAG_Frame received, starting pose estimation');
        doPoseEstimationOnFrame();
      }
    });

    controller.value = newController;
    debugPrint('TAG_CameraController set and image stream started');
  }

  void doPoseEstimationOnFrame() async {
    final inputImage = _inputImageFromCameraImage();
    if (inputImage == null) {
      isBusy = false;
      debugPrint('TAG_Failed to convert camera image to InputImage');
      return;
    }

    try {
      final poses = await poseDetector.processImage(inputImage);
      scanResults.value = poses;
      debugPrint('TAG_Poses detected: ${poses.length}');

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
          debugPrint('TAG_Distance feedback: ${distanceFeedback.value}');
        }

        switch (dataModel.type) {
          case ExcerciseType.pushup:
            ExerciseDetectors.detectPushUp(
              landmarks: landmarks,
              onPushUpCount: () {
                markExerciseStartedOnce();
                pushCount.value++;
                debugPrint('TAG_Push-up count: ${pushCount.value}');
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
                markExerciseStartedOnce();
                squatCount.value++;
                debugPrint('TAG_Squat count: ${squatCount.value}');
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
                markExerciseStartedOnce();
                jumpingJackCount.value++;
                debugPrint('TAG_Jumping Jack count: ${jumpingJackCount.value}');
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
                markExerciseStartedOnce();
                plankToDownwardDogCount.value++;
                debugPrint(
                  '>> Plank to Downward Dog count: ${plankToDownwardDogCount.value}',
                );
              },
              getWasPlank: () => wasInPlank,
              updateWasPlank: (val) {
                debugPrint('TAG_wasInPlank updated to: $val');
                wasInPlank = val;
              },
              onRepDetected: showWarningOnScreen,
            );
            break;
          case ExcerciseType.overHeadArmClap:
            ExerciseDetectors.detectOverheadClaps(
              landmarks: landmarks,
              onClapCount: () {
                markExerciseStartedOnce();
                clapCount.value++;
                debugPrint('TAG_Arm Clap count: ${clapCount.value}');
              },
              isClapped: isClapOpen,
              updateClapState: (val) => isClapOpen = val,
              onRepDetected: showWarningOnScreen,
            );
            break;
        }
      }
    } catch (e) {
      debugPrint('TAG_Error during pose detection: $e');
    }

    isBusy = false;
  }

  // void startInactivityWatcher() {
  //   inactivityTimer = Timer.periodic(const Duration(seconds: 1), (_) {
  //     if (showCountdown.value || lastRepTime == null) return;
  //     final elapsed = DateTime.now().difference(lastRepTime!).inSeconds;
  //     if (elapsed >= 3 && !warningShown) {
  //       warningMessage.value = "Please do ${dataModel.title} properly";
  //       warningShown = true;
  //       debugPrint('TAG_Showing inactivity warning');
  //     }
  //   });
  // }

  void showWarningOnScreen() {
    // lastRepTime = DateTime.now();
    // if (warningShown) {
    //   warningShown = false;
    //   warningMessage.value = '';
    //   debugPrint('TAG_Hiding warning');
    // }
  }

  InputImage? _inputImageFromCameraImage() {
    try {
      final camera = cameras[0];
      final sensorOrientation = camera.sensorOrientation;
      final rotation = InputImageRotationValue.fromRawValue(sensorOrientation);

      if (rotation == null) {
        debugPrint('TAG_Rotation is null');
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

      debugPrint('TAG_InputImage created successfully');
      return inputImage;
    } catch (e) {
      debugPrint('TAG_Error in _inputImageFromCameraImage: $e');
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
    // inactivityTimer?.cancel();
    debugPrint('TAG_DetectionController disposed');
    super.onClose();
  }

  void getBurnCaloriesAndGoBack() {
    final profileData = secureStorage.getProfileData();    
    exerciseEndTime = DateTime.now();

    if (exerciseStartTime != null && exerciseEndTime != null) {
      final duration = exerciseEndTime!.difference(exerciseStartTime!);
      final durationMinutes = duration.inSeconds / 60.0;

      final burnedCalories = calculateCaloriesBurned(
        met: getMetValue(dataModel.type),
        weightKg: profileData?.weight??60, // Temp set 60 kg
        durationMinutes: durationMinutes,
      );

      final results = {
        'exType': dataModel.type.name,
        'poseCount': getCount(),
        'caloriesBurned': burnedCalories,
        'duration': durationMinutes,
        'startTime': exerciseStartTime,
        'endTime': exerciseEndTime,
      };

      Get.back(result: results);
    } else {
      Get.back();
    }
  }

  // =================== CALCULATING BURN CALORIES

  void markExerciseStartedOnce() {
    if (exerciseStartTime == null) {
      exerciseStartTime = DateTime.now();
      debugPrint('TAG_Exercise started at: $exerciseStartTime');
    }
  }

  // Return MET value of exercise
  double getMetValue(ExcerciseType exercise) {
    switch (exercise) {
      case ExcerciseType.pushup:
        return 8.0;
      case ExcerciseType.squat:
        return 5.0;
      case ExcerciseType.jumpingJack:
        return 8.0;
      case ExcerciseType.plankToDownwardDog:
        return 4.0;
      case ExcerciseType.overHeadArmClap:
        return 6.0;
    }
  }

  // Calculate Burn Calories
  double calculateCaloriesBurned({
    required double met,
    required double weightKg,
    required double durationMinutes,
  }) {
    final burnedCalories = (met * 3.5 * weightKg / 200) * durationMinutes;
    print("""
    ExName ${dataModel.type.name.toString()}   
    PoseCount ${getCount()} 
    Met ${met}
    Weight ${weightKg}
    StartTime ${exerciseStartTime}
    EndTime ${exerciseEndTime}
    Duration ${durationMinutes}
    BurnedCal ~ ${burnedCalories}
    """);
    return burnedCalories;
  }

  // ========================
}

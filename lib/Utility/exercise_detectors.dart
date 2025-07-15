import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class ExerciseDetectors {
  static double calculateAngle(PoseLandmark a, PoseLandmark b, PoseLandmark c) {
    double ab = sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2));
    double bc = sqrt(pow(b.x - c.x, 2) + pow(b.y - c.y, 2));
    double ac = sqrt(pow(a.x - c.x, 2) + pow(a.y - c.y, 2));
    return acos((ab * ab + bc * bc - ac * ac) / (2 * ab * bc)) * (180 / pi);
  }

  static void detectPushUp({
    required Map<PoseLandmarkType, PoseLandmark> landmarks,
    required void Function() onPushUpCount,
    required bool isLowered,
    required void Function(bool) updateLowered,
    required void Function() onRepDetected,
  }) {
    final ls = landmarks[PoseLandmarkType.leftShoulder];
    final rs = landmarks[PoseLandmarkType.rightShoulder];
    final le = landmarks[PoseLandmarkType.leftElbow];
    final re = landmarks[PoseLandmarkType.rightElbow];
    final lw = landmarks[PoseLandmarkType.leftWrist];
    final rw = landmarks[PoseLandmarkType.rightWrist];
    final lh = landmarks[PoseLandmarkType.leftHip];
    final lk = landmarks[PoseLandmarkType.leftKnee];

    if ([ls, rs, le, re, lw, rw, lh, lk].contains(null)) return;

    final leftElbowAngle = calculateAngle(ls!, le!, lw!);
    final rightElbowAngle = calculateAngle(rs!, re!, rw!);
    final averageElbowAngle = (leftElbowAngle + rightElbowAngle) / 2;

    final torsoAngle = calculateAngle(ls, lh!, lk!);
    final inPlank = torsoAngle > 160 && torsoAngle < 180;

    if (averageElbowAngle < 90 && inPlank) {
      updateLowered(true);
    } else if (averageElbowAngle > 160 && isLowered && inPlank) {
      onPushUpCount();
      onRepDetected();
      updateLowered(false);
    }
  }

  static void detectSquat({
    required Map<PoseLandmarkType, PoseLandmark> landmarks,
    required void Function() onSquatCount,
    required bool isSquatting,
    required void Function(bool) updateSquatting,
    required void Function() onRepDetected,
  }) {
    final lh = landmarks[PoseLandmarkType.leftHip];
    final rh = landmarks[PoseLandmarkType.rightHip];
    final lk = landmarks[PoseLandmarkType.leftKnee];
    final rk = landmarks[PoseLandmarkType.rightKnee];
    final la = landmarks[PoseLandmarkType.leftAnkle];
    final ra = landmarks[PoseLandmarkType.rightAnkle];

    if ([lh, rh, lk, rk, la, ra].contains(null)) return;

    final kneeAngle =
        (calculateAngle(lh!, lk!, la!) + calculateAngle(rh!, rk!, ra!)) / 2;
    final hipY = (lh.y + rh.y) / 2;
    final kneeY = (lk.y + rk.y) / 2;
    final deepSquat = kneeAngle < 90 && hipY > kneeY;
    if (deepSquat && !isSquatting) {
      updateSquatting(true);
    } else if (!deepSquat && isSquatting) {
      onSquatCount();
      onRepDetected();
      updateSquatting(false);
    }
  }

  static void detectJumpingJack({
    required Map<PoseLandmarkType, PoseLandmark> landmarks,
    required void Function() onJumpingJackCount,
    required bool isOpen,
    required void Function(bool) updateOpen,
    required void Function() onRepDetected,
  }) {
    final la = landmarks[PoseLandmarkType.leftAnkle];
    final ra = landmarks[PoseLandmarkType.rightAnkle];
    final lh = landmarks[PoseLandmarkType.leftHip];
    final rh = landmarks[PoseLandmarkType.rightHip];
    final ls = landmarks[PoseLandmarkType.leftShoulder];
    final rs = landmarks[PoseLandmarkType.rightShoulder];
    final lw = landmarks[PoseLandmarkType.leftWrist];
    final rw = landmarks[PoseLandmarkType.rightWrist];

    if ([la, ra, lh, rh, ls, rs, lw, rw].contains(null)) return;

    final legSpread = (ra!.x - la!.x).abs();
    final armHeight = (lw!.y + rw!.y) / 2;
    final hipHeight = (lh!.y + rh!.y) / 2;
    final shoulderWidth = (rs!.x - ls!.x).abs();

    final legThreshold = shoulderWidth * 1.2;
    final armThreshold = hipHeight - shoulderWidth * 0.5;

    final armsUp = armHeight < armThreshold;
    final legsApart = legSpread > legThreshold;

    if (armsUp && legsApart && !isOpen) {
      updateOpen(true);
    } else if (!armsUp && !legsApart && isOpen) {
      onJumpingJackCount();
      onRepDetected();
      updateOpen(false);
    }
  }

  static void detectPlankToDownwardDog({
    required Map<PoseLandmarkType, PoseLandmark> landmarks,
    required void Function() onTransitionCount,
    required bool Function() getWasPlank,
    required void Function(bool) updateWasPlank,
    required void Function() onRepDetected,
  }) {
    final lh = landmarks[PoseLandmarkType.leftHip];
    final rh = landmarks[PoseLandmarkType.rightHip];
    final ls = landmarks[PoseLandmarkType.leftShoulder];
    final rs = landmarks[PoseLandmarkType.rightShoulder];
    final la = landmarks[PoseLandmarkType.leftAnkle];
    final ra = landmarks[PoseLandmarkType.rightAnkle];
    final lw = landmarks[PoseLandmarkType.leftWrist];
    final rw = landmarks[PoseLandmarkType.rightWrist];

    if ([lh, rh, ls, rs, la, ra, lw, rw].contains(null)) {
      debugPrint("TAG_One or more landmarks are null");
      return;
    }

    final hipY = (lh!.y + rh!.y) / 2;
    final shoulderY = (ls!.y + rs!.y) / 2;
    final ankleY = (la!.y + ra!.y) / 2;
    final wristY = (lw!.y + rw!.y) / 2;

    debugPrint(
      'TAG_hipY: $hipY, shoulderY: $shoulderY, ankleY: $ankleY, wristY: $wristY',
    );

    final isPlank =
        (hipY - shoulderY).abs() < 60 && // previously 30
        (ankleY - hipY).abs() < 250 && // previously 150
        (wristY - shoulderY).abs() < 250; // previously 150

    final isDownwardDog = (hipY < shoulderY - 60) && (ankleY > hipY + 50);

    debugPrint(
      'TAG_[DD] isPlank: $isPlank | isDownwardDog: $isDownwardDog | wasPlank: ${getWasPlank()}',
    );

    if (isPlank && !getWasPlank()) {
      debugPrint('TAG_[DD] Entered plank position');
      updateWasPlank(true);
    } else if (isDownwardDog && getWasPlank()) {
      debugPrint('TAG_[DD] Detected transition to Downward Dog');
      onTransitionCount();
      onRepDetected();
      updateWasPlank(false);
    }
  }

  static void detectOverheadClaps({
    required Map<PoseLandmarkType, PoseLandmark> landmarks,
    required void Function() onClapCount,
    required bool isClapped,
    required void Function(bool) updateClapState,
    required void Function() onRepDetected,
  }) {
    final lw = landmarks[PoseLandmarkType.leftWrist];
    final rw = landmarks[PoseLandmarkType.rightWrist];
    final ls = landmarks[PoseLandmarkType.leftShoulder];
    final rs = landmarks[PoseLandmarkType.rightShoulder];

    if ([lw, rw, ls, rs].contains(null)) return;

    final wristDistance = (rw!.x - lw!.x).abs();
    final averageWristY = (rw.y + lw.y) / 2;
    final shoulderY = (ls!.y + rs!.y) / 2;
    final shoulderWidth = (rs.x - ls.x).abs();

    final armsAboveShoulder = averageWristY < shoulderY;
    final handsClose = wristDistance < shoulderWidth * 0.5;

    if (armsAboveShoulder && handsClose && !isClapped) {
      updateClapState(true);
    } else if ((!armsAboveShoulder || !handsClose) && isClapped) {
      onClapCount();
      onRepDetected();
      updateClapState(false);
    }
  }
}

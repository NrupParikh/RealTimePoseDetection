// Show exercise information dialog
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Models/excercise_data_model.dart';

final List<ExcerciseDataModel> exerciseList = [
  ExcerciseDataModel(
    title: 'Push-Up',
    type: ExcerciseType.pushup,
    gifPath: 'assets/myGif/pushup.gif',
    description:
        'A bodyweight exercise performed in a prone position by lowering and raising the body using the arms, targeting the chest, shoulders, and triceps.',
    poseTip:
        '- Keep your body in a straight line from head to heels.\n-Lower your chest by bending elbows close to your sides.',
    startPosition: "assets/myGif/start_pushup.jpg",
    advantage:
        "- Builds upper body strength (chest, shoulders, triceps).\n- Engages core for stability.\n -Requires no equipment and can be done anywhere.",
  ),
  ExcerciseDataModel(
    title: 'Squat',
    type: ExcerciseType.squat,
    gifPath: 'assets/myGif/squat.gif',
    description:
        'A lower-body exercise where the hips are lowered from a standing position and then raised back up, engaging the thighs, hips, and glutes.',
    poseTip:
        '- Keep your back straight and chest up throughout the movement.\n- Push hips back and make sure knees don’t go past your toes.',
    startPosition: "assets/myGif/start_squat.jpg",
    advantage:
        "- Strengthens legs, glutes, and hips.\n- Improves balance and mobility.\n - Boosts calorie burn and functional movement.",
  ),
  ExcerciseDataModel(
    title: 'Jumping Jack',
    type: ExcerciseType.jumpingJack,
    gifPath: 'assets/myGif/jumping_jack.gif',
    description:
        'A full-body aerobic movement involving jumping to a position with legs spread wide and hands overhead, then returning to the starting position. ',
    poseTip:
        '- Jump with feet wide and clap hands fully overhead.\nMaintain a tight core and land softly with knees slightly bent.',
    startPosition: "assets/myGif/start_jumping_jack.jpg",
    advantage:
        "- Increases heart rate for cardio fitness.\n- Works the entire body with dynamic movement.\n -Great warm-up or fat-burning exercise.",
  ),
  ExcerciseDataModel(
    title: 'Plank to Downward Dog',
    type: ExcerciseType.plankToDownwardDog,
    gifPath: 'assets/myGif/plank_to_downward_dog.gif',
    description:
        'A dynamic movement starting in a plank position, then pushing the hips up and back into a Downward Dog yoga pose, stretching the hamstrings and shoulders while building core strength.',
    poseTip:
        '- Start from a solid plank with a straight back and tight core.\n- Push your hips upward, forming an inverted V-shape.',
    startPosition: "assets/myGif/start_plank_to_downward_dog.jpg",
    advantage:
        "- Strengthens core, shoulders, and arms.\n- Improves flexibility in hamstrings and calves.\n - Enhances posture and body awareness.",
  ),
  ExcerciseDataModel(
    title: 'Over Head Arm Clap',
    type: ExcerciseType.overHeadArmClap,
    gifPath: 'assets/myGif/overhead_clap.gif',
    description:
        'An upper-body movement where the arms are raised and clapped overhead repeatedly, often performed while standing or as part of cardio routines to engage the shoulders and upper back.',
    poseTip:
        '- Raise your arms fully straight and clap above your head.\n- Stand tall, avoid arching your back, and engage your shoulders.',
    startPosition: "assets/myGif/start_over_head_clap.jpg",
    advantage:
        "- Activates shoulders and upper back.\n- Promotes shoulder mobility and circulation.\n- Easy to perform in warm-ups or light cardio.",
  ),
];
//  ======= AlertDialog Extension =======
extension AlertDialogExtensions on BuildContext {
  void showAlertDialog({
    required String message,
    String title = AppStrings.appName,
    String okButtonText = 'OK',
    String cancelButtonText = 'Cancel',
    bool showCancelButton = true,
    VoidCallback? onOkPressed,
    VoidCallback? onCancelPressed,
  }) {
    showDialog(
      context: this,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            if (showCancelButton)
              TextButton(
                onPressed: () {
                  Get.back();
                  if (onCancelPressed != null) {
                    onCancelPressed();
                  }
                },
                child: Text(cancelButtonText),
              ),
            TextButton(
              onPressed: () {
                Get.back();
                if (onOkPressed != null) {
                  onOkPressed();
                }
              },
              child: Text(okButtonText, style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }  
}

// Show exercise information dialog
import 'package:flutter/material.dart';
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

void showExerciseInfo(BuildContext mCtx, ExcerciseDataModel dataModel) {
  showDialog(
    context: mCtx,
    barrierDismissible: false,
    builder: (context) {
      final screenWidth = MediaQuery.of(context).size.width;
      return Dialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
        child: SizedBox(
          width: screenWidth * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    dataModel.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Scrollable content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
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
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dataModel.description,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Pose Tips',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dataModel.poseTip,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Advantages',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dataModel.advantage,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

              // Fixed OK button at bottom
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: TextButton(
                  onPressed: () => Navigator.of(mCtx).pop(),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

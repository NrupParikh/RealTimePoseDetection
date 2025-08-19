import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Components/permission_service.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Constants/page_name.dart';
import 'package:pose_detection/Models/excercise_data_model.dart';
import 'package:pose_detection/Utility/helper.dart';
import 'package:pose_detection/Utility/utility.dart';
import 'package:pose_detection/api/apiModels/fitness_plan_response.dart';
import 'package:tuple/tuple.dart'; // Adjust import path

class RecommandedExerciseList extends StatelessWidget {
  final List<WorkoutPlan> workoutPlan;

  const RecommandedExerciseList({super.key, required this.workoutPlan});

  Tuple2<String, String> getExerciseData(String exerciseName) {
    final name = exerciseName.toLowerCase();
    print("Tag_name ${name}");
    if (name.contains(ExcerciseType.squat.name.toLowerCase())) {
      return Tuple2(AppStrings.squatGif, AppStrings.squat);
    } else if (name.contains(ExcerciseType.pushup.name.toLowerCase())) {
      return Tuple2(AppStrings.pushUpGif, AppStrings.pushup);
    } else if (name.contains(
      ExcerciseType.plankToDownwardDog.name.toLowerCase(),
    )) {
      return Tuple2(
        AppStrings.plankToDownwardDogGif,
        AppStrings.plankToDownwardDog,
      );
    } else if (name.contains(ExcerciseType.jumpingJack.name.toLowerCase())) {
      return Tuple2(AppStrings.jumpingJackGif, AppStrings.jumpingJack);
    } else
      return Tuple2(AppStrings.overHeadArmClapGif, AppStrings.overHeadArmClap);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: workoutPlan.length,
        itemBuilder: (context, index) {
          final exercise = workoutPlan[index];
          return InkWell(
            onTap: () async {
              // Comparing Gemini AI Response exercise name with our exercise list and pass the item
              final item = exerciseList.firstWhere(
                (element) =>
                    element.type.name.toString() == exercise.exerciseName,
              );
              if (Platform.isAndroid) {
                PermissionService.requestAllPermissionsAndNavigate(
                  item,
                  context,
                );
              } else if (Platform.isIOS) {
                await Helper.navigateAndShowWorkoutSummary(
                  PageName.detection,
                  arguments: item,
                );
              }
            },
            child: buildExerciseCard(context, exercise),
          );
        },
      ),
    );
  }

  Widget buildExerciseCard(BuildContext context, WorkoutPlan exercise) {
    return Container(
      width: 100.0,
      margin: const EdgeInsets.only(right: 10.0),
      child: FrostedGlass(
        applyFilter: false,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        gradientColors: [
          ColorConstants.startColor.withValues(alpha: 0.6),
          ColorConstants.endColor.withValues(alpha: 0.6),
        ],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                getExerciseData(exercise.exerciseName).item1,
                fit: BoxFit.cover,
                width: 100,
                height: 70,
              ),
              // Exercise Name
              Text(
                getExerciseData(exercise.exerciseName).item2,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.0),
              // Exercise Value (Reps/Duration)
              Text(
                exercise.value,
                style: TextStyle(fontSize: 12, color: Colors.white70),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

FitnessPlanResponse fitnessPlanResponseFromJson(String str) =>
    FitnessPlanResponse.fromJson(json.decode(str));

class FitnessPlanResponse {
  final List<WorkoutPlan> workoutPlan;
  final EstimatedCaloriesBurned estimatedCaloriesBurned;

  FitnessPlanResponse({
    required this.workoutPlan,
    required this.estimatedCaloriesBurned,
  });

  factory FitnessPlanResponse.fromJson(Map<String, dynamic> json) {
    if (json['workout_plan'] == null ||
        json['estimated_calories_burned'] == null) {
      throw FormatException(
          "Invalid JSON structure: Missing 'workout_plan' or 'estimated_calories_burned'");
    }

    return FitnessPlanResponse(      
      workoutPlan: List<WorkoutPlan>.from(
        json["workout_plan"].map((x) => WorkoutPlan.fromJson(x)),
      ),      
      estimatedCaloriesBurned: EstimatedCaloriesBurned.fromJson(
        json["estimated_calories_burned"],
      ),
    );
  }
}

class EstimatedCaloriesBurned {
  final int perDay;
  final int perWeek;

  EstimatedCaloriesBurned({
    required this.perDay,
    required this.perWeek,
  });

  factory EstimatedCaloriesBurned.fromJson(Map<String, dynamic> json) {
    return EstimatedCaloriesBurned(
      perDay: json["per_day"],
      perWeek: json["per_week"],
    );
  }
}

class WorkoutPlan {
  final String exerciseName;
  final String type; // e.g., "reps" or "duration"
  final String value; // e.g., "3 sets of 12 reps" or "45 seconds"

  WorkoutPlan({
    required this.exerciseName,
    required this.type,
    required this.value,
  });

  
  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      exerciseName: json["exercise_name"],
      type: json["type"],
      value: json["value"],
    );
  }
}

// ====== Sample JSON structure for reference ======
/* 
{
    "workout_plan": [
        {
            "exercise_name": "pushup",
            "type": "reps",
            "value": "3 sets of 10 reps"
        },
        {
            "exercise_name": "squat",
            "type": "reps",
            "value": "3 sets of 12 reps"
        },
        {
            "exercise_name": "jumpingJack",
            "type": "duration",
            "value": "3 sets of 30 seconds"
        },
        {
            "exercise_name": "plankToDownwardDog",
            "type": "reps",
            "value": "3 sets of 8 reps"
        },
        {
            "exercise_name": "overHeadArmClap",
            "type": "duration",
            "value": "3 sets of 45 seconds"
        }
    ],
    "estimated_calories_burned": {
        "per_day": 300,
        "per_week": 2100
    }
}
*/
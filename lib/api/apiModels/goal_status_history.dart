import 'package:pose_detection/Utility/parsing_types.dart';

class GoalStatusHistory {
  final int age;
  final double height;
  final double weight;
  final String gender;
  final String goal;
  final int goalDuration;
  final int caloriesToBurn;
  final int goalDurationAchieved;
  final int caloriesBurned;
  final bool isDurationCompleted;
  final bool isCaloriesBurned;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GoalStatusHistory({
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.goal,
    required this.goalDuration,
    required this.caloriesToBurn,
    required this.goalDurationAchieved,
    required this.caloriesBurned,
    required this.isDurationCompleted,
    required this.isCaloriesBurned,
    this.createdAt,
    this.updatedAt,
  });

  factory GoalStatusHistory.fromJson(Map<String, dynamic> json) {
    return GoalStatusHistory(
      age: SafeParser.toInt(json['age']) ?? 0,
      height: SafeParser.toDouble(json['height']) ?? 0,
      weight: SafeParser.toDouble(json['weight']) ?? 0,
      gender: SafeParser.toStringVal(json['gender']) ?? '',
      goal: SafeParser.toStringVal(json['goal']) ?? '',
      goalDuration: SafeParser.toInt(json['goalDuration']) ?? 0,
      caloriesToBurn: SafeParser.toInt(json['caloriesToBurn']) ?? 0,
      goalDurationAchieved:
          SafeParser.toInt(json['goal_duration_achieved']) ?? 0,
      caloriesBurned: SafeParser.toInt(json['caloriesBurned']) ?? 0,
      isDurationCompleted:
          (SafeParser.toInt(json['isDurationCompleted']) ?? 0) == 1,
      isCaloriesBurned: (SafeParser.toInt(json['isCaloriesBurned']) ?? 0) == 1,
      createdAt: SafeParser.toDateTime(json['createdAt']),
      updatedAt: SafeParser.toDateTime(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
      'goal': goal,
      'goalDuration': goalDuration,
      'caloriesToBurn': caloriesToBurn,
      'goal_duration_achieved': goalDurationAchieved,
      'caloriesBurned': caloriesBurned,
      'isDurationCompleted': isDurationCompleted ? 1 : 0,
      'isCaloriesBurned': isCaloriesBurned ? 1 : 0,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

import 'package:pose_detection/Utility/parsing_types.dart' show SafeParser;

class Profile {
  final String name;
  final int age;
  final double height;
  final double weight;
  final String gender;
  final String goal;
  final int goalDuration;
  final double? caloriesStatus;
  final String createdAt;
  final String? updatedAt;

  Profile({
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.goal,
    required this.goalDuration,
    this.caloriesStatus,
    required this.createdAt,
    this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: SafeParser.toStringVal(json['name']) ?? 'User',
      age: SafeParser.toInt(json['age']) ?? 0,
      height: SafeParser.toDouble(json['height']) ?? 0,
      weight: SafeParser.toDouble(json['weight']) ?? 0,
      gender: SafeParser.toStringVal(json['gender']) ?? 'Other',
      goal: SafeParser.toStringVal(json['goal']) ?? '',
      goalDuration: SafeParser.toInt(json['goalDuration']) ?? 0,
      caloriesStatus: SafeParser.toDouble(json['caloriesStatus']),
      createdAt: SafeParser.toStringVal(json['createdAt']) ?? '',
      updatedAt: SafeParser.toStringVal(json['updatedAt']) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
      'goal': goal,
      'goalDuration': goalDuration,
      'caloriesStatus': caloriesStatus,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() {
    return 'Profile(name: $name,age: $age, height: $height, weight: $weight, gender: $gender, goal: $goal, Goal Duration: $goalDuration, caloriesStatus: $caloriesStatus, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  Profile copyWith({
    String? name,
    int? age,
    double? height,
    double? weight,
    String? gender,
    String? goal,
    int? goalDuration,
    double? caloriesStatus,
    String? createdAt,
    String? updatedAt,
  }) {
    return Profile(
      name: name ?? this.name,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      goal: goal ?? this.goal,
      goalDuration: goalDuration ?? this.goalDuration,
      caloriesStatus: caloriesStatus ?? this.caloriesStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /* Calculates how many days have passed since:
   `updatedAt` if caloriesStatus is 0 and updatedAt exists,
    otherwise uses updatedAt (if available) or falls back to createdAt.
  */

  int getDayCount() {
    String? dateString;

    if (caloriesStatus == 0 && updatedAt != null && updatedAt!.isNotEmpty) {
      dateString = updatedAt; // use updatedAt only when calories not burned yet
    } else {
      dateString =
          createdAt; // always fall back to createdAt for goal day counting
    }

    if (dateString == null || dateString.isEmpty) return 1;

    // Parse "yyyy-MM-dd HH:mm:ss"
    final DateTime baseDate = DateTime.parse(dateString.replaceFirst(' ', 'T'));
    final DateTime now = DateTime.now();

    final DateTime start = DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
    );
    final DateTime today = DateTime(now.year, now.month, now.day);

    final int diffDays = today.difference(start).inDays;

    return diffDays + 1; // inclusive
  }
}

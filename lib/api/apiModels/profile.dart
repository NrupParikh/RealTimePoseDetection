import 'package:pose_detection/Utility/parsing_types.dart' show SafeParser;

class Profile {
  final String? name;
  final int? age;
  final double? height;
  final double? weight;
  final String? gender;
  final String? goal;

  Profile({
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.goal,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: SafeParser.toStringVal(json['name']),
      age: SafeParser.toInt(json['age']),
      height: SafeParser.toDouble(json['height']),
      weight: SafeParser.toDouble(json['weight']),
      gender: SafeParser.toStringVal(json['gender']),
      goal: SafeParser.toStringVal(json['goal']),
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
    };
  }

  @override
  String toString() {
    return 'Profile(name: $name,age: $age, height: $height, weight: $weight, gender: $gender, goal: $goal)';
  }
}

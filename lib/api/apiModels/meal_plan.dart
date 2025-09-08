
class MealPlan {
  String? day;
  List<String>? breakfast;
  List<String>? lunch;
  List<String>? snack;
  List<String>? dinner;

  MealPlan({
    this.day,
    this.breakfast,
    this.lunch,
    this.snack,
    this.dinner,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      day: json['day'] as String?,
      breakfast: (json['breakfast'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      lunch: (json['lunch'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      snack: (json['snack'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      dinner: (json['dinner'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'breakfast': breakfast,
      'lunch': lunch,
      'snack': snack,
      'dinner': dinner,
    };
  }
}

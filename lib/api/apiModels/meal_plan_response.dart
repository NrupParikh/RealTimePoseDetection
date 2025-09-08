import 'dart:convert';

import 'package:pose_detection/api/apiModels/meal_plan.dart';

class MealPlanResponse {
  List<MealPlan>? mealPlan;

  MealPlanResponse({this.mealPlan});

  factory MealPlanResponse.fromJson(Map<String, dynamic> json) {
    return MealPlanResponse(
      mealPlan:
          (json['mealPlan'] as List<dynamic>?)
              ?.map((e) => MealPlan.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'mealPlan': mealPlan?.map((e) => e.toJson()).toList()};
  }

  /// For convenience (parsing string directly)
  static MealPlanResponse fromJsonString(String str) =>
      MealPlanResponse.fromJson(jsonDecode(str));

  String toJsonString() => jsonEncode(toJson());
}

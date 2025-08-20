import 'package:pose_detection/api/apiModels/fitness_plan_response.dart';

class FitnessPlanData {
  final FitnessPlanResponse? geminiFitnessPlan;
  final String? createdAt;

  FitnessPlanData({this.geminiFitnessPlan, this.createdAt});

  factory FitnessPlanData.fromJson(Map<String, dynamic> json) {
    return FitnessPlanData(
      geminiFitnessPlan:
          json['geminiFitnessPlan'] != null
              ? FitnessPlanResponse.fromJson(json['geminiFitnessPlan'])
              : null,
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "geminiFitnessPlan": geminiFitnessPlan?.toJson(),
      "created_at": createdAt,
    };
  }
}

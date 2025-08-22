import 'package:pose_detection/api/apiModels/fitness_tips_response.dart';

class FitnessTipsData {
  final FitnessTipsResponse? geminiFitnessTips;
  final String? createdAt;

  FitnessTipsData({this.geminiFitnessTips, this.createdAt});

  factory FitnessTipsData.fromJson(Map<String, dynamic> json) {
    return FitnessTipsData(
      geminiFitnessTips: json['geminiFitnessTips'] != null
          ? FitnessTipsResponse.fromJson(json['geminiFitnessTips'])
          : null,
      createdAt: json['created_at'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "geminiFitnessTips": geminiFitnessTips?.toJson(),
      "created_at": createdAt,
    };
  }
}
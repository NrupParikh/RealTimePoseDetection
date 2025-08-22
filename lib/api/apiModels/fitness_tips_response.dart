import 'dart:convert';

class FitnessTipsResponse {
  final List<String> fitnessTips;

  FitnessTipsResponse({required this.fitnessTips});

  factory FitnessTipsResponse.fromJson(Map<String, dynamic> json) {
    return FitnessTipsResponse(
      fitnessTips: List<String>.from(json['fitness_tips'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {'fitness_tips': fitnessTips};
  }

  /// Convert object to JSON string
  String toJsonString() => jsonEncode(toJson());

  /// Convert JSON string back to object
  factory FitnessTipsResponse.fromJsonString(String jsonString) {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return FitnessTipsResponse.fromJson(jsonMap);
  }
}

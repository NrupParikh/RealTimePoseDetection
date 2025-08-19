class FitnessTipsResponse {
  final List<String> fitnessTips;

  FitnessTipsResponse({required this.fitnessTips});

  factory FitnessTipsResponse.fromJson(Map<String, dynamic> json) {
    return FitnessTipsResponse(
      fitnessTips: List<String>.from(json['fitness_tips'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fitness_tips': fitnessTips,
    };
  }
}

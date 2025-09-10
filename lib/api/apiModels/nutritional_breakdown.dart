class NutritionalBreakdown {
  final String protein;
  final String carbs;
  final String fats;
  final String fiber;

  NutritionalBreakdown({
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.fiber,
  });

  factory NutritionalBreakdown.fromJson(Map<String, dynamic> json) {
    return NutritionalBreakdown(
      protein: json['protein'] ?? "",
      carbs: json['carbs'] ?? "",
      fats: json['fats'] ?? "",
      fiber: json['fiber'] ?? "", 
    );
  }

  Map<String, dynamic> toJson() {
    return {"protein": protein, "carbs": carbs, "fats": fats, "fiber": fiber};
  }
}
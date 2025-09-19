import 'dart:convert';

import 'package:pose_detection/api/apiModels/nutritional_breakdown.dart';

class RecipeResponse {
  final String recipeName;
  final String preparationTime;
  final String cookingTime;
  final String calories;
  final List<IngredientSection> ingredients;
  final List<InstructionSection> instructions;
  final NutritionalBreakdown nutritionalBreakdown;
  String youtubeUrl;

  RecipeResponse({
    required this.recipeName,
    required this.preparationTime,
    required this.cookingTime,
    required this.calories,
    required this.ingredients,
    required this.instructions,
    required this.nutritionalBreakdown,
    required this.youtubeUrl,
  });

  factory RecipeResponse.fromJson(Map<String, dynamic> json) {
    return RecipeResponse(
      recipeName: json["recipe_name"] ?? "",
      preparationTime: json["prep_time"] ?? "",
      cookingTime: json["cook_time"] ?? "",
      calories: json["calories"] ?? "",
      ingredients:
          (json["ingredients"] as List?)
              ?.map(
                (e) => IngredientSection.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      instructions:
          (json["instructions"] as List?)
              ?.map(
                (e) => InstructionSection.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      nutritionalBreakdown: NutritionalBreakdown.fromJson(
        json["nutrition"] ?? {},
      ),
      youtubeUrl: json["yt_url"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "recipe_name": recipeName,
    "prep_time": preparationTime,
    "cook_time": cookingTime,
    "calories": calories,
    "ingredients": ingredients.map((e) => e.toJson()).toList(),
    "instructions": instructions.map((e) => e.toJson()).toList(),
    "nutrition": nutritionalBreakdown.toJson(),
    "yt_url": youtubeUrl,
  };

  static RecipeResponse fromJsonString(String str) {
    final jsonData = json.decode(str) as Map<String, dynamic>;
    return RecipeResponse.fromJson(jsonData);
  }

    String toJsonString() => jsonEncode(toJson());
}

class IngredientSection {
  final String section;
  final List<String> items;

  IngredientSection({required this.section, required this.items});

  factory IngredientSection.fromJson(Map<String, dynamic> json) {
    return IngredientSection(
      section: json["section"] ?? "",
      items: (json["items"] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {"section": section, "items": items};
}

class InstructionSection {
  final String section;
  final List<String> steps;

  InstructionSection({required this.section, required this.steps});

  factory InstructionSection.fromJson(Map<String, dynamic> json) {
    return InstructionSection(
      section: json["section"] ?? "",
      steps: (json["steps"] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {"section": section, "steps": steps};
}

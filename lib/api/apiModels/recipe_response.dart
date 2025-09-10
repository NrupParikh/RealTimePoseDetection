import 'dart:convert';

import 'package:pose_detection/api/apiModels/nutritional_breakdown.dart';

class RecipeResponse {
  final String recipeName;
  final String preparationTime;
  final String cookingTime;
  final String calories;
  final List<IngredientSection> ingredients;
  final List<InstructionSection> instructions;
  // final List<String> ingredients;
  // final List<String> instructions;
  final NutritionalBreakdown nutritionalBreakdown;
  final String youtubeUrl;

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

  /// Factory constructor to create Recipe from Map
   factory RecipeResponse.fromJson(Map<String, dynamic> json) {
    return RecipeResponse(
      recipeName: json["recipe_name"] ?? "",
      preparationTime: json["preparation_time"] ?? "",
      cookingTime: json["cooking_time"] ?? "",
      calories: json["calories"] ?? "",
      ingredients: (json["ingredients"] as List<dynamic>)
          .map((e) => IngredientSection.fromJson(e))
          .toList(),
      instructions: (json["instructions"] as List<dynamic>)
          .map((e) => InstructionSection.fromJson(e))
          .toList(),
      nutritionalBreakdown:
          NutritionalBreakdown.fromJson(json["nutritional_breakdown"]),
      youtubeUrl: json["youtube_url"] ?? "",
    );
  }

  /// Convert Recipe to Map
    Map<String, dynamic> toJson() => {
        "recipe_name": recipeName,
        "preparation_time": preparationTime,
        "cooking_time": cookingTime,
        "calories": calories,
        "ingredients": ingredients.map((e) => e.toJson()).toList(),
        "instructions": instructions.map((e) => e.toJson()).toList(),
        "nutritional_breakdown": nutritionalBreakdown.toJson(),
        "youtube_url": youtubeUrl,
      };

   static RecipeResponse fromJsonString(String str) {
    final jsonData = json.decode(str) as Map<String, dynamic>;
    return RecipeResponse.fromJson(jsonData);
  }


}

class IngredientSection {
  final String section;
  final List<String> items;

  IngredientSection({required this.section, required this.items});

  factory IngredientSection.fromJson(Map<String, dynamic> json) {
    return IngredientSection(
      section: json["section"] ?? "",
      items: List<String>.from(json["items"] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        "section": section,
        "items": items,
      };
}

class InstructionSection {
  final String section;
  final List<String> steps;

  InstructionSection({required this.section, required this.steps});

  factory InstructionSection.fromJson(Map<String, dynamic> json) {
    return InstructionSection(
      section: json["section"] ?? "",
      steps: List<String>.from(json["steps"] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        "section": section,
        "steps": steps,
      };
}

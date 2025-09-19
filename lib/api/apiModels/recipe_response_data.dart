import 'package:pose_detection/api/apiModels/recipe_response.dart';

class RecipeData {
  final String recipeName;
  final List<RecipeResponse> recipeDescription;

  RecipeData({
    required this.recipeName,
    required this.recipeDescription,
  });

  factory RecipeData.fromJson(Map<String, dynamic> json) {
    return RecipeData(
      recipeName: json['recipe_name'] ?? "",
      recipeDescription: (json['recipe_description'] as List?)
              ?.map((e) => RecipeResponse.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "recipe_name": recipeName,
      "recipe_description":
          recipeDescription.map((e) => e.toJson()).toList(),
    };
  }
}



// class RecipeData {
//   final String recipeName;
//   final RecipeResponse? recipeDescription;

//   RecipeData({
//     required this.recipeName,
//     this.recipeDescription,
//   });

//   factory RecipeData.fromJson(Map<String, dynamic> json) {
//     return RecipeData(
//       recipeName: json['recipe_name'],
//       recipeDescription: json['recipe_description'] != null
//           ? RecipeResponse.fromJson(json['recipe_description'])
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "recipe_name": recipeName,
//       "recipe_description": recipeDescription?.toJson(),
//     };
//   }
// }


// Fruit Chat, Dhokla, Moong Dal Chilla

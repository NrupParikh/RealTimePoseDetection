import 'package:get/get.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/api/apiModels/recipe_response.dart';

class RecipeController extends GetxController {
  final Map<String, dynamic> recipe;
  RecipeController(this.recipe);
  final RxString title = AppStrings.recipe.obs;
  final Rx<RecipeResponse?> recipeDataModel = Rx<RecipeResponse?>(null);

  @override
  void onInit() {
    super.onInit();
    print("Tag_recipe_controller");
    print("Recipe Title: ${recipe["title"]}");
    title.value = recipe['title'];
    recipeDataModel.value = RecipeResponse.fromJsonString(newText2);
    print("Tag_recipeDataModel.value ${recipeDataModel.value?.calories}");
   
  }

  // Request
  /**
 * "JSON only. Recipe: Vegetable Biryani with Raita. Fields: recipe_name, prep_time, cook_time, calories, ingredients[{section,items[]}], instructions[{section,steps[]}], nutrition{protein,carbs,fats,fiber}, yt_url. Rules: short vals (30m not 30 minutes), group items, concise steps, no extra words, readable."
 * 
 */

String newText = """{
  "recipe_name": "Vegetable Biryani with Raita",
  "prep_time": "30m",
  "cook_time": "45m",
  "calories": "450",
  "ingredients": [
    {
      "section": "Biryani",
      "items": [
        "1 cup basmati rice",
        "1 onion, chopped",
        "1 tomato, chopped",
        "1 cup mixed vegetables",
        "1/2 cup yogurt",
        "2 tbsp biryani masala",
        "1 tsp ginger-garlic paste",
        "1/4 cup cilantro, chopped",
        "Salt to taste",
        "Oil/ghee"
      ]
    },
    {
      "section": "Raita",
      "items": [
        "1 cup yogurt",
        "1/2 cucumber, diced",
        "1/4 cup cilantro, chopped",
        "Salt to taste"
      ]
    }
  ],
  "instructions": [
    {
      "section": "Biryani",
      "steps": [
        "Wash and soak rice for 30m",
        "Sauté onions, add ginger-garlic paste, and vegetables. ",
        "Add biryani masala, salt, and tomatoes",
        "Add soaked rice and yogurt. Mix well",
        "Cook on low heat until rice is done"
      ]
    },
    {
      "section": "Raita",
      "steps": [
        "Mix yogurt, cucumber, cilantro, and salt"
      ]
    }
  ],
  "nutrition": {
    "protein": "12g",
    "carbs": "70g",
    "fats": "15g",
    "fiber": "8g"
  },
  "yt_url": "https://www.youtube.com/results?search_query=vegetable+biryani+recipe"
}""";

String newText2 = """{
  "recipe_name": "Vegetable Idli with Sambhar",
  "prep_time": "20m",
  "cook_time": "30m",
  "calories": "250",
  "ingredients": [
    {
      "section": "Idli Batter",
      "items": [
        "1 cup urad dal",
        "1 cup rice",
        "1/2 tsp fenugreek seeds",
        "Salt to taste"
      ]
    },
    {
      "section": "Vegetables",
      "items": [
        "1/2 cup chopped carrots",
        "1/4 cup chopped beans",
        "1/4 cup chopped bell peppers",
        "1/4 cup chopped onions",
        "1/4 cup chopped tomatoes",
        "1 tbsp chopped cilantro"
      ]
    },
    {
      "section": "Sambhar",
      "items": [
        "1 tbsp oil",
        "1 tsp mustard seeds",
        "1/2 tsp urad dal",
        "1/2 tsp cumin seeds",
        "1 dry red chili",
        "1/4 tsp turmeric powder",
        "1/2 tsp coriander powder",
        "1/4 tsp garam masala",
        "1 cup sambhar powder",
        "Salt to taste",
        "4 cups water",
        "1 cup chopped vegetables"
      ]
    }
  ],
  "instructions": [
    {
      "section": "Idli Batter",
      "steps": [
        "Wash and soak urad dal, rice, and fenugreek seeds for at least 4 hours.",
        "Grind to a smooth batter.",
        "Ferment for 8-10 hours."
      ]
    },
    {
      "section": "Vegetables",
      "steps": [
        "Mix all the vegetables together."
      ]
    },
    {
      "section": "Sambhar",
      "steps": [
        "Heat oil in a pan. Add mustard seeds, urad dal, and cumin seeds. Once they splutter, add red chili and saute for a minute.",
        "Add turmeric powder, coriander powder, garam masala, and sambhar powder. Saute for a minute.",
        "Add water and salt. Bring it to a boil.",
        "Add the mixed vegetables and simmer for 10 minutes."
      ]
    },
    {
      "section": "Cooking Idli",
      "steps": [
        "Add chopped vegetables to the idli batter.",
        "Steam the batter in greased idli molds for 10-12 minutes."
      ]
    }
  ],
  "nutrition": {
    "protein": "15g",
    "carbs": "40g",
    "fats": "5g",
    "fiber": "5g"
  },
  "yt_url": "https://www.youtube.com/results?search_query=vegetable+idli+recipe"
}""";
}


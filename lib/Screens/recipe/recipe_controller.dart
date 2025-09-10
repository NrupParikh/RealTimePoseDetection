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
    recipeDataModel.value = RecipeResponse.fromJsonString(newText);
    print("Tag_recipeDataModel.value ${recipeDataModel.value?.calories}");
   
  }

  // Request
  /**
 * "Give a healthy recipe in JSON for Vegetable biriyani with raita. Fields: recipe_name, preparation_time, cooking_time, calories, ingredients[{section,items[]}], instructions[{section,steps[]}], nutritional_breakdown{protein,carbs,fats,fiber}. JSON only."
 * 
 */
  String recipeText = """[
  {
    "recipe_name": "Healthy Vegetable Biryani with Raita",
    "preparation_time": "30 minutes",
    "cooking_time": "45 minutes",
    "calories": "450 kcal",
    "ingredients": [
      "Basmati rice - 2 cups",
      "Mixed vegetables (carrots, peas, beans, potatoes, cauliflower) - 2 cups, chopped",
      "Onion - 1 large, thinly sliced",
      "Tomato - 2 medium, chopped",
      "Ginger-garlic paste - 2 tablespoons",
      "Green chilies - 2-3, slit",
      "Mint leaves - 1/4 cup, chopped",
      "Cilantro - 1/4 cup, chopped",
      "Biryani masala - 2 tablespoons",
      "Turmeric powder - 1 teaspoon",
      "Red chili powder - 1 teaspoon (optional)",
      "Ghee/Oil - 3 tablespoons",
      "Salt - to taste",
      "Whole spices (bay leaf, cardamom, cinnamon, cloves) - as needed",
      "Yogurt - 1 cup",
      "Cucumber - 1/2, grated",
      "Carrot - 1/4, grated",
      "Cilantro - 1 tablespoon, chopped (for raita)",
      "Salt - to taste (for raita)",
      "Cumin powder - 1/2 teaspoon (for raita)"
    ],
    "instructions": [
      "Soak basmati rice in water for 30 minutes, then drain.",
      "Heat ghee/oil in a large pot or pressure cooker.",
      "Add whole spices and saute for a minute.",
      "Add sliced onions and sauté until golden brown.",
      "Add ginger-garlic paste and green chilies, sauté for a minute.",
      "Add chopped tomatoes, turmeric powder, red chili powder (if using), and biryani masala. Cook until tomatoes are soft.",
      "Add mixed vegetables and salt, cook for 5-7 minutes.",
      "Add soaked rice, mint leaves, and cilantro. Mix gently.",
      "Add 4 cups of water (or as needed for rice) and bring to a boil.",
      "Cover the pot or pressure cooker and cook on low heat until rice is cooked (about 15-20 minutes). If using a pressure cooker, cook for 2 whistles.",
      "For raita, mix yogurt, grated cucumber, grated carrot, chopped cilantro, salt, and cumin powder in a bowl.",
      "Serve hot vegetable biryani with raita."
    ],
      _breakdown": {
      "protein": "12 g",
      "carbs": "70 g",
      "fats": "10 g",
      "fiber": "8 g"
    }
  }
]
""";

String newText = """{
  "recipe_name": "Vegetable Biryani with Raita",
  "preparation_time": "30 minutes",
  "cooking_time": "45 minutes",
  "calories": "350 per serving",
  "ingredients": [
    {
      "section": "For the Biryani",
      "items": [
        "1 cup basmati rice",
        "1 medium onion, finely chopped",
        "1 cup mixed vegetables (carrots, peas, beans, cauliflower)",
        "1/2 cup mint leaves, chopped",
        "1/4 cup coriander leaves, chopped",
        "2 green chilies, finely chopped",
        "1 inch ginger, grated",
        "2 cloves garlic, minced",
        "1 teaspoon turmeric powder",
        "1 teaspoon biryani masala",
        "1/2 teaspoon cumin powder",
        "1/4 teaspoon saffron strands",
        "1/4 cup yogurt",
        "2 tablespoons oil",
        "Salt to taste"
      ]
    },
    {
      "section": "For the Raita",
      "items": [
        "1 cup yogurt",
        "1/2 cucumber, grated",
        "1/4 cup chopped coriander leaves",
        "1/4 teaspoon cumin powder",
        "Salt to taste"
      ]
    }
  ],
  "instructions": [
    {
      "section": "Preparing the Rice",
      "steps": [
        "Wash the basmati rice thoroughly and soak it in water for 30 minutes.",
        "Heat oil in a pan and add the chopped onions. Saute until golden brown.",
        "Add ginger, garlic, and green chilies. Saute for a minute.",
        "Add mixed vegetables and saute for 2-3 minutes.",
        "Add turmeric powder, biryani masala, cumin powder, and salt. Mix well and saute for another minute.",
        "Add soaked rice, mint leaves, coriander leaves, and saffron strands. Mix gently.",
        "Add yogurt and mix well. Add enough water (about 1.5 cups) to cook the rice.",
        "Bring to a boil, reduce heat to low, cover, and simmer for 15-20 minutes, or until the rice is cooked and the water is absorbed."
      ]
    },
    {
      "section": "Preparing the Raita",
      "steps": [
        "In a bowl, combine yogurt, grated cucumber, chopped coriander leaves, cumin powder, and salt.",
        "Mix well and refrigerate for at least 30 minutes before serving."
      ]
    },
    {
      "section": "Serving",
      "steps": [
        "Garnish the biryani with extra coriander leaves.",
        "Serve hot with raita."
      ]
    }
  ],
  "nutritional_breakdown": {
    "protein": "10g",
    "carbs": "60g",
    "fats": "10g",
    "fiber": "5g"
  },
  "youtube_url": "https://www.youtube.com/watch?v=mfCW8Xtljeg"
}""";
}

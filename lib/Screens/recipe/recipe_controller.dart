import 'package:get/get.dart';
import 'package:pose_detection/Components/fancy_alert_dialog.dart';
import 'package:pose_detection/Components/session_expire_controller.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Constants/gemini_prompt.dart';
import 'package:pose_detection/Singleton/api_service_singleton.dart';
import 'package:pose_detection/api/apiModels/recipe_response.dart';
import 'package:pose_detection/api/apiModels/recipe_response_data.dart';
import 'package:pose_detection/api/api_service.dart';
import 'package:pose_detection/api/gemini_api_service.dart';
import 'package:tuple/tuple.dart';

class RecipeController extends GetxController {
  final Map<String, dynamic> recipe;
  RecipeController(this.recipe);
  final RxString title = AppStrings.recipe.obs;
  final ApiService _apiService = ApiServiceSingleton().apiService;
  final Rx<RecipeResponse?> recipeDataModel = Rx<RecipeResponse?>(null);
  final geminiService = GeminiApiService();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final SessionExpireController sessionController =
      Get.find<SessionExpireController>();

  @override
  void onInit() async {
    super.onInit();
    print("Tag_recipe_controller");
    print("Recipe Title: ${recipe["title"]}");
    title.value = recipe['title'];
    // title.value = "Moong Dal Chilla";
    // recipeDataModel.value = RecipeResponse.fromJsonString(moongDalChilla);
    // print("Tag_recipeDataModel.value ${recipeDataModel.value?.calories}");

    // await getGeminiRecipe(title.value);
   
    handleRecipe(title.value);
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> handleRecipe(String recipeName) async {
    // =========== OUR API CHECK
    await getRecipeFromAPI(recipeName).then((result) async {
      if (result.item1) {
        print("Success");
      } else if (result.item3 == 401) {
        displaySessionExpireDialog(result);
      } else {
        // =========== GEMINI API CALL
        await callRecipeFromGemini(title.value);
      }
    });
  }

  Future<void> callRecipeFromGemini(String recipeName) async {
    final recipe = await getGeminiRecipe(recipeName);

    if (recipe != null) {
      final recipeDataInString = recipeDataModel.value?.toJsonString();
      print("Tag_recipeName ${recipeName}");
      print("Tag_recipeDataInString ${recipeDataInString}");
      // =========== SAVE TO OUR API
      final result = await saveRecipe(recipeName, recipeDataInString!);
      if (result.item1) {
      } else if (result.item3 == 401) {
        displaySessionExpireDialog(result);
      } else {
        showFancyDialog(result.item2.toString());
      }
    }
  }

  void displaySessionExpireDialog(Tuple3<bool, String?, int> result) {
    if (Get.context != null && !Get.isDialogOpen!) {
      sessionController.showSessionExpiredDialog(
        Get.context!,
        result.item2.toString(),
      );
    }
  }

  void showFancyDialog(String message) {
    if (Get.context != null && !Get.isDialogOpen!) {
      FancyAlertDialog.showFancyAlertDialog(
        context: Get.context!,
        title: AppStrings.appName,
        message: message,
        onOkPressed: () {
          Get.back();
        },
        onCancelPressed: null,
      );
    }
  }

  Future<RecipeResponse?> getGeminiRecipe(String recipeName) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      recipeDataModel.value = null;

      final recipePrompt = GeminiPrompt.buildRecipePrompt(
        recipeName: recipeName,
        jsonStructure: GeminiPrompt.jsonStructureForRecipe,
      );

      final jsonMap = await geminiService.fetchJsonResponse(recipePrompt);
      recipeDataModel.value = RecipeResponse.fromJson(jsonMap);

      if (recipeDataModel.value != null) {
        return recipeDataModel.value;
      }
      return null;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Request
  /**
 * "JSON only. Recipe: Vegetable Biryani with Raita. Fields: recipe_name, prep_time, cook_time, calories, ingredients[{section,items[]}], instructions[{section,steps[]}], nutrition{protein,carbs,fats,fiber}, yt_url. Rules: short vals (30m not 30 minutes), group items, concise steps, no extra words, readable."
 * 
 */

  String vegBiriyaniWithRaita = """{
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

  String vegIdliWithSambhar = """{
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

  String moongDalChilla = """{
  "recipe_name": "Moong Dal Chilla",
  "prep_time": "6h",
  "cook_time": "20m",
  "calories": "220",
  "ingredients": [
    {
      "section": "Batter",
      "items": [
        "1 cup moong dal",
        "1/2 inch ginger",
        "1-2 green chilies",
        "1/4 tsp asafoetida",
        "Salt to taste",
        "Water as needed"
      ]
    },
    {
      "section": "Vegetables",
      "items": [
        "1/4 cup chopped onion",
        "1/4 cup chopped tomato",
        "1/4 cup chopped coriander leaves",
        "1/4 tsp red chili powder",
        "1/4 tsp garam masala"
      ]
    },
    {
      "section": "Other",
      "items": [
        "Oil for cooking"
      ]
    }
  ],
  "instructions": [
    {
      "section": "Preparation",
      "steps": [
        "Soak moong dal for 6 hours.",
        "Grind into a smooth batter with ginger, green chilies, and asafoetida.",
        "Add salt and mix well."
      ]
    },
    {
      "section": "Mixing Vegetables",
      "steps": [
        "Add chopped onion, tomato, coriander leaves, red chili powder, and garam masala to the batter.",
        "Mix everything evenly."
      ]
    },
    {
      "section": "Cooking",
      "steps": [
        "Heat a non-stick tawa and grease lightly with oil.",
        "Pour a ladleful of batter and spread into a thin circle.",
        "Cook on medium flame until golden on one side.",
        "Flip and cook the other side until crisp.",
        "Repeat with remaining batter."
      ]
    },
    {
      "section": "Serving",
      "steps": [
        "Serve hot moong dal chilla with green chutney or yogurt."
      ]
    }
  ],
  "nutrition": {
    "protein": "12g",
    "carbs": "35g",
    "fats": "6g",
    "fiber": "6g"
  },
  "yt_url": "https://www.youtube.com/watch?v=31uzn1F2h7c"
}""";

  Future<Tuple3<bool, String?, int>> saveRecipe(
    String recipeName,
    String recipeData,
  ) async {
    print("Tag_Save_recipe_Function");
    try {
      isLoading.value = true;
      var appResponse = await _apiService.saveRecipeAPI(
        recipe: recipeName,
        recipeData: recipeData,
      );
      // For 200 or 201 handling we use result=1
      if (appResponse.result == 1) {
        isLoading.value = false;
        return Tuple3(
          true,
          appResponse.message.toString(),
          appResponse.statusCode.toInt(),
        );
      } else {
        isLoading.value = false;
        return Tuple3(
          false,
          appResponse.message.toString(),
          appResponse.statusCode.toInt(),
        );
      }
    } catch (ex) {
      isLoading.value = false;
      return Tuple3(false, "$ex", 0);
    }
  }

  Future<Tuple3<bool, String?, int>> getRecipeFromAPI(String recipeName) async {
    print("Tag_getRecipeFromAPI");
    try {
      isLoading.value = true;
      var appResponse = await _apiService.getRecipeAPI(recipeName);
      if (appResponse.statusCode == 200) {
        print("Tag_success200");
        isLoading.value = false;
        if (appResponse.data is Map<String, dynamic>) {
          print("Tag_appResponse.data is a Map");
          try {
            final RecipeData data = RecipeData.fromJson(appResponse.data);
            recipeDataModel.value =
                recipeDataModel.value =
                    data.recipeDescription.isNotEmpty
                        ? data.recipeDescription.first
                        : null;
            print("Tag_recipe_name ${data.recipeName.toString()}");
            print("Tag_recipe_data ${data.recipeDescription}");
            return Tuple3(
              true,
              appResponse.message.toString(),
              appResponse.statusCode.toInt(),
            );
          } catch (e) {
            isLoading.value = false;
            return Tuple3(
              false,
              "Error parsing ApiResponse",
              appResponse.statusCode.toInt(),
            );
          }
        } else {
          print("Tag_appResponse.data is not a Map");
          isLoading.value = false;
          return Tuple3(
            false,
            "appResponse.data is not a Map",
            appResponse.statusCode.toInt(),
          );
        }
      } else if (appResponse.statusCode == 401) {
        isLoading.value = false;
        return Tuple3(
          false,
          appResponse.message.toString(),
          appResponse.statusCode.toInt(),
        );
      } else {
        isLoading.value = false;
        return Tuple3(
          false,
          appResponse.message.toString(),
          appResponse.statusCode.toInt(),
        );
      }
    } catch (ex) {
      isLoading.value = false;
      return Tuple3(false, "$ex", 0);
    }
  }
}

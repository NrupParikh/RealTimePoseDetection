import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Screens/recipe/recipe_controller.dart';
import 'package:pose_detection/Screens/recipe/recipe_tile.dart';

class Recipe extends StatefulWidget {
  const Recipe({super.key});

  @override
  State<Recipe> createState() => RecipeState();
}

class RecipeState extends State<Recipe> {
  final controller = Get.find<RecipeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.recipeDataModel;
      final ingredients = data.value?.ingredients;
      final instructions = data.value?.instructions;
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            AppStrings.recipe,
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/login_bg.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: FrostedGlass(
                applyFilter: false,
                borderRadius: BorderRadius.zero,
                gradientColors: [
                  ColorConstants.startColor.withValues(alpha: 0.8),
                  ColorConstants.endColor.withValues(alpha: 0.8),
                ],
                child: const SizedBox.expand(),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        controller.title.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Preparation / Cooking / Calories row
                      FrostedGlass(
                        applyFilter: false,
                        borderRadius: BorderRadius.zero,
                        gradientColors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.black.withValues(alpha: 0.3),
                        ],
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      AppStrings.preparation.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      data.value!.preparationTime,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      AppStrings.cookingTime.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      data.value!.cookingTime,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      AppStrings.calories.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      data.value!.calories,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Ingredients Header
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.ingredients.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          ExpansionPanelList.radio(
                            dividerColor: Colors.white,
                            expandIconColor: Colors.white,
                            animationDuration: const Duration(
                              milliseconds: 500,
                            ),
                            elevation: 0,
                            children:
                                ingredients!.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final data = entry.value;
                                  return ExpansionPanelRadio(
                                    value: index,
                                    canTapOnHeader: true,
                                    splashColor: Colors.transparent,
                                    backgroundColor: Colors.black.withValues(
                                      alpha: 0.3,
                                    ),
                                    headerBuilder: (context, isExpanded) {
                                      return ListTile(
                                        title: Text(
                                          data.section,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                    body: Column(
                                      children: [
                                        RecipeTile(
                                          icon: Icons.list_alt_outlined,
                                          title: AppStrings.items,
                                          items: data.items,
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Instructions Header
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.instructions.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          ExpansionPanelList.radio(
                            dividerColor: Colors.white,
                            expandIconColor: Colors.white,
                            animationDuration: const Duration(
                              milliseconds: 500,
                            ),
                            elevation: 0,
                            children:
                                instructions!.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final data = entry.value;
                                  return ExpansionPanelRadio(
                                    value: index,
                                    canTapOnHeader: true,
                                    splashColor: Colors.transparent,
                                    backgroundColor: Colors.black.withValues(
                                      alpha: 0.3,
                                    ),
                                    headerBuilder: (context, isExpanded) {
                                      return ListTile(
                                        title: Text(
                                          data.section,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                    body: Column(
                                      children: [
                                        RecipeTile(
                                          icon: Icons.list_alt_outlined,
                                          title: AppStrings.items,
                                          items: data.steps,
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppStrings.nutritionalBreakdown.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      FrostedGlass(
                        applyFilter: false,
                        borderRadius: BorderRadius.zero,
                        gradientColors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.black.withValues(alpha: 0.3),
                        ],
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      AppStrings.protein.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      data.value!.nutritionalBreakdown.protein,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      AppStrings.carbs.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      data.value!.nutritionalBreakdown.carbs,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      AppStrings.fats.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      data.value!.nutritionalBreakdown.fats,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      AppStrings.fiber.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      data.value!.nutritionalBreakdown.fiber,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

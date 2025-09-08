import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Screens/mealPlan/meal_plan_controller.dart';
import 'package:pose_detection/Screens/exerciseList/navigationDrawer/my_navigation_drawer.dart';

class MealPlanTest extends StatefulWidget {
  const MealPlanTest({super.key});

  @override
  State<MealPlanTest> createState() => MealPlanState();
}

class MealPlanState extends State<MealPlanTest> {
  final controller = Get.find<MealPlanController>();

  @override
  Widget build(BuildContext context) {
    final mealPlanResponse = controller.mealPlanDataModel.value;
    final mealPlans = mealPlanResponse?.mealPlan;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          AppStrings.weeklyMealPlan,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: MyNavigationDrawer(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/login_bg.jpg", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: FrostedGlass(
              applyFilter: false,
              borderRadius: BorderRadius.zero,
              gradientColors: [
                ColorConstants.startColor.withValues(alpha: 0.8),
                ColorConstants.endColor.withValues(alpha: 0.8),
              ],
              child: SizedBox.expand(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  (mealPlans == null || mealPlans.isEmpty)
                      ? Center(
                        child: Text(
                          "No meal plan found",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                      : ListView.separated(
                        itemBuilder: (context, index) {
                          final data = mealPlans[index];
                          return FrostedGlass(
                            applyFilter: false,
                            borderRadius: BorderRadius.circular(12),
                            gradientColors: [
                              ColorConstants.startColor.withValues(alpha: 0.3),
                              ColorConstants.endColor.withValues(alpha: 0.3),
                            ],
                            child: Theme(
                              data: Theme.of(
                                context,
                              ).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                title: Text(
                                  data.day ?? "Day",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Colors.black.withValues(
                                  alpha: 0.3,
                                ),
                                iconColor: Colors.white,
                                collapsedIconColor: Colors.white,
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      Icons.breakfast_dining_outlined,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      'Breakfast',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "- ${data.breakfast?[0]} or\n- ${data.breakfast?[1]}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.lunch_dining_outlined,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      'Lunch',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "- ${data.lunch?[0]}\n- ${data.lunch?[1]}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.brunch_dining_outlined,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      'Snacks',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "- ${data.snack?[0]}\n- ${data.snack?[1]}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.dinner_dining_outlined,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      'Dinner',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "- ${data.dinner?[0]}\n- ${data.dinner?[1]}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 8),
                        itemCount: mealPlans.length,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

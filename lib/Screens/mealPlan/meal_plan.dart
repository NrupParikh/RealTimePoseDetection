import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Screens/mealPlan/meal_plan_controller.dart';
import 'package:pose_detection/Screens/exerciseList/navigationDrawer/my_navigation_drawer.dart';
import 'package:pose_detection/Screens/mealPlan/meal_tile.dart';

class MealPlan extends StatefulWidget {
  const MealPlan({super.key});

  @override
  State<MealPlan> createState() => MealPlanState();
}

class MealPlanState extends State<MealPlan> {
  final controller = Get.find<MealPlanController>();
    
  @override
  Widget build(BuildContext context) {
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
            child: Obx(() {
              final mealPlanResponse = controller.mealPlanDataModel.value;
              final mealPlans = mealPlanResponse?.mealPlan;
              return Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: 8,
                ),
                child:
                    controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : controller.errorMessage.value.isNotEmpty
                        ? Center(
                          child: Text(
                            controller.errorMessage.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                        : (mealPlans == null || mealPlans.isEmpty)
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
                        : LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: ExpansionPanelList.radio(
                                  dividerColor: Colors.white,
                                  expandIconColor: Colors.white,
                                  animationDuration: const Duration(
                                    milliseconds: 500,
                                  ),
                                  elevation: 0,
                                  children:
                                      mealPlans.asMap().entries.map((entry) {
                                        final index = entry.key;
                                        final data = entry.value;
                                        return ExpansionPanelRadio(
                                          value: index,
                                          canTapOnHeader: true,
                                          splashColor: Colors.transparent,
                                          backgroundColor: Colors.black
                                              .withValues(alpha: 0.3),
                                          headerBuilder: (context, isExpanded) {
                                            return ListTile(
                                              title: Text(
                                                data.day ?? "Day",
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
                                              MealTile(
                                                icon:
                                                    Icons
                                                        .breakfast_dining_outlined, 
                                                title: AppStrings.breakfast,
                                                items: data.breakfast,
                                              ),
                                              MealTile(
                                                icon:
                                                    Icons.lunch_dining_outlined,
                                                title: AppStrings.lunch,
                                                items: data.lunch,
                                              ),
                                              MealTile(
                                                icon:
                                                    Icons
                                                        .brunch_dining_outlined,
                                                title: AppStrings.snacks,
                                                items: data.snack,
                                              ),
                                              MealTile(
                                                icon:
                                                    Icons
                                                        .dinner_dining_outlined,
                                                title: AppStrings.dinner,
                                                items: data.dinner,
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

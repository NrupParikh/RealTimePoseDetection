import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Screens/exerciseList/navigationDrawer/my_navigation_drawer.dart';
import 'package:pose_detection/Screens/goalHistory/goalHistoryChartDialog/goal_history_chart_dialog.dart';
import 'package:pose_detection/Screens/goalHistory/goal_history_controller.dart';
import 'package:pose_detection/Utility/bmi_calculator.dart';

class GoalHistory extends StatefulWidget {
  @override
  State<GoalHistory> createState() => GoalHistoryState();
}

class GoalHistoryState extends State<GoalHistory> {
  final controller = Get.find<GoalHistoryController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Goal History',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              GoalHistoryChartDialog.showGoalHistoryChartDialog(context);
            },
            icon: Icon(Icons.bar_chart, color: Colors.white),
          ),
        ],
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
            // Use LayoutBuilder to get the maximum height available to the SafeArea child
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: 8,
                ),
                child:
                    controller.isLoadingForHistory.value
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
                        : ListView.separated(
                          itemCount:
                              controller
                                  .goalStatusData
                                  .value
                                  ?.goalStatusHistory
                                  .length ??
                              0,
                          separatorBuilder:
                              (context, index) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final record =
                                controller
                                    .goalStatusData
                                    .value!
                                    .goalStatusHistory[index];
                            final bmi = BMICalculator.calculateBMI(
                              heightCm: record.height,
                              weightKg: record.weight,
                            );
                            final bmiStatus =
                                BMICalculator.getBMIInterpretation(bmi);

                            final goalStatus =
                                controller
                                    .goalStatus(
                                      record.isCaloriesBurned,
                                      record.isDurationCompleted,
                                    )
                                    .toUpperCase();

                            final goalSummary = AppStrings.goalSummary(
                              height: record.height,
                              weight: record.weight,
                              bmi: bmi,
                              bmiStatus: bmiStatus,
                              caloriesToBurned: record.caloriesToBurn,
                              caloriesBurned: record.caloriesBurned,
                              goalDurationAchieved: record.goalDurationAchieved,
                              isDurationCompleted: record.isDurationCompleted,
                              isCaloriesBurned: record.isCaloriesBurned,
                              goalStatus: goalStatus,
                            );

                            final goalPlan = AppStrings.goalPlan(
                              goal: record.goal,
                              goalDuration: record.goalDuration,
                            );

                            return FrostedGlass(
                              applyFilter: false,
                              borderRadius: BorderRadius.circular(10),
                              gradientColors: [
                                Colors.white.withValues(alpha: 0.4),
                                Colors.white.withValues(alpha: 0.4),
                              ],
                              child: ListTile(
                                title: Text(
                                  goalPlan,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  goalSummary,
                                  style: const TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

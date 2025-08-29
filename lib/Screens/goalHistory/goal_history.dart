import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Screens/exerciseList/navigationDrawer/my_navigation_drawer.dart';
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
                        : ListView.builder(
                          itemCount:
                              controller
                                  .goalStatusData
                                  .value
                                  ?.goalStatusHistory
                                  .length ??
                              0,
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

                            return Card(
                              color: Colors.transparent,
                              child: FrostedGlass(
                                applyFilter: false,
                                borderRadius: BorderRadius.circular(10),
                                gradientColors: [
                                  Colors.white.withValues(alpha: 0.6),
                                  Colors.white.withValues(alpha: 0.6),
                                ],
                                child: ListTile(
                                  title: Text(
                                    "Goal was ${record.goal} in ${record.goalDuration} days",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Age: ${record.age} years\n"
                                    "Height: ${record.height} cm\n"
                                    "Weight: ${record.weight} kg\n"
                                    "BMI: ${bmi.toStringAsFixed(2)} (${bmiStatus})\n"
                                    "Burned ${record.caloriesBurned.toStringAsFixed(2)} kcal in ${record.goalDurationAchieved} day(s)\n"
                                    "Goal Duration Completed: ${record.isDurationCompleted ? "Yes" : "No"}\n"
                                    "Calories Burned Goal Achieved: ${record.isCaloriesBurned ? "Yes" : "No"}\n"
                                    "Goal Status: $goalStatus",
                                    style: const TextStyle(
                                      color: Colors.black38,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
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

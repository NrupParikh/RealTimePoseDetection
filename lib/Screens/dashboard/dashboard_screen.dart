import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Screens/bmi_calc/bmi_info_dialog.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Screens/dashboard/bmi/bmi_info_widget.dart';
import 'package:pose_detection/Screens/dashboard/bmi/bmi_radial_gauge.dart';
import 'package:pose_detection/Screens/dashboard/dashboard_controller.dart';
import 'package:pose_detection/Screens/dashboard/bmi/status_indicator_row.dart';
import 'package:pose_detection/Screens/dashboard/fitness_tips.dart';
import 'package:pose_detection/Screens/dashboard/recommanded_ex.dart';
import 'package:pose_detection/Screens/dashboard/recommanded_ex_info_dialog.dart';
import 'package:pose_detection/Screens/exerciseList/navigationDrawer/my_navigation_drawer.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    final List<StatusItem> bmiStatuses = [
      StatusItem(color: ColorConstants.underweightColor, label: AppStrings.underweight),
      StatusItem(color: ColorConstants.normalWeightColor, label: AppStrings.normal),
      StatusItem(color: ColorConstants.overweightColor, label: AppStrings.overweight),
      StatusItem(color: ColorConstants.obeseColor, label: AppStrings.obese),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          AppStrings.titleDashBoard,
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
              applyFilter: true,
              borderRadius: BorderRadius.zero,
              gradientColors: [
                ColorConstants.startColor.withValues(alpha: 0.8),
                ColorConstants.endColor.withValues(alpha: 0.8),
              ],
              child: const SizedBox.expand(),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Obx(() {
                          final plan = controller.fitnessPlan.value;
                          final tipsObj = controller.fitnessTipsDataModel.value;
                          final burned = controller.RxTotalBurnedCal.value;
                          final dailyGoal =
                              plan?.estimatedCaloriesBurned.perDay ?? 0;
                          final progress =
                              dailyGoal > 0
                                  ? (burned / dailyGoal).clamp(0.0, 1.0)
                                  : 0.0;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Greeting
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Row(
                                  children: [
                                    Text(
                                      AppStrings.greeting(
                                        controller.profileData?.name,
                                      ),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Text(
                                      '\u{1F44B}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Text(
                                  AppStrings.welcomMsg,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Goal Section
                              FrostedGlass(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                applyFilter: true,
                                gradientColors: [
                                  Colors.black.withValues(alpha: 0.6),
                                  Colors.black.withValues(alpha: 0.6),
                                ],
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppStrings.goalText(
                                          plan?.estimatedCaloriesBurned.perDay,
                                          plan?.estimatedCaloriesBurned.perWeek,
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        AppStrings.challengeDayText(
                                          1, // current day
                                          7, // total days
                                          burned,
                                        ),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      LinearProgressIndicator(
                                        color: Colors.green,
                                        value: progress,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),

                              // BMI Section
                              FrostedGlass(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                applyFilter: true,
                                gradientColors: [
                                  Colors.black.withValues(alpha: 0.6),
                                  Colors.black.withValues(alpha: 0.6),
                                ],
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.balance,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 8),
                                                const Text(
                                                  AppStrings.bmiAndHealthStatus,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap:
                                                  () =>
                                                      BMIInfoDialog.showBMIinfo(
                                                        context,
                                                      ),
                                              child: const Icon(
                                                Icons.info_outline,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 115,
                                            width: 115,
                                            child: BmiRadialGauge(),
                                          ),
                                          const Expanded(
                                            child: BMIInfoWidget(),
                                          ),
                                        ],
                                      ),
                                      StatusIndicatorRow(
                                        statusItems: bmiStatuses,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),

                              // Recommended Exercise
                              if (controller.isLoading.value)
                                Center(child: CircularProgressIndicator())
                              else if (controller
                                  .errorMessageForFitnessPlan
                                  .isNotEmpty)
                                SizedBox(
                                  height: 20,
                                  child: Text(
                                    textAlign: TextAlign.start,
                                    "Error: ${controller.errorMessageForFitnessPlan.value}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70,
                                    ),
                                  ),
                                )
                              else if (plan == null || plan.workoutPlan.isEmpty)
                                SizedBox(
                                  height: 20,
                                  child: Center(
                                    child: Text(
                                      AppStrings.noExerciseAvailable,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                FrostedGlass(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  applyFilter: true,
                                  gradientColors: [
                                    Colors.black.withValues(alpha: 0.6),
                                    Colors.black.withValues(alpha: 0.6),
                                  ],
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 8.0,
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.fitness_center,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  const Text(
                                                    AppStrings
                                                        .recommandedExercise,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              GestureDetector(
                                                onTap:
                                                    () =>
                                                        RecommandedExInfoDialog.showRecommandedExInfo(
                                                          context,
                                                        ),
                                                child: const Icon(
                                                  Icons.info_outline,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        RecommandedExerciseList(
                                          workoutPlan: plan.workoutPlan,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          AppStrings.estimatedCaloriesBurned(
                                            plan.estimatedCaloriesBurned.perDay,
                                          ),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              const SizedBox(height: 4),

                              // Fitness Tips
                              if (controller.isLoadingForTips.value)
                                Center(child: CircularProgressIndicator())
                              else if (controller
                                  .errorMessageForFitnessTips
                                  .isNotEmpty)                                  
                                SizedBox(
                                  height: 20,
                                  child: Text(
                                    textAlign: TextAlign.start,
                                    "Error: ${controller.errorMessageForFitnessTips.value}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70,
                                    ),
                                  ),
                                )
                              else if (tipsObj == null ||
                                  tipsObj.fitnessTips.isEmpty)
                                SizedBox(
                                  height: 20,
                                  child: Center(
                                    child: Text(
                                      AppStrings.noTipsAvailable,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                FrostedGlass(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  applyFilter: true,
                                  gradientColors: [
                                    Colors.black.withValues(alpha: 0.6),
                                    Colors.black.withValues(alpha: 0.6),
                                  ],
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 8.0,
                                    ),
                                    child: FitnessTips(
                                      fitnessTips: tipsObj.fitnessTips,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

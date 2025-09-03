import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/button_widget.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Screens/goalHistory/goal_history_controller.dart';
import 'package:pose_detection/Screens/goalHistory/goalHistoryChartDialog/history_bar_chart.dart';

class GoalHistoryChartDialog extends StatefulWidget {
  final controller = Get.find<GoalHistoryController>();

  @override
  State<GoalHistoryChartDialog> createState() => GoalHistoryChartDialogState();

  static void showGoalHistoryChartDialog(BuildContext mCtx) {
    showDialog(
      context: mCtx,
      barrierDismissible: false,
      builder: (context) {
        return GoalHistoryChartDialog();
      },
    );
  }
}

class GoalHistoryChartDialogState extends State<GoalHistoryChartDialog> {
  @override
  Widget build(BuildContext context) {
    final goalHistoryList =
        widget.controller.goalStatusData.value?.goalStatusHistory;
    print("Tag_goalHistoryList ${goalHistoryList?.length}");
    final BorderRadius dialogBorderRadius = BorderRadius.circular(20);

    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: dialogBorderRadius),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: FrostedGlass(
        applyFilter: true,
        gradientColors: [ColorConstants.endColor, Colors.black],
        borderRadius: dialogBorderRadius,
        padding: const EdgeInsets.all(20),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Goal History Chart",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                height: 300,
                child:
                    widget.controller.goalStatusData.value == null
                        ? Center(
                          child: Text(
                            "No History found",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                        : SizedBox(
                          child: HistoryBarChart(
                            goalHistoryList: goalHistoryList,
                          ),
                        ),
              ),

              Visibility(
                visible: widget.controller.goalStatusData.value != null,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        const SizedBox(height: 16),
                        LegendItem(
                          color: Colors.orangeAccent,
                          text: 'Calories To Burn',
                        ),
                        LegendItem(
                          color: Colors.greenAccent,
                          text: 'Calories Burned',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "X Axis : Goal with Duration taken/Total duration",
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Y Axis : Calories in kcal",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: Buttonwidget(
                  width: 100,
                  height: 40,
                  buttontitle: 'Ok',
                  gradientColors: [
                    ColorConstants.startColor,
                    ColorConstants.endColor,
                  ],
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Screens/exerciseList/navigationDrawer/my_navigation_drawer.dart';
import 'package:pose_detection/Screens/goalHistory/goal_history_controller.dart';

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
            child: ListView.builder(
              itemCount: controller.goalHistoryRecords.length,
              itemBuilder: (context, index) {
                final record = controller.goalHistoryRecords[index];
                return Card(
                  color: Colors.white.withValues(alpha: 0.8),
                  child: ListTile(
                    title: Text(
                      "${record.goal} - ${record.goalDuration} weeks",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Age: ${record.age}, Height: ${record.height} cm, Weight: ${record.weight} kg)",
                    ),
                    trailing: Text(
                      "${record.caloriesStatus} kcal",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
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

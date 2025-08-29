import 'package:pose_detection/Screens/goalHistory/goal_status_history.dart';

class GoalStatusData {
  final List<GoalStatusHistory> goalStatusHistory;

  GoalStatusData({required this.goalStatusHistory});

  factory GoalStatusData.fromJson(Map<String, dynamic> json) {
    return GoalStatusData(
      goalStatusHistory: (json['goalStatusHistory'] as List<dynamic>?)
              ?.map((e) => GoalStatusHistory.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goalStatusHistory':
          goalStatusHistory.map((e) => e.toJson()).toList(),
    };
  }
}
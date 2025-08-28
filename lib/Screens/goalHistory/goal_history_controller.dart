import 'package:get/get.dart';
import 'package:pose_detection/Components/session_expire_controller.dart';
import 'package:pose_detection/Screens/goalHistory/goal_history_data.dart';
// import 'package:pose_detection/Singleton/api_service_singleton.dart';
// import 'package:pose_detection/api/api_service.dart';

class GoalHistoryController extends GetxController {
  // final ApiService _apiService = ApiServiceSingleton().apiService;
  final SessionExpireController sessionController =
      Get.find<SessionExpireController>();

  @override
  void onInit() {
    super.onInit();
    print("Tag_goal_history_controller");
  }

  final List<GoalHistoryRecord> goalHistoryRecords = [
    GoalHistoryRecord(
      age: 55,
      height: 145.5,
      weight: 70,
      gender: "Male",
      goal: "Lose Weight",
      goalDuration: 5,
      caloriesStatus: 1.30,
      createdAt: DateTime.parse("2025-07-22 06:14:46"),
      updatedAt: DateTime.parse("2025-08-22 10:03:57"),
    ),
    GoalHistoryRecord(
      age: 40,
      height: 160.2,
      weight: 80,
      gender: "Female",
      goal: "Gain Weight",
      goalDuration: 8,
      caloriesStatus: 2.15,
      createdAt: DateTime.parse("2025-07-25 08:20:15"),
      updatedAt: DateTime.parse("2025-08-21 09:45:00"),
    ),
    GoalHistoryRecord(
      age: 29,
      height: 172.8,
      weight: 65,
      gender: "Other",
      goal: "Lose Weight",
      goalDuration: 6,
      caloriesStatus: 1.75,
      createdAt: DateTime.parse("2025-07-28 07:05:30"),
      updatedAt: DateTime.parse("2025-08-20 14:20:10"),
    ),
    GoalHistoryRecord(
      age: 35,
      height: 180.0,
      weight: 90,
      gender: "Male",
      goal: "Gain Weight",
      goalDuration: 10,
      caloriesStatus: 2.80,
      createdAt: DateTime.parse("2025-07-30 10:45:00"),
      updatedAt: DateTime.parse("2025-08-19 12:10:25"),
    ),
    GoalHistoryRecord(
      age: 50,
      height: 155.4,
      weight: 72,
      gender: "Female",
      goal: "Lose Weight",
      goalDuration: 7,
      caloriesStatus: 1.95,
      createdAt: DateTime.parse("2025-07-27 09:15:10"),
      updatedAt: DateTime.parse("2025-08-18 11:00:00"),
    ),
    
  ];
}

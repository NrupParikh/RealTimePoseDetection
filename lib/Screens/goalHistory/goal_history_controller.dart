import 'package:get/get.dart';
import 'package:pose_detection/Components/fancy_alert_dialog.dart';
import 'package:pose_detection/Components/session_expire_controller.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Screens/goalHistory/goal_history_record.dart';
import 'package:pose_detection/Screens/goalHistory/goal_status_data.dart';
import 'package:pose_detection/Singleton/api_service_singleton.dart';
import 'package:pose_detection/api/api_service.dart';
import 'package:pose_detection/main.dart';
import 'package:tuple/tuple.dart';
// import 'package:pose_detection/Singleton/api_service_singleton.dart';
// import 'package:pose_detection/api/api_service.dart';

class GoalHistoryController extends GetxController {
  final ApiService _apiService = ApiServiceSingleton().apiService;
  final SessionExpireController sessionController =
      Get.find<SessionExpireController>();

  final RxBool isLoadingForHistory = false.obs;

  final Rx<GoalStatusData?> goalStatusData = Rx<GoalStatusData?>(null);
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    print("Tag_goal_history_controller");
    handleFitnessPlan();
  }

  Future<void> handleFitnessPlan() async {
 
      await getGoalHistory().then((result) async {
        if (result.item1) {
        } else if (result.item3 == 401) {
          displaySessionExpireDialog(result);
        } else {
          showFancyDialog(result.item2.toString());
        }
      });
    
  }

  void displaySessionExpireDialog(Tuple3<bool, String?, int> result) {
    if (Get.context != null && !Get.isDialogOpen!) {
      sessionController.showSessionExpiredDialog(
        Get.context!,
        result.item2.toString(),
      );
    }
  }

  void showFancyDialog(String message) {
    if (Get.context != null && !Get.isDialogOpen!) {
      FancyAlertDialog.showFancyAlertDialog(
        context: Get.context!,
        title: AppStrings.appName,
        message: message,
        onOkPressed: () {
          Get.back();
        },
        onCancelPressed: null,
      );
    }
  }
  
  Future<Tuple3<bool, String?, int>> getGoalHistory() async {
    try {
      isLoadingForHistory.value = true;
      var appResponse = await _apiService.getGoalHistory();
      if (appResponse.statusCode == 200) {
        isLoadingForHistory.value = false;
        if (appResponse.data is Map<String, dynamic>) {
          try {
            print("Tag_goal_history_response ${appResponse.data}");
            final GoalStatusData data = GoalStatusData.fromJson(
              appResponse.data,
            );
            print("Tag_goal_history_parsed ${data.goalStatusHistory.length}");
            goalStatusData.value = data;
            if (goalStatusData.value != null) {              
              return Tuple3(
                true,
                appResponse.message.toString(),
                appResponse.statusCode.toInt(),
              );
            } else {
              errorMessage.value = "No goal history data available.";
              return Tuple3(
                false,
                "No goal history data available.",
                appResponse.statusCode.toInt(),
              );
            }
          } catch (e) {
            isLoadingForHistory.value = false;
            return Tuple3(
              false,
              "Error parsing ApiResponse",
              appResponse.statusCode.toInt(),
            );
          }
        } else {
          isLoadingForHistory.value = false;
          return Tuple3(
            false,
            "appResponse.data is not a Map",
            appResponse.statusCode.toInt(),
          );
        }
      } else if (appResponse.statusCode == 401) {
        isLoadingForHistory.value = false;
        return Tuple3(
          false,
          appResponse.message.toString(),
          appResponse.statusCode.toInt(),
        );
      } else {
        isLoadingForHistory.value = false;
        return Tuple3(
          false,
          appResponse.message.toString(),
          appResponse.statusCode.toInt(),
        );
      }
    } catch (ex) {
      isLoadingForHistory.value = false;
      return Tuple3(false, "$ex", 0);
    }    
  }
  String goalStatus(bool isCaloriesBurned, bool isDurationCompleted){
     if (isDurationCompleted && isCaloriesBurned) {
      return  "Goal Achieved on time";
    } else
    // if only duration completed
    if (isDurationCompleted && isCaloriesBurned == false) {
      return "Duration Completed";
    }
    // if duration not completed but calories burned
    else if (isDurationCompleted == false && isCaloriesBurned) {
      return "Goal Achieved before time";
    } else {
       return "In progress";
    }
  }  
}

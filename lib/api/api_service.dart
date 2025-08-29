import 'package:flutter/foundation.dart';
import 'package:pose_detection/Constants/app_api_constants.dart';
import 'package:pose_detection/api/apiModels/app_response.dart';
import 'package:pose_detection/api/network_service.dart';

class ApiService {
  final NetworkService _networkService;
  ApiService(this._networkService);

  // ============================= login
  Future<AppResponse> login({
    required String email,
    required String password,
  }) async {
    Map<String, dynamic> data = {'email': email, 'password': password};

    try {
      final response = await _networkService.post(
        url: ApiConstants.login,
        data: data,
        showProgressBar: false,
      );
      return _networkService.handleException(response);
    } catch (e) {
      if (kDebugMode) {
        print("TAG Exception: $e");
      }
      rethrow;
    }
  }
  
  // ============================= register
  Future<AppResponse> register({
    required String email,
    required String password,
  }) async {
    Map<String, dynamic> data = {'email': email, 'password': password};

    try {
      final response = await _networkService.post(
        url: ApiConstants.register,
        data: data,
        showProgressBar: false,
      );
      return _networkService.handleException(response);
    } catch (e) {
      if (kDebugMode) {
        print("TAG Exception: $e");
      }
      rethrow;
    }
  }

  // ============================= Update profile
  Future<AppResponse> updateUserProfile({
    required int id,
    required String name,
    required int age,
    required double height,
    required double weight,
    required String gender,
    required String goal,
    required int goalDuration
  }) async {
    Map<String, dynamic> data = {
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
      'goal': goal,
      'goal_duration': goalDuration
    };

    try {
      final response = await _networkService.put(
        url: "${ApiConstants.profile}/$id",
        data: data,
        showProgressBar: false,
      );
      return _networkService.handleException(response);
    } catch (e) {
      if (kDebugMode) {
        print("TAG Exception: $e");
      }
      rethrow;
    }
  }

  // ============================= Get Profile
  Future<AppResponse> getProfile({required int id}) async {
    try {
      final response = await _networkService.get(
        url: "${ApiConstants.profile}/$id",
        showProgressBar: false,
      );
      return _networkService.handleException(response);
    } catch (e) {
      if (kDebugMode) {
        print("TAG Exception: $e");
      }
      rethrow;
    }
  }

  // ============================= Logout
  Future<AppResponse> logout() async {
    try {
      final response = await _networkService.post(
        url: ApiConstants.logout,
        showProgressBar: false,
      );
      return _networkService.handleException(response);
    } catch (e) {
      if (kDebugMode) {
        print("TAG Exception: $e");
      }
      rethrow;
    }
  }

  // Get Fitness Tips
  Future<AppResponse> getFitnessTips() async {
    try {
      final response = await _networkService.get(
        url: "${ApiConstants.tips}",
        showProgressBar: false,
      );
      return _networkService.handleException(response);
    } catch (e) {
      if (kDebugMode) {
        print("TAG Exception: $e");
      }
      rethrow;
    }
  }

  // Save Fitness Tips
  Future<AppResponse> saveFitnessTipsAPI({required String fitnessTips}) async {
    try {
      print("Tag_Save_fitness_tips_API_Call");
      final response = await _networkService.post(
        url: "${ApiConstants.tips}",
        data: fitnessTips,
        showProgressBar: false,
      );
      return _networkService.handleException(response);
    } catch (e) {
      if (kDebugMode) {
        print("TAG Exception: $e");
      }
      rethrow;
    }
  }

  // Get Fitness Plan
  Future<AppResponse> getFitnessPlan() async {
    try {
      final response = await _networkService.get(
        url: "${ApiConstants.fitnessPlan}",
        showProgressBar: false,
      );
      return _networkService.handleException(response);
    } catch (e) {
      if (kDebugMode) {
        print("TAG Exception: $e");
      }
      rethrow;
    }
  }

  // Save Fitness Plan
  Future<AppResponse> saveFitnessPlanAPI({required String fitnessPlan}) async {
    try {
      print("Tag_Save_fitness_plan_API_Call");
      final response = await _networkService.post(
        url: "${ApiConstants.fitnessPlan}",
        data: fitnessPlan,
        showProgressBar: false,
      );
      return _networkService.handleException(response);
    } catch (e) {
      if (kDebugMode) {
        print("TAG Exception: $e");
      }
      rethrow;
    }
  }

  // Save Burned Calories
  Future<AppResponse> saveCaloriesStatus(double burnedCalories) async {
    Map<String, dynamic> data = {'calories_status': burnedCalories};

    try {
      print("Tag_Save_calories_status_API_Call");
      final response = await _networkService.put(
        url: "${ApiConstants.caloriesStatus}",
        data: data,
        showProgressBar: false,
      );
      return _networkService.handleException(response);
    } catch (e) {
      if (kDebugMode) {
        print("TAG Exception: $e");
      }
      rethrow;
    }
  }

  Future<AppResponse> saveGoalStatus({
    required int age,
    required double height,
    required double weight,
    required double bmi,
    required String bmiStatus,
    required String gender,
    required String goal,
    required int goalDuration,
    required int goalDurationAchieved,
    required int caloriesToBurn,
    required double caloriesBurned,
    required bool isDurationCompleted,
    required bool isCaloriesBurned,
  }) async {
    if (kDebugMode) {
      print("""-----saveGoalStatus Parameters---
    'age: $age'
    'height: $height'
    'weight: $weight'
    'bmi: $bmi'
    'bmiStatus: $bmiStatus'
    'gender: $gender'
    'goal: $goal'
    'goalDuration: $goalDuration'
    'goalDurationAchieved: $goalDurationAchieved'
    'caloriesToBurn: ${caloriesToBurn.toStringAsFixed(2)}'
    'caloriesBurned: $caloriesBurned'
    'isDurationCompleted: $isDurationCompleted'
    'isCaloriesBurned: $isCaloriesBurned'
    '--------------------------------');
    """);
    }
    Map<String, dynamic> data = {
      'age': age,
      'height': height,
      'weight': weight,
      'bmi': bmi,
      'bmi_status': bmiStatus,
      'gender': gender,
      'goal': goal,
      'goal_duration': goalDuration,
      'goal_duration_achieved': goalDurationAchieved,
      'caloriesToBurn': caloriesToBurn,
      'caloriesBurned': caloriesBurned,
      'isDurationCompleted': isDurationCompleted,
      'isCaloriesBurned': isCaloriesBurned,
    };

    try {
      final response = await _networkService.post(
        url: "${ApiConstants.goalStatus}",
        data: data,
        showProgressBar: false,
      );
      return _networkService.handleException(response);
    } catch (e) {
      if (kDebugMode) {
        print("TAG Exception: $e");
      }
      rethrow;
    }
  }

  Future<AppResponse> getGoalHistory() async {
    try {
      final response = await _networkService.get(
        url: "${ApiConstants.goalStatus}",
        showProgressBar: false,
      );
      return _networkService.handleException(response);
    } catch (e) {
      if (kDebugMode) {
        print("TAG Exception: $e");
      }
      rethrow;
    }
  }
}

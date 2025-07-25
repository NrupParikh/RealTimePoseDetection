import 'package:flutter/foundation.dart';

import 'package:pose_detection/API/network_service.dart';
import 'package:pose_detection/Constants/app_api_constants.dart';

import 'apiModels/app_response.dart';

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
  }) async {
    Map<String, dynamic> data = {
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
      'goal': goal,
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
}

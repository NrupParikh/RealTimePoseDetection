import 'package:flutter/foundation.dart';
import 'package:pose_detection/API/apiModels/app_response.dart';
import 'package:pose_detection/API/network_service.dart';
import 'package:pose_detection/Constants/app_api_constants.dart';

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
}

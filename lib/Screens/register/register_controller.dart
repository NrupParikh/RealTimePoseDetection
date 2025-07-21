import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Singleton/api_service_singleton.dart';
import 'package:pose_detection/api/apiModels/auth_response.dart';
import 'package:pose_detection/api/api_service.dart';
import 'package:pose_detection/main.dart';
import 'package:tuple/tuple.dart';

class RegisterController extends GetxController {
  final ApiService _apiService = ApiServiceSingleton().apiService;
  final RxBool isLoading = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<Tuple2<bool, String?>> handleRegister() async {
    final email = emailController.text;
    final password = passwordController.text;
    if (GetUtils.isNullOrBlank(email) == true) {
      return Tuple2(false, AppStrings.valEnterEmail);
    } else if (GetUtils.isEmail(email) == false) {
      return Tuple2(false, AppStrings.valEnterValidEmail);
    } else if (GetUtils.isNullOrBlank(password) == true) {
      return Tuple2(false, AppStrings.valEnterPassword);
    } else if (password.length < 6) {
      return Tuple2(false, AppStrings.valEnterValidPassword);
    } else {
      isLoading.value = true;
      try {
        var appResponse = await _apiService.register(
          email: email,
          password: password,
        );
        if (appResponse.statusCode == 200) {
          isLoading.value = false;
          if (appResponse.data is Map<String, dynamic>) {
            try {
              final AuthResponse data = AuthResponse.fromJson(appResponse.data);
              debugPrint("Tag_data ${data.user}");
              secureStorage.storeUserData(data.user);
              if (data.token != null) {
                secureStorage.storeToken(data.token!);
              }
              return Tuple2(true, appResponse.message.toString());
            } catch (e) {
              isLoading.value = false;
              return Tuple2(false, "Error parsing ApiResponse");
            }
          } else {
            isLoading.value = false;
            return Tuple2(false, "appResponse.data is not a Map");
          }
        } else {
          isLoading.value = false;
          return Tuple2(false, appResponse.message.toString());
        }
      } catch (ex) {
        isLoading.value = false;
        return Tuple2(false, "$ex");
      }
    }
  }
}

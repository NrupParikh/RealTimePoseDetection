import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:tuple/tuple.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

    Tuple2<bool, String?> handleRegister() {
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
      return Tuple2(true, null);
    }
  }
}

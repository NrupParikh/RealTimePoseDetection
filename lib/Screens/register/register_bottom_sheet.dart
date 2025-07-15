import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/button_widget.dart';
import 'package:pose_detection/Components/fancy_alert_dialog.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Components/gradiant_text.dart';
import 'package:pose_detection/Components/text_field_widget.dart';
import 'package:pose_detection/Components/text_widget.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Constants/app_constants.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Screens/login/login_binding.dart';
import 'package:pose_detection/Screens/login/login_screen.dart';
import 'package:pose_detection/Screens/register/register_controller.dart';

class RegisterBottomSheet extends StatefulWidget {
  const RegisterBottomSheet({super.key});

  @override
  State<RegisterBottomSheet> createState() => RegisterBottomSheetState();
}

class RegisterBottomSheetState extends State<RegisterBottomSheet> {
  final controller = Get.find<RegisterController>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void handleRegister() {
    final result = controller.handleRegister();
    if (result.item1) {
      goToLoginScreenAfterRegisterSuccess();
    } else {
      FancyAlertDialog.showFancyAlertDialog(
        context: context,
        title: AppStrings.appName,
        message: result.item2.toString(),
        onOkPressed: () {
          Get.back();
        },
        onCancelPressed: null
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FrostedGlass(
        applyFilter: true,
        blurSigmaX: 10,
        blurSigmaY: 10,
        height: 400,
        child: Column(
          children: [
            SizedBox(height: 30),
            TitleWidget(titleText: AppStrings.registerMsg),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextWidget(
                    hintTitle: AppStrings.email,
                    rightIcon: Icons.email,
                    hideIcon: false,
                    keyboardType: TextInputType.emailAddress,
                    controller: controller.emailController,
                  ),
                  SizedBox(height: 15),
                  TextWidget(
                    hintTitle: AppStrings.password,
                    rightIcon: Icons.lock,
                    hideIcon: true,
                    keyboardType: TextInputType.visiblePassword,
                    controller: controller.passwordController,
                  ),
                  SizedBox(height: 30),
                  Buttonwidget(
                    width: 250,
                    buttontitle: AppStrings.register,
                    gradientColors: [
                      ColorConstants.startColor, // Start blue
                      ColorConstants.endColor, // End purple-ish
                    ],
                    onPressed: handleRegister,
                  ),
                  SizedBox(height: 15),
                  GradientTextExample(
                    title: AppStrings.loginTitleButton,
                    titleMsg: AppStrings.loginButtonTitle,
                    onTap: () {
                      Get.off(
                        () => LoginScreen(),
                        transition: Transition.rightToLeft,
                        duration: Duration(
                          milliseconds: AppConstants.navigationDurationTime,
                        ),
                        binding: LoginBinding(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void goToLoginScreenAfterRegisterSuccess() {
    Get.offAll(
      () => LoginScreen(),
      transition: Transition.leftToRight,
      duration: const Duration(
        milliseconds: AppConstants.navigationDurationTime,
      ),
      binding: LoginBinding(),
    );
  }
}

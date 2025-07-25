import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/button_widget.dart';
import 'package:pose_detection/Components/fancy_alert_dialog.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Components/gradiant_text.dart';
import 'package:pose_detection/Components/text_field_widget.dart';
import 'package:pose_detection/Components/text_widget.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Constants/page_name.dart';
import 'package:pose_detection/Screens/register/register_controller.dart';
import 'package:pose_detection/main.dart';

class RegisterBottomSheet extends StatefulWidget {
  const RegisterBottomSheet({super.key});

  @override
  State<RegisterBottomSheet> createState() => RegisterBottomSheetState();
}

class RegisterBottomSheetState extends State<RegisterBottomSheet> {
  final controller = Get.find<RegisterController>();

  void handleRegister() async {
    FocusScope.of(context).unfocus();
    final result = await controller.handleRegister();
    if (!mounted) return;
    if (result.item1) {
      secureStorage.storeLoginStatus(true);
      final userData = secureStorage.getUserData();
      if (userData != null) {
        if (userData.isProfileDataAvailable) {
          Get.offAllNamed(PageName.exerciseList);
        } else {
          Get.offAllNamed(PageName.chat);
        }
      }
    } else {
      FancyAlertDialog.showFancyAlertDialog(
        context: context,
        title: AppStrings.appName,
        message: result.item2.toString(),
        onOkPressed: () {
          Get.back();
        },
        onCancelPressed: null,
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
        height: 350,
        child: Stack(
          children: [
            Obx(
              () => IgnorePointer(
                ignoring: controller.isLoading.value,
                child: Opacity(
                  opacity: controller.isLoading.value ? 0.5 : 1.0,
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
                              textInputAction: TextInputAction.next,
                              onSubmitted: (value) {
                                controller.focusNodePassword.requestFocus();
                              },
                              focusNode: controller.focusNodeEmail,
                            ),
                            SizedBox(height: 15),
                            TextWidget(
                              hintTitle: AppStrings.password,
                              rightIcon: Icons.lock,
                              hideIcon: true,
                              keyboardType: TextInputType.visiblePassword,
                              controller: controller.passwordController,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (value) {
                                handleRegister();
                              },
                              focusNode: controller.focusNodePassword,
                            ),
                            SizedBox(height: 30),
                            Buttonwidget(
                              width: 250,
                              buttontitle: AppStrings.register,
                              gradientColors: [
                                ColorConstants.startColor,
                                ColorConstants.endColor,
                              ],
                              onPressed: handleRegister,
                            ),
                            SizedBox(height: 15),
                            GradientTextExample(
                              title: AppStrings.loginTitleButton,
                              titleMsg: AppStrings.loginButtonTitle,
                              onTap: () {
                                Get.offAllNamed(PageName.login);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () =>
                  controller.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

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
import 'package:pose_detection/Screens/login/login_controller.dart';
import 'package:pose_detection/main.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({super.key});

  @override
  State<LoginBottomSheet> createState() => LoginBottomSheetState();
}

class LoginBottomSheetState extends State<LoginBottomSheet> {
  final controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FrostedGlass(
        blurSigmaX: 10,
        blurSigmaY: 10,
        applyFilter: true,

        height: 400,
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
                      TitleWidget(titleText: AppStrings.loginMsg),
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
                              buttontitle: AppStrings.login,
                              gradientColors: [
                                ColorConstants.startColor,
                                ColorConstants.endColor,
                              ],
                              onPressed: () async {
                                final result = await controller.handleLogin();
                                if (result.item1) {
                                  secureStorage.storeLoginStatus(true);
                                  // Get.offAllNamed(PageName.exerciseList);
                                  // final isUserDataSaved =
                                  //     secureStorage.isUserDataSaved() ?? false;

                                  final userData = secureStorage.getUserData();
                                  if(userData!=null){
                                    if(userData.isProfileDataAvailable){
                                      Get.offAllNamed(PageName.exerciseList);
                                    }else {
                                        Get.offAllNamed(PageName.chat);
                                    }
                                  }    
                                      
                                  // if (isUserDataSaved) {
                                  //   Get.offAllNamed(PageName.exerciseList);
                                  // } else {
                                  //   Get.offAllNamed(PageName.chat);
                                  // }
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
                              },
                            ),
                            SizedBox(height: 15),
                            GradientTextExample(
                              title: AppStrings.registerTitle,
                              titleMsg: AppStrings.signupTitle,
                              onTap: () {
                                // Get.off(
                                //   () => RegisterScreen(),
                                //   transition: Transition.rightToLeft,
                                //   duration: Duration(
                                //     milliseconds: AppConstants.navigationDurationTime,
                                //   ),
                                //   binding: RegisterBinding(),
                                // );
                                Get.offAllNamed(PageName.register);
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

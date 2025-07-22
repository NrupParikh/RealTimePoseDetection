import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/button_widget.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Constants/page_name.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => OnBoardScreenState();
}

class OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FrostedGlass(
        applyFilter: false,
        gradientColors: [ColorConstants.startColor,ColorConstants.endColor],
        borderRadius: BorderRadius.zero,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/login_bg.jpg",
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FrostedGlass(
                  applyFilter: true,  
                  blurSigmaX: 10,
                  blurSigmaY: 10,
                  height: 240,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Buttonwidget(
                        width: 250,
                        buttontitle: AppStrings.loginButtonTitle,
                        gradientColors: [
                          ColorConstants.startColor, // Start blue
                          ColorConstants.endColor, // End purple-ish
                        ],
                        onPressed: () {
                          // Get.to(
                          //   () => LoginScreen(),
                          //   transition: Transition.rightToLeft,
                          //   duration: Duration(
                          //     milliseconds: AppConstants.navigationDurationTime,
                          //   ),
                          //   binding: LoginBinding(),
                          // ); 
                          Get.toNamed(PageName.login);
                        },
                      ),
                        
                      const SizedBox(height: 30),
                      Buttonwidget(
                        width: 250,
                        buttontitle: AppStrings.signupTitle,
                        gradientColors: [
                          ColorConstants.startColor,
                          ColorConstants.endColor,
                        ],
                        onPressed: () {
                          // Get.to(
                          //   () => RegisterScreen(),
                          //   transition: Transition.rightToLeft,
                          //   duration: Duration(
                          //     milliseconds: AppConstants.navigationDurationTime,
                          //   ),
                          //   binding: RegisterBinding(),
                          // );
                          Get.toNamed(PageName.register);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

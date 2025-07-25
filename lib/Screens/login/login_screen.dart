import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Constants/page_name.dart';
import 'package:pose_detection/Screens/login/login_bottom_sheet.dart';
import 'package:pose_detection/Constants/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          goToOnBoardScreen();
        }
      },
      child: Scaffold(
        body: FrostedGlass(
          applyFilter: false,
          gradientColors: [ColorConstants.startColor, ColorConstants.endColor],
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(
                        alpha: 0.1,
                      ), // Black circle with slight transparency
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        goToOnBoardScreen();
                      },
                    ),
                  ),
                ),
              ),

              isAndroid
                  ? SafeArea(child: LoginBottomSheet())
                  : LoginBottomSheet(),
            ],
          ),
        ),
      ),
    );
  }

  void goToOnBoardScreen() {
    // Get.offAll(
    //   () => OnBoardScreen(),
    //   transition: Transition.leftToRight,
    //   duration: Duration(milliseconds: AppConstants.navigationDurationTime),
    // );

    Get.offAllNamed(PageName.onboard);
  }
}

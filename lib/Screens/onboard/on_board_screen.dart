import 'package:flutter/material.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Screens/onboard/on_board_bottom_sheet.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => OnBoardScreenState();
}

class OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
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
            isAndroid
                ? SafeArea(child: OnBoardBottomSheet())
                : OnBoardBottomSheet(),        
          ],
        ),
      ),
    );
  }
}

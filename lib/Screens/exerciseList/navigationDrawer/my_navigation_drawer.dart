import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Constants/page_name.dart';
import 'package:pose_detection/Screens/exerciseList/navigationDrawer/nav_drawer_controller.dart';

class MyNavigationDrawer extends StatefulWidget {
  const MyNavigationDrawer({super.key});

  @override
  State<MyNavigationDrawer> createState() => _MyNavigationDrawerState();
}

class _MyNavigationDrawerState extends State<MyNavigationDrawer> {
  final navDrawerController = Get.find<NavDrawerController>();

  @override
  Widget build(BuildContext context) {
    bool isExerciseListSelected = Get.currentRoute == PageName.exerciseList;
    final isProfileSelected = Get.currentRoute == PageName.profile;
    final isBMISelected = Get.currentRoute == PageName.bmiCalcScreen;
    return Drawer(
      child: FrostedGlass(
        applyFilter: false,
        borderRadius: BorderRadius.zero,
        gradientColors: [
          ColorConstants.startColor.withValues(alpha: 0.8),
          ColorConstants.endColor.withValues(alpha: 0.8),
        ],
        child: SizedBox.expand(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      selected: isExerciseListSelected,
                      selectedTileColor: Colors.black.withValues(alpha: 0.2),
                      leading: Icon(Icons.home_outlined, color: Colors.white),
                      title: Text(
                        "Exercise List",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        // Close the drawer first
                        Get.back();
                        if (Get.currentRoute != PageName.exerciseList) {
                          Get.offAllNamed(PageName.exerciseList);
                        }
                      },
                    ),
                    Divider(color: ColorConstants.startColor),
                    ListTile(
                      selected: isProfileSelected,
                      selectedTileColor: Colors.black.withValues(alpha: 0.2),
                      leading: Icon(Icons.person_outline, color: Colors.white),
                      title: Text(
                        "Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        // Close the drawer first
                        Get.back();
                        if (Get.currentRoute != PageName.profile) {
                          Get.offAllNamed(PageName.profile);
                        }
                      },
                    ),
                    Divider(color: ColorConstants.startColor),
                     ListTile(
                      selected: isBMISelected,
                      selectedTileColor: Colors.black.withValues(alpha: 0.2),
                      leading: Icon(Icons.calculate_outlined, color: Colors.white),
                      title: Text(
                        "BMI Calculator",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        // Close the drawer first
                        Get.back();
                        if (Get.currentRoute != PageName.bmiCalcScreen) {
                          Get.offAllNamed(PageName.bmiCalcScreen);
                        }
                      },
                    ),
                    Divider(color: ColorConstants.startColor),
                    ListTile(
                      leading: Icon(Icons.logout_outlined, color: Colors.white),
                      title: Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        Get.back();
                        navDrawerController.handleLogout();
                      },
                    ),
                    Divider(color: ColorConstants.startColor),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

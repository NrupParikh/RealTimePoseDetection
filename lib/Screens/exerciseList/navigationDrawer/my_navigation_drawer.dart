import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Constants/page_name.dart';
import 'package:pose_detection/Screens/exerciseList/navigationDrawer/nav_drawer_controller.dart';

class MyNavigationDrawer extends StatefulWidget {
  const MyNavigationDrawer({super.key});

  @override
  State<MyNavigationDrawer> createState() => _MyNavigationDrawerState();
}

class _MyNavigationDrawerState extends State<MyNavigationDrawer> {
  final navDrawerController = Get.find<NavDrawerController>();

  // Common text style
  final TextStyle drawerTextStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  // Common drawer item
  Widget buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return ListTile(
      selected: isSelected,
      selectedTileColor: Colors.black.withValues(alpha: 0.2),
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: drawerTextStyle),
      onTap: () {
        Get.back();
        onTap();
      },
    );
  }

  // Drawer section with divider + item
  Widget buildDrawerSection({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return Column(
      children: [
        buildDrawerItem(
          icon: icon,
          title: title,
          onTap: onTap,
          isSelected: isSelected,
        ),
        Divider(color: ColorConstants.startColor),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDashboardSelected = Get.currentRoute == PageName.dashboard;
    // final isExerciseListSelected = Get.currentRoute == PageName.exerciseList;
    final isProfileSelected = Get.currentRoute == PageName.profile;
    // final isBMISelected = Get.currentRoute == PageName.bmiCalcScreen;
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
                    buildDrawerSection(
                      icon: Icons.dashboard_outlined,
                      title: AppStrings.dashboard,
                      isSelected: isDashboardSelected,
                      onTap: () {
                        Get.back();
                        if (Get.currentRoute != PageName.dashboard) {
                          Get.offAllNamed(PageName.dashboard);
                        }
                      },
                    ),
                    // buildDrawerSection(
                    //   icon: Icons.fitness_center,
                    //   title: AppStrings.exerciseList,
                    //   isSelected: isExerciseListSelected,
                    //   onTap: () {
                    //     Get.back();
                    //     if (Get.currentRoute != PageName.exerciseList) {
                    //       Get.offAllNamed(PageName.exerciseList);
                    //     }
                    //   },
                    // ),
                    buildDrawerSection(
                      icon: Icons.person_outline,
                      title: AppStrings.profile,
                      isSelected: isProfileSelected,
                      onTap: () {
                        Get.back();
                        if (Get.currentRoute != PageName.profile) {
                          Get.offAllNamed(PageName.profile);
                        }
                      },
                    ),
                    // buildDrawerSection(
                    //   icon: Icons.calculate_outlined,
                    //   title: AppStrings.bmiCalculator,
                    //   isSelected: isBMISelected,
                    //   onTap: () {
                    //     Get.back();
                    //     if (Get.currentRoute != PageName.bmiCalcScreen) {
                    //       Get.offAllNamed(PageName.bmiCalcScreen);
                    //     }
                    //   },
                    // ),
                    buildDrawerSection(
                      icon: Icons.logout_outlined,
                      title: AppStrings.logout,
                      onTap: () {
                        navDrawerController.handleLogout();
                      },
                    ),
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

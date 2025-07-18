import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/fancy_alert_dialog.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Components/permission_service.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Constants/page_name.dart';
import 'package:pose_detection/Models/excercise_data_model.dart';
import 'package:pose_detection/Screens/exerciseList/exercise_list_item.dart';
import 'package:pose_detection/Utility/utility.dart';
import 'package:pose_detection/main.dart';

class ExcerciseListScreen extends StatelessWidget {
  const ExcerciseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This is the key property
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Exercise List',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        // Make app bar transparent
        backgroundColor: Colors.transparent,
        // Remove shadow
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () {
              logout(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/login_bg.jpg", fit: BoxFit.cover),
          ),

          Positioned.fill(
            child: FrostedGlass(
              applyFilter: false,
              borderRadius: BorderRadius.zero,
              // gradientColors: [Color.fromRGBO(0, 0, 0, 0.2),Color.fromRGBO(0, 0, 0, 0.2)],
              gradientColors: [
                ColorConstants.startColor.withValues(alpha: 0.8),
                ColorConstants.endColor.withValues(alpha: 0.8),
              ],
              child: SizedBox.expand(),
            ),
          ),

          // Your existing Column content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      final item = exerciseList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: ExerciseListItem(
                          item: item,
                          onRequestPermissionsAndNavigate: (
                            ExcerciseDataModel item,
                          ) {
                            PermissionService.requestAllPermissionsAndNavigate(
                              item,
                              context,
                            );
                          },
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 0,
                        ),
                        child: SizedBox.shrink(),
                      );
                    },
                    itemCount: exerciseList.length,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void logout(BuildContext ctx) {
    if (ctx.mounted) {
      FancyAlertDialog.showFancyAlertDialog(
        context: ctx,
        title: AppStrings.appName,
        message: "Are you sure you want to logout ?",
        onOkPressed: () {
          Get.back();
          secureStorage.clearSharedPreference();
          Get.offAllNamed(PageName.onboard);
        },
        onCancelPressed: () {
          Get.back();
        },
      );
    }
  }
}

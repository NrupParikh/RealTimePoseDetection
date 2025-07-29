import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/fancy_alert_dialog.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Components/text_field_widget.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Screens/exerciseList/navigationDrawer/my_navigation_drawer.dart';
import 'package:pose_detection/Screens/profile/profile_controller.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final controller = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Profile', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            controller.isEdit.value
                ? IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      controller.isEdit.value = false;
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.done),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      updateProfile();
                    },
                  ),
          ],
        ),
        drawer: MyNavigationDrawer(),
        body: IgnorePointer(
          ignoring: controller.isLoading.value,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/images/login_bg.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: FrostedGlass(
                  applyFilter: false,
                  borderRadius: BorderRadius.zero,
                  gradientColors: [
                    ColorConstants.startColor.withValues(alpha: 0.8),
                    ColorConstants.endColor.withValues(alpha: 0.8),
                  ],
                  child: SizedBox.expand(),
                ),
              ),
              SafeArea(
                // Use LayoutBuilder to get the maximum height available to the SafeArea child
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      // Constrain the child of SingleChildScrollView to ensure it's at least as tall as the available space
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight, // This is the key line
                        ),
                        // IntrinsicHeight allows the Column to measure its children (including Spacer) correctly
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextWidget(
                                  hintTitle: AppStrings.name,
                                  rightIcon: Icons.person,
                                  hideIcon: false,
                                  keyboardType: TextInputType.name,
                                  controller: controller.nameController,
                                  textInputAction: TextInputAction.next,
                                  isEnabled: !controller.isEdit.value,
                                  onSubmitted: (value) {
                                    controller.focusNodeAge.requestFocus();
                                  },
                                  focusNode: controller.focusNodeName,
                                ),
                                SizedBox(height: 15),
                                TextWidget(
                                  hintTitle: AppStrings.age,
                                  rightIcon: Icons.numbers,
                                  hideIcon: false,
                                  keyboardType: TextInputType.number,
                                  controller: controller.ageController,
                                  textInputAction: TextInputAction.next,
                                  isEnabled: !controller.isEdit.value,
                                ),
                                SizedBox(height: 15),
                                TextWidget(
                                  hintTitle: AppStrings.height,
                                  rightIcon: Icons.height,
                                  hideIcon: false,
                                  keyboardType: TextInputType.number,
                                  controller: controller.heightController,
                                  textInputAction: TextInputAction.next,
                                  isEnabled: !controller.isEdit.value,
                                  onSubmitted: (value) {
                                    controller.focusNodeWeight.requestFocus();
                                  },
                                  focusNode: controller.focusNodeHeight,
                                ),
                                SizedBox(height: 15),
                                TextWidget(
                                  hintTitle: AppStrings.weight,
                                  rightIcon: Icons.line_weight,
                                  hideIcon: false,
                                  keyboardType: TextInputType.number,
                                  controller: controller.weightController,
                                  textInputAction: TextInputAction.next,
                                  isEnabled: !controller.isEdit.value,
                                  onSubmitted: (value) {
                                    controller.focusNodeGender.requestFocus();
                                  },
                                  focusNode: controller.focusNodeWeight,
                                ),
                                SizedBox(height: 15),
                                TextWidget(
                                  hintTitle: AppStrings.gender,
                                  rightIcon: Icons.male,
                                  hideIcon: false,
                                  keyboardType: TextInputType.text,
                                  controller: controller.genderController,
                                  textInputAction: TextInputAction.next,
                                  isEnabled: !controller.isEdit.value,
                                  onSubmitted: (value) {
                                    controller.focusNodeGoal.requestFocus();
                                  },
                                  focusNode: controller.focusNodeGender,
                                ),
                                SizedBox(height: 15),
                                TextWidget(
                                  hintTitle: AppStrings.goal,
                                  rightIcon: Icons.center_focus_strong,
                                  hideIcon: false,
                                  keyboardType: TextInputType.text,
                                  controller: controller.goalController,
                                  textInputAction: TextInputAction.done,
                                  isEnabled: !controller.isEdit.value,
                                  onSubmitted: (value) {
                                    updateProfile();
                                  },
                                ),
                                // Spacer pushes the content up and fills any remaining vertical space
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (controller.isLoading.value)
                Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      );
    });
  }

  void updateProfile() {
    FocusScope.of(context).unfocus();
    controller.handleUpdateProfile().then((result) {
      if (result.item1) {
        FancyAlertDialog.showFancyAlertDialog(
          context: context,
          title: AppStrings.appName,
          message: result.item2.toString(),
          onOkPressed: () {
            Get.back();
          },
          onCancelPressed: null,
        );
      } else if (result.item3 == 401) {
        if (Get.context != null && !Get.isDialogOpen!) {
          controller.sessionController.showSessionExpiredDialog(
            Get.context!,
            result.item2.toString(),
          );
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
    });
  }
}
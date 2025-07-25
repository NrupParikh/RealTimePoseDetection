import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/fancy_alert_dialog.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Components/permission_service.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Constants/page_name.dart';
import 'package:pose_detection/Models/excercise_data_model.dart';
import 'package:pose_detection/Screens/exerciseList/exercise_list_controller.dart';
import 'package:pose_detection/Screens/exerciseList/exercise_list_item.dart';
import 'package:pose_detection/Utility/utility.dart';
import 'package:pose_detection/api/apiModels/profile.dart';
import 'package:pose_detection/api/apiModels/user.dart';
import 'package:pose_detection/main.dart';

class ExcerciseListScreen extends StatefulWidget {
  const ExcerciseListScreen({super.key});

  @override
  State<ExcerciseListScreen> createState() => _ExcerciseListScreenState();
}

class _ExcerciseListScreenState extends State<ExcerciseListScreen> {
  final exerciseListController = Get.find<ExerciseListController>();
  @override
  void initState() {
    super.initState();
    try {
      final User? user = secureStorage.getUserData();
      final String? token = secureStorage.getToken();
      final Profile? profile = secureStorage.getProfileData();

      if (user != null) {
        if (kDebugMode) {
          print("Tag_User ${user.toString()}");
        }
      }
      if (token != null) {
        if (kDebugMode) {
          print("Tag_token $token");
        }
      }

      if (profile != null) {
        if (kDebugMode) {
          print("Tag_profile ${profile.toString()}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Tag_e ${e.toString()}");
      }
    }
  }

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
              // logout(context);
              exerciseListController.handleLogout();
            },
          ),
        ],
      ),
      // drawer: MyNavigationDrawer(),
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
        onOkPressed: () async {
          Get.back();
          showDialog(
            context: ctx,
            barrierDismissible: false,
            builder: (BuildContext dialogContext) {
              return const Center(child: CircularProgressIndicator());
            },
          );

          final result = await exerciseListController.logout();

          // Dismiss the loader
          Get.back(); // This will pop the loader dialog

          if (result.item1) {
            secureStorage.clearSharedPreference();
            Get.offAllNamed(PageName.onboard);
          } else {
            // Handle logout failure, e.g., show a snackbar or another dialog
            if (ctx.mounted) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(
                  content: Text("Logout failed. Please try again."),
                ),
              );
            }
          }
        },
        onCancelPressed: () {
          Get.back();
        },
      );
    }
  }
}

class MyNavigationDrawer extends StatefulWidget {
  const MyNavigationDrawer({super.key});

  @override
  State<MyNavigationDrawer> createState() => _MyNavigationDrawerState();
}

class _MyNavigationDrawerState extends State<MyNavigationDrawer> {
  final exerciseListController = Get.find<ExerciseListController>();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.home_outlined),
                title: Text("Home"),
                onTap: () {
                  // Close the drawer first
                  Navigator.pop(context);
                  // If already on the home screen (ExcerciseListScreen), do nothing or ensure it's the only route
                  if (Get.currentRoute != PageName.exerciseList) {
                    Get.offAllNamed(
                      PageName.exerciseList,
                    ); // Clears stack and goes to home
                  }
                },
              ),
              Divider(color: ColorConstants.startColor),
              ListTile(
                leading: Icon(Icons.person_outline),
                title: Text("Profile"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Divider(color: ColorConstants.startColor),
              ListTile(
                leading: Icon(Icons.logout_outlined),
                title: Text("Logout"),
                onTap: () {
                  Navigator.pop(context);
                  exerciseListController.handleLogout();
                },
              ),
              Divider(color: ColorConstants.startColor),
            ],
          ),
        ),
      ),
    );
  }
}

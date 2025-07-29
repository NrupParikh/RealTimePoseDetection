import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Components/permission_service.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Models/excercise_data_model.dart';
import 'package:pose_detection/Screens/exerciseList/exercise_list_item.dart';
import 'package:pose_detection/Screens/exerciseList/navigationDrawer/my_navigation_drawer.dart';
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
        // automaticallyImplyLeading: false,
        title: const Text(
          'Exercise List',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        // Make app bar transparent
        backgroundColor: Colors.transparent,
        // Remove shadow
        elevation: 0,
      ),
      drawer: MyNavigationDrawer(),
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
}

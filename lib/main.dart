import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/default_firebase_options.dart';
import 'package:pose_detection/Components/session_expire_controller.dart';
import 'package:pose_detection/Models/excercise_data_model.dart';
import 'package:pose_detection/Screens/bmi_calc/bmi_calc_binding.dart';
import 'package:pose_detection/Screens/bmi_calc/bmi_calc_screen.dart';
import 'package:pose_detection/Screens/dashboard/dashboard_binding.dart';
import 'package:pose_detection/Screens/dashboard/dashboard_screen.dart';
import 'package:pose_detection/Screens/mealPlan/meal_plan_binding.dart';
import 'package:pose_detection/Screens/mealPlan/meal_plan.dart';
import 'package:pose_detection/Screens/detection/detection_controller.dart';
import 'package:pose_detection/Screens/detection/detection_screen.dart';
import 'package:pose_detection/Screens/exerciseList/navigationDrawer/nav_drawer_binding.dart';
import 'package:pose_detection/Screens/exerciseList/exercise_list_screen.dart';
import 'package:pose_detection/Screens/firebase_chat_boat/chat_binding.dart';
import 'package:pose_detection/Screens/firebase_chat_boat/firebase_chat_screen.dart';
import 'package:pose_detection/Screens/goalHistory/goal_history.dart';
import 'package:pose_detection/Screens/goalHistory/goal_history_binding.dart';
import 'package:pose_detection/Screens/login/login_binding.dart';
import 'package:pose_detection/Screens/login/login_screen.dart';
import 'package:pose_detection/Screens/onboard/on_board_screen.dart';
import 'package:pose_detection/Screens/profile/profile.dart';
import 'package:pose_detection/Screens/profile/profile_binding.dart';
import 'package:pose_detection/Screens/register/register_binding.dart';
import 'package:pose_detection/Screens/register/register_screen.dart';
import 'package:pose_detection/Singleton/sercure_storage_singleton.dart';
import 'package:pose_detection/api/apiModels/user.dart';

import 'Constants/page_name.dart';

late SecureStorageSingleton secureStorage;
late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  secureStorage = SecureStorageSingleton();
  await secureStorage.init();
  Get.put(SessionExpireController(secureStorage));
  cameras = await availableCameras();
  final isLoggedIn = secureStorage.getLoginStatus() ?? false;
  final userData = secureStorage.getUserData();

  await Firebase.initializeApp(
    name: "AIChatBotApp",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(isLoggedIn: isLoggedIn, userData: userData));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final User? userData;
  const MyApp({super.key, required this.isLoggedIn, required this.userData});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pose Detection',
      debugShowCheckedModeBanner: false,
      initialRoute:
          // isLoggedIn
          //     ? isUserDataSaved?PageName.exerciseList:PageName.chat
          //     : PageName.onboard,
          isLoggedIn
              ? userData?.isProfileDataAvailable == true
                  ? PageName.dashboard
                  : PageName.chat
              : PageName.onboard,
      getPages: [
        GetPage(name: PageName.onboard, page: () => OnBoardScreen()),
        GetPage(
          name: PageName.login,
          page: () => LoginScreen(),
          binding: LoginBinding(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: PageName.register,
          page: () => RegisterScreen(),
          binding: RegisterBinding(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: PageName.chat,
          page: () => FirebaseChatScreen(),
          binding: ChatBinding(),
        ),
        GetPage(
          name: PageName.exerciseList,
          page: () => ExcerciseListScreen(),
          binding: NavDrawerBinding(),
          transition: Transition.noTransition,
          transitionDuration: Duration.zero,
        ),
        GetPage(
          name: PageName.detection,
          page: () => DetectionScreen(),
          binding: BindingsBuilder(() {
            final ExcerciseDataModel dataModel =
                Get.arguments as ExcerciseDataModel;
            Get.lazyPut<DetectionController>(
              () => DetectionController(dataModel),
            );
          }),
        ),
        GetPage(
          name: PageName.profile,
          page: () => Profile(),
          bindings: [NavDrawerBinding(), ProfileBinding()],
          transition: Transition.noTransition,
          transitionDuration: Duration.zero,
        ),
        GetPage(
          name: PageName.bmiCalcScreen,
          page: () => BMICalcScreen(),
          bindings: [NavDrawerBinding(), BmiCalcBinding()],
          transition: Transition.noTransition,
          transitionDuration: Duration.zero,
        ),
        GetPage(
          name: PageName.dashboard,
          page: () => DashboardScreen(),
          bindings: [NavDrawerBinding(), DashboardBinding()],
          transition: Transition.noTransition,
          transitionDuration: Duration.zero,
        ),
        GetPage(
          name: PageName.goalHistory,
          page: () => GoalHistory(),
          bindings: [NavDrawerBinding(), GoalHistoryBinding()],
          transition: Transition.noTransition,
          transitionDuration: Duration.zero,
        ),
        GetPage(
          name: PageName.mealPlan,
          page: () => MealPlan(),
          bindings: [NavDrawerBinding(), MealPlanBinding()],
          transition: Transition.noTransition,
          transitionDuration: Duration.zero,
        ),
      ],
    );
  }
}

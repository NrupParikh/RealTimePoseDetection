import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/default_firebase_options.dart';
import 'package:pose_detection/Models/excercise_data_model.dart';
import 'package:pose_detection/Screens/detection/detection_controller.dart';
import 'package:pose_detection/Screens/detection/detection_screen.dart';
import 'package:pose_detection/Screens/exerciseList/exercise_list_screen.dart';
import 'package:pose_detection/Screens/firebase_chat_boat/chat_binding.dart';
import 'package:pose_detection/Screens/firebase_chat_boat/firebase_chat_screen.dart';
import 'package:pose_detection/Screens/login/login_binding.dart';
import 'package:pose_detection/Screens/login/login_screen.dart';
import 'package:pose_detection/Screens/onboard/on_board_screen.dart';
import 'package:pose_detection/Screens/register/register_binding.dart';
import 'package:pose_detection/Screens/register/register_screen.dart';
import 'package:pose_detection/Singleton/sercure_storage_singleton.dart';

import 'Constants/page_name.dart';
late SecureStorageSingleton secureStorage;
late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  secureStorage = SecureStorageSingleton();
  await secureStorage.init();
  cameras = await availableCameras();
  final isLoggedIn = secureStorage.getLoginStatus() ?? false;
  final isUserDataSaved = secureStorage.isUserDataSaved() ?? false;
  await Firebase.initializeApp(
    name: "AIChatBotApp",
    options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp(isLoggedIn: isLoggedIn,isUserDataSaved: isUserDataSaved,));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool isUserDataSaved;
  const MyApp({super.key, required this.isLoggedIn,required this.isUserDataSaved});

  @override
  Widget build(BuildContext context) {  
    return GetMaterialApp(
      title: 'Pose Detection',
      debugShowCheckedModeBanner: false,
      // home: isLoggedIn ? ExerciseListScreen() : OnBoardScreen(), // Original code
      // Use GetX routes and bindings for proper controller management
      initialRoute:
          isLoggedIn
              ? isUserDataSaved?PageName.exerciseList:PageName.chat
              : PageName.onboard, // Set initial route
      getPages: [
        GetPage(name: PageName.onboard, page: () => OnBoardScreen()),
        GetPage(
          name: PageName.login, 
          page: () => LoginScreen(),
          binding: LoginBinding(), // Bind LoginController to LoginScreen
           transition: Transition.rightToLeft    
        ),
        GetPage(
          name: PageName.register,
          page: () => RegisterScreen(),
          binding:
              RegisterBinding(), // Bind RegisterController to RegisterScreen
          transition: Transition.rightToLeft    
        ),
        GetPage(
          name: PageName.chat,
          page: () => FirebaseChatScreen(),
          binding: ChatBinding(), // Bind ChatController to FirebaseChatScreen
        ),
        GetPage(name: PageName.exerciseList, page: () => ExcerciseListScreen()),
        GetPage(
          name: PageName.detection,
          page: () => DetectionScreen(),
          binding: BindingsBuilder(() {
            // Get.arguments will contain the dataModel passed during navigation
            final ExcerciseDataModel dataModel =
                Get.arguments as ExcerciseDataModel;
            Get.lazyPut<DetectionController>(
              () => DetectionController(dataModel),
            );
          }),
        ),
      ],
    );
  }
}

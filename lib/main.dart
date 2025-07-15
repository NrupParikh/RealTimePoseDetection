import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Screens/exerciseList/exercise_list_screen.dart';
import 'package:pose_detection/Screens/onboard/on_board_screen.dart';
import 'package:pose_detection/Singleton/sercure_storage_singleton.dart';

late SecureStorageSingleton secureStorage;
late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize secure storage
  secureStorage = SecureStorageSingleton();
  await secureStorage.init();
  cameras = await availableCameras();
  // Get login status
  final isLoggedIn = secureStorage.getLoginStatus() ?? false;
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pose Detection',
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? ExcerciseListScreen() : OnBoardScreen(),
    );
  }
}

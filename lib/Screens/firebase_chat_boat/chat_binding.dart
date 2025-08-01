import 'package:get/get.dart';
import 'package:pose_detection/Screens/firebase_chat_boat/chat_controller_new.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut<ChatControllerNew>(() => ChatControllerNew()); 
  }
}

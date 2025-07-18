import 'package:get/get.dart';
import 'package:pose_detection/Screens/firebase_chat_boat/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut<ChatController>(() => ChatController()); 
  }
}

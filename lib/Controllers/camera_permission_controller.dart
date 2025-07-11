import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPermissionController extends GetxController {
  final RxBool permissionGranted = false.obs;

  Future<void> checkAndRequestPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      permissionGranted.value = true;
    } else {
      final result = await Permission.camera.request();
      permissionGranted.value = result.isGranted;
    }
  }
}

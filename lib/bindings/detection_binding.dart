import 'package:get/get.dart';
import 'package:pose_detection/Controllers/detection_controller.dart';
import 'package:pose_detection/Models/excercise_data_model.dart';

class DetectionBinding extends Bindings {
  final ExcerciseDataModel dataModel;
  DetectionBinding(this.dataModel);

  @override
  void dependencies() {
    Get.put(DetectionController(dataModel));
  }
}


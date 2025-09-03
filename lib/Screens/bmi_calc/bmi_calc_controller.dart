import 'package:get/get.dart';
import 'package:pose_detection/Utility/bmi_calculator.dart';
import 'package:pose_detection/main.dart';

class BMICalcController extends GetxController {
  final RxDouble height = 0.0.obs;
  final RxDouble weight = 0.0.obs;

  final profileData = secureStorage.getProfileData();

  @override
  void onInit() {
    super.onInit();

    height.value = (profileData?.height ?? 0).toDouble();
    weight.value = (profileData?.weight ?? 0).toDouble();
  }

  /// Computed BMI value
  double get bmi => BMICalculator.calculateBMI(
    heightCm: height.value,
    weightKg: weight.value,
  );

  /// Computed BMI category
  String get bmiStatus => BMICalculator.getBMIInterpretation(bmi);
}

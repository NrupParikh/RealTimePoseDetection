import 'package:pose_detection/Constants/app_string.dart';

class BMICalculator {
  static double calculateBMI({required double heightCm, required double weightKg}) {
    if (heightCm <= 0 || weightKg <= 0) return 0.0;
    final h = heightCm / 100;
    return weightKg / (h * h);
  }

  static String getBMIInterpretation(double bmi) {
    if (bmi < 18.5) return AppStrings.underweight;
    if (bmi < 24.9) return AppStrings.normal;
    if (bmi < 29.9) return AppStrings.overweight;
    return AppStrings.obese;
  }
}

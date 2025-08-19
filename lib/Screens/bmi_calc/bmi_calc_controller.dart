import 'package:get/get.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/main.dart';

class BMICalcController extends GetxController {
  RxInt age = 25.obs;
  RxInt height = 150.obs;
  RxInt weight = 60.obs; 

  final profileData = secureStorage.getProfileData();

  @override
  void onInit() {
    super.onInit();

    if (profileData != null) {
      age.value = profileData?.age ?? 25;
      height.value = (profileData?.height ?? 150).toInt();
      weight.value = (profileData?.weight ?? 60).toInt();
    } else {     
      age.value = 25;
      height.value = 150;
      weight.value = 60;
    }
  }

  // You might want to add a method to calculate BMI here
  double calculateBMI() {
    if (height.value <= 0 || weight.value <= 0) {
      return 0.0; // Avoid division by zero or invalid input
    }
    // BMI formula: weight (kg) / (height (m) * height (m))
    double heightInMeters = height.value / 100.0;
    return weight.value / (heightInMeters * heightInMeters);
  }

  // Example: You could add a method here to get age-based BMI interpretation
  String getBMIInterpretation() {
    double bmi = calculateBMI();
    // This is a simplified example; actual interpretation would be more complex
    if (age.value < 18) {
      return "BMI for children and teens should be interpreted using growth charts.";
    } else {
      if (bmi < 18.5) {
        return AppStrings.underweight;
      } else if (bmi >= 18.5 && bmi < 24.9) {
        return AppStrings.normal;
      } else if (bmi >= 25 && bmi < 29.9) {
        return AppStrings.overweight;
      } else {
        return AppStrings.obese;
      }
    }
  }
}

import 'package:get/get.dart';

class BMICalcController extends GetxController {
  RxInt age = 25.obs; 
  RxInt height = 170.obs; // Default height in cm
  RxInt weight = 70.obs; // Default weight in kg

  @override
  void onInit() {
    super.onInit();
    // You can add any initial logic here if needed
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
        return "Underweight";
      } else if (bmi >= 18.5 && bmi < 24.9) {
        return "Normal weight";
      } else if (bmi >= 25 && bmi < 29.9) {
        return "Overweight";
      } else {
        return "Obesity";
      }
    }
  }
}

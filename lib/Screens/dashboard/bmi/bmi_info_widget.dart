import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Screens/dashboard/dashboard_controller.dart';

class BMIInfoWidget extends StatefulWidget {
  const BMIInfoWidget({Key? key}) : super(key: key);

  @override
  State<BMIInfoWidget> createState() => _BMIInfoWidgetState();
}

class _BMIInfoWidgetState extends State<BMIInfoWidget> {
  final controller = Get.find<DashboardController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(left: 16.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                  label: "Height (cm)",
                  value: controller.height.value.toString(),
                ),
                _buildInfoItem(
                  label: "Weight (kg)",
                  value: controller.weight.value.toString(),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                  label: "BMI",
                  value: controller.calculateBMI().toStringAsFixed(2),
                ),
                _buildInfoItem(
                  label: "Status",
                  value: controller.getBMIInterpretation(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({required String label, required String value}) {
    return Expanded(  
      child: Container(    
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
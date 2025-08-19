import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Screens/dashboard/dashboard_controller.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class BmiRadialGauge extends StatefulWidget {
  const BmiRadialGauge({Key? key}) : super(key: key);

  @override
  State<BmiRadialGauge> createState() => _BmiRadialGaugeState();
}

class _BmiRadialGaugeState extends State<BmiRadialGauge> {
  final controller = Get.find<DashboardController>();

  // Common label style for ranges
  static const GaugeTextStyle rangeLabelStyle = GaugeTextStyle(
    fontSize: 6,
    color: Colors.black,
  );
  static double widthValue = 4;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => 
      SfRadialGauge(
        axes: [
          RadialAxis(
            minimum: 0,
            maximum: 40,
            showLabels: true,
            showTicks: true,
            interval: 5,
            axisLabelStyle: const GaugeTextStyle(
              color: Colors.white,
              fontSize: 8, // Reduced font size
            ),
            ranges: [
              GaugeRange(
                startWidth: widthValue,
                endWidth: widthValue,
                startValue: 0,
                endValue: 18.5,
                color: ColorConstants.underweightColor,
                labelStyle: rangeLabelStyle,
              ),
              GaugeRange(
                startWidth: widthValue,
                endWidth: widthValue,
                startValue: 18.5,
                endValue: 24.9,
                color: ColorConstants.normalWeightColor,
                labelStyle: rangeLabelStyle,
              ),
              GaugeRange(
                startWidth: widthValue,
                endWidth: widthValue,
                startValue: 25,
                endValue: 29.9,
                color: ColorConstants.overweightColor,
                labelStyle: rangeLabelStyle,
              ),
              GaugeRange(
                startWidth: widthValue,
                endWidth: widthValue,
                startValue: 30,
                endValue: 40,
                color: ColorConstants.obeseColor,
                labelStyle: rangeLabelStyle,
              ),
            ],
            pointers: [
              NeedlePointer(
                enableAnimation: true,
                animationDuration: 1500,
                animationType: AnimationType.ease,
                value: controller.calculateBMI(),
                needleColor: Colors.white,
                needleStartWidth: 1,
                needleEndWidth: 1,
                needleLength: 0.9,
                knobStyle: const KnobStyle(
                  color: Colors.white,
                  knobRadius: 0.04,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Constants/app_string.dart';
import 'package:pose_detection/Screens/bmi_calc/bmi_calc_controller.dart';
import 'package:pose_detection/Screens/bmi_calc/common_slider.dart';
import 'package:pose_detection/Screens/exerciseList/navigationDrawer/my_navigation_drawer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class BMICalcScreen extends StatefulWidget {
  @override
  State<BMICalcScreen> createState() => _BMICalcScreenState();
}

class _BMICalcScreenState extends State<BMICalcScreen> {
  final controller = Get.find<BMICalcController>();

  static const GaugeTextStyle rangeLabelStyle = GaugeTextStyle(
    fontSize: 12,
    color: Colors.white,
  );
  static double widthValue = 30;

  static const labelTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'BMI Calculator',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: MyNavigationDrawer(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/login_bg.jpg", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: FrostedGlass(
              applyFilter: false,
              borderRadius: BorderRadius.zero,
              gradientColors: [
                ColorConstants.startColor.withValues(alpha: 0.8),
                ColorConstants.endColor.withValues(alpha: 0.8),
              ],
              child: const SizedBox.expand(),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FrostedGlass(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                              applyFilter: true,
                              gradientColors: [
                                Colors.black.withValues(alpha: 0.6),
                                Colors.black.withValues(alpha: 0.6),
                              ],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    CommonSlider(
                                      label: "Age",
                                      min: 0,
                                      max: 100,
                                      divisions: 100,
                                      unit: "years",
                                      value: controller.age,
                                    ),
                                    CommonSlider(
                                      label: "Height",
                                      min: 100,
                                      max: 220,
                                      divisions: 120,
                                      unit: "cm",
                                      value: controller.height,
                                    ),
                                    CommonSlider(
                                      label: "Weight",
                                      min: 30,
                                      max: 150,
                                      divisions: 120,
                                      unit: "kg",
                                      value: controller.weight,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              height: 250,
                              width: 250,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Obx(
                                () => SfRadialGauge(
                                  axes: [
                                    RadialAxis(
                                      minimum: 0,
                                      maximum: 40,
                                      showLabels: false,
                                      showTicks: false,
                                      axisLabelStyle: rangeLabelStyle,
                                      ranges: [
                                        GaugeRange(
                                          startWidth: widthValue,
                                          endWidth: widthValue,
                                          startValue: 0,
                                          endValue: 18.5,
                                          color: ColorConstants
                                              .underweightColor,
                                          label: AppStrings.underweight,
                                          labelStyle: rangeLabelStyle,
                                        ),
                                        GaugeRange(
                                          startWidth: widthValue,
                                          endWidth: widthValue,
                                          startValue: 18.5,
                                          endValue: 24.9,
                                          color: ColorConstants
                                              .normalWeightColor,
                                          label: AppStrings.normal,
                                          labelStyle: rangeLabelStyle,
                                        ),
                                        GaugeRange(
                                          startWidth: widthValue,
                                          endWidth: widthValue,
                                          startValue: 25,
                                          endValue: 29.9,
                                          color: ColorConstants
                                              .overweightColor,
                                          label: AppStrings.overweight,
                                          labelStyle: const GaugeTextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                        GaugeRange(
                                          startWidth: widthValue,
                                          endWidth: widthValue,
                                          startValue: 30,
                                          endValue: 40,
                                          color: ColorConstants.obeseColor,
                                          label: AppStrings.obese,
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
                                          needleLength: 0.9,
                                          needleStartWidth: 1,
                                          needleEndWidth: 5,
                                          knobStyle: const KnobStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                      annotations: [
                                        GaugeAnnotation(
                                          widget: Text(
                                            textAlign: TextAlign.center,
                                            'BMI\n${controller.calculateBMI().toStringAsFixed(2)}\n ${controller.getBMIInterpretation()}',
                                            style: labelTextStyle,
                                          ),
                                          angle: 90,
                                          positionFactor: 0.5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
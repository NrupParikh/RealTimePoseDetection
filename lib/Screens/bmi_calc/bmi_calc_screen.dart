import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Constants/app_colors.dart';
import 'package:pose_detection/Screens/bmi_calc/bmi_calc_controller.dart';
import 'package:pose_detection/Screens/exerciseList/navigationDrawer/my_navigation_drawer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class BMICalcScreen extends StatefulWidget {
  @override
  State<BMICalcScreen> createState() => _BMICalcScreenState();
}

class _BMICalcScreenState extends State<BMICalcScreen> {
  final controller = Get.find<BMICalcController>();

  @override
  Widget build(BuildContext context) {
    const double labelWidth = 70.0;
    const double valueWidth = 80.0;

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
                            // Age Slider
                            Obx(
                              () => Row(
                                children: [
                                  SizedBox(
                                    width: labelWidth,
                                    child: const Text(
                                      "Age",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        valueIndicatorTextStyle:
                                            const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      child: Slider(
                                        value: controller.age.value.toDouble(),
                                        min: 0,
                                        max: 100,
                                        divisions: 100,
                                        label:
                                            controller.age.value.toString() +
                                            " years",
                                        activeColor: Colors.yellow,
                                        inactiveColor: Colors.white,
                                        onChanged: (double newValue) {
                                          controller.age.value =
                                              newValue.round();
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  SizedBox(
                                    width: valueWidth,
                                    child: Text(
                                      "${controller.age.value} years",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16, 
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Height Slider
                            Obx(
                              () => Row(
                                children: [
                                  SizedBox(
                                    width: labelWidth,
                                    child: const Text(
                                      "Height",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        valueIndicatorTextStyle:
                                            const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      child: Slider(
                                        value:
                                            controller.height.value.toDouble(),
                                        min:
                                            100, // Minimum realistic height in cm
                                        max:
                                            220, // Maximum realistic height in cm
                                        divisions: 120, // (220-100) divisions
                                        label:
                                            controller.height.value.toString() +
                                            " cm",
                                        activeColor: Colors.yellow,
                                        inactiveColor: Colors.white,
                                        onChanged: (double newValue) {
                                          controller.height.value =
                                              newValue.round();
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  SizedBox(
                                    width: valueWidth,
                                    child: Text(
                                      "${controller.height.value} cm",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Weight Slider
                            Obx(
                              () => Row(
                                children: [
                                  SizedBox(
                                    width: labelWidth,
                                    child: const Text(
                                      "Weight",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        valueIndicatorTextStyle:
                                            const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      child: Slider(
                                        value:
                                            controller.weight.value.toDouble(),
                                        min:
                                            30, // Minimum realistic weight in kg
                                        max:
                                            150, // Maximum realistic weight in kg
                                        divisions: 120, // (150-30) divisions
                                        label:
                                            controller.weight.value.toString() +
                                            " kg",
                                        activeColor: Colors.yellow,
                                        inactiveColor: Colors.white,
                                        onChanged: (double newValue) {
                                          controller.weight.value =
                                              newValue.round();
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  SizedBox(
                                    width: valueWidth,
                                    child: Text(
                                      "${controller.weight.value} kg",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Obx(
                              () => Text(
                                "BMI: ${controller.calculateBMI().toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Obx(
                              () => Text(
                                "Result: ${controller.getBMIInterpretation()}",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 22, 18, 18),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(height: 250,
                            padding: EdgeInsets.symmetric(horizontal: 10),child: 
                            SfRadialGauge(
                              axes: [
                                RadialAxis(
                                  minimum: 0,
                                  maximum: 40,
                                  ranges: [
                                    GaugeRange(
                                      startValue: 0,
                                      endValue: 18.5,
                                      color: Colors.blue,
                                      // label: 'Underweight',
                                    ),
                                    GaugeRange(
                                      startValue: 18.5,
                                      endValue: 24.9,
                                      color: Colors.green,
                                      // label: 'Normal',
                                    ),
                                    GaugeRange(
                                      startValue: 25,
                                      endValue: 29.9,
                                      color: Colors.yellow,
                                      // label: 'Overweight',
                                    ),
                                    GaugeRange(
                                      startValue: 30,
                                      endValue: 40,
                                      color: Colors.red,
                                      // label: 'Obese',
                                    ),
                                  ],
                                  pointers: [
                                    NeedlePointer(
                                      value: controller.calculateBMI(),
                                      needleColor: Colors.black,
                                      knobStyle:
                                          KnobStyle(color: Colors.black),
                                    ),
                                  ],
                                  annotations: [
                                    GaugeAnnotation(
                                        widget: Text(
                                          '${controller.calculateBMI().toStringAsFixed(2)}',
                                          style: TextStyle(
                                              fontSize: 25, color: Colors.black),
                                        ),
                                        angle: 90, positionFactor: 0.5)
                                  ],
                                )
                              ],
                            ),),
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

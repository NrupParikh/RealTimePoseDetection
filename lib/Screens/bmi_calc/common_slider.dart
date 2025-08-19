import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CommonSlider extends StatelessWidget {
  final String label;
  final int min;
  final int max;
  final int divisions;
  final String unit;
  final RxInt value;

  static const double labelWidth = 70.0;
  static const double valueWidth = 80.0;

  static const labelTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  const CommonSlider({
    super.key,
    required this.label,
    required this.min,
    required this.max,
    required this.divisions,
    required this.unit,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(label, style: labelTextStyle),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                valueIndicatorTextStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Slider(
                value: value.value.toDouble(),
                min: min.toDouble(),
                max: max.toDouble(),
                divisions: divisions,
                label: "${value.value} $unit",
                activeColor: Colors.yellow,
                inactiveColor: Colors.white,
                onChanged: (double newValue) {
                  value.value = newValue.round();
                },
              ),
            ),
          ),
          const SizedBox(width: 5),
          SizedBox(
            width: valueWidth,
            child: Text(
              "${value.value} $unit",
              style: labelTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
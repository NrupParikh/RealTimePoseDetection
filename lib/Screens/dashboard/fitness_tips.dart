import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/Screens/dashboard/dashboard_controller.dart';
import 'package:marquee/marquee.dart';

class FitnessTips extends StatefulWidget {
  final List<String> fitnessTips;
  const FitnessTips({super.key, required this.fitnessTips});

  @override
  State<FitnessTips> createState() => FitnessTipsState();
}

class FitnessTipsState extends State<FitnessTips> {
  final DashboardController controller = Get.find<DashboardController>();
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Center(
          child: Text(
            '\u{1F4A1}',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
        const SizedBox(width: 4),

        // Swipeable vertical tips
        Expanded(
          child: Container(
            height: 25,
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              controller: pageController,
              itemCount: widget.fitnessTips.length,
              onPageChanged:
                  (index) => controller.currentTipIndex.value = index,
              itemBuilder: (context, index) {
                String tip = widget.fitnessTips[index];

                return Align(
                  alignment: Alignment.centerLeft,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Check if text overflows
                      final textPainter = TextPainter(
                        text: TextSpan(
                          text: tip,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
                      )..layout(maxWidth: constraints.maxWidth);

                      bool isOverflowing = textPainter.didExceedMaxLines;

                      return isOverflowing
                          ? Marquee(
                            text: tip,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            velocity: 30.0,
                            blankSpace: 40.0,
                            pauseAfterRound: const Duration(seconds: 1),
                          )
                          : Text(
                            tip,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          );
                    },
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Vertical dots indicator
        Obx(() {
          int total = widget.fitnessTips.length;
          int current = controller.currentTipIndex.value;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(total, (index) {
              bool isActive = index == current;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                width: 6,
                height: isActive ? 12 : 6,
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.white54,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          );
        }),
      ],
    );
  }
}

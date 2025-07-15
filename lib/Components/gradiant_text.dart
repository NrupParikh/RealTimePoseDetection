import 'package:flutter/material.dart';
import 'package:pose_detection/Constants/app_colors.dart';

class GradientTextExample extends StatefulWidget {
  final String title;
  final String titleMsg;
  final VoidCallback onTap;
  const GradientTextExample({
    super.key,
    required this.title,
    required this.titleMsg,
    required this.onTap,
  });

  @override
  State<GradientTextExample> createState() => _GradientTextExampleState();
}

class _GradientTextExampleState extends State<GradientTextExample> {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: widget.title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        children: [
          WidgetSpan(
            child: GestureDetector(
              onTap: widget.onTap,
              child: ShaderMask(
                shaderCallback:
                    (bounds) => LinearGradient(
                      colors: [
                        ColorConstants.endColor,
                        ColorConstants.startColor,
                      ], // Minor gradient
                    ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                blendMode: BlendMode.srcIn,
                child: Text(
                  widget.titleMsg,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

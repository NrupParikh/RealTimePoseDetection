import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  final Color color1;
  final Color color2;
  final Widget child;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final BorderRadiusGeometry? borderRadius;
  final double? width; // Add width parameter
  final double? height; // Add height parameter

  const GradientContainer({
    super.key,
    required this.color1,
    required this.color2,
    required this.child,
    
    this.begin = Alignment.topRight,
    this.end = Alignment.topLeft,
    this.borderRadius,
    this.width, // Initialize width
    this.height, // Initialize height
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          width ?? double.infinity, // Use provided width or full width if null
      height:
          height ??
          double.infinity, // Use provided height or full height if null
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: [color1, color2],
        ),
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
